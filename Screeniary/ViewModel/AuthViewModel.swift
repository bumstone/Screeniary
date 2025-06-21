//
//  AuthViewModel.swift
//  Screeniary
//
//  Created by 고범석 on 6/18/25.
//

import FirebaseAuth
import GoogleSignIn
import FirebaseFirestore
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var userNickname: String = ""
    
    init() {
        self.user = Auth.auth().currentUser
        if user != nil {
            Task {
                await fetchUserNickname()
            }
        }
    }
    
    func fetchUserNickname() async {
        guard let uid = self.user?.uid else { return }
        
        do {
            let document = try await Firestore.firestore().collection("users").document(uid).getDocument()
            // Main 스레드에서 UI 관련 프로퍼티를 업데이트합니다.
            await MainActor.run {
                self.userNickname = document.data()?["nickname"] as? String ?? "사용자"
            }
        } catch {
            print("Error fetching user nickname: \(error.localizedDescription)")
            await MainActor.run {
                self.userNickname = "사용자" // 실패 시 기본값
            }
        }
    }
    
    
    
    func isNicknameAvailable(_ nickname: String) async throws -> Bool {
        let snapshot = try await Firestore.firestore()
            .collection("users")
            .whereField("nickname", isEqualTo: nickname)
            .getDocuments()
        
        return snapshot.documents.isEmpty
    }
    
    func signUp(email: String, password: String, nickname: String) async throws {
        let available = try await isNicknameAvailable(nickname)
        guard available else {
            throw NSError(domain: "", code: 409, userInfo: [NSLocalizedDescriptionKey: "이미 사용 중인 닉네임입니다."])
        }
        
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        self.user = result.user
        
        // Firestore에 닉네임 저장
        try await Firestore.firestore().collection("users")
            .document(result.user.uid)
            .setData([
                "nickname": nickname,
                "email": email
            ])
        
        //회원가입 성공 후 닉네임을 ViewModel에 저장
        await MainActor.run {
            self.userNickname = nickname
        }
    }
    
    
    func signIn(email: String, password: String) async throws {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        self.user = result.user
        
        // 로그인 성공 후 닉네임을 FIreStore에서 가져온다.
        await fetchUserNickname()
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
        self.user = nil
        // 닉네임 초기화
        self.userNickname = ""
    }
}

extension AuthViewModel {
    
    // 구글 쇼셜 로그인
    func signInWithGoogle() async throws {
        guard let rootViewController = await UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene }).first?.windows.first?.rootViewController else {
            throw NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "화면 정보를 가져올 수 없습니다."])
        }
        
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        
        guard let idToken = result.user.idToken?.tokenString,
              let email = result.user.profile?.email else { return }
        
        let accessToken = result.user.accessToken.tokenString
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        let authResult = try await Auth.auth().signIn(with: credential)
        
        let nickname = email.components(separatedBy: "@").first ?? "사용자"
        
        // Firestore에 사용자 정보 저장
        try await Firestore.firestore().collection("users").document(authResult.user.uid).setData([
            "email": email,
            "nickname": nickname
        ], merge: true)
        
        await MainActor.run {
            self.user = authResult.user
        }
        await fetchUserNickname()
    }
}

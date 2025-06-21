//
//  LoginView.swift
//  Screeniary
//
//  Created by 고범석 on 6/18/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var isSigningIn = false
    @State private var showSignUp = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                
                Text("Screeniary")
                    .font(.largeTitle.bold())
                
                VStack(spacing: 12) {
                    TextField("이메일", text: $email)
                        .textFieldStyle(.roundedBorder)
                    
                    SecureField("비밀번호", text: $password)
                        .textFieldStyle(.roundedBorder)
                }
                
                if !errorMessage.isEmpty {
                    Text(errorMessage).foregroundColor(.red)
                }
                
                // 로그인 버튼
                Button("로그인") {
                    Task {
                        isSigningIn = true
                        do {
                            try await authVM.signIn(email: email, password: password)
                        } catch {
                            errorMessage = error.localizedDescription
                        }
                        isSigningIn = false
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(6)
                .disabled(isSigningIn)
                
                // 일반 로그인과 구글 로그인 구분선
                HStack {
                    Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.3))
                    Text("또는").font(.caption).foregroundColor(.gray)
                    Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.3))
                }
                
                // Google 로그인 버튼
                Button {
                    Task {
                        do {
                            try await authVM.signInWithGoogle()
                        } catch {
                            errorMessage = error.localizedDescription
                        }
                    }
                } label: {
                    HStack {
                        Image("google_icon") // Assets에 google_icon.png 추가 필요
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Google로 로그인")
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray.opacity(0.3)))
                }
                
                Spacer()
                
                // 회원가입 링크
                HStack(spacing: 4) {
                    Text("계정이 없으신가요?")
                        .foregroundColor(.gray)
                    Button("가입하기") {
                        showSignUp = true
                    }
                    .foregroundColor(.blue)
                    .bold()
                }
                
                NavigationLink("", destination: SignUpView(), isActive: $showSignUp)
                    .hidden()
            }
            .padding()
        }
    }
}


#Preview{
    NavigationView {
        LoginView()
        // 프리뷰에서 사용할 AuthViewModel의 인스턴스를 생성하여 주입합니다.
            .environmentObject(AuthViewModel())
    }
}

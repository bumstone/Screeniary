//
//  SignUpView.swift
//  Screeniary
//
//  Created by 고범석 on 6/18/25.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var nickname = ""
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("회원가입")
                .font(.title.bold())

            TextField("닉네임", text: $nickname)
                .textFieldStyle(.roundedBorder)

            TextField("이메일", text: $email)
                .textFieldStyle(.roundedBorder)

            SecureField("비밀번호", text: $password)
                .textFieldStyle(.roundedBorder)

            if !errorMessage.isEmpty {
                Text(errorMessage).foregroundColor(.red)
            }

            Button("회원가입 완료") {
                Task {
                    do {
                        try await authVM.signUp(email: email, password: password, nickname: nickname)
                        dismiss()
                    } catch {
                        errorMessage = error.localizedDescription
                    }
                }
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
    }
}

#Preview{
    NavigationView {
        SignUpView()
            // 프리뷰에서 사용할 AuthViewModel의 인스턴스를 생성하여 주입합니다.
            .environmentObject(AuthViewModel())
    }
}

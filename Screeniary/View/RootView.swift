//
//  RootView.swift
//  Screeniary
//
//  Created by 고범석 on 6/18/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        if let _ = authVM.user {
            MainTabView() // 로그인된 상태
        } else {
            LoginView()   // 비로그인 상태
        }
    }
}

#Preview{
    RootView()
        .environmentObject(AuthViewModel())
    
}
    
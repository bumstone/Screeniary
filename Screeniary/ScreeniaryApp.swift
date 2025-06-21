//
//  ScreeniaryApp.swift
//  Screeniary
//
//  Created by 고범석 on 6/16/25.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore
import FirebaseCore
import GoogleSignIn

@main
struct ScreeniaryApp: App {
    
    // AppDelegate를 앱의 생명주기에 연결합니다.
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authVM = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authVM)
        }
    }
}

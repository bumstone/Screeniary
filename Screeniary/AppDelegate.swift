//
//  AppDelegate.swift
//  Screeniary
//
//  Created by 고범석 on 6/18/25.
//

// AppDelegate.swift

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Firebase 기본 설정
        FirebaseApp.configure()
        
        // Google Sign-In 설정
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("Firebase에서 ClientID를 찾을 수 없습니다.")
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        
        return true
    }
    
    // Google 로그인 후 앱으로 돌아올 때 URL을 처리하는 필수 메서드
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    

}

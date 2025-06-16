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

@main
struct ScreeniaryApp: App {
    
    init(){
        // firebase 연결
        FirebaseApp.configure()
        
        // firestore에 저장
        Firestore.firestore().collection("test").document("name").setData(["name": "Ko Bum Seouk"])

        // storage에 이미지 저장
        let image = UIImage(named: "Seoul")!
        let imageData = image.jpegData(compressionQuality: 1.0)
        let reference = Storage.storage().reference().child("test").child("Hansung")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        reference.putData(imageData!, metadata: metaData) { _ in }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

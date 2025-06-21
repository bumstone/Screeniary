//
//  MainTabView.swift
//  Screeniary
//
//  Created by 고범석 on 6/18/25.
//

import SwiftUI

struct MainTabView: View {
    // @StateObject를 통해 뷰가 살아있는 동안 ViewModel 인스턴스를 단 한 번만 생성하고 유지
    @StateObject private var mediaVM = MediaViewModel()
    
    var body: some View {
        TabView {
            WatchListView()
                .tabItem {
                    Image(systemName: "film.fill")
                    Text("시청 기록")
                }
            
            Text("검색 화면")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("검색")
                }
            FavoriteView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("즐겨찾기")
                }
        }
        .environmentObject(mediaVM)
    }
}

#Preview{
    MainTabView()
}

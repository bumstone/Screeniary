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
                    Text("Record")
                }
            
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            FavoriteView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Favorites")
                }
        }
        .environmentObject(mediaVM)
    }
}

#Preview{
    MainTabView()
        .environmentObject(AuthViewModel())
}

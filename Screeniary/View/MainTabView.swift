//
//  MainTabView.swift
//  Screeniary
//
//  Created by 고범석 on 6/18/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            WatchListView()
                .tabItem {
                    Image(systemName: "film.fill")
                    Text("시청 기록")
                }

            SearchView()
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
    }
}

#Preview{
    MainTabView()
}

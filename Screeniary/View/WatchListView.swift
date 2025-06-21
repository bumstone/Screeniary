//
//  WatchListView.swift
//  Screeniary
//
//  Created by 고범석 on 6/19/25.
//

import SwiftUI

struct WatchListView: View {
    // EnvironmentObject를 통해 MainTabView에서 생성한 ViewModel을 가져옵니다.
    @EnvironmentObject var mediaVM: MediaViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Text("Screeniary")
                        .font(.title.bold())
                    Spacer()
                    // ViewModel의 sortOption을 바인딩하여 사용
                    SortOptionMenu(sortOption: $mediaVM.sortOption)
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                List {
                    // $를 사용하여 Binding 배열로 생성
                    // 각 요소를 $media로 받아 사용
                    ForEach($mediaVM.displayedMedias) { $media in
                        MediaCardView(
                            media: $media,
                            onToggleFavorite: {
                                // 즐겨찾기 버튼이 눌리면 ViewModel의 함수를 호출
                                mediaVM.toggleFavorite(for: media)
                            }
                        )
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                    }
                    .onDelete(perform: mediaVM.deleteMedia)
                }
                .listStyle(.plain)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { EditButton() }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink("추가") {
                        MediaNewView()
                    }
                }
            }
        }
    }
}

#Preview {
    WatchListView()
        .environmentObject(MediaViewModel()) // Preview에서도 주입해줍니다.
}

//
//  WatchListView.swift
//  Screeniary
//
//  Created by 고범석 on 6/19/25.
//

import SwiftUI

struct WatchListView: View {
    @EnvironmentObject var mediaVM: MediaViewModel
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Spacer()
                    SortOptionMenu(sortOption: $mediaVM.sortOption)
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                
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
            // .navigationTitle을 사용하여 큰 제목을 표시하고 왼쪽 정렬합니다.
            .navigationTitle("Media Record")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: MediaNewView()) {
                        Image(systemName: "plus.app")
                    }
                }
            }
        }
    }
}

#Preview {
    WatchListView()
        .environmentObject(MediaViewModel(isPreview: true))
}

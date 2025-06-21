//
//  FavoriteView.swift
//  Screeniary
//
//  Created by 고범석 on 6/19/25.
//

import SwiftUI

struct FavoriteView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var mediaVM: MediaViewModel
    
    private var favoriteMedias: [Media] {
        // ViewModel의 정렬 옵션에 따라 먼저 정렬된 후, 즐겨찾기만 필터링
        let sortedMedias = mediaVM.displayedMedias
        return sortedMedias.filter { $0.isFavorite }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 정렬 메뉴를 리스트 상단, 우측으로 배치합니다.
                HStack {
                    Spacer()
                    SortOptionMenu(sortOption: $mediaVM.sortOption)
                }
                .padding(.horizontal)
                .padding(.bottom, 8) // 리스트와의 간격
                
                if favoriteMedias.isEmpty {
                    VStack {
                        Image(systemName: "star.slash.fill")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        Text("즐겨찾기한 항목이 없습니다.")
                            .font(.headline)
                            .padding(.top)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // 화면 중앙 정렬
                    
                } else {
                    List {
                        // favoriteMedias 배열을 순회
                        ForEach(favoriteMedias) { media in
                            // ViewModel의 원본 배열(medias)에서 현재 media와 일치하는 인덱스를 찾아 바인딩을 생성
                            if let index = mediaVM.medias.firstIndex(where: { $0.id == media.id }) {
                                MediaCardView(
                                    media: $mediaVM.medias[index],
                                    onToggleFavorite: {
                                        mediaVM.toggleFavorite(for: media)
                                    }
                                )
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            // .navigationTitle을 사용하여 큰 제목을 표시하고 왼쪽 정렬합니다.
            .navigationTitle("Favorites")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("로그아웃") {
                        do {
                            try authVM.signOut()
                        } catch {
                            // 로그아웃 실패 시 에러 처리
                            print("Error signing out: \(error.localizedDescription)")
                        }
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }
}

#Preview {
    FavoriteView()
        .environmentObject(AuthViewModel())
        .environmentObject(MediaViewModel(isPreview: true))
}

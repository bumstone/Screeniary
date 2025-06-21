//
//  FavoriteView.swift
//  Screeniary
//
//  Created by 고범석 on 6/19/25.
//

import SwiftUI

struct FavoriteView: View {
    @EnvironmentObject var authVM: AuthViewModel
    // 동일한 ViewModel을 공유받습니다.
    @EnvironmentObject var mediaVM: MediaViewModel
    
    // ViewModel의 데이터를 기반으로 즐겨찾기 목록을 계산합니다.
    var favoriteMedias: [Media] {
        mediaVM.displayedMedias.filter { $0.isFavorite }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    SortOptionMenu(sortOption: $mediaVM.sortOption)
                }
                .padding(.horizontal)
                
                if favoriteMedias.isEmpty {
                    VStack {
                        Image(systemName: "star.slash.fill")
                            .font(.largeTitle)
                        Text("즐겨찾기한 항목이 없습니다.")
                            .font(.headline)
                            .padding(.top)
                    }
                    .foregroundColor(.gray)
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
            .navigationTitle("\(authVM.userNickname)님의 즐겨찾기")
            .navigationBarTitleDisplayMode(.inline)
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
        .environmentObject(MediaViewModel())
}

//
//  SearchView.swift
//  Screeniary
//
//  Created by 고범석 on 6/21/25.
//

import SwiftUI

struct SearchView: View {
    // MediaViewModel을 환경 객체로 받아옵니다.
    @EnvironmentObject var mediaVM: MediaViewModel
    
    // 검색 텍스트, 선택된 유형 필터, 정렬 옵션을 위한 상태 변수
    @State private var searchText = ""
    @State private var selectedType: String? = nil
    @State private var sortOption: SortOption = .latest
    
    // 필터링 및 정렬된 결과를 계산하는 연산 프로퍼티
    private var searchResults: [Media] {
        var results = mediaVM.medias
        
        // 유형 필터링
        if let selectedType = selectedType {
            results = results.filter { $0.typeTags.contains(selectedType) }
        }
        
        // 검색 텍스트 필터링 (부분일치, 대소문자 무시)
        if !searchText.isEmpty {
            results = results.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
        
        // 정렬
        switch sortOption {
        case .latest:
            results.sort { $0.watchDate ?? .distantPast > $1.watchDate ?? .distantPast }
        case .rating:
            results.sort { $0.rating > $1.rating }
        }
        
        return results
    }
    
    // 필터링 버튼에 사용될 유형 목록
    let availableTypes = ["영화", "드라마", "다큐", "스포츠"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // MARK: - Filter and Sort Controls
                VStack(spacing: 12) {
                    // 유형 필터 버튼
                    HStack(spacing: 12) {
                        ForEach(availableTypes, id: \.self) { type in
                            Button(action: {
                                if selectedType == type {
                                    selectedType = nil
                                } else {
                                    selectedType = type
                                }
                            }) {
                                Text(type)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .frame(maxWidth: .infinity)
                                    .background(selectedType == type ? Color.blue.opacity(0.2) : Color(.systemGray5))
                                    .foregroundColor(selectedType == type ? .blue : .primary)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    
                    HStack {
                        Spacer()
                        SortOptionMenu(sortOption: $sortOption)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 12) // 컨트롤과 리스트 사이의 간격
                
                // 시청 검색 기록
                List {
                    ForEach(searchResults) { media in
                        if let index = mediaVM.medias.firstIndex(where: { $0.id == media.id }) {
                            MediaCardView(
                                media: $mediaVM.medias[index],
                                onToggleFavorite: {
                                    mediaVM.toggleFavorite(for: mediaVM.medias[index])
                                }
                            )
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                        }
                    }
                }
                .listStyle(.plain)
                .overlay {
                    if searchResults.isEmpty {
                        Text(searchText.isEmpty && selectedType == nil ? "검색어를 입력하거나 필터를 선택하세요." : "검색 결과가 없습니다.")
                            .foregroundColor(.gray)
                    }
                }
            }
            .searchable(text: .constant(""), prompt: "검색어를 입력하세요")
            .navigationTitle("Search")
        }
    }
}

#Preview {
    SearchView()
        .environmentObject(MediaViewModel(isPreview: true))
}

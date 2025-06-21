//
//  TagSelectionView.swift
//  Screeniary
//
//  Created by 고범석 on 6/20/25.
//

import SwiftUI

// 단일, 다중 태그 구별
enum TagSelectionMode {
    case single(Binding<String?>)
    case multiple(Binding<[String]>)
}

// 태그별 선택 UI 뷰 및 효과
struct TagSelectionView: View {
    let tags: [String]
    let mode: TagSelectionMode
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.adaptive(minimum: 80), spacing: 8)
        ], spacing: 8) {
            ForEach(tags, id: \.self) { tag in
                tagButton(for: tag)
            }
        }
    }

    /// 개별 태그를 나타내는 버튼 뷰
    private func tagButton(for tag: String) -> some View {
        Button(action: {
            // 태그 선택 로직
            switch mode {
            case .single(let selected):
                selected.wrappedValue = (selected.wrappedValue == tag) ? nil : tag
            case .multiple(let selected):
                if selected.wrappedValue.contains(tag) {
                    selected.wrappedValue.removeAll { $0 == tag }
                } else {
                    selected.wrappedValue.append(tag)
                }
            }
        }) {
            Text(tag)
                .font(.caption)
                .lineLimit(1)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(selectionBackground(for: tag))
                .foregroundColor(selectionForeground(for: tag))
                .clipShape(Capsule())
        }
        .frame(minWidth: 60) // 최소 너비 설정으로 일관성 있는 모양 유지
    }
    
    // 선택 상태에 따라 배경색을 결정하는 함수
    private func selectionBackground(for tag: String) -> Color {
        let isSelected = isSelected(for: tag)
        return isSelected ? Color.blue.opacity(0.2) : Color(.systemGray6)
    }
    
    // 선택 상태에 따라 글자색을 결정하는 함수
    private func selectionForeground(for tag: String) -> Color {
        let isSelected = isSelected(for: tag)
        return isSelected ? .blue : .primary
    }
    
    // 태그가 현재 선택되었는지 확인하는 헬퍼 함수
    private func isSelected(for tag: String) -> Bool {
        switch mode {
        case .single(let selected):
            return selected.wrappedValue == tag
        case .multiple(let selected):
            return selected.wrappedValue.contains(tag)
        }
    }
}

#Preview {
    struct TagSelectionPreview: View {
        let allGenres = ["액션", "코미디", "로맨스/멜로", "SF", "판타지", "애니메이션", "범죄/스릴러", "공포/미스터리", "드라마", "다큐멘터리", "음악/뮤지컬", "사극", "스포츠", "가족", "어드벤처", "전쟁"]
        
        @State private var singleSelection: String? = "드라마"
        @State private var multiSelection: [String] = ["액션", "SF", "어드벤처"]
        
        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("장르")
                        .font(.headline)
                    TagSelectionView(tags: allGenres, mode: .multiple($multiSelection))
                    
                    Divider().padding(.vertical, 8)
                    
                    Text("OTT 플랫폼")
                        .font(.headline)
                    TagSelectionView(tags: ["Netflix", "Disney+", "Youtube", "Wavve", "CoupangPlay", "Watcha", "Tving", "AppleTV+"], mode: .single($singleSelection))
                    
                    Divider().padding(.vertical, 8)

                    Text("해결된 문제들")
                        .font(.headline)
                    Text("✅ 중앙 정렬 완료\n✅ 라벨 간격 최적화\n✅ 자동 줄바꿈 개선")
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                }
                .padding()
            }
            .navigationTitle("UI 정렬/여백 문제 해결")
        }
    }
    
    return NavigationView {
        TagSelectionPreview()
    }
}

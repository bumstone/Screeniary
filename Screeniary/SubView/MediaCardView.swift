//
//  MediaListView.swift
//  Screeniary
//
//  Created by 고범석 on 6/19/25.
//

import SwiftUI

struct MediaCardView: View {
    @Binding var media: Media
    var onToggleFavorite: () -> Void
    @State var image = UIImage()
    let size = CGSize(width: 100, height: 100)
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            NavigationLink(destination: Text("상세보기 임시 화면")) {
                HStack(alignment: .top, spacing: 12) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: size.width, height: size.height)
                        .cornerRadius(8)
                        .onAppear {
                            ImagePool.image(name: media.thumbnailName ?? "noImage", size: size) { loadedImage in
                                self.image = loadedImage
                            }
                        }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(media.title)
                            .font(.headline)
                            .lineLimit(1)
                        
                        Text(media.watchStatus)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        TagChipView(tags: media.genres)
                        TagChipView(tags: media.typeTags)
                        
                        HStack(spacing: 4) {
                            ForEach(media.ottTags, id: \.self) { tag in
                                Image(tag)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                            }
                        }
                        
                        RatingView(rating: media.rating)
                    }
                    Spacer()
                }
            }
            
            VStack {
                Button(action: {
                    // 이제 dbFirebase를 직접 호출하는 대신,
                    // 부모로부터 전달받은 onToggleFavorite 클로저를 실행하기만 합니다.
                    onToggleFavorite()
                }) {
                    Image(systemName: media.isFavorite ? "bookmark.fill" : "bookmark")
                        .foregroundColor(.yellow)
                }
                .padding(4)
                
                Spacer()
                
                ProgressCircleView(progress: media.progress)
                    .frame(width: 30, height: 30)
                    .padding(4)
            }
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

// 별점 표시
struct RatingView: View {
    let rating: Double
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<5) { i in
                Image(systemName: i < Int(rating) ? "star.fill" : "star")
                    .foregroundColor(.yellow)
            }
        }
    }
}

// 원형 진행률
struct ProgressCircleView: View {
    let progress: Double // 0~1
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 4)
                .opacity(0.3)
                .foregroundColor(.blue)
            
            Circle()
                .trim(from: 0, to: CGFloat(progress))
                .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .foregroundColor(.blue)
                .rotationEffect(.degrees(-90))
            
            Text("\(Int(progress * 100))%")
                .font(.caption2)
        }
    }
}

// 태그 뷰
struct TagChipView: View {
    let tags: [String]
    var body: some View {
        HStack(spacing: 4) {
            ForEach(tags.prefix(3), id: \ .self) { tag in
                Text(tag)
                    .font(.caption2)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(6)
            }
        }
    }
}


#Preview(traits: .sizeThatFitsLayout) {
    let mockMedia = Media(
        title: "더 글로리",
        genres: ["드라마", "스릴러"],
        ottTags: ["Netflix"],
        typeTags: ["드라마"],
        watchStatus: "시청 중",
        rating: 4.0,
        progress: 0.6,
        episodes: 16,
        watchDate: Date(),
        memo: "재미있다",
        thumbnailName: "",
        isFavorite: true,
        nickname: "고범석"
    )
    
    // 변경된 init에 맞게 dbFirebase를 제거하고, onToggleFavorite에 빈 클로저를 전달합니다.
    MediaCardView(media: .constant(mockMedia), onToggleFavorite: {
        print("Favorite Toggled in Preview")
    })
    .padding()
}

//
//  MediaDetailView.swift
//  Screeniary
//
//  Created by 고범석 on 6/19/25.
//

import SwiftUI
import PhotosUI

struct MediaDetailView: View {
    @Binding var media: Media
    @State var image = UIImage(named: "noImage") ?? UIImage()
    
    let size = CGSize(width: 200, height: 200)
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // 썸네일 이미지
                VStack(alignment: .leading, spacing: 4) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: size.width, height: size.height)
                        .cornerRadius(12)
                        .onAppear {
                            ImagePool.image(name: media.thumbnailName ?? "noImage", size: size) { loaded in
                                image = loaded
                            }
                        }
                }
                
                // 제목
                VStack(alignment: .leading, spacing: 4) {
                    Text(media.title)
                        .font(.title2.bold())
                }
                
                // 별점
                VStack(alignment: .leading, spacing: 4) {
                    Text("별점")
                        .font(.headline)
                    RatingView(rating: media.rating)
                }
                
                // 시청 상태
                VStack(alignment: .leading, spacing: 4) {
                    Text(media.watchStatus)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                // 시청 진행도
                VStack(alignment: .leading, spacing: 4) {
                    Text("시청 진행도")
                        .font(.headline)
                    ProgressView(value: media.progress)
                    Text("\(Int(media.progress * Double(media.episodes))) / \(media.episodes) 회차")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                // 장르
                VStack(alignment: .center, spacing: 4) {
                    Text("장르")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .center) // 가운데 정렬

                    TagChipView(tags: media.genres)
                        .frame(maxWidth: .infinity, alignment: .center) // 가운데 정렬
                }

                // 유형
                VStack(alignment: .center, spacing: 4) {
                    Text("유형")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .center)

                    TagChipView(tags: media.typeTags)
                        .frame(maxWidth: .infinity, alignment: .center)
                }

                // OTT 플랫폼
                VStack(alignment: .center, spacing: 4) {
                    Text("OTT 플랫폼")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .center)

                    HStack(spacing: 8) {
                        ForEach(media.ottTags, id: \.self) { tag in
                            Image(tag)
                                .resizable()
                                .frame(width: 60, height: 20)
                                .clipShape(RoundedRectangle(cornerRadius: 3))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }

                
                // 메모
                VStack(alignment: .leading, spacing: 8) {
                    Text("메모")
                        .font(.headline)
                    Text(media.memo)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .navigationTitle("상세 보기")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink("수정") {
                    MediaEditView(media: $media)
                }
            }
        }
    }
}


// 별점 선택 피커뷰
struct StarRatingPicker: View {
    @Binding var rating: Double
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: rating >= Double(index) ? "star.fill" : "star")
                    .foregroundColor(.yellow)
                    .onTapGesture {
                        rating = Double(index)
                    }
            }
        }
    }
}

// 진행 회차 슬라이더
struct EpisodeProgressPicker: View {
    @Binding var progress: Double
    @Binding var episodes: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Slider(value: $progress, in: 0...1)
            Text("\(Int(progress * Double(episodes))) / \(episodes) 회차")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}



#Preview {
    NavigationView {
        MediaDetailView(media: .constant(Media(
            title: "미리보기 제목", genres: ["스포츠"], ottTags: ["Netflix"], typeTags: ["드라마"],
            watchStatus: "시청 완료", rating: 5.0, progress: 1.0, episodes: 16,
            watchDate: Date(), memo: "메모", nickname: "사용자"
        )))
    }
}

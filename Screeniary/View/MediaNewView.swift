//
//  MediaNewView.swift
//  Screeniary
//
//  Created by 고범석 on 6/19/25.
//

import SwiftUI
import PhotosUI

struct MediaNewView: View {
    @EnvironmentObject var mediaVM: MediaViewModel
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.dismiss) var dismiss  // 이전 화면 이동시
    
    @State private var title = ""
    @State private var rating: Double = 0
    @State private var progress: Double = 0
    @State private var episodes: Int = 1
    @State private var genres: [String] = []
    @State private var ottTags: [String] = []
    @State private var typeTag: String? = nil
    @State private var watchStatus: String = "시청 전"
    @State private var memo: String = ""
    @State private var thumbnail: UIImage? = nil
    @State private var selectedImageItem: PhotosPickerItem? = nil
    
    let availableGenres = ["액션", "코미디", "로맨스/멜로", "SF", "판타지", "애니메이션", "범죄/스릴러", "공포/미스터리", "드라마", "다큐멘터리", "음악/뮤지컬", "사극", "스포츠"]
    let availableOtts = ["Netflix", "Disney+", "Youtube", "CoupangPlay", "Watcha", "Tving", "Wavve", "AppleTV+"]
    let availableTypes = ["영화", "드라마", "예능", "다큐", "스포츠"]
    let availableWatchStatus = ["시청 예정", "시청 중", "시청 완료"]
    
    var body: some View {
        NavigationView {
            // 생략된 import 및 변수는 그대로 유지
            
            ScrollView {
                VStack(spacing: 20) {
                    // 썸네일
                    PhotosPicker(selection: $selectedImageItem, matching: .images) {
                        if let thumbnail = thumbnail {
                            Image(uiImage: thumbnail)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 200)
                                .cornerRadius(12)
                        } else {
                            VStack {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.gray)
                                Text("이미지 선택")
                                    .foregroundColor(.gray)
                            }
                            .frame(width: 200, height: 200)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                    }
                    .onChange(of: selectedImageItem) { newValue in
                        Task {
                            if let data = try? await newValue?.loadTransferable(type: Data.self),
                               let image = UIImage(data: data) {
                                thumbnail = image
                            }
                        }
                    }
                    
                    // 제목
                    TextField("제목", text: $title)
                        .textFieldStyle(.roundedBorder)
                    
                    // 메모
                    VStack(alignment: .leading, spacing: 8) {
                        Text("메모")
                            .font(.headline)
                        TextField("메모를 입력하세요", text: $memo, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    // 별점
                    VStack(alignment: .leading, spacing: 8) {
                        Text("별점")
                            .font(.headline)
                        StarRatingPicker(rating: $rating)
                    }
                    
                    // 장르
                    VStack(alignment: .leading, spacing: 16) {
                        Text("장르")
                            .font(.headline)
                        TagSelectionView(tags: availableGenres, mode: .multiple($genres))
                    }
                    
                    // OTT
                    VStack(alignment: .leading, spacing: 16) {
                        Text("OTT 플랫폼")
                            .font(.headline)
                        TagSelectionView(tags: availableOtts, mode: .multiple($ottTags))
                    }
                    
                    // 유형
                    VStack(alignment: .leading, spacing: 16) {
                        Text("유형")
                            .font(.headline)
                        HStack {
                            TagSelectionView(tags: availableTypes, mode: .single($typeTag))
                            Spacer()
                        }
                    }
                    
                    // 회차
                    VStack(alignment: .leading, spacing: 8) {
                        Text("총 회차")
                            .font(.headline)
                        Stepper("총 회차: \(episodes)", value: $episodes, in: 1...500)
                    }
                    
                    // 시청 상태
                    VStack(alignment: .leading, spacing: 8) {
                        Text("시청 상태")
                            .font(.headline)
                        Picker("시청 상태", selection: $watchStatus) {
                            ForEach(availableWatchStatus, id: \.self) { status in
                                Text(status).tag(status)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    // 시청 중인 경우 진행률
                    if watchStatus == "시청 중" {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("시청 진행률")
                                .font(.headline)
                            EpisodeProgressPicker(progress: $progress, episodes: $episodes)
                        }
                    }
                }
                .padding()
            }
            
            .navigationTitle("미디어 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("저장") {
                        mediaVM.addMedia(
                            title: title, genres: genres, ottTags: ottTags, typeTags: typeTag.map { [$0] } ?? [],
                            watchStatus: watchStatus, rating: rating, progress: progress, episodes: episodes,
                            memo: memo, thumbnail: thumbnail, nickname: authVM.userNickname
                        )
                        // 저장 후 뷰 닫기
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
}

#Preview {
    NavigationView {
        MediaNewView()
    }
    .environmentObject(AuthViewModel())
    .environmentObject(MediaViewModel(isPreview: true))
}

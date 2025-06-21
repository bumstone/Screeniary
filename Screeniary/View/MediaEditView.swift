//
//  MediaEditView.swift
//  Screeniary
//
//  Created by 고범석 on 6/20/25.
//

import SwiftUI
import PhotosUI

struct MediaEditView: View {
    @EnvironmentObject var mediaVM: MediaViewModel
    @Environment(\.dismiss) var dismiss
    @Binding var media: Media
    
    @State private var title: String
    @State private var rating: Double
    @State private var progress: Double
    @State private var episodes: Int
    @State private var genres: [String]
    @State private var ottTags: [String]
    @State private var typeTag: String?
    @State private var watchStatus: String
    @State private var memo: String
    @State private var thumbnail: UIImage?
    @State private var thumbnailName: String
    @State private var selectedImageItem: PhotosPickerItem? = nil
    
    @State var image = UIImage()
    
    let availableGenres = ["액션", "코미디", "로맨스/멜로", "SF", "판타지", "애니메이션", "범죄/스릴러", "공포/미스터리", "드라마", "다큐멘터리", "음악/뮤지컬", "사극", "스포츠"]
    let availableOtts = ["Netflix", "Disney+", "Youtube", "CoupangPlay", "Watcha", "Tving", "Wavve", "AppleTV+"]
    let availableTypes = ["영화", "드라마", "다큐", "스포츠"]
    let availableWatchStatus = ["시청 예정", "시청 중", "시청 완료"]
    
    let size = CGSize(width: 200, height: 200)
    
    init(media: Binding<Media>) {
        self._media = media
        // 기존 데이터로 초기화
        self._title = State(initialValue: media.wrappedValue.title)
        self._rating = State(initialValue: media.wrappedValue.rating)
        self._progress = State(initialValue: media.wrappedValue.progress)
        self._episodes = State(initialValue: media.wrappedValue.episodes)
        self._genres = State(initialValue: media.wrappedValue.genres)
        self._ottTags = State(initialValue: media.wrappedValue.ottTags)
        self._typeTag = State(initialValue: media.wrappedValue.typeTags.first)
        self._watchStatus = State(initialValue: media.wrappedValue.watchStatus)
        self._memo = State(initialValue: media.wrappedValue.memo)
        self._thumbnailName = State(initialValue: media.wrappedValue.thumbnailName ?? UUID().uuidString)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    PhotosPicker(selection: $selectedImageItem, matching: .images) {
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
                    .onChange(of: selectedImageItem) { newValue in
                        Task {
                            if let data = try? await newValue?.loadTransferable(type: Data.self),
                               let loadedImage = UIImage(data: data) {
                                thumbnail = loadedImage
                                image = loadedImage
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
                    
                    // 유형 (왼쪽 정렬)
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
            .navigationTitle("미디어 수정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("저장") {
                        saveChanges()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    // 객체 업데이트
    private func saveChanges() {
        media.title = title
        media.rating = rating
        media.progress = progress
        media.episodes = episodes
        media.genres = genres
        media.ottTags = ottTags
        media.typeTags = typeTag.map { [$0] } ?? []
        media.watchStatus = watchStatus
        media.memo = memo
        media.thumbnailName = thumbnailName
        
        mediaVM.updateMedia(media: media, newThumbnail: thumbnail)
        
        dismiss()
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var mockMedia = Media(
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
            thumbnailName: "noImage",
            isFavorite: true,
            nickname: "사용자"
        )
        
        var body: some View {
            MediaEditView(media: $mockMedia)
                .environmentObject(MediaViewModel()) // ViewModel 주입
        }
    }
    
    return PreviewWrapper()
}

//
//  MediaViewModel.swift
//  Screeniary
//
//  Created by 고범석 on 6/20/25.
//

import Foundation
import SwiftUI

// ObservableObject를 채택하여 SwiftUI 뷰가 이 객체의 변경사항을 감지할 수 있게 합니다.
class MediaViewModel: ObservableObject {
    
    // @Published 프로퍼티는 변경될 때마다 구독 중인 뷰를 자동으로 업데이트합니다.
    @Published var medias: [Media] = []
    @Published var displayedMedias: [Media] = []
    @Published var sortOption: SortOption = .latest {
        // sortOption이 변경되면 즉시 sortMedia 함수를 호출
        didSet {
            sortMedia()
        }
    }
    
    private var dbFirebase: DbFirebase?
    
    init() {
        setupFirebase()
    }
    
    // SwiftUI 프리뷰를 위한 초기화 메서드
    init(isPreview: Bool) {
        guard isPreview else {
            setupFirebase()
            return
        }
        // 프리뷰용 목업(Mock) 데이터를 생성합니다.
        let now = Date()
        self.medias = [
            Media(
                id: "preview-media-1",
                title: "더 글로리",
                genres: ["드라마", "스릴러"],
                ottTags: ["Netflix"],
                typeTags: ["드라마"],
                watchStatus: "시청 중",
                rating: 4.5,
                progress: 0.6,
                episodes: 16,
                watchDate: Date(),
                memo: "프리뷰용 목업 데이터입니다.",
                thumbnailName: "noImage",
                isFavorite: true,
                nickname: "고범석",
                creationDate: now
            ),
            Media(
                id: "preview-media-2",
                title: "오징어 게임",
                genres: ["스릴러", "액션"],
                ottTags: ["Netflix"],
                typeTags: ["드라마"],
                watchStatus: "시청 완료",
                rating: 5.0,
                progress: 1.0,
                episodes: 9,
                watchDate: Date().addingTimeInterval(-86400),
                memo: "아주 재미있게 봤습니다.",
                thumbnailName: "noImage",
                isFavorite: false,
                nickname: "고범석",
                creationDate: now.addingTimeInterval(-86400 * 5) // 5일 전 생성
            )
        ]
        sortMedia() // 정렬 함수를 호출하여 displayedMedias를 채웁니다.
    }
    
    
    func sortMedia() {
        switch sortOption {
        case .latest:
            displayedMedias = medias.sorted { $0.creationDate > $1.creationDate }
        case .rating:
            displayedMedias = medias.sorted { $0.rating > $1.rating }
        }
    }
    
    func addMedia(
        title: String, genres: [String], ottTags: [String], typeTags: [String],
        watchStatus: String, rating: Double, progress: Double, episodes: Int,
        memo: String, thumbnail: UIImage?, nickname: String
    ) {
        let documentId = UUID().uuidString
        let newThumbnailName = thumbnail != nil ? documentId : nil
        
        let newMedia = Media(
            id: documentId, // id를 여기서 할당
            title: title, genres: genres, ottTags: ottTags, typeTags: typeTags,
            watchStatus: watchStatus, rating: rating, progress: progress, episodes: episodes,
            watchDate: Date(), memo: memo, thumbnailName: newThumbnailName,
            isFavorite: false, nickname: nickname
        )
        
        // Firestore에 저장 요청
        dbFirebase?.saveChange(key: documentId, object: Media.toDict(media: newMedia), action: .add)
        
        // 이미지 업로드 요청
        if let thumbnail = thumbnail, let thumbnailName = newThumbnailName {
            ImagePool.putImage(name: thumbnailName, image: thumbnail)
            DbFirebase.uploadImage(imageName: thumbnailName, image: thumbnail) { _ in }
        }
    }
    
    // 미디어 '수정' 함수
    func updateMedia(media: Media, newThumbnail: UIImage?) {
        var mediaToUpdate = media
        
        // 이미지가 변경되었는지 확인
        if let newThumbnail = newThumbnail {
            // 새 이미지가 있으면 새 ID를 기반으로 이름을 지정하고 업로드합니다.
            let newThumbnailName = media.id ?? UUID().uuidString // 기존 ID를 최대한 활용
            mediaToUpdate.thumbnailName = newThumbnailName
            
            ImagePool.putImage(name: newThumbnailName, image: newThumbnail)
            DbFirebase.uploadImage(imageName: newThumbnailName, image: newThumbnail) { _ in }
        }
        
        // Firestore에 수정 요청
        if let id = mediaToUpdate.id {
            dbFirebase?.saveChange(key: id, object: Media.toDict(media: mediaToUpdate), action: .modify)
        }
    }
    
    
    func deleteMedia(at offsets: IndexSet) {
        let mediasToDelete = offsets.map { displayedMedias[$0] }
        mediasToDelete.forEach { media in
            if let id = media.id {
                dbFirebase?.saveChange(key: id, object: [:], action: .delete)
            }
        }
    }
    
    func setupFirebase() {
        if dbFirebase == nil {
            dbFirebase = DbFirebase(parentNotification: handleDbChange)
            dbFirebase?.setQuery(from: 1, to: 10000)
        }
    }
    
    func handleDbChange(dict: [String: Any]?, id: String?, dbaction: DbAction?) {
        guard let dict = dict, let id = id, let dbaction = dbaction else { return }
        let media = Media.fromDict(dict: dict, id: id)
        
        // 데이터 변경은 항상 Main 스레드에서 처리하여 UI 업데이트 오류를 사전에 방지함.
        DispatchQueue.main.async {
            switch dbaction {
            case .add:
                if !self.medias.contains(where: { $0.id == media.id }) {
                    self.medias.append(media)
                }
            case .modify:
                if let index = self.medias.firstIndex(where: { $0.id == media.id }) {
                    self.medias[index] = media
                }
            case .delete:
                self.medias.removeAll { $0.id == media.id }
            }
            // 원본 데이터(medias)가 변경된 후 정렬을 다시 수행합니다.
            self.sortMedia()
        }
    }
    
    // 즐겨찾기 토글 기능
    func toggleFavorite(for media: Media) {
        // ViewModel이 가진 원본 'medias' 배열에서 해당 항목의 인덱스를 찾습니다.
        guard let index = medias.firstIndex(where: { $0.id == media.id }) else {
            print("Error: Could not find media to toggle favorite.")
            return
        }
        
        // 'medias' 배열의 해당 항목의 isFavorite 값을 직접 변경
        // @Published 프로퍼티가 변경되었으므로, UI가 즉시 업데이트
        medias[index].isFavorite.toggle()
        
        // 변경된 데이터 수신
        let updatedMedia = medias[index]
        
        // 변경된 데이터를 Firestore에 저장합니다. (백그라운드 작업)
        if let id = updatedMedia.id {
            dbFirebase?.saveChange(key: id, object: Media.toDict(media: updatedMedia), action: .modify)
        }
    }
    
    
}

//
//  MediaEntry.swift
//  Screeniary
//
//  Created by 고범석 on 6/19/25.
//

import UIKit
import Foundation
import FirebaseFirestore

struct Media: Identifiable, Codable {
    @DocumentID var id: String? // Firestore 문서 ID 자동 주입
    
    var title: String
    var genres: [String]
    var ottTags: [String]
    var typeTags: [String]
    var watchStatus: String
    var rating: Double
    var progress: Double
    var episodes: Int
    var watchDate: Date?
    var memo: String
    var thumbnailName: String?
    var isFavorite: Bool
    var nickname: String
    
    init(title: String,
         genres: [String],
         ottTags: [String],
         typeTags: [String],
         watchStatus: String,
         rating: Double,
         progress: Double,
         episodes: Int,
         watchDate: Date?,
         memo: String,
         thumbnailName: String? = nil,
         isFavorite: Bool = false,
         nickname: String
    ) {
        self.title = title
        self.genres = genres
        self.ottTags = ottTags
        self.typeTags = typeTags
        self.watchStatus = watchStatus
        self.rating = rating
        self.progress = progress
        self.episodes = episodes
        self.watchDate = watchDate
        self.memo = memo
        self.thumbnailName = thumbnailName
        self.isFavorite = isFavorite
        self.nickname = nickname
    }
}

extension Media {
    static func toDict(media: Media) -> [String: Any] {
        return [
            "title": media.title,
            "genres": media.genres,
            "ottTags": media.ottTags,
            "typeTags": media.typeTags,
            "watchStatus": media.watchStatus,
            "rating": media.rating,
            "progress": media.progress,
            "episodes": media.episodes,
            "watchDate": media.watchDate?.timeIntervalSince1970 as Any,
            "memo": media.memo,
            "thumbnailName": media.thumbnailName as Any,
            "isFavorite": media.isFavorite,
            "nickname": media.nickname,
            "datetime": Date().timeIntervalSince1970
        ]
    }
    
    static func fromDict(dict: [String: Any]) -> Media {
        return Media(
            title: dict["title"] as! String,
            genres: dict["genres"] as! [String],
            ottTags: dict["ottTags"] as! [String],
            typeTags: dict["typeTags"] as! [String],
            watchStatus: dict["watchStatus"] as! String,
            rating: dict["rating"] as! Double,
            progress: dict["progress"] as! Double,
            episodes: dict["episodes"] as! Int,
            watchDate: (dict["watchDate"] as? TimeInterval).map { Date(timeIntervalSince1970: $0) },
            memo: dict["memo"] as! String,
            thumbnailName: dict["thumbnailName"] as? String,
            isFavorite: dict["isFavorite"] as! Bool,
            nickname: dict["nickname"] as! String
        )
    }
}

extension Media {
    func loadThumbnail(size: CGSize? = nil, completion: @escaping (UIImage) -> Void) {
        guard let imageName = thumbnailName else {
            completion(UIImage()) // 기본 이미지 반환
            return
        }
        
        ImagePool.image(name: imageName, size: size, completion: completion)
    }
}


//
//  Media.swift
//  Screeniary
//
//  Created by 고범석 on 6/19/25.
//

import UIKit
import Foundation
import FirebaseFirestore

struct Media: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    
    var title: String
    var genres: [String]
    var ottTags: [String]
    var typeTags: [String]
    var watchStatus: String
    var rating: Double
    var progress: Double
    var episodes: Int
    var watchDate: Date? // 사용자가 시청한 날짜
    var memo: String
    var thumbnailName: String?
    var isFavorite: Bool
    var nickname: String
    var creationDate: Date // 미디어 기록을 생성한 날짜 (정렬)

    static func == (lhs: Media, rhs: Media) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(id: String? = nil,
         title: String,
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
         nickname: String,
         creationDate: Date = Date() // 기본값을 현재 시간으로 설정
    ) {
        self.id = id
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
        self.creationDate = creationDate
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
            "creationDate": media.creationDate.timeIntervalSince1970
        ]
    }
    
    static func fromDict(dict: [String: Any], id: String) -> Media {
        let creationTimestamp = dict["creationDate"] as? TimeInterval ?? Date().timeIntervalSince1970
        
        return Media(
            id: id,
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
            nickname: dict["nickname"] as! String,
            creationDate: Date(timeIntervalSince1970: creationTimestamp)
        )
    }
}

extension Media {
    func loadThumbnail(size: CGSize? = nil, completion: @escaping (UIImage) -> Void) {
        guard let imageName = thumbnailName, !imageName.isEmpty else {
            ImagePool.image(name: "noImage", size: size, completion: completion)
            return
        }
        ImagePool.image(name: imageName, size: size, completion: completion)
    }
}

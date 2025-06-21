//
//  SortOption.swift
//  Screeniary
//
//  Created by 고범석 on 6/20/25.
//

import Foundation

enum SortOption: String, CaseIterable {
    case latest = "최신순"
    case rating = "별점순"
    
    var systemImage: String {
        switch self {
        case .latest:
            return "calendar"
        case .rating:
            return "star.fill"
        }
    }
}

//
//  Database.swift
//  ch11-kobumseouk-1971204-CityFirebase
//
//  Created by 고범석 on 5/11/25.
//

import Foundation

enum DbAction{
    case add, delete, modify // 데이터베이스 변경의 유형
}

protocol Database{
    // 생성자, 데이터베이스에 변경이 생기면 parentNotification를 호출하여 부모에게 알림
    init(parentNotification: (([String:Any]?, String?, DbAction?) -> Void)?)
    
    func setQuery(from: Any, to: Any)
    
    func saveChange(key: String, object: [String:Any], action: DbAction)
}

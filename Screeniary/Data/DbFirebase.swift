import FirebaseFirestore
import FirebaseStorage
import UIKit

class DbFirebase: Database {
    
    // 데이터를 저장할 Firestore 컬렉션 위치
    var reference: CollectionReference = Firestore.firestore().collection("medias")
    
    var parentNotification: (([String: Any]?, String?, DbAction?) -> Void)?
    var existQuery: ListenerRegistration?
    
    required init(parentNotification: (([String : Any]?, String?, DbAction?) -> Void)?) {
        self.parentNotification = parentNotification
    }
    
    // Firestore 문서의 추가, 수정, 삭제를 처리
    func saveChange(key: String, object: [String : Any], action: DbAction) {
        if action == .delete {
            reference.document(key).delete()
            return
        }
        reference.document(key).setData(object)
    }
    
    // Firestore 데이터 변경을 감지하는 리스너 설정
    func setQuery(from: Any, to: Any) {
        if let query = existQuery {
            query.remove()
        }
        // 필요에 따라 쿼리를 수정하세요. (e.g., order by timestamp)
        let query = reference.order(by: "timestamp", descending: true)
        existQuery = query.addSnapshotListener(onChangingData)
    }
    
    // 리스너에 의해 데이터 변경이 감지되면 호출됨
    func onChangingData(querySnapshot: QuerySnapshot?, error: Error?) {
        guard let querySnapshot = querySnapshot else { return }

        if querySnapshot.documentChanges.isEmpty { return }

        for documentChange in querySnapshot.documentChanges {
            let dict = documentChange.document.data()
            let docID = documentChange.document.documentID
            var action: DbAction?

            switch documentChange.type {
            case .added:
                action = .add
            case .modified:
                action = .modify
            case .removed:
                action = .delete
            }
            
            // 등록된 parentNotification 클로저를 통해 변경 사항을 알림
            parentNotification?(dict, docID, action)
        }
    }
    
    // UIImage를 PNG 데이터로 변환하여 Storage에 업로드
    static func uploadImage(imageName: String, image: UIImage?, completion: @escaping (Bool) -> Void) {
        let storageRef = Storage.storage().reference().child("medias").child(imageName)

        guard let image = image else {
            // 이미지가 nil이면 Storage에서 해당 파일 삭제
            storageRef.delete { _ in completion(true) }
            return
        }

        guard let pngData = image.pngData() else {
            completion(false)
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        storageRef.putData(pngData, metadata: metadata) { _, error in
            completion(error == nil) // 에러가 없으면 true 반환
        }
    }
    
    // Storage에서 이미지 데이터를 다운로드하여 UIImage로 변환
    static func downloadImage(imageName: String, completion: @escaping (UIImage?) -> Void) {
        let storageRef = Storage.storage().reference().child("medias").child(imageName)
        let megaByte = Int64(10 * 1024 * 1024)
        
        storageRef.getData(maxSize: megaByte) { data, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(UIImage(data: data))
        }
    }
}

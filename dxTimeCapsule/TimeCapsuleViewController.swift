import Foundation
import FirebaseFirestore

class TimeCapsuleViewController {
    private var db = Firestore.firestore()
    
    // MARK: - 캡슐 추가 (Create)
    func addTimeCapsule(_ capsule: TimeCapsule) {
        db.collection("timeCapsules").addDocument(data: [
            "title": capsule.title,
            "description": capsule.description,
            "location": capsule.location,
            "createTime": capsule.createTime,
            "unlockTime": capsule.unlockTime,
            "creator": capsule.creator
        ]) { error in
            if let error = error {
                print("문서 추가 에러: \(error)") // 에러 처리
            } else {
                print("캡슐을 성공적으로 추가되었습니다.")
            }
        }
    }
    
    // MARK: - 캡슐 조회 (Read)
    func fetchTimeCapsules(completion: @escaping ([TimeCapsule]) -> Void) {
        db.collection("timeCapsules").getDocuments { (querySnapshot, err) in
            var capsules: [TimeCapsule] = [] // 조회한 캡슐들을 저장할 배열
            
            if let err = err {
                print("캡슐 조회 에러: \(err)") // 에러 처리
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data() // 캡슐 데이터
                    // 캡슐 데이터를 `TimeCapsule` 구조체로 변환
                    let capsule = TimeCapsule(
                        id: document.documentID,
                        title: data["title"] as? String ?? "",
                        description: data["description"] as? String ?? "",
                        location: data["location"] as? GeoPoint ?? GeoPoint(latitude: 0, longitude: 0),
                        createTime: data["createTime"] as? Timestamp ?? Timestamp(),
                        unlockTime: data["unlockTime"] as? Timestamp ?? Timestamp(),
                        creator: data["creator"] as? String ?? ""
                    )
                    capsules.append(capsule) // 배열에 추가
                }
            }
            
            completion(capsules) // 완료 핸들러 호출
        }
    }
    
    // MARK: - 캡슐 업데이트 (Update)
    func updateTimeCapsule(_ capsule: TimeCapsule) {
        guard !capsule.id.isEmpty else { return }
        
        db.collection("timeCapsules").document(capsule.id).updateData([
            "title": capsule.title,
            "description": capsule.description,
            "location": capsule.location,
            "createTime": capsule.createTime,
            "unlockTime": capsule.unlockTime,
            "creator": capsule.creator
        ]) { error in
            if let error = error {
                print("캡슐 업데이트 에러: \(error)") // 에러 처리
            } else {
                print("캡슐을 성공적으로 업데이트되었습니다.")
            }
        }
    }
    
    // MARK: - 캡슐 삭제 (Delete)
    func deleteTimeCapsule(_ capsuleId: String) {
        db.collection("timeCapsules").document(capsuleId).delete() { error in
            if let error = error {
                print("캡슐 삭제 에러: \(error)") // 에러 처리
            } else {
                print("캡슐을 성공적으로 삭제되었습니다.")
            }
        }
    }
}

import Foundation
import FirebaseFirestore
import FirebaseAuth

class TimeCapsuleCreationViewModel {
    
    private var db = Firestore.firestore()
    
    // 타임캡슐 데이터 저장
    func saveTimeCapsule(timeCapsule: TimeCapsule) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let data: [String: Any] = [
            "id": timeCapsule.uid,
            "userId": userId, // 현재 로그인한 사용자의 ID
            "mood": timeCapsule.userMood, // 기분
            "photoUrl": timeCapsule.timeCapsuleImageURL ?? "", // 사진url
            "location": timeCapsule.gpslocation , // 위치
            "user_location": timeCapsule.userLocation ?? "", // 사용자 위치
            "comment": timeCapsule.userLocation ?? "", // 코멘트
            "tags": timeCapsule.tagFriend ?? [], // 태그
            "openDate": timeCapsule.openTimeCapsuleDate, // 개봉일
            "creationDate": timeCapsule.createTimeCapsuleDate // 생성일
        ]
        
        db.collection("timeCapsules").addDocument(data: data) { error in
            if let error = error {
                print("Error saving time capsule: \(error.localizedDescription)")
            } else {
                print("Time capsule saved successfully")
            }
        }
    }
    
    // 특정 사용자의 타임캡슐 데이터 가져오기
    func fetchTimeCapsulesForUser() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("timeCapsules").whereField("userId", isEqualTo: userId)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                    }
                }
            }
    }
}

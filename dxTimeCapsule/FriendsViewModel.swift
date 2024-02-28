import FirebaseFirestore

// 사용자 검색 및 정보 가져오기와 같은 데이터베이스 관련 작업
class FriendsViewModel {
    private let db = Firestore.firestore()
    
    // 친구 검색 (닉네임 기준 영어 2글자만 입력해도 검색되게)
    func searchUsersByNickname(nickname: String, completion: @escaping ([User]?, Error?) -> Void) {
        let query = db.collection("users")
        
        // 입력한 닉네임으로 시작하는 사용자를 검색합니다.
        query.whereField("nickname", isGreaterThanOrEqualTo: nickname)
             .whereField("nickname", isLessThan: nickname + "\u{f8ff}")
             .getDocuments { snapshot, error in
                 if let error = error {
                     completion(nil, error)
                     return
                 }
                 
                 guard let documents = snapshot?.documents else {
                     completion([], nil)
                     return
                 }
                 
                 let users: [User] = documents.compactMap { doc in
                     var user = User(uid: doc.documentID, email: "", nickname: "", profileImageUrl: nil)
                     user.nickname = doc.get("nickname") as? String ?? ""
                     user.profileImageUrl = doc.get("profileImageUrl") as? String
                     user.email = doc.get("email") as? String ?? ""
                     return user
                 }
                 
                 completion(users, nil)
             }
    }

}

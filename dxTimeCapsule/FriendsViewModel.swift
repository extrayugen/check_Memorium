import FirebaseFirestore

class FriendsViewModel {
    private let db = Firestore.firestore()
    
    // 친구 검색 (닉네임 기준 영어 2글자만 입력해도 검색되게)
    func searchUsersByUsername(username: String, completion: @escaping ([User]?, Error?) -> Void) {
        
        // 검색어의 첫 글자를 대문자로 변환합니다.
        let firstLetter = username.prefix(1).uppercased()
        let remainingString = username.dropFirst().lowercased()
        let searchQuery = firstLetter + remainingString

        let query = db.collection("users")
                     .whereField("username", isGreaterThanOrEqualTo: searchQuery)
                     .whereField("username", isLessThan: searchQuery + "\u{f8ff}")

        query.getDocuments { (snapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion([], nil)
                return
            }
            
            let users: [User] = documents.compactMap { doc in
                var user = User(uid: doc.documentID, email: "", username: "", profileImageUrl: nil)
                user.uid = doc.get("uid") as? String ?? ""
                user.username = doc.get("username") as? String ?? ""
                user.profileImageUrl = doc.get("profileImageUrl") as? String
                user.email = doc.get("email") as? String ?? ""
                print("user: \(user)")
                return user
            }
            
            completion(users, nil)
        }
    }
    
    // 사용자의 친구 상태를 확인하는 메서드 추가
     func checkFriendshipStatus(forUser userId: String, completion: @escaping (String) -> Void) {
         // Firestore에서 현재 사용자의 친구 목록, 보낸 친구 요청 목록, 받은 친구 요청 목록을 가져오는 로직 구현
         
         // 예시 로직:
         let currentUser = "현재 사용자 ID" // 현재 사용자 ID를 적절히 설정해야 합니다.
         
         // 현재 사용자의 친구 목록 가져오기
         db.collection("users").document(currentUser).getDocument { (document, error) in
             if let document = document, document.exists {
                 let data = document.data()
                 let friends = data?["friends"] as? [String] ?? []
                 let sentRequests = data?["friendRequestsSent"] as? [String] ?? []
                 let receivedRequests = data?["friendRequestsReceived"] as? [String] ?? []
                 
                 if friends.contains(userId) {
                     completion("이미 친구입니다")
                 } else if sentRequests.contains(userId) {
                     completion("요청 보냄")
                 } else if receivedRequests.contains(userId) {
                     completion("요청 받음")
                 } else {
                     completion("친구 추가")
                 }
             } else {
                 print("Document does not exist")
                 completion("친구 추가")
             }
         }
     }
}

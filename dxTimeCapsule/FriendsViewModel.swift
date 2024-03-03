import FirebaseFirestore
import FirebaseAuth

 class FriendsViewModel {
    let db = Firestore.firestore()
    
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
         let currentUser = Auth.auth().currentUser! // 현재 사용자 ID를 적절히 설정해야 합니다.
         
         // 현재 사용자의 친구 목록 가져오기
         db.collection("users").document("username").getDocument { (document, error) in
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
    
     // 사용자 ID를 기반으로 친구 요청 보내기
     func sendFriendRequest(toUser targetUserId: String, fromUser currentUserId: String, completion: @escaping (Bool, Error?) -> Void) {
         // 요청을 보내는 사용자의 friendRequestsSent 배열 업데이트
         let fromUserRef = db.collection("users").document(currentUserId)
         fromUserRef.updateData([
             "friendRequestsSent": FieldValue.arrayUnion([targetUserId])
         ]) { error in
             if let error = error {
                 print("friendRequestsSent 배열 업데이트 중 에러 발생: \(error.localizedDescription)")
                 completion(false, error)
                 return
             }
             print("사용자 \(fromUserRef)로부터 사용자 \(targetUserId)에게 친구 요청이 성공적으로 보내졌습니다.")
             
             // 요청을 받는 사용자의 friendRequestsReceived 배열 업데이트
             let toUserRef = self.db.collection("users").document(targetUserId)
             toUserRef.updateData([
                 "friendRequestsReceived": FieldValue.arrayUnion([currentUserId])
             ]) { error in
                 if let error = error {
                     print("friendRequestsReceived 배열 업데이트 중 에러 발생: \(error.localizedDescription)")
                     completion(false, error)
                     return
                 }
                 print("사용자 \(targetUserId)가 사용자 \(currentUserId)로부터 친구 요청을 성공적으로 받았습니다.")
                 completion(true, nil)
             }
         }
     }

     
     // 받은 친구 요청 수락하기
    func acceptFriendRequest(fromUser targetUserId: String, forUser currentUserId: String, completion: @escaping (Bool, Error?) -> Void) {
         // Firestore에 친구 요청 수락 데이터 업데이트 로직
     }
}

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthenticationViewModel {
    private let db = Firestore.firestore()
    
    var email: String = ""
    var password: String = ""
    
    // 상태 업데이트를 위한 클로저
    var onAuthStateChanged: ((Bool, String?) -> Void)?
    
    // 회원가입 함수
    func signUp(email: String, password: String, name: String) {
        // Firestore에 사용자 정보 저장
        let userDocument = db.collection("users").document(email)
        userDocument.setData([
            "email": email,
            "password": password, // 실제 앱에서는 비밀번호를 평문으로 저장해서는 안 됩니다. 암호화를 고려해야 합니다.
            "name": name
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added with ID: \(userDocument.documentID)")
            }
        }
    }
    
    // 로그인 함수
    func signIn(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, nil)
            }
        }
    }

}

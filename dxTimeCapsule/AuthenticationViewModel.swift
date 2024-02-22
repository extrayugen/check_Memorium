import Foundation
import FirebaseAuth

class AuthenticationViewModel {
    // 사용자 입력 프로퍼티
    var email: String = ""
    var password: String = ""

    // 상태 업데이트를 위한 클로저
    var onAuthStateChanged: ((Bool, String?) -> Void)?

    // 로그인 함수
    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.onAuthStateChanged?(false, error.localizedDescription)
            } else {
                self?.onAuthStateChanged?(true, nil)
            }
        }
    }

    // 회원가입 함수
    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.onAuthStateChanged?(false, error.localizedDescription)
            } else {
                self?.onAuthStateChanged?(true, nil)
            }
        }
    }
}


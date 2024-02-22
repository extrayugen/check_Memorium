import UIKit
import SnapKit
import FirebaseAuth

class AuthenticationViewController: UIViewController {
    private let loginButton = UIButton(type: .system)
    private let signUpButton = UIButton(type: .system)

    private var viewModel = AuthenticationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white

        // 로그인 버튼 설정
        loginButton.setTitle("로그인", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 10
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)

        // 회원가입 버튼 설정
        signUpButton.setTitle("회원가입", for: .normal)
        signUpButton.backgroundColor = .systemBlue
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.layer.cornerRadius = 10
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)

        // 뷰에 버튼 추가
        view.addSubview(loginButton)
        view.addSubview(signUpButton)

        // 버튼 레이아웃 설정
        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.signUpButton.snp.top).offset(-20)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(50)
        }

        signUpButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-50)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(50)
        }
    }
    
    @objc private func didTapLoginButton() {
        // 로그인 버튼 탭 처리
        viewModel.signIn()
    }

    @objc private func didTapSignUpButton() {
        // 회원가입 버튼 탭 처리
        viewModel.signUp()
    }

    private func showAlert(with message: String) {
        // 간단한 알림 창 표시 함수
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}



// MARK: - Preview
import SwiftUI

struct PreView: PreviewProvider {
    static var previews: some View {
        AuthenticationViewController().toPreview()
    }
}

#if DEBUG
extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }
    
    func toPreview() -> some View {
        Preview(viewController: self)
    }
}
#endif

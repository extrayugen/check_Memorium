import UIKit
import SnapKit
import FirebaseAuth

class AuthenticationViewController: UIViewController {
    
    // MARK: - Propertys
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let signUpButton = UIButton(type: .system)
    private let imageView = UIImageView(image: UIImage(systemName: "person.circle.fill"))
    
    private var authenticationViewModel = AuthenticationViewModel()
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Functions
    private func setupUI() {
        // 배경색 설정
        view.backgroundColor = .white
        
        // 이미지 뷰 설정
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        // 이메일 텍스트 필드 설정
        emailTextField.placeholder = "이메일"
        emailTextField.borderStyle = .roundedRect
        view.addSubview(emailTextField)
        
        // 비밀번호 텍스트 필드 설정
        passwordTextField.placeholder = "비밀번호"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        view.addSubview(passwordTextField)
        
        // UI 컴포넌트 설정 및 레이아웃 조정
        configureUIComponents()
        
        // 이미지 뷰 레이아웃
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-80) // 중앙에서 위로 조금 올림
            make.width.height.equalTo(100)
        }
        
        
        // 이메일 텍스트 필드 레이아웃 설정
        emailTextField.placeholder = "이메일"
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(50)
        }
        
        // 비밀번호 텍스트 필드 레이아웃 설정
        passwordTextField.placeholder = "비밀번호"
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emailTextField.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(50)
        }
        
        // 회원가입 버튼 레이아웃 조정
        signUpButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(300)
            make.top.equalTo(loginButton.snp.bottom).offset(30) // 간격을 30 포인트로 조정
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(50)
        }

        // 로그인 버튼 레이아웃 조정
        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(signUpButton.snp.top).offset(-30) // 간격을 30 포인트로 조정
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(50)
        }


    }
    
    private func configureUIComponents() {
        // 로그인 및 회원가입 버튼 설정
        setupButton(loginButton, title: "로그인", backgroundColor: .systemBlue, selector: #selector(didTapLoginButton))
        setupButton(signUpButton, title: "회원가입", backgroundColor: .systemBlue, selector: #selector(didTapSignUpButton))
        
        // 뷰에 컴포넌트 추가
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(signUpButton)
        
        // 로그인 및 회원가입 버튼 레이아웃 설정
        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            // 기타 제약 조건
        }

        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            // 기타 제약 조건
        }
    }
    
    
    // 버튼 셋업
    private func setupButton(_ button: UIButton, title: String, backgroundColor: UIColor, selector: Selector) {
        button.setTitle(title, for: .normal)
        button.backgroundColor = backgroundColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: selector, for: .touchUpInside)
    }
    
    // 로그인 버튼 탭 처리
    @objc private func didTapLoginButton() {
        // 가정: emailTextField와 passwordTextField가 이미 정의되어 있고, 사용자 입력을 받는다.
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        authenticationViewModel.signIn(email: email, password: password) { success, errorMessage in
            if success {
                // 로그인 성공 처리, 예: 다음 화면으로 전환
            } else {
                // 에러 메시지 표시
                print(errorMessage ?? "로그인 실패")
            }
        }
    }
    
    // 회원가입 버튼 탭 처리
    @objc private func didTapSignUpButton() {
        let signUpViewController = SignUpViewController()
        let navigationController = UINavigationController(rootViewController: signUpViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }

    
    // 간단한 알림 창 표시 함수
    private func showAlert(with message: String) {
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

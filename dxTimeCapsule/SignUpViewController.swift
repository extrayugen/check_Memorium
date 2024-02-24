import UIKit
import FirebaseFirestore
import FirebaseAuth
import SnapKit

class SignUpViewController: UIViewController {
    
    // MARK: - UI Components
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let nameTextField = UITextField()
    private let signUpButton = UIButton(type: .system)
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        
        emailTextField.placeholder = "이메일"
        passwordTextField.placeholder = "비밀번호"
        passwordTextField.isSecureTextEntry = true
        nameTextField.placeholder = "이름"
        
        signUpButton.setTitle("회원가입", for: .normal)
        signUpButton.backgroundColor = .systemBlue
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.layer.cornerRadius = 10
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, nameTextField, signUpButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        [emailTextField, passwordTextField, nameTextField, signUpButton].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(50)
            }
        }
    }

    
    // MARK: - Navigation Bar Setup
    
    private func setupNavigationBar() {
        navigationItem.title = "회원가입"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissSelf))
    }

    // MARK: - Actions
    
    // 회원가입 함수  
    @objc private func signUpAction() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    // 회원가입 실패 알림 표시
                    let alert = UIAlertController(title: "회원가입 실패", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    self.present(alert, animated: true)
                }
                return
            }
            
            DispatchQueue.main.async {
                // 회원가입 성공 알림 표시
                let alert = UIAlertController(title: "회원가입 완료", message: "회원가입이 되었습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
                    self.dismiss(animated: true, completion: nil) // 성공 시, 현재 뷰 컨트롤러 닫기
                })
                self.present(alert, animated: true)
            }
        }
    }

    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
}


import UIKit
import SnapKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    // 리스너 핸들을 저장하기 위한 변수 선언
    private var authHandle: AuthStateDidChangeListenerHandle?
    
    private let labelsContainerView = UIView()
    private let logoImageView = UIImageView()
    private let appNameLabel = UILabel()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let signUpLabel = UILabel()
    private let signUpButton = UIButton(type: .system)
    private let dividerView = UIView()
    
    private let noAccountLabel = UILabel() // "계정이 없으신가요?" 라벨
    private let signUpActionLabel = UILabel() // "회원가입" 액션 라벨
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupSignUpButtonAction() // 회원가입 버튼의 액션을 설정하는 메서드 호출
        setupViews()
        setupLayouts()
        
        // Test 자동기입
        emailTextField.text =  "bebe@google.com"
        passwordTextField.text = "123456"
        
        
        //        // 폰트 체크 하기
        //        UIFont.familyNames.sorted().forEach { familyName in
        //            print("*** \(familyName) ***")
        //            UIFont.fontNames(forFamilyName: familyName).forEach { fontName in
        //                print("\(fontName)")
        //            }
        //            print("---------------------")
        //        }
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //        // 사용자가 로그인되어 있지 않다면 로그인 화면을 유지
    //        if Auth.auth().currentUser == nil {
    //            // 로그인 화면 유지
    //        } else {
    //            // 이미 로그인되어 있다면 메인 페이지로 이동
    //            navigateToMainFeed()
    //        }
    //    }
    
    private func setupSignUpButtonAction() {
        // 회원가입 버튼의 액션 설정
        signUpActionLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSignUpLabel))
        signUpActionLabel.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 기존 색상
        //                loginButton.applyGradient(colors: [#colorLiteral(red: 0.7882352941, green: 0.2941176471, blue: 0.2941176471, alpha: 1), #colorLiteral(red: 0.2941176471, green: 0.07450980392, blue: 0.3098039216, alpha: 1)])
        
        // BlurryBeach
        loginButton.applyGradient(colors: [#colorLiteral(red: 0.831372549, green: 0.2, blue: 0.4117647059, alpha: 1), #colorLiteral(red: 0.7960784314, green: 0.6784313725, blue: 0.4274509804, alpha: 1)])
        
        //         AzurLane
        //        loginButton.applyGradient(colors: [#colorLiteral(red: 0.4980392157, green: 0.4980392157, blue: 0.8352941176, alpha: 1), #colorLiteral(red: 0.5254901961, green: 0.6588235294, blue: 0.9058823529, alpha: 1), #colorLiteral(red: 0.568627451, green: 0.9176470588, blue: 0.8941176471, alpha: 1)])
        
        //         ViceCity
        //        loginButton.applyGradient(colors: [#colorLiteral(red: 0.2039215686, green: 0.5803921569, blue: 0.9019607843, alpha: 1), #colorLiteral(red: 0.9254901961, green: 0.431372549, blue: 0.6784313725, alpha: 1)])
        
        // Mango
        //                loginButton.applyGradient(colors: [#colorLiteral(red: 1, green: 0.8862745098, blue: 0.3490196078, alpha: 1), #colorLiteral(red: 1, green: 0.6549019608, blue: 0.3176470588, alpha: 1)])
        // Custom-1
        //                loginButton.applyGradient(colors: [#colorLiteral(red: 1, green: 0.8862745098, blue: 0.3490196078, alpha: 1), #colorLiteral(red: 0.7894003391, green: 0.2963732481, blue: 0.2954288721, alpha: 1)])
        
    }
    
    deinit {
        // 리스너 제거
        if let handle = authHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    private func setupViews() {
        view.addSubview(logoImageView)
        view.addSubview(appNameLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(dividerView)
        view.addSubview(labelsContainerView)
        
        // labelsContainerView 내에 라벨들을 추가
        labelsContainerView.addSubview(noAccountLabel)
        labelsContainerView.addSubview(signUpActionLabel)
        
        // 로그인 이미지 설정
        logoImageView.image = UIImage(named: "LoginLogo")
        
        // 앱 이름 설정
        appNameLabel.text = "Memorium"
        appNameLabel.font = UIFont.pretendardSemiBold(ofSize: 36)
        appNameLabel.textAlignment = .center
        
        // 이메일 텍스트필드 설정
        configureTextField(emailTextField, placeholder: "Enter your email")
        
        // 비밀번호 텍스트필드 설정
        configureTextField(passwordTextField, placeholder: "Enter your password")
        
        // 로그인 버튼 설정 및 액션 연결ㅐ
        configureButton(loginButton, title: "Login")
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        
        // "계정이 없으신가요?" 라벨 설정
        noAccountLabel.text = "Do not have an account?"
        noAccountLabel.font = .systemFont(ofSize: 14)
        noAccountLabel.textColor = .black
        
        // "회원가입" 라벨 &설정
        signUpActionLabel.text = "Sign Up!"
        signUpActionLabel.font = .systemFont(ofSize: 14, weight: .bold)
        signUpActionLabel.textColor = UIColor(hex: "#D28488")
        signUpActionLabel.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSignUpLabel))
        signUpActionLabel.addGestureRecognizer(tapGesture)
        
        // 디바이더 뷰 셋업
        dividerView.backgroundColor = .lightGray
        
    }
    
    private func setupLayouts() {
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(80)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(220)
        }
        
        appNameLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(appNameLabel.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(44)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.left.right.equalTo(emailTextField)
            make.height.equalTo(44)
        }
        passwordTextField.isSecureTextEntry = true
        
        
        // Add the loginButton constraints
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.left.right.equalTo(passwordTextField)
            make.height.equalTo(44)
        }
        
        // Ensure dividerView is added to the view before setting constraints
        dividerView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-70)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        // labelsContainerView에 대한 높이 제약 조건 추가
        labelsContainerView.snp.makeConstraints { make in
            make.top.equalTo(dividerView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            // 높이를 명시적으로 설정
            make.height.equalTo(20)
        }
        
        // noAccountLabel 및 signUpActionLabel에 대한 레이아웃 설정
        noAccountLabel.snp.makeConstraints { make in
            make.left.equalTo(labelsContainerView.snp.left)
            make.centerY.equalTo(labelsContainerView.snp.centerY)
        }
        
        signUpActionLabel.snp.makeConstraints { make in
            make.right.equalTo(labelsContainerView.snp.right)
            make.centerY.equalTo(labelsContainerView.snp.centerY)
            make.left.equalTo(noAccountLabel.snp.right).offset(5)
        }
        
        // 디버깅을 위한 배경색 설정
        //        labelsContainerView.backgroundColor = .green // labelsContainerView의 배경색 설정
        //        noAccountLabel.backgroundColor = .red // noAccountLabel의 배경색 설정
        //        signUpActionLabel.backgroundColor = .blue // signUpActionLabel의 배경색 설정
        
    }
    
    
    // MARK: - Actions
    // 로그인 버튼 탭 처리
    @objc private func didTapLoginButton() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            let alert = UIAlertController(title: "입력 오류", message: "이메일 또는 비밀번호를 입력해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(alert, animated: true)
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (authResult, error) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let error = error {
                    print("Login failed with error: \(error.localizedDescription)") // Debug print
                    
                    // 로그인 실패: 에러 메시지 처리 및 알림 표시
                    let alert = UIAlertController(title: "로그인 실패", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    self.present(alert, animated: true)
                } else {
                    print("Login succeeded") // Debug print
                    let mainTabVC = MainTabBarView()
                    let navigationController = UINavigationController(rootViewController: mainTabVC)
                       navigationController.modalPresentationStyle = .fullScreen
                       self.present(navigationController, animated: true, completion: nil)

                }
            }
        }
    }
    
    
    
    // 회원가입 버튼 탭 처리
    @objc private func didTapSignUpLabel() {
        let signUpViewController = SignUpViewController()
        self.present(signUpViewController, animated: true, completion: nil)
        print("Sign Up Button Tapped")
        
    }
}


// 텍스트 필드 스타일 설정 함수
private extension LoginViewController {
    func configureTextField(_ textField: UITextField, placeholder: String) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.layer.backgroundColor = UIColor.systemGray6.cgColor
        textField.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
    }
    
    func configureButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
    }
    
    func configureSignUpLabel() {
        signUpLabel.text = "Do not have an account? Sign Up"
        signUpLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        signUpLabel.textAlignment = .center
    }
}




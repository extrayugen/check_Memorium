import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - UI Components
    var profileImageUrl: String?
    
    
    private let profileImageView = UIImageView()
    private let selectImageButton = UIButton()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let usernameTextField = UITextField()
    private let signUpButton = UIButton(type: .system)
    
    private let labelsContainerView = UIView()

    private let dividerView = UIView()

    private let alreadyHaveAccountLabel = UILabel()
    private let signInActionLabel = UILabel()
    
    
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayouts()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        signUpButton.applyGradient(colors: [#colorLiteral(red: 0.831372549, green: 0.2, blue: 0.4117647059, alpha: 1), #colorLiteral(red: 0.7960784314, green: 0.6784313725, blue: 0.4274509804, alpha: 1)])
        selectImageButton.applyGradient(colors: [#colorLiteral(red: 0.831372549, green: 0.2, blue: 0.4117647059, alpha: 1), #colorLiteral(red: 0.7960784314, green: 0.6784313725, blue: 0.4274509804, alpha: 1)])
        
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        view.backgroundColor = .white
        
        // Configure the profileImageView
        profileImageView.image = UIImage(named: "defaultProfileImage")
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.clipsToBounds = true
        profileImageView.isUserInteractionEnabled = true // if you want the image to be tappable
        view.addSubview(profileImageView)
        
        // Configure the selectImageButton
        configureButton(selectImageButton, title: "Select Image")
        selectImageButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        
        // Configure the text fields
        configureTextField(emailTextField, placeholder: "Enter your email")
        configureTextField(passwordTextField, placeholder: "Enter your password", isSecure: true)
        configureTextField(usernameTextField, placeholder: "Enter your username")
        
        // Configure the signUpButton
        configureButton(signUpButton, title: "Sign Up")
        signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        
        // 디바이더 뷰 셋업
        dividerView.backgroundColor = .lightGray
        view.addSubview(dividerView)
        
        view.addSubview(labelsContainerView)
        
        // labelsContainerView 내에 라벨들을 추가
        labelsContainerView.addSubview(alreadyHaveAccountLabel)
        labelsContainerView.addSubview(signInActionLabel)
        
        // Configure the Label
        alreadyHaveAccountLabel.text = "Already have an account?"
        alreadyHaveAccountLabel.font = .systemFont(ofSize: 14)
        alreadyHaveAccountLabel.textAlignment = .center
        alreadyHaveAccountLabel.isUserInteractionEnabled = true
        
        signInActionLabel.text = "Sign In"
        signInActionLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        signInActionLabel.textAlignment = .center
        signInActionLabel.isUserInteractionEnabled = true
        signInActionLabel.textColor = UIColor(hex: "#D28488")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(alreadyHaveAccountTapped))
        signInActionLabel.addGestureRecognizer(tapGesture)
    }
    
    
    private func setupLayouts() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(80)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(220)
        }
        
        selectImageButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(selectImageButton.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(44)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(10)
            make.left.right.equalTo(emailTextField)
            make.height.equalTo(44)
        }
        
        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
            make.left.right.equalTo(passwordTextField)
            make.height.equalTo(44)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(20)
            make.left.right.equalTo(usernameTextField)
            make.height.equalTo(50)
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

        alreadyHaveAccountLabel.snp.makeConstraints { make in
            make.left.equalTo(labelsContainerView.snp.left)
            make.centerY.equalTo(labelsContainerView.snp.centerY)
            make.height.equalTo(labelsContainerView.snp.height) // labelsContainerView와 동일한 높이를 가지도록 설정
        }

        signInActionLabel.snp.makeConstraints { make in
            make.right.equalTo(labelsContainerView.snp.right)
            make.centerY.equalTo(labelsContainerView.snp.centerY)
            make.left.equalTo(alreadyHaveAccountLabel.snp.right).offset(5)
            make.height.equalTo(labelsContainerView.snp.height) // labelsContainerView와 동일한 높이를 가지도록 설정
        }
    }
    
    // MARK: - Functions
    private func configureTextField(_ textField: UITextField, placeholder: String, isSecure: Bool = false) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = isSecure
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.layer.backgroundColor = UIColor.systemGray6.cgColor
        view.addSubview(textField)
    }
    
    private func configureButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
         button.setTitleColor(.white, for: .normal)
         button.titleLabel?.font = UIFont.systemFont(ofSize: 14) // 텍스트 크기 및 폰트 설정
         button.layer.cornerRadius = 10
         button.snp.makeConstraints { make in
             make.height.equalTo(44)
         }
         view.addSubview(button)
    }
    
    private func presentAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
    // MARK: - Actions
    
    @objc private func selectImagePressed() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true // if you want to allow editing
        imagePickerController.sourceType = .photoLibrary // or .camera if you want to take a photo
        present(imagePickerController, animated: true)
    }
    
    @objc private func selectImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // 이전 화면으로 돌아가기
    @objc private func dismissSelf() {
        // 네비게이션 컨트롤러를 사용하는 경우 이전 화면으로 돌아감
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        } else {
            // 네비게이션 컨트롤러가 없는 경우, 모달을 닫음
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func alreadyHaveAccountTapped() {
        // Go back to login view controller
        navigationController?.popViewController(animated: true)
    }
    
    // 회원가입 함수
    @objc private func signUpButtonPressed() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let username = usernameTextField.text, !username.isEmpty
//              let profileImageView = profileImageView, !profileImageView.image!.isEqualToImage(UIImage(named: "defaultProfileImage")!)
        else {
            presentAlert(title: "입력 오류", message: "모든 필드를 채워주세요.")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                self.presentAlert(title: "회원가입 실패", message: error.localizedDescription)
                return
            }
            
            guard let uid = authResult?.user.uid else { return }
            let userDocument = Firestore.firestore().collection("users").document(uid)
            
            // 사용자 정보를 Firestore에 저장합니다.
            var userData: [String: Any] = [
                "uid": uid,
                "email": email,
                "nickname": username,
                "friends": [],
                "friendRequestsSent": [],
                "friendRequestsReceived": []
            ]
            
            if let profileImageUrl = self.profileImageView.image?.roundedImage()?.pngData() {
                userData["profileImageUrl"] = profileImageUrl
            } else {
                // 프로필 이미지가 없는 경우 기본 이미지로 설정
                let defaultProfileImageUrl = "defaultProfileImage"
                userData["profileImageUrl"] = defaultProfileImageUrl
            }
            
            userDocument.setData(userData) { error in
                if let error = error {
                    self.presentAlert(title: "정보 저장 실패", message: error.localizedDescription)
                } else {
                    // 회원가입 성공 알림 후 이전 화면으로 돌아가기
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "회원가입 성공", message: "회원가입이 완료되었습니다.", preferredStyle: .alert)
                        print("----------------------------")
                        print("가입한 userData: \(userData)")
                        print("----------------------------\n")
                        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
                            self.dismiss(animated: true, completion: nil)
                        })
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            profileImageView.image = editedImage.roundedImage()
        } else if let originalImage = info[.originalImage] as? UIImage {
            profileImageView.image = originalImage.roundedImage()
        }
        
        dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
        
    }
}

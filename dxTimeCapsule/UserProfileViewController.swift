//
//  UserProfileViewController.swift
//  dxTimeCapsule
//
//  Created by t2023-m0051 on 2/28/24.
//

import UIKit
import SnapKit
import SDWebImage
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage


class UserProfileViewController: UIViewController {
    
    // MARK: - Properties
    private let userProfileViewModel = UserProfileViewModel()
    
    // MARK: - UI Components
    private let labelsContainerView = UIView()
    private let profileImageView = UIImageView()
    private let nicknameLabel = UILabel()
    private let emailLabel = UILabel()
    private let logoutButton = UIButton()
    
    private let areYouSerious = UILabel()
    private let deleteAccountLabel = UILabel()
    private let dividerView = UIView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        userProfileViewModel.fetchUserData { [weak self] in
            self?.bindViewModel()
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // 이미지 뷰의 크기에 따라 cornerRadius를 동적으로 설정합니다.
        let imageSize: CGFloat = profileImageView.frame.width
        profileImageView.layer.cornerRadius = imageSize / 2
        
        logoutButton.applyGradient(colors: [#colorLiteral(red: 0.831372549, green: 0.2, blue: 0.4117647059, alpha: 1), #colorLiteral(red: 0.7960784314, green: 0.6784313725, blue: 0.4274509804, alpha: 1)])
    }
    
    // MARK: - Setup
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(profileImageView)
        view.addSubview(nicknameLabel)
        view.addSubview(logoutButton)
        view.addSubview(dividerView)
        view.addSubview(emailLabel)
        view.addSubview(labelsContainerView)
        
        // Profile Image View Setup
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true // 이 부분을 추가합니다.
        let imageSize: CGFloat = 220 // 원하는 이미지 크기로 설정
        profileImageView.layer.cornerRadius = imageSize / 2 // 이미지 뷰를 둥글게 처리하기 위해 반지름을 이미지 크기의 절반으로 설정
    
        // Nickname Label Setup
        nicknameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        nicknameLabel.textAlignment = .center
        
        // Email Label Setup
        emailLabel.font = .systemFont(ofSize: 18, weight: .regular)
        emailLabel.textAlignment = .center
               
        // Logout Button Setup
        logoutButton.setTitle("로그아웃", for: .normal)
        logoutButton.titleLabel?.font = .systemFont(ofSize: 14)
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        logoutButton.layer.cornerRadius = 12
        
        // Divider View Setup
        dividerView.backgroundColor = .lightGray
        
        // "계정이 없으신가요?" 라벨 설정
        areYouSerious.text = "정말 탈퇴하실 건가요..?"
        areYouSerious.font = .systemFont(ofSize: 14)
        areYouSerious.textColor = .black
        
        // Delete Account Label Setup
        deleteAccountLabel.text = "탈퇴하기"
        deleteAccountLabel.font = .systemFont(ofSize: 14, weight: .bold)
        deleteAccountLabel.textColor = UIColor(hex: "#D28488")
        deleteAccountLabel.textAlignment = .center
        
        labelsContainerView.addSubview(areYouSerious)
        labelsContainerView.addSubview(deleteAccountLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(deleteProfileTapped))
        deleteAccountLabel.isUserInteractionEnabled = true // 사용자 인터랙션 활성화
        deleteAccountLabel.addGestureRecognizer(tapGesture)
    }

    private func setupConstraints() {
        // Profile Image View Constraints
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(220)
            profileImageView.setRoundedImage()
        }
        
        // Nickname Label Constraints
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        // Email Label Constraints
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        
        // Logout Button Constraints
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(50)
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
        
        // Delete Account Label Constraints
        areYouSerious.snp.makeConstraints { make in
            make.left.equalTo(labelsContainerView.snp.left)
            make.centerY.equalTo(labelsContainerView.snp.centerY)
        }

        deleteAccountLabel.snp.makeConstraints { make in
            make.right.equalTo(labelsContainerView.snp.right)
            make.centerY.equalTo(labelsContainerView.snp.centerY)
            make.left.equalTo(areYouSerious.snp.right).offset(5)
        }
    }
    
    // MARK: - Binding
    private func bindViewModel() {
        // 프로필 이미지 URL이 nil이거나 비어있는 경우 기본 이미지 사용
        if let profileImageUrl = userProfileViewModel.profileImageUrl, !profileImageUrl.isEmpty {
            profileImageView.sd_setImage(with: URL(string: profileImageUrl), placeholderImage: UIImage(named: "defaultProfileImage"))
        } else {
            // 기본 이미지를 사용하거나 이미지가 없는 경우를 처리할 수 있습니다.
            profileImageView.image = UIImage(named: "LoginLogo")
        }

        // 닉네임 설정
        nicknameLabel.text = userProfileViewModel.nickname
        
        // 이메일 설정
        emailLabel.text = userProfileViewModel.email
    }
    
    // MARK: - Actions
    
    @objc private func logoutTapped() {
        do {
            try Auth.auth().signOut()
            
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
            
            let loginViewController = LoginViewController()
            sceneDelegate.window?.rootViewController = loginViewController
            sceneDelegate.window?.makeKeyAndVisible()
        } catch let signOutError as NSError {
            print("로그아웃 실패: \(signOutError.localizedDescription)")
        }
    }
    
    
    @objc private func deleteProfileTapped() {
        // 사용자 ID를 가져옵니다.
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        // Firestore에서 사용자 데이터 삭제
        let userDocument = Firestore.firestore().collection("users").document(userId)
        userDocument.delete { error in
            if let error = error {
                // Firestore에서 사용자 데이터 삭제 실패 처리
                print("Firestore에서 사용자 데이터 삭제 실패: \(error.localizedDescription)")
                return
            }
            
            // Firebase Storage에서 사용자 이미지 삭제
            let storageRef = Storage.storage().reference().child("userProfileImages/\(userId)/profileImage.jpg")
            storageRef.delete { error in
                if let error = error as NSError? {
                    // Storage 오류 코드 확인
                    if error.domain == StorageErrorDomain && error.code == StorageErrorCode.objectNotFound.rawValue {
                        // 이미지가 존재하지 않는 경우, 오류를 무시하고 계속 진행
                        print("이미지가 존재하지 않으므로 삭제 과정을 건너뜁니다.")
                    } else {
                        // 다른 유형의 오류 처리
                        print("Storage에서 이미지 삭제 실패: \(error.localizedDescription)")
                    }
                    return
                }
                // 이미지 삭제 성공 처리
                print("이미지가 성공적으로 삭제되었습니다.")
            }
            
            // Firebase Authentication에서 사용자 삭제
            Auth.auth().currentUser?.delete { error in
                if let error = error {
                    // 사용자 삭제 실패 처리
                    print("사용자 삭제 실패: \(error.localizedDescription)")
                } else {
                    // 성공적으로 모든 작업 완료 후 처리
                    print("사용자 계정 및 데이터 삭제 완료")
                    DispatchQueue.main.async {
                        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                        guard let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
                        
                        let loginViewController = LoginViewController()
                        sceneDelegate.window?.rootViewController = loginViewController
                        sceneDelegate.window?.makeKeyAndVisible()
                    }
                }
            }
        }
    }
}



func configureButton(_ button: UIButton, title: String) {
    button.setTitle(title, for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 12
    button.snp.makeConstraints { make in
        make.height.equalTo(44)
    }
}


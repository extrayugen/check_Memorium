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
    private let profileImageView = UIImageView()
    private let nicknameLabel = UILabel()
    private let emailLabel = UILabel()
    private let logoutButton = UIButton()
    private let deleteAccountButton = UIButton()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        userProfileViewModel.fetchUserData { [weak self] in
            self?.bindViewModel()
        }
    }
    
    // MARK: - Setup
    private func setupViews() {
        view.backgroundColor = .white
        
        // Profile Image View Setup
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 50
        view.addSubview(profileImageView)
        
        // Nickname Label Setup
        nicknameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        nicknameLabel.textAlignment = .center
        view.addSubview(nicknameLabel)
        
        // Email Label Setup
        emailLabel.font = .systemFont(ofSize: 18, weight: .regular)
        emailLabel.textAlignment = .center
        view.addSubview(emailLabel)
        
        // Logout Button Setup
        logoutButton.setTitle("로그아웃", for: .normal)
        logoutButton.backgroundColor = .systemMint
        logoutButton.layer.cornerRadius = 5
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        view.addSubview(logoutButton)
        
        // Delete Button Setup
        deleteAccountButton.setTitle("회원탈퇴하기", for: .normal)
        deleteAccountButton.backgroundColor = .systemMint
        deleteAccountButton.layer.cornerRadius = 5
        deleteAccountButton.addTarget(self, action: #selector(deleteProfileTapped), for: .touchUpInside)
        view.addSubview(deleteAccountButton)
    }
    
    private func setupConstraints() {
        // Profile Image View Constraints
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
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
        
        // Delete Button Constraints
        deleteAccountButton.snp.makeConstraints { make in
            make.top.equalTo(logoutButton.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(50)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Binding
    private func bindViewModel() {
        if let profileImageUrl = userProfileViewModel.profileImageUrl, let image = UIImage(named: profileImageUrl) {
            profileImageView.sd_setImage(with: URL(string: profileImageUrl), placeholderImage: UIImage(named: "MainCapsule"))
            profileImageView.image = image
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




//
//  UserProfileViewController.swift
//  dxTimeCapsule
//
//  Created by t2023-m0051 on 2/28/24.
//

import UIKit
import SnapKit
import SDWebImage

class UserProfileViewController: UIViewController {
    
    // MARK: - Properties
    private let userProfileViewModel = UserProfileViewModel()



    // MARK: - UI Components
    private let profileImageView = UIImageView()
    private let nicknameLabel = UILabel()
    private let emailLabel = UILabel()
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
        nicknameLabel.text = "test"
        view.addSubview(nicknameLabel)
        
        // Email Label Setup
        emailLabel.font = .systemFont(ofSize: 18, weight: .regular)
        emailLabel.textAlignment = .center
        view.addSubview(emailLabel)
        
        // Update Button Setup
        deleteAccountButton.setTitle("회원탈퇴하기", for: .normal)
        deleteAccountButton.backgroundColor = .systemMint
        deleteAccountButton.layer.cornerRadius = 5
        deleteAccountButton.addTarget(self, action: #selector(updateProfileTapped), for: .touchUpInside)
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
        
        // Update Button Constraints
        deleteAccountButton.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(20)
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
    @objc private func updateProfileTapped() {
        // Handle the update profile action
    }
}


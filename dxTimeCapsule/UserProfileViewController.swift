//
//  UserProfileViewController.swift
//  dxTimeCapsule
//
//  Created by t2023-m0051 on 2/28/24.
//

import UIKit
import SnapKit

class UserProfileViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: UserProfileViewModel

    // MARK: - UI Components
    private let profileImageView = UIImageView()
    private let nicknameLabel = UILabel()
    private let emailLabel = UILabel()
    private let updateButton = UIButton()

    // MARK: - Initialization
    init(viewModel: UserProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        bindViewModel()
    }

    // MARK: - Setup
    private func setupViews() {
        view.backgroundColor = .white
        
        // Profile Image View Setup
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        view.addSubview(profileImageView)
        
        // Nickname Label Setup
        nicknameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        nicknameLabel.textAlignment = .center
        view.addSubview(nicknameLabel)
        
        // Email Label Setup
        emailLabel.font = .systemFont(ofSize: 18, weight: .regular)
        emailLabel.textAlignment = .center
        view.addSubview(emailLabel)
        
        // Update Button Setup
        updateButton.setTitle("Update Profile", for: .normal)
        updateButton.backgroundColor = .blue
        updateButton.layer.cornerRadius = 5
        updateButton.addTarget(self, action: #selector(updateProfileTapped), for: .touchUpInside)
        view.addSubview(updateButton)
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
        updateButton.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(50)
            make.height.equalTo(50)
        }
    }

    // MARK: - Binding
    private func bindViewModel() {
        profileImageView.image = UIImage(named: viewModel.profileImageUrl ?? "")
        nicknameLabel.text = viewModel.nickname
        emailLabel.text = viewModel.email
    }

    // MARK: - Actions
    @objc private func updateProfileTapped() {
        // Handle the update profile action
    }
}


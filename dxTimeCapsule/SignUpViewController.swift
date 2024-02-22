//
//  SignUpViewController.swift
//  dxTimeCapsule
//
//  Created by t2023-m0031 on 2/23/24.
//

import UIKit
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    // MARK: - UI Components
    
    // UI 컴포넌트 선언
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let nameTextField = UITextField()
    private let signUpButton = UIButton(type: .system)
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // 텍스트 필드 속성 설정
        emailTextField.placeholder = "이메일"
        passwordTextField.placeholder = "비밀번호"
        nameTextField.placeholder = "이름"
        
        // 회원가입 버튼 속성 설정
        signUpButton.setTitle("회원가입", for: .normal)
        signUpButton.backgroundColor = .systemBlue
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.layer.cornerRadius = 10
        signUpButton.addTarget(self, action: #selector(signUpAction), for: .touchUpInside)
        
        // UI 컴포넌트를 뷰에 추가
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, nameTextField, signUpButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        
        // 스택 뷰 레이아웃 설정
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
    }
    
    // MARK: - Navigation Bar Setup
    
    private func setupNavigationBar() {
        navigationItem.title = "회원가입"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissSelf))
    }

    // MARK: - Actions
    
    @objc private func signUpAction() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let name = nameTextField.text, !name.isEmpty else {
            print("모든 필드를 채워주세요.")
            return
        }
        
        // Firestore에 사용자 정보 저장
        let db = Firestore.firestore()
        db.collection("users").document(email).setData([
            "email": email,
            "password": password, // 비밀번호는 실제 앱에서 평문으로 저장하지 않아야 합니다.
            "name": name
        ]) { error in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
            } else {
                print("사용자 정보가 성공적으로 저장되었습니다.")
                // 회원가입 성공 후 처리, 예: 로그인 화면으로 돌아가기
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
}

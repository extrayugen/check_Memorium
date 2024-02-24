//
//  HomeViewController.swift
//  dxTimeCapsule
//
//  Created by t2023-m0031 on 2/23/24.
//

import UIKit

#Preview{
   HomeViewController()
}

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    // 메뉴 스택바 생성
    let menuStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()

    // pagelogo 이미지뷰 생성
    let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "pagelogo"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // 알림 버튼 생성
    let notificationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bell"), for: .normal)
        button.addTarget(self, action: #selector(notificationButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }()

    // 메뉴 버튼 생성
    let menuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        button.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }()

    
    // 스택뷰
    let userStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    // 프로필 이미지뷰
    let profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "profilePic"))
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    // 사용자 ID 레이블
    let userIdLabel: UILabel = {
        let label = UILabel()
        label.text = "사용자 ID"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    // 날씨 정보 레이블
    let weatherLabel: UILabel = {
        let label = UILabel()
        label.text = "날씨 정보"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    // 메인 타임캡슐 이미지뷰
    let mainTCImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "duestTC"))
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    // D-Day 레이블
    let dDayLabel: UILabel = {
        let label = UILabel()
        label.text = "D-DAY"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        return label
    }()
    
    // 위치 레이블
    let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "서울시 양천구 신월동"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        return label
    }()
    
    // 타임캡슐 보러가기 레이블
    let checkDuestTCLabel: UILabel = {
        let label = UILabel()
        label.text = "이 타임캡슐 보러가기 >>"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        return label
    }()
    
    // 새로운 타임캡슐 만들기 버튼 생성
    let addNewTCButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("새로운 타임캡슐 만들기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 113/255, green: 183/255, blue: 246/255, alpha: 1.0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .black)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(addNewTCButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // 열어본 타임캡슐 뷰어
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 163/255, green: 201/255, blue: 246/255, alpha: 1.0)
        view.layer.cornerRadius = 20
        return view
    }()
    
    // 열어본 타임캡슐 라벨
    let openedTCLabel: UILabel = {
        let label = UILabel()
        label.text = "열어본 타임 캡슐"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    
    // 추억 회상하기 라벨
    let memoryLabel: UILabel = {
        let label = UILabel()
        label.text = "추억 회상하기"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    // 추억 회상2 레이블
    let memorySecondLabel: UILabel = {
        let label = UILabel()
        label.text = "타입 캡슐을 타고 잊혀진 추억을 찾아보세요"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    // Opened Label StackView 생성
    lazy var openedLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 3
        stackView.addArrangedSubview(self.memoryLabel)
        stackView.addArrangedSubview(self.memorySecondLabel)
        return stackView
    }()
    
    // Opened TCStackView 생성
    lazy var openedTCStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 8
        stackView.addArrangedSubview(self.memoryThirdLabel)
        stackView.addArrangedSubview(self.openedLabelStackView)
        stackView.addArrangedSubview(self.openedMemoryButton)
        return stackView
    }()
    
    // 추억 회상3 라벨
    let memoryThirdLabel: UILabel = {
        let label = UILabel()
        label.text = "💡"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = .white
        label.backgroundColor = UIColor(red: 113/255, green: 183/255, blue: 246/255, alpha: 1.0)
        label.layer.cornerRadius = 10
        label.textAlignment = .center
        label.clipsToBounds = true
        return label
    }()
    
    // 추억 회상 버튼
    let openedMemoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("〉", for: .normal)
        button.setTitleColor(. black , for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .black)
        button.addTarget(self, action: #selector(openedMemoryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // 다가오는 타임캡슐 라벨
    let upComingLabel: UILabel = {
        let label = UILabel()
        label.text = "다가오는 타임 캡슐"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    
    // MARK: - Collection View

    // 열어 본 타임캡슐 컬렉션 뷰
    lazy var openedcollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "openedCellIdentifier")
        return collectionView
    }()
    
    // 다가오는 타임캡슐 컬렉션 뷰
    lazy var upComingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "upComingCellIdentifier")
        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        openedcollectionView.layoutIfNeeded()
    }
    
    // MARK: - Helpers
    
    private func configureUI(){
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        
        // 메뉴 스택뷰 추가
        view.addSubview(menuStackView)
        menuStackView.translatesAutoresizingMaskIntoConstraints = false
        menuStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        menuStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        menuStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        // pagelogo 이미지뷰 추가
        menuStackView.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.centerYAnchor.constraint(equalTo: menuStackView.centerYAnchor).isActive = true
        logoImageView.leftAnchor.constraint(equalTo: menuStackView.leftAnchor).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 170).isActive = true
        
        // 메뉴 버튼 추가
        let menuButton = UIButton(type: .system)
            menuButton.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
            menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
            menuButton.isUserInteractionEnabled = true
        menuStackView.addSubview(menuButton)
            menuButton.translatesAutoresizingMaskIntoConstraints = false
            menuButton.centerYAnchor.constraint(equalTo: menuStackView.centerYAnchor).isActive = true
            menuButton.rightAnchor.constraint(equalTo: menuStackView.rightAnchor, constant: -16).isActive = true
                
        // 알림 버튼 추가
        let notificationButton = UIButton(type: .system)
            notificationButton.setImage(UIImage(systemName: "bell"), for: .normal)
            notificationButton.addTarget(self, action: #selector(notificationButtonTapped), for: .touchUpInside)
            notificationButton.isUserInteractionEnabled = true
        menuStackView.addSubview(notificationButton)
            notificationButton.translatesAutoresizingMaskIntoConstraints = false
            notificationButton.centerYAnchor.constraint(equalTo: menuStackView.centerYAnchor).isActive = true
            notificationButton.rightAnchor.constraint(equalTo: menuButton.leftAnchor, constant: -16).isActive = true
        
        
        
        // 스택뷰 추가
        view.addSubview(userStackView)
        userStackView.translatesAutoresizingMaskIntoConstraints = false
        userStackView.topAnchor.constraint(equalTo: menuStackView.bottomAnchor, constant: 30).isActive = true
        userStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        userStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        // 프로필 이미지뷰 추가
        userStackView.addArrangedSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.layer.cornerRadius = 20
        
        // 사용자 ID 레이블 추가
        userStackView.addArrangedSubview(userIdLabel)
        
        // 날씨 정보 레이블 추가
        userStackView.addArrangedSubview(weatherLabel)
        
        // 메인 타임캡슐 이미지뷰 추가
        view.addSubview(mainTCImageView)
        mainTCImageView.isUserInteractionEnabled = true
        mainTCImageView.translatesAutoresizingMaskIntoConstraints = false
        mainTCImageView.topAnchor.constraint(equalTo: userStackView.bottomAnchor, constant: 20).isActive = true
        mainTCImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        mainTCImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        mainTCImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        mainTCImageView.layer.cornerRadius = 20
        mainTCImageView.layer.masksToBounds = true
        mainTCImageView.layer.shadowColor = UIColor.black.cgColor
        mainTCImageView.layer.shadowOpacity = 0.5
        mainTCImageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        mainTCImageView.layer.shadowRadius = 4
        
        // D-Day 레이블 추가
        mainTCImageView.addSubview(dDayLabel)
        dDayLabel.translatesAutoresizingMaskIntoConstraints = false
        dDayLabel.topAnchor.constraint(equalTo: mainTCImageView.topAnchor, constant: 15).isActive = true
        dDayLabel.leftAnchor.constraint(equalTo: mainTCImageView.leftAnchor, constant: 15).isActive = true
        
        // 위치 레이블 추가
        mainTCImageView.addSubview(locationLabel)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.centerXAnchor.constraint(equalTo: mainTCImageView.centerXAnchor).isActive = true
        locationLabel.centerYAnchor.constraint(equalTo: mainTCImageView.centerYAnchor).isActive = true
        
        // 타임캡슐 보러가기 레이블 추가
        mainTCImageView.addSubview(checkDuestTCLabel)
        checkDuestTCLabel.translatesAutoresizingMaskIntoConstraints = false
        checkDuestTCLabel.bottomAnchor.constraint(equalTo: mainTCImageView.bottomAnchor, constant: -10).isActive = true
        checkDuestTCLabel.trailingAnchor.constraint(equalTo: mainTCImageView.trailingAnchor, constant: -10).isActive = true
        
        // 메인 타임캡슐 이미지뷰에 탭 제스처 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mainTCImageViewTapped))
        mainTCImageView.addGestureRecognizer(tapGesture)
        
        // 뷰에 버튼 추가
        view.addSubview(addNewTCButton)
        
        // 버튼의 오토레이아웃 설정
        addNewTCButton.translatesAutoresizingMaskIntoConstraints = false
        addNewTCButton.topAnchor.constraint(equalTo: mainTCImageView.bottomAnchor, constant: 25).isActive = true
        addNewTCButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100).isActive = true
        addNewTCButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100).isActive = true
        addNewTCButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // 컨테이너뷰에 라벨 추가
        containerView.addSubview(openedTCLabel)

        // 라벨의 오토레이아웃 설정
        openedTCLabel.translatesAutoresizingMaskIntoConstraints = false
        openedTCLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -20).isActive = true
        openedTCLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        
        view.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        containerView.topAnchor.constraint(equalTo: addNewTCButton.bottomAnchor, constant: 45).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        // 컨테이너뷰에 컬렉션 뷰 추가
        view.addSubview(openedcollectionView)
        openedcollectionView.translatesAutoresizingMaskIntoConstraints = false
        openedcollectionView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        openedcollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        openedcollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        openedcollectionView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 3/5).isActive = true

    
        containerView.addSubview(openedTCStackView)

        openedTCStackView.translatesAutoresizingMaskIntoConstraints = false
        openedTCStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10).isActive = true
        openedTCStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        openedTCStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        openedTCStackView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/5).isActive = true

        openedMemoryButton.widthAnchor.constraint(equalTo: openedMemoryButton.heightAnchor).isActive = true
        
        memoryThirdLabel.widthAnchor.constraint(equalTo: memoryThirdLabel.heightAnchor).isActive = true
        
        view.addSubview(upComingCollectionView)
        
        // 컨테이너뷰에 라벨 추가
        containerView.addSubview(upComingLabel)

        upComingLabel.translatesAutoresizingMaskIntoConstraints = false
        upComingLabel.topAnchor.constraint(equalTo: upComingCollectionView.topAnchor, constant: -20).isActive = true
        upComingLabel.leadingAnchor.constraint(equalTo: upComingCollectionView.leadingAnchor, constant: 10).isActive = true
        
        upComingCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            upComingCollectionView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 45),
            upComingCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            upComingCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            upComingCollectionView.heightAnchor.constraint(equalToConstant: 0) // 적절한 높이 설정
        ])
        
    }
    
    // MARK: - Actions
    
    @objc func menuButtonTapped() {
        print("메뉴 버튼이 클릭되었습니다")
        
    }
    
    @objc func notificationButtonTapped() {
        print("알림 버튼이 클릭되었습니다")
        
    }
    
    @objc private func mainTCImageViewTapped() {
        print("메인 타임캡슐 보러가기 버튼이 클릭되었습니다")
        let mainCapsuleVC = MainCapsuleViewController()
        let navController = UINavigationController(rootViewController: mainCapsuleVC)
        present(navController, animated: true, completion: nil)
    }
    
    @objc func addNewTCButtonTapped() {
        print("새로운 타임캡슐 만들기 버튼이 클릭되었습니다")
        let addNewTCVC = CreationViewController()
        let navController = UINavigationController(rootViewController: addNewTCVC)
        present(navController, animated: true, completion: nil)
    }
    
    @objc func openedMemoryButtonTapped(){
        print("저장된 타임캡슐 열기 버튼이 클릭되었습니다")
        
    }
}

// MARK: - UICollectionViewDataSource

// 첫 번째 컬렉션 뷰 데이터 소스 및 델리게이트
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == openedcollectionView {
            return 20 // 첫 번째 컬렉션 뷰의 아이템 개수 설정
        } else if collectionView == upComingCollectionView {
            return 15 // 두 번째 컬렉션 뷰의 아이템 개수 설정
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "openedCellIdentifier", for: indexPath)
        
        if collectionView == openedcollectionView {
            cell.backgroundColor = .blue // 첫 번째 컬렉션 뷰의 셀 색상 설정
        } else if collectionView == upComingCollectionView {
            cell.backgroundColor = .yellow // 두 번째 컬렉션 뷰의 셀 색상 설정
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == openedcollectionView {
            let collectionViewHeight = openedcollectionView.frame.height
            return CGSize(width: 40, height: collectionViewHeight) // 첫 번째 컬렉션 뷰의 셀 크기 설정
        } else if collectionView == upComingCollectionView {
            let collectionViewHeight = upComingCollectionView.frame.height
            return CGSize(width: 50, height: collectionViewHeight) // 두 번째 컬렉션 뷰의 셀 크기 설정
        } else {
            return CGSize.zero
        }
    }
}

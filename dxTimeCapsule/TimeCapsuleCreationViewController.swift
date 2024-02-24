import UIKit
import SnapKit
import FirebaseFirestore
import FirebaseAuth

class TimeCapsuleCreationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - UI Components
    private let photoPlaceholderView = UIView()
    private let photoPlaceholderLabel = UILabel()
    private let uploadPhotoButton = UIButton()
    private let locationInputButton = UIButton()
    private let capsuleContentTextField = UITextField()
    private let openDateLabel = UILabel()
    private let openDatePicker = UIDatePicker()
    private let saveButton = UIButton()
    
    private let createDummyDataButton = UIButton() // 더미 버튼
    
    private var selectedImage: UIImage? {
        didSet {
            updatePhotoPlaceholder()
        }
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCreateDummyDataButton() // 더미 데이터 생성 버튼 설정 메서드 호출
        
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        setupPhotoPlaceholderView()
        setupLocationInputButton()
        setupCapsuleContentTextField()
        setupOpenDateComponents()
        setupSaveButton()
    }
    
    // 더미 데이터 생성 버튼 설정
    private func setupCreateDummyDataButton() {
        createDummyDataButton.setTitle("더미 데이터 생성", for: .normal)
        createDummyDataButton.backgroundColor = .systemGreen
        createDummyDataButton.layer.cornerRadius = 10
        view.addSubview(createDummyDataButton)
        
        createDummyDataButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        createDummyDataButton.addTarget(self, action: #selector(createDummyDataButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Photo Placeholder View
    private func setupPhotoPlaceholderView() {
        photoPlaceholderView.layer.borderWidth = 1
        photoPlaceholderView.layer.borderColor = UIColor.gray.cgColor
        photoPlaceholderView.layer.cornerRadius = 10
        photoPlaceholderView.backgroundColor = .lightGray
        view.addSubview(photoPlaceholderView)
        
        photoPlaceholderLabel.text = "사진 업로드를 해주세요"
        photoPlaceholderView.addSubview(photoPlaceholderLabel)
        
//        uploadPhotoButton.setTitle("사진 업로드", for: .normal)
        photoPlaceholderView.addSubview(uploadPhotoButton)
        
        // SnapKit을 사용한 레이아웃 설정 - 상단으로 이동
        photoPlaceholderView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9) // 너비를 조금 더 화면에 맞게 조정
            make.height.equalTo(300) // 높이는 그대로 유지
        }
        
        photoPlaceholderLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        uploadPhotoButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        uploadPhotoButton.addTarget(self, action: #selector(photoUploadButtonTapped), for: .touchUpInside)
    }
    
    
    private func updatePhotoPlaceholder() {
        photoPlaceholderView.subviews.forEach { if $0 is UIImageView { $0.removeFromSuperview() } }
        
        if let selectedImage = selectedImage {
            let imageView = UIImageView(image: selectedImage)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            photoPlaceholderView.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            photoPlaceholderLabel.isHidden = true
        } else {
            photoPlaceholderLabel.isHidden = false
        }
    }
    
    // MARK: - Location Input Button
    private func setupLocationInputButton() {
        locationInputButton.setTitle("현재 위치 입력", for: .normal)
        locationInputButton.backgroundColor = .systemTeal
        locationInputButton.layer.cornerRadius = 10
        locationInputButton.addTarget(self, action: #selector(locationInputButtonTapped), for: .touchUpInside)
        view.addSubview(locationInputButton)
        
        locationInputButton.snp.makeConstraints { make in
            make.top.equalTo(photoPlaceholderView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Capsule Content TextField
    private func setupCapsuleContentTextField() {
        capsuleContentTextField.placeholder = "타임캡슐 내용 입력"
        capsuleContentTextField.borderStyle = .roundedRect
        view.addSubview(capsuleContentTextField)
        
        capsuleContentTextField.snp.makeConstraints { make in
            make.top.equalTo(locationInputButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(100) // 내용 입력 공간 확장
        }
    }
    
    // MARK: - Open Date Components
    private func setupOpenDateComponents() {
        openDateLabel.text = "타임캡슐 개봉날짜 선택"
        view.addSubview(openDateLabel)
        
        openDateLabel.snp.makeConstraints { make in
            make.top.equalTo(capsuleContentTextField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(openDatePicker)
        openDatePicker.datePickerMode = .date
        openDatePicker.snp.makeConstraints { make in
            make.top.equalTo(openDateLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Save Button
    private func setupSaveButton() {
        saveButton.setTitle("저장", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.layer.cornerRadius = 10
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        view.addSubview(saveButton)
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(openDatePicker.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Action Handlers
    @objc private func photoUploadButtonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc private func locationInputButtonTapped() {
        print("현재 위치 입력 버튼이 클릭되었습니다.")
        // 위치 입력 로직 구현
    }
    
    @objc private func saveButtonTapped() {
        print("저장 버튼이 클릭되었습니다.")
        // 타임캡슐 저장 로직 구현
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            self.selectedImage = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    // 더미 데이터 생성 버튼 액션
    @objc private func createDummyDataButtonTapped() {
        let db = Firestore.firestore()
        
        let dummyTimeCapsule = TimeCapsule(
            id: UUID().uuidString,
            userId: "dummyUserId", // 건들면안됨
            mood: "😊",
            photoUrl: nil,
            location: nil,
            user_location: "서울",
            comment: "이것은 더미 데이터입니다.",
            tags: ["테스트", "더미"],
            openDate: Date(),
            creationDate: Date()
        )
        
        // Firestore에 더미 데이터 저장
        db.collection("timeCapsules").document(dummyTimeCapsule.id).setData([
            "id": dummyTimeCapsule.id,
            "userId": dummyTimeCapsule.userId,
            "mood": dummyTimeCapsule.mood,
            "photoUrl": dummyTimeCapsule.photoUrl ?? "",
            "location": dummyTimeCapsule.location ?? "",
            "user_location": dummyTimeCapsule.user_location ?? "",
            "comment": dummyTimeCapsule.comment ?? "",
            "tags": dummyTimeCapsule.tags ?? [],
            "openDate": dummyTimeCapsule.openDate,
            "creationDate": dummyTimeCapsule.creationDate
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document successfully added with details:")
                print("ID: \(dummyTimeCapsule.id)")
                print("User ID: \(dummyTimeCapsule.userId)")
                print("Mood: \(dummyTimeCapsule.mood)")
                print("Photo URL: \(dummyTimeCapsule.photoUrl ?? "None")")
                print("Location: \(dummyTimeCapsule.location ?? "None")")
                print("User Location: \(dummyTimeCapsule.user_location ?? "None")")
                print("Comment: \(dummyTimeCapsule.comment ?? "None")")
                print("Tags: \(dummyTimeCapsule.tags?.joined(separator: ", ") ?? "None")")
                print("Open Date: \(dummyTimeCapsule.openDate)")
                print("Creation Date: \(dummyTimeCapsule.creationDate)")
            }
        }
    }

}

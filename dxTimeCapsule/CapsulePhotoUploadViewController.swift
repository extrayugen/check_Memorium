import UIKit
import SnapKit

class CapsulePhotoUploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - UI Components
    private let uploadAreaView = UIView()
    private let imageView = UIImageView() // 이미지를 표시할 UIImageView
    private let instructionLabel = UILabel()
    private let startUploadButton = UIButton()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        setupUploadAreaView()
        setupInstructionLabel()
        setupStartUploadButton()
    }
    
    // MARK: - Upload Area View
    private func setupUploadAreaView() {
        uploadAreaView.backgroundColor = .systemGray6
        uploadAreaView.layer.cornerRadius = 8
        view.addSubview(uploadAreaView)
        
        uploadAreaView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill // 이미지 비율을 유지하면서 뷰를 채웁니다.
        imageView.clipsToBounds = true
        
        uploadAreaView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            make.width.equalTo(350)
            make.height.equalTo(350)
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupInstructionLabel() {
        instructionLabel.text = "현재 작성의 특정지역 모습을\n사진에 담아주세요\n(이 사진이 타임캡슐에 담아지게 됩니다)"
        instructionLabel.numberOfLines = 0
        instructionLabel.textAlignment = .center
        view.addSubview(instructionLabel)
        
        instructionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(uploadAreaView.snp.bottom).offset(20)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
    }
    
    private func setupStartUploadButton() {
        startUploadButton.setTitle("사진 선택", for: .normal)
        startUploadButton.backgroundColor = .systemBlue
        startUploadButton.layer.cornerRadius = 20
        startUploadButton.addTarget(self, action: #selector(startUploadButtonTapped), for: .touchUpInside)
        view.addSubview(startUploadButton)
        
        startUploadButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(instructionLabel.snp.bottom).offset(20)
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Actions
    @objc private func startUploadButtonTapped() {
        // 액션 시트 생성
        let actionSheet = UIAlertController(title: "선택", message: "사진을 촬영하거나 앨범에서 선택해주세요.", preferredStyle: .actionSheet)
        
        // 카메라 액션 추가
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "카메라 촬영", style: .default, handler: { [weak self] _ in
                self?.presentImagePicker(sourceType: .camera)
            }))
        }
        
        // 사진 앨범 액션 추가
        actionSheet.addAction(UIAlertAction(title: "앨범에서 선택", style: .default, handler: { [weak self] _ in
            self?.presentImagePicker(sourceType: .photoLibrary)
        }))
        
        // 취소 액션 추가
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        // 액션 시트 표시
        present(actionSheet, animated: true)
    }

    // UIImagePickerController를 표시하는 메소드
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        
        present(imagePickerController, animated: true, completion: nil)
    }


    // MARK: - Image Picker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // 이미지 피커를 닫습니다.
        picker.dismiss(animated: true, completion: nil)
        
        // info 딕셔너리에서 선택된 이미지를 추출합니다.
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // imageView에 선택된 이미지를 할당합니다.
            imageView.image = pickedImage
        }
    }

}

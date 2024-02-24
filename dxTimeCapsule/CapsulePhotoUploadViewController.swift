import UIKit
import SnapKit

class CapsulePhotoUploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // UI Components
    private let uploadAreaView = UIView()
    private let cameraIconImageView = UIImageView()
    private let instructionLabel = UILabel()
    private let startUploadButton = UIButton()
    
    // View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        setupUploadAreaView()
        setupInstructionLabel()
        setupStartUploadButton()
    }
    
    private func setupUploadAreaView() {
        uploadAreaView.backgroundColor = .systemGray6
        uploadAreaView.layer.cornerRadius = 8
        view.addSubview(uploadAreaView)
        
        cameraIconImageView.image = UIImage(named: "camera_icon") // Replace with your camera icon image
        cameraIconImageView.contentMode = .scaleAspectFit
        uploadAreaView.addSubview(cameraIconImageView)
        
        uploadAreaView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            make.width.equalTo(200)
            make.height.equalTo(200)
        }
        
        cameraIconImageView.snp.makeConstraints { make in
            make.size.equalTo(80)
            make.center.equalToSuperview()
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
        startUploadButton.setTitle("이해했어요", for: .normal)
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
    
    // Action Handlers
    @objc private func startUploadButtonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary // or .camera based on user's choice
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // UIImagePickerControllerDelegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Handle the selected image
        dismiss(animated: true, completion: nil)
    }
}

import UIKit
import SnapKit
import SDWebImage

class SearchUserTableViewCell: UITableViewCell {
    var actionButton: UIButton! // 친구 추가 또는 요청 수락 버튼
    var userProfileImageView: UIImageView!
    var userNameLabel: UILabel!
    var friendsViewModel: FriendsViewModel? // FriendsViewModel 인스턴스 추가
    var addUserAction: (() -> Void)? // 친구 추가/수락 버튼 클릭 시 실행될 클로저
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        userProfileImageView = UIImageView()
        userProfileImageView.layer.cornerRadius = 25
        userProfileImageView.clipsToBounds = true // 이미지 뷰의 모서리를 둥글게 처리하기 위해 필요
        addSubview(userProfileImageView)
        
        userNameLabel = UILabel()
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        addSubview(userNameLabel)
        
        actionButton = UIButton(type: .system)
        actionButton.setTitle("친구 요청", for: .normal)
        actionButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.layer.cornerRadius = 15
        actionButton.backgroundColor = UIColor.systemBlue // 기본 배경색 설정
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        addSubview(actionButton)
    }
    
    private func setupLayout() {
        userProfileImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(80)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(userProfileImageView.snp.trailing).offset(16)
        }
        
        actionButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
    }
    
    // MARK: - Configuration
    func configure(with user: User, viewModel: FriendsViewModel) {
        self.friendsViewModel = viewModel
        userNameLabel.text = user.username
        userProfileImageView.sd_setImage(with: URL(string: user.profileImageUrl ?? ""), placeholderImage: UIImage(named: "defaultProfileImage"))
        
        viewModel.checkFriendshipStatus(forUser: user.uid) { [weak self] status in
            DispatchQueue.main.async {
                self?.updateUIBasedOnFriendshipStatus(status: status)
            }
        }
    }
    
    func updateUIBasedOnFriendshipStatus(status: String) {
        switch status {
        case "이미 친구입니다":
            actionButton.isHidden = true
        case "요청 보냄":
            actionButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.3)
            actionButton.setTitle("요청 보냄", for: .normal)
        case "요청 받음":
            // '요청 받음' 상태에 대한 추가적인 UI 업데이트가 필요할 경우 여기에 구현
            break
        default: // "친구 추가"
            actionButton.backgroundColor = .systemBlue
            actionButton.setTitle("친구 추가", for: .normal)
        }
    }
    
    @objc private func actionButtonTapped() {
        addUserAction?()
    }
}

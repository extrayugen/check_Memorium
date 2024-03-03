import UIKit
import SnapKit
import SDWebImage
import FirebaseAuth

class SearchUserTableViewCell: UITableViewCell {
    var user : User?
    var friendsViewModel: FriendsViewModel? // FriendsViewModel 인스턴스 추가
    
    // 친구 추가/요청 버튼 탭 시 실행될 클로저
    var friendActionButtonTapAction: (() -> Void)?
    
    var friendActionButton: UIButton! // 친구 추가 또는 요청 수락 버튼
    var userProfileImageView: UIImageView!
    var userNameLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI Setup
    
    private func setupUI() {
        userProfileImageView = UIImageView()
        userProfileImageView.layer.cornerRadius = 25
        userProfileImageView.clipsToBounds = true
        contentView.addSubview(userProfileImageView)
        
        userNameLabel = UILabel()
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        contentView.addSubview(userNameLabel)
        
        friendActionButton = UIButton(type: .system)
        friendActionButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        friendActionButton.layer.cornerRadius = 15
        friendActionButton.addTarget(self, action: #selector(friendActionButtonTapped), for: .touchUpInside)
        contentView.addSubview(friendActionButton)
    }
    
    private func setupLayout() {
        userProfileImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(80)
        }
        userNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(userProfileImageView.snp.trailing).offset(25)
        }
        friendActionButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
    }
    
    
    // MARK: - Configuration
    func configure(with user: User, viewModel: FriendsViewModel) {
         self.user = user
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
        case "친구":
            friendActionButton.isHidden = true
        case "요청 받음":
            friendActionButton.backgroundColor = UIColor.lightGray
            friendActionButton.setTitle("요청 받음", for: .normal)
        case "요청 보냄":
            friendActionButton.backgroundColor = UIColor.lightGray
            friendActionButton.setTitle("요청 보냄", for: .normal)
        default: // "친구 요청"
            friendActionButton.backgroundColor = UIColor.white
            friendActionButton.setTitle("친구 요청", for: .normal)
        }
    }
    
    // MARK: - Actions
    
    private func setupActions() {
        friendActionButton.addTarget(self, action: #selector(friendActionButtonTapped), for: .touchUpInside)
    }

    // 친구 요청/승낙 버튼 액션
    @objc private func friendActionButtonTapped() {
        friendActionButtonTapAction?()

        guard let user = user, let viewModel = friendsViewModel else {
            print("User 또는 ViewModel이 설정되지 않았습니다.")
            return
        }

        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("현재 사용자 ID를 가져올 수 없습니다.")
            return
        }

        // 친구 요청 보내기 로직
        let targetUserId = user.uid
        
        viewModel.sendFriendRequest(toUser: targetUserId, fromUser: currentUserId) { success, error in
            if let error = error {
                print("친구 요청 실패: \(error.localizedDescription)")
            } else if success {
                print("친구 요청 성공: \(user.username)")
            } else {
                print("친구 요청 처리 중 알 수 없는 오류 발생")
            }
        }
    }

    // 셀이 선택되었을 때 호출되는 메서드
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // 셀이 선택되었을 때의 UI 업데이트
        if selected {
            backgroundColor = .clear // 선택된 상태에서 배경색 제거
        } else {
            backgroundColor = .white // 선택되지 않은 상태에서는 기본 배경색으로 변경
        }
    }
}

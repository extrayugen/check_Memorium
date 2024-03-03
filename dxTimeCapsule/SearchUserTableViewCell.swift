import UIKit
import SnapKit
import SDWebImage
import FirebaseAuth

class SearchUserTableViewCell: UITableViewCell {
    var user : User?
    var friendsViewModel: FriendsViewModel?
    var friendActionButtonTapAction: (() -> Void)?  // 친구 추가/요청 버튼 탭 시 실행될 클로저
    var userProfileImageView: UIImageView!
    var userNameLabel: UILabel!
    var friendActionButton: UIButton! // 친구 추가 또는 요청 수락 버튼
    var statusLabel: UILabel! // 상태를 나타내는 레이블


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
        
        // 친구 추가/요청 버튼 초기화
        friendActionButton = UIButton(type: .system)
        friendActionButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        friendActionButton.layer.cornerRadius = 15
        friendActionButton.addTarget(self, action: #selector(friendActionButtonTapped), for: .touchUpInside)
        contentView.addSubview(friendActionButton)

        // 상태 레이블 초기화
        statusLabel = UILabel()
        statusLabel.font = UIFont.systemFont(ofSize: 16)
        statusLabel.textAlignment = .center
        contentView.addSubview(statusLabel)
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
        
        statusLabel.snp.makeConstraints { make in
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
        
        // 현재 로그인한 사용자 ID를 가져옴
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            // 로그인한 사용자 ID를 가져올 수 없는 경우, 버튼과 레이블을 숨김
            friendActionButton.isHidden = true
            statusLabel.isHidden = true
            return
        }

        // 사용자의 친구 상태에 따라 UI 업데이트
        updateFriendshipStatusUI(user: user, currentUserID: currentUserID)
    }

   
    func updateFriendshipStatusUI(user: User, currentUserID: String) {
        if user.friends?.contains(currentUserID) ?? false {
            // 이미 친구인 경우
            friendActionButton.isHidden = true
            statusLabel.text = "이미 친구인 상태"
            statusLabel.isHidden = false
        } else if user.friendRequestsSent?.contains(currentUserID) ?? false {
            // 친구 요청을 이미 보낸 경우
            friendActionButton.isHidden = true
            statusLabel.text = "친구 요청 보냄"
            statusLabel.isHidden = false
        } else if user.friendRequestsReceived?.contains(currentUserID) ?? false {
            // 사용자에게 친구 요청을 받은 경우
            friendActionButton.isHidden = false
            friendActionButton.setTitle("요청 받음", for: .normal)
            friendActionButton.backgroundColor = .systemGreen // 또는 적절한 색상으로 변경
            friendActionButton.setTitleColor(.white, for: .normal)
            statusLabel.isHidden = true
        } else {
            // 친구 요청이 가능한 경우
            friendActionButton.isHidden = false
            friendActionButton.setTitle("친구 신청", for: .normal)
            friendActionButton.backgroundColor = .systemBlue
            friendActionButton.setTitleColor(.white, for: .normal)
            statusLabel.isHidden = true
        }
    }
    @objc private func friendActionButtonTapped() {
        guard let user = user, let viewModel = friendsViewModel,
              let currentUserID = Auth.auth().currentUser?.uid else {
            print("사용자 정보 누락 또는 로그인하지 않은 상태입니다.")
            return
        }
        
        viewModel.sendFriendRequest(toUser: user.uid, fromUser: currentUserID) { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    // 요청 성공 시, UI 즉시 업데이트
                    self?.updateFriendshipStatusUI(user: user, currentUserID: currentUserID)
                } else {
                    // 에러 처리
                    print("친구 요청 실패: \(error?.localizedDescription ?? "")")
                }
            }
        }
    }

}

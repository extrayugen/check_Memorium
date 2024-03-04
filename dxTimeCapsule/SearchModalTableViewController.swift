import UIKit
import SnapKit
import SDWebImage

class SearchModalTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate {
    // 황금 비율 상수
    let goldenRatio: CGFloat = 1.618
    
    // MARK: - Properties
    private let userProfileViewModel = UserProfileViewModel()
    private let friendsViewModel = FriendsViewModel()
    private var searchResults: [User] = []
    
    private var searchDebounceTimer: Timer?
    
    private let tableHeaderView: UIView = {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        headerView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
        
        let label = UILabel(frame: headerView.bounds)
        label.text = "친구 검색"
        label.textAlignment = .center
        headerView.addSubview(label)
        
        return headerView
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchUserTableViewCell.self, forCellReuseIdentifier: "userCell")
        return tableView
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search by username"
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        searchTextField.delegate = self
        searchTextField.becomeFirstResponder() // 이 코드 추가
        
        searchTextField.isUserInteractionEnabled  = true
        view.isUserInteractionEnabled = true
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(searchTextField)
        view.addSubview(tableView)
        
        searchTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // 텍스트 필드의 editingChanged 이벤트에 대한 핸들러 설정
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    // MARK: - Functions
    
    // 친구 검색
    private func performSearch() {
        guard let searchText = searchTextField.text?.lowercased(), !searchText.isEmpty else { return }
        
        friendsViewModel.searchUsersByUsername(username: searchText) { [weak self] users, error in
            DispatchQueue.main.async {
                if let error = error {
                    // 에러 처리 로직 (예: 사용자에게 에러 메시지 표시)
                    print("Error searching users: \(error.localizedDescription)")
                } else {
                    if let users = users {
                        if users.isEmpty {
                            // 검색 결과가 없을 때, 검색 목록에 메시지 표시
                            self?.showNoResultsMessage()
                        } else {
                            // 검색 결과가 있을 때는 표시
                            self?.searchResults = users
                            self?.tableView.reloadData()
                        }
                        print("Search results: \(users)")
                    }
                }
            }
        }
    }
    
    
    // MARK: - TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // 키보드 숨김
        performSearch()
        return true
    }
    
    // 검색 결과 없음 메시지 표시
    private func showNoResultsMessage() {
        // 현재 검색 결과 목록을 비워줌

        
        // 검색 결과 없음을 나타내는 레이블 생성 및 설정
        let noResultsLabel = UILabel()
        noResultsLabel.text = "검색 결과 없음"
        noResultsLabel.textColor = .gray
        noResultsLabel.textAlignment = .center
        noResultsLabel.font = UIFont.systemFont(ofSize: 20)
        
        // 테이블 뷰의 footer로 설정하여 검색 결과가 없음을 표시
        tableView.tableFooterView = noResultsLabel
    }
    
    // MARK: - Actions
    
    // 0,5초 디바운싱.
    @objc private func textFieldDidChange(_ textField: UITextField) {
        // 이전에 설정된 타이머가 있으면 취소합니다.
        searchDebounceTimer?.invalidate()
        
        // 사용자가 타이핑을 멈춘 후 0.5초가 지나면 검색을 수행합니다.
        searchDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
            self?.performSearch()
        })
    }
    // MARK: - TableView Delegate & DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? SearchUserTableViewCell else {
                return UITableViewCell()
            }
            let user = searchResults[indexPath.row]
            cell.configure(with: user, viewModel: friendsViewModel)
    
        // 친구 추가/요청 버튼 탭 액션 설정
          cell.friendActionButtonTapAction = { [weak self] in
              print("친구 추가/요청 로직 실행: \(user.username)")
              // 여기에 친구 추가/요청 로직을 구현합니다.
              // 예를 들어, FriendsViewModel의 sendFriendRequest 메서드 호출 등
          }
          return cell
        }
    }

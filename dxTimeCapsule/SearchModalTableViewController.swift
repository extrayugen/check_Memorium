import UIKit
import SnapKit
import SDWebImage

class SearchModalTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchBarDelegate {

    
    private var searchLabel: UILabel!
    private var searchContainerView: UIView!
    
    private let userProfileViewModel = UserProfileViewModel()
    private let friendsViewModel = FriendsViewModel()
    private var searchResults: [User] = []
    
    private var searchDebounceTimer: Timer?
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search UserName"
        searchBar.autocorrectionType = .no
        searchBar.spellCheckingType = .no
        searchBar.backgroundImage = UIImage() // 선 제거
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchUserTableViewCell.self, forCellReuseIdentifier: "userCell")
        return tableView
    }()
    
//    
//    private let searchTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "Search by username"
//        textField.borderStyle = .roundedRect
//        textField.autocorrectionType = .no
//        textField.spellCheckingType = .no
//        textField.layer.cornerRadius = 10
//        return textField
//    }()
//
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchComponents()
        setupTableView()
        
        searchBar.delegate = self
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        searchTextField.delegate = self
//        searchTextField.becomeFirstResponder() // 이 코드 추가
//        
//        searchTextField.isUserInteractionEnabled  = true
//        view.isUserInteractionEnabled = true
//    }
//    
    
    func setupSearchComponents() {
        searchContainerView = UIView()
        searchContainerView.backgroundColor = .white
        
        searchLabel = UILabel()
        searchLabel.text = "Search"
        searchLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        searchLabel.textAlignment = .left
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor.init(hex: "#EFEFEF")
            textField.layer.cornerRadius = 15 // 원하는 라디우스 값 설정
            textField.clipsToBounds = true
        }
        
        searchContainerView.addSubview(searchLabel)
        searchContainerView.addSubview(searchBar)
        
        view.addSubview(searchContainerView)
        
        searchContainerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-80)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(searchBar.snp.bottom)
        }
        
        searchLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(searchLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupTableView() {
        tableView.register(SearchUserTableViewCell.self, forCellReuseIdentifier: "SearchUserCell")
        tableView.rowHeight = 100
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchContainerView.snp.bottom) // 컨테이너 뷰의 바로 아래 시작
            make.leading.bottom.trailing.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // MARK: - Functions
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 디바운싱 로직을 여기에 적용
        searchDebounceTimer?.invalidate()
        searchDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
            self?.performSearch(with: searchText)
        })
    }
    // 친구 검색
    
    private func performSearch(with searchText: String) {
        guard !searchText.isEmpty else {
            searchResults = []
            tableView.reloadData()
            return
        }

        friendsViewModel.searchUsersByUsername(username: searchText) { [weak self] users, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error searching users: \(error.localizedDescription)")
                } else {
                    self?.searchResults = users ?? []
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // 키보드 숨김
        searchBar.endEditing(true)
        return true
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

import UIKit
import SnapKit
import SDWebImage

class SearchModalTableViewController:
    UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    
    private var searchResults: [User] = []
    private let friendsViewModel = FriendsViewModel()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "유저네임으로 검색"
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        return textField
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchUserTableViewCell.self, forCellReuseIdentifier: "userCell")
        return tableView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        setupUI()

        // 모달 외부 탭 제스쳐
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        
        setupModalViewDesign()
        
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
    
        // MARK: - ModalView Designjj
    private func setupModalViewDesign(){
        view.layer.cornerRadius = 25  // 모달 뷰의 모서리를 둥글게
        view.layer.masksToBounds = true  // 모서리를 둥글게 하기 위해 필요
        
        // 그림자 설정
        view.layer.shadowColor = UIColor.black.cgColor  // 그림자 색상을 검은색으로
        view.layer.shadowOpacity = 0.5  // 그림자 투명도
        view.layer.shadowOffset = CGSize(width: 0, height: -3)  // 그림자 방향 (위로 조금 올라가게)
        view.layer.shadowRadius = 25  // 그림자의 퍼짐 정도
        
        // 경계선 설정
        view.layer.borderWidth = 1  // 경계선 두께
        view.layer.borderColor = UIColor.lightGray.cgColor  // 경계선 색상
    }
    
    // MARK: - Functions
    
    // 친구 검색
    private func performSearch(_ textField: UITextField) {
            guard let searchText = textField.text, !searchText.isEmpty else {
                searchResults = []
                tableView.reloadData()
                return
            }
            
            // 검색 실행
            friendsViewModel.searchUsersByUsername(username: searchText) { [weak self] (users, error) in
                guard let self = self, let users = users else {
                    // 에러 처리 또는 결과가 없을 경우의 로직
                    return
                }
                
                // 검색 결과 업데이트 및 테이블 뷰 리로드
                self.searchResults = users
                self.tableView.reloadData()
            }
        }

    // 검색 결과 없음 메시지 표시
    private func showNoResultsMessage() {
        
        // 현재 검색 결과 목록을 비워줌
        searchResults.removeAll()
        tableView.reloadData()
        
        // 검색 결과 없음을 나타내는 레이블 생성 및 설정
        let noResultsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        
        noResultsLabel.text = "검색 결과 없음"
        noResultsLabel.textColor = .gray
        noResultsLabel.textAlignment = .center
        noResultsLabel.font = UIFont.systemFont(ofSize: 20)
        
        // 테이블 뷰의 footer로 설정하여 검색 결과가 없음을 표시
        tableView.tableFooterView = noResultsLabel
    }
    
    // UIGestureRecognizerDelegate 메서드 구현
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let location = touch.location(in: self.view)
        // searchTextField와 tableView의 프레임이 location을 포함하지 않는 경우에만 true 반환
        return !searchTextField.frame.contains(location) && !tableView.frame.contains(location)
    }
    
    // MARK: - Actions
    
    // 텍스트필드가 바뀔때마다 검색을 수행하는 메서드
    @objc private func textFieldDidChange(_ textField: UITextField) {
        print("performSearch")
        performSearch(textField)
    }
    
    // 배경을 탭할 때 호출되는 메서드
    @objc func backgroundTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    // Tap to Dismiss
    @objc func handleTapToDismiss(gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        // searchTextField와 tableView의 프레임이 location을 포함하지 않는 경우에만 dismiss 실행
        if !searchTextField.frame.contains(location) && !tableView.frame.contains(location) {
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    // MARK: - TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // 키보드 숨김
        performSearch(textField)
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
        cell.configure(with: user)
        
        cell.addUserAction = {
            // Firestore에 친구 추가 요청 로직 구현
            print("친구 추가 요청: \(user.username)")
        }
        
        return cell
    }
    
}

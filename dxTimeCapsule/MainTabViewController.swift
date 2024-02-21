import UIKit

class MainTabViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        
        // 각 기능별 뷰 컨트롤러 인스턴스 생성
        let homeViewController = HomeViewController()
        let friendListViewController = FriendListViewController()
        let postUploadViewController = PostUploadViewController()
        let myTimeCapsuleViewController = MyTimeCapsuleViewController()
        let profileViewController = ProfileViewController()
        
        // 시스템 이미지를 사용한 탭 바 아이템 설정
        homeViewController.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        friendListViewController.tabBarItem = UITabBarItem(title: "친구", image: UIImage(systemName: "person.2"), selectedImage: UIImage(systemName: "person.2.fill"))
        postUploadViewController.tabBarItem = UITabBarItem(title: "업로드", image: UIImage(systemName: "plus.square"), selectedImage: UIImage(systemName: "plus.square.fill"))
        myTimeCapsuleViewController.tabBarItem = UITabBarItem(title: "내 캡슐", image: UIImage(systemName: "capsule"), selectedImage: UIImage(systemName: "capsule.fill"))
        profileViewController.tabBarItem = UITabBarItem(title: "프로필", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        // 탭 바 컨트롤러에 뷰 컨트롤러들 추가
        viewControllers = [homeViewController, friendListViewController, postUploadViewController, myTimeCapsuleViewController, profileViewController].map {
            UINavigationController(rootViewController: $0)
        }
    }
    
    // 탭 선택 이벤트 처리
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let viewControllers = viewControllers else { return true }
        
        if viewController == viewControllers[2] { // 세 번째 탭(업로드) 선택 시
            
            // 모달창 표시 로직
            showUploadOptions()
            return false // 기본 탭 전환 방지
        }
        
        return true // 나머지 탭은 기본 동작 수행
    }
    
    func showUploadOptions() {
        let alertController = UIAlertController(title: nil, message: "무엇을 하시겠습니까?", preferredStyle: .actionSheet)
        
        // 타임캡슐 추가하기 옵션
        alertController.addAction(UIAlertAction(title: "+ 타임캡슐 추가하기", style: .default, handler: { _ in
            // 타임캡슐 추가 기능 실행
            self.addTimeCapsule()
        }))
        
        // 산책피드 올리기 옵션
        alertController.addAction(UIAlertAction(title: "+ 산책피드 올리기", style: .default, handler: { _ in
            // 산책피드 업로드 기능 실행
            self.uploadWalkFeed()
        }))
        
        // 취소 옵션
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        // 모달창 표시
        present(alertController, animated: true, completion: nil)
    }
    
    func addTimeCapsule() {
        // 타임캡슐 추가 기능 구현
        print("타임캡슐 추가하기 선택됨")
    }
    
    func uploadWalkFeed() {
        // 산책피드 업로드 기능 구현
        print("산책피드 올리기 선택됨")
    }
    
}

import SwiftUI

struct PreView: PreviewProvider {
    static var previews: some View {
        MainTabViewController().toPreview()
    }
}

#if DEBUG
extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }
    
    func toPreview() -> some View {
        Preview(viewController: self)
    }
}
#endif

import UIKit

class MainTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 각 기능별 뷰 컨트롤러 인스턴스 생성
        let homeViewController = HomeViewController()
        let friendListViewController = FriendListViewController()
        let postUploadViewController = PostUploadViewController()
        let myTimeCapsuleViewController = MyTimeCapsuleViewController()
        let profileViewController = ProfileViewController()
        
        // 각 뷰 컨트롤러에 탭 바 아이템 설정
        homeViewController.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "homeIcon"), selectedImage: nil)
        friendListViewController.tabBarItem = UITabBarItem(title: "친구", image: UIImage(named: "friendsIcon"), selectedImage: nil)
        postUploadViewController.tabBarItem = UITabBarItem(title: "업로드", image: UIImage(named: "uploadIcon"), selectedImage: nil)
        myTimeCapsuleViewController.tabBarItem = UITabBarItem(title: "내 캡슐", image: UIImage(named: "capsuleIcon"), selectedImage: nil)
        profileViewController.tabBarItem = UITabBarItem(title: "프로필", image: UIImage(named: "profileIcon"), selectedImage: nil)
        
        // 탭 바 컨트롤러에 뷰 컨트롤러들 추가
        viewControllers = [homeViewController, friendListViewController, postUploadViewController, myTimeCapsuleViewController, profileViewController].map {
            UINavigationController(rootViewController: $0)
        }
    }
}

import SwiftUI

struct PreView: PreviewProvider {
    static var previews: some View {
        MainTabViewController().toPreview()
    }
}

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

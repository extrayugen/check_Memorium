import UIKit

class MainTabBarView: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTabs()
    }
    
    private func setupTabs() {
        let homeTabViewController = HomeTabViewController()
        homeTabViewController.tabBarItem = UITabBarItem(title: nil, image: svgImage(named: "Light=Home_Deselect"), selectedImage: svgImage(named: "Light=Home_Deselect_1"))
        
        let findTabViewController = FindTabViewController()
        findTabViewController.tabBarItem = UITabBarItem(title: nil, image: svgImage(named: "Light=Search_Deselect"), selectedImage: svgImage(named: "Light=Search_Deselect_1"))
        
        let taskListViewController = TaskListViewController()
        taskListViewController.tabBarItem = UITabBarItem(title: nil, image: svgImage(named: "Light=Write_Deselect"), selectedImage: svgImage(named: "Light=Write_Deselect_1"))
        
        let followViewController = FollowTabViewController()
        followViewController.tabBarItem = UITabBarItem(title: nil, image: svgImage(named: "Light=Activity_Deselect"), selectedImage: svgImage(named: "Light=Activity_Deselect_1"))
        
        let profileViewController = ProfileTabViewController()
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: svgImage(named: "Light=Profile_Deselect"), selectedImage: svgImage(named: "Light=Profile_Deselect_1"))
        
        let viewControllers = [homeTabViewController, findTabViewController, taskListViewController, followViewController, profileViewController]
        
        self.viewControllers = viewControllers
        
//        self.tabBar.tintColor = .green
    }

    
    private func svgImage(named name: String) -> UIImage? {
        return UIImage(named: name)
    }
}

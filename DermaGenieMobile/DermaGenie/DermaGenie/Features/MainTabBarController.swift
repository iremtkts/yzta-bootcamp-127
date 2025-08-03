import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let lightRedColor = UIColor(red: 250/255, green: 240/255, blue: 240/255, alpha: 1)

        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .gray
        tabBar.barTintColor = lightRedColor
        tabBar.backgroundColor = lightRedColor

        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = lightRedColor
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }

        setupTabs()
    }

    private func setupTabs() {
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        homeVC.tabBarItem = UITabBarItem(title: "Ana Sayfa", image: UIImage(systemName: "house"), tag: 0)
        homeVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        let historyVC = UINavigationController(rootViewController: HistoryViewController())
        historyVC.tabBarItem = UITabBarItem(title: "Geçmiş", image: UIImage(systemName: "clock.arrow.circlepath"), tag: 1)
        historyVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        profileVC.tabBarItem = UITabBarItem(title: "Profil", image: UIImage(systemName: "person"), tag: 2)
        profileVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        viewControllers = [homeVC, historyVC, profileVC]
    }



    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        var tabFrame = tabBar.frame
        tabFrame.size.height = 80
        tabFrame.origin.y = view.frame.size.height - 80
        tabBar.frame = tabFrame
    }
}

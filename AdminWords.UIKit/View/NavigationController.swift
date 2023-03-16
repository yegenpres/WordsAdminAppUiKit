//
//  NavigationView.swift
//  AdminWords.UIKit
//
//  Created by 111 on 05.09.2022.
//

import Foundation
import UIKit

class NavigationController: UITabBarController {
   
    
    
    override func viewDidLoad() {
        viewControllers = [
            setupWordsPage(),
            setupUsersPage(),
        ]
        
    }
    
    private func setupWordsPage() -> UINavigationController {
        let viewModel = WordsViewModel()
        let pageController = PageController(viewModel: viewModel)
        pageController.navigationItem.title = "Words Setting"
        
        let wordsPage = UINavigationController(rootViewController: pageController)
        wordsPage.tabBarItem.title = "Words"
        wordsPage.tabBarItem.image = UIImage(systemName: "w.circle.fill")
        return wordsPage
    }
    
    private func setupUsersPage() -> UINavigationController {
        let viewModel = UsersViewModel()
        let pageController = PageController(viewModel: viewModel)
        pageController.navigationItem.title = "Users Setting"

        let usersPage = UINavigationController(rootViewController: pageController)
        usersPage.tabBarItem.title = "Users"
        usersPage.tabBarItem.image = UIImage(systemName: "person.circle")
        return usersPage
    }
    
 
}


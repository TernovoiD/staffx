//
//  MainTabBarViewController.swift
//  StaffX
//
//  Created by Danylo Ternovoi on 21.05.2023.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init managers and view models
        let employeesManager = EmployeesManager()
        let employeesViewModel = EmployeesViewModel(manager: employeesManager)
        let departmentsViewModel = DepartmentsViewModel(manager: employeesManager)
        let employeesViewController = EmployeesViewController(viewModel: employeesViewModel)
        let departmentsViewController = DepartmentsViewController(viewModel: departmentsViewModel)
        
        
        // Configure employees tab
        let tab1 = UINavigationController(rootViewController: employeesViewController)
        let tab1BarItem = UITabBarItem(title: "Employees",
                                       image: UIImage(systemName: "person.3"),
                                       selectedImage: UIImage(systemName: "person.3.fill"))
        tab1.tabBarItem = tab1BarItem
        
        
        // Configure departments tab
        let tab2 = UINavigationController(rootViewController: departmentsViewController)
        let tab2BarItem = UITabBarItem(title: "Departments",
                                       image: UIImage(systemName: "building.columns"),
                                       selectedImage: UIImage(systemName: "building.columns.fill"))
        tab2.tabBarItem = tab2BarItem
        
        
        // Configure tab view
        self.viewControllers = [tab1, tab2]
    }
}

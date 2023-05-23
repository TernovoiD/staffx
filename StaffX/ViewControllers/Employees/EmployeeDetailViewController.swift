//
//  EmployeeDetailViewController.swift
//  StaffX
//
//  Created by Danylo Ternovoi on 17.05.2023.
//

import UIKit

class EmployeeDetailViewController: UIViewController {
    
    let employee: EmployeeModel
    private let viewModel: EmployeesViewModel
    private let employeeView = EmployeeDetailedView()
    
    
    init(employee: EmployeeModel, viewModel: EmployeesViewModel) {
        self.employee = employee
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: UI variables
    
    private lazy var trailingNavigationButton: UIBarButtonItem = {
       let button = UIBarButtonItem()
        button.customView?.translatesAutoresizingMaskIntoConstraints = false
        button.title = "Edit"
        button.target = self
        button.action = #selector(showAddUpdateEmployeeView)
        return button
    }()
    
    @objc func showAddUpdateEmployeeView() {
        present(AddUpdateEmployeeViewController(employee: self.employee, viewModel: viewModel), animated: true)
    }
    
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        setup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: UI Setup
    
    func setup() {
        employeeView.configure(employee: employee)
        view = employeeView
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = trailingNavigationButton
        
    }
}

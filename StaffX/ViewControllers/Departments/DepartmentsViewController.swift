//
//  DepartmentsViewController.swift
//  StaffX
//
//  Created by Danylo Ternovoi on 21.05.2023.
//

import UIKit
import Combine

class DepartmentsViewController: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: DepartmentsViewModel
    
    //MARK: Initialization
    
    init(viewModel: DepartmentsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setup()
        setupBindings()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.rowHeight = 80
        table.register(DepartmentTableViewCell.self, forCellReuseIdentifier: DepartmentTableViewCell.cellID)
        return table
    }()
    
    private lazy var navigationButton: UIBarButtonItem = {
       let button = UIBarButtonItem()
        button.customView?.translatesAutoresizingMaskIntoConstraints = false
        button.image = UIImage(systemName: "plus")
        button.target = self
        button.action = #selector(presentAlertController)
        return button
    }()
}

extension DepartmentsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.departments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DepartmentTableViewCell.cellID, for: indexPath) as! DepartmentTableViewCell
        let department = viewModel.departments[indexPath.row]
        cell.configure(withDepartment: department)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let department = viewModel.departments[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (myContext, myView, complete) in
            self.viewModel.deleteDepartment(department: department)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    
}

//MARK: Functions

extension DepartmentsViewController {
    func setup() {
        navigationController?.navigationBar.topItem?.title = "Departments"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.rightBarButtonItem = navigationButton
        
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.dataChangePublisher
            .receive(on: DispatchQueue.main)
            .sink { loadedDepartemnts in
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @objc func presentAlertController() {
        let alertController = UIAlertController(title: "Department title:",
                                                message: nil,
                                                preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Title"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let createAction = UIAlertAction(title: "Create",
                                         style: .default) { [weak alertController] _ in
            guard let textFields = alertController?.textFields else { return }
            
            if let departmentTitle = textFields[0].text {
                let newDepartment = DepartmentModel(title: departmentTitle)
                self.viewModel.createDepartment(newDepartment)
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(createAction)
        
        
        
        self.present(alertController, animated: true)
    }
}

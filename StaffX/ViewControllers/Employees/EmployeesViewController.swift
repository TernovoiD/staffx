//
//  EmployeesViewController.swift
//  StaffX
//
//  Created by Danylo Ternovoi on 16.05.2023.
//

import UIKit
import Combine

class EmployeesViewController: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: EmployeesViewModel
    
    
    // MARK: Initialization
    
    init(viewModel: EmployeesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var searchController = UISearchController(searchResultsController: nil)
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.rowHeight = 80
        table.register(EmployeeTableViewCell.self, forCellReuseIdentifier: EmployeeTableViewCell.cellID)
        return table
    }()
    
    private lazy var trailingNavigationButton: UIBarButtonItem = {
       let button = UIBarButtonItem()
        button.customView?.translatesAutoresizingMaskIntoConstraints = false
        button.image = UIImage(systemName: "plus")
        button.target = self
        button.action = #selector(showAddUpdateEmployeeView)
        return button
    }()
    
    //MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        setup()
        setupBindings()
        setupSearchController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: TableView

extension EmployeesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.filteredDepartments.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = viewModel.filteredDepartments[section]
        return section.title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredDepartments[section].employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeTableViewCell.cellID, for: indexPath) as! EmployeeTableViewCell
        let employee = viewModel.filteredDepartments[indexPath.section].employees[indexPath.row]
        cell.configure(withEmployee: employee)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let department = viewModel.filteredDepartments[indexPath.section]
        let employee = viewModel.filteredDepartments[indexPath.section].employees[indexPath.row]
        let deleteEmployee = UIContextualAction(style: .destructive, title: "Delete") { (myContext, myView, complete)  in
            self.viewModel.delete(employee: employee, fromDepartment: department)
        }
        return UISwipeActionsConfiguration(actions: [deleteEmployee])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let employee = viewModel.filteredDepartments[indexPath.section].employees[indexPath.row]
        pushToEmployeeDetailVC(employee: employee)
    }
    
    func pushToEmployeeDetailVC(employee: EmployeeModel) {
        navigationController?.pushViewController(EmployeeDetailViewController(employee: employee, viewModel: viewModel), animated: true)
    }
}

// MARK: Functions

extension EmployeesViewController {
    
    private func setup() {
//        let searchController = UISearchController()
        navigationController?.navigationBar.topItem?.title = "Employees"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.rightBarButtonItem = trailingNavigationButton
//        navigationController?.navigationItem.searchController = searchController
        
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
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = false
    }
    
    private func setupBindings() {
        viewModel.dataChangePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @objc func showAddUpdateEmployeeView() {
        present(AddUpdateEmployeeViewController(employee: nil, viewModel: viewModel), animated: true)
    }
    
    @objc func reloadTableView() {
        self.tableView.reloadData()
    }
}

extension EmployeesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let textToSearch = searchController.searchBar.text
        viewModel.search(byText: textToSearch)
    }
}

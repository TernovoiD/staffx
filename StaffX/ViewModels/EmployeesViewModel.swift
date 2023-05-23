//
//  EmployeesViewModel.swift
//  StaffX
//
//  Created by Danylo Ternovoi on 21.05.2023.
//

import Foundation
import Combine

class EmployeesViewModel {
    
    private lazy var dataChangeSubject = PassthroughSubject<Void, Never>()
    lazy var dataChangePublisher = dataChangeSubject.eraseToAnyPublisher()
    private var cancellables = Set<AnyCancellable>()
    private let manager: EmployeesManager
     
    var allDepartments: [DepartmentModel] = [] { didSet { filter() }}
    var filteredDepartments: [DepartmentModel] = [] { didSet { dataChangeSubject.send() }}
    var filterText: String? { didSet { filter() }}
    
    init(manager: EmployeesManager) {
        self.manager = manager
        setupBindings()
    }
    
    func create(employee: EmployeeModel, idDepartment department: DepartmentModel) {
        do {
            try manager.createEmployee(employee, inDepartment: department.id)
        } catch {
            print("Error while creating employee")
        }
    }
    
    func update(employee: EmployeeModel,
                inDepartment department: DepartmentModel) {
        do {
            try manager.updateEmployee(employee, inDepartment: department.id)
        } catch {
            print("Error while updating employee")
        }
        
    }
    
    func delete(employee: EmployeeModel, fromDepartment department: DepartmentModel) {
        Task {
            try await manager.deleteEmployee(employee, inDepartment: department.id)
        }
    }
    
    private func setupBindings() {
        manager.$departments
            .receive(on: DispatchQueue.main)
            .sink { loadedDepartemnts in
                self.allDepartments = loadedDepartemnts
                self.filter()
                self.dataChangeSubject.send()
            }
            .store(in: &cancellables)
    }
}

// MARK: Search

extension EmployeesViewModel {
    
    func search(byText searchText: String?) {
        filterText = searchText
    }
    
    private func filter() {
        var result: [DepartmentModel] = []
        
        if let textToSearch = filterText, filterText != "" {
            for department in allDepartments {
                let departmentWithFilteredEmployees = department.filterEmployees(byText: textToSearch)
                result.append(departmentWithFilteredEmployees)
            }
        } else {
            result = allDepartments
        }
        
        
        self.filteredDepartments = result.filter({ !$0.employees.isEmpty }).sorted(by: { $0.title < $1.title })
    }
    
}

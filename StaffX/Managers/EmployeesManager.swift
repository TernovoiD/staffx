//
//  EmployeesManager.swift
//  StaffX
//
//  Created by Danylo Ternovoi on 20.05.2023.
//

import Foundation
import Combine

class EmployeesManager {
    
    private lazy var managerDataChangeSubject = PassthroughSubject<Void, Never>()
    lazy var managerDataChangePublisher = managerDataChangeSubject.eraseToAnyPublisher()
    private let database = FirestoreManager()

    @Published var departments: [DepartmentModel] = []
    
    init() {
        Task {
            try await fetchDepartments()
        }
    }
    
    // MARK: Departments
    
    func createDepartment(_ department: DepartmentModel) throws {
        try database.createOrUpdate(document: department,
                                    inCollection: StaffXCollections.departments.rawValue)
        departments.append(department)
    }
    
    func updateDepartment(_ department: DepartmentModel) throws {
        try database.createOrUpdate(document: department,
                                    inCollection: StaffXCollections.departments.rawValue)
        if let departmentIndex = departments.firstIndex(where: { $0.id == department.id }) {
            departments.remove(at: departmentIndex)
            departments.append(department)
        }
    }
    
    func deleteDepartment(withID departmentID: String) async throws {
        try await database.delete(documentID: departmentID, fromCollection: StaffXCollections.departments.rawValue)
        if let departmentIndex = departments.firstIndex(where: { $0.id == departmentID }) {
            departments.remove(at: departmentIndex)
        }
    }
    
    
    // MARK: Employees
    
    func createEmployee(_ employee: EmployeeModel, inDepartment departmentID: String) throws {
        
        // Create employee in database
        try database.createOrUpdate(document: employee,
                                    inCollection: StaffXCollections.departments.rawValue,
                                    inDocument: departmentID,
                                    inSubcollection: StaffXSubCollections.employees.rawValue)
        
        // Add employee to local storage
        if let departmentIndex = departments.firstIndex(where: { $0.id == departmentID }) {
            removeThanAdd(departmentIndex: departmentIndex, withNewEmployee: employee)
        }
    }
    
    func updateEmployee(_ employee: EmployeeModel, inDepartment departmentID: String) throws {
        
        // Update employee at database
        try database.createOrUpdate(document: employee,
                                    inCollection: StaffXCollections.departments.rawValue,
                                    inDocument: departmentID, inSubcollection: StaffXSubCollections.employees.rawValue)
        
        // Update employee at local storage
        if let departmentIndex = departments.firstIndex(where: { $0.id == departmentID }),
           let employeeIndex = departments[departmentIndex].employees.firstIndex(where: { $0.id == employee.id }) {
            departments[departmentIndex].employees.remove(at: employeeIndex)
            departments[departmentIndex].employees.append(employee)
        }
    }

    func deleteEmployee(_ employee: EmployeeModel, inDepartment departmentID: String) async throws {
        
        // Delete employee from database
        try await database.delete(documentID: employee.id, fromCollection: StaffXCollections.departments.rawValue,
                                  inDocument: departmentID,
                                  inSubCollection: StaffXSubCollections.employees.rawValue)
        
        // Delete employee from local storage
        if let departmentIndex = departments.firstIndex(where: { $0.id == departmentID }) {
            removeThanAdd(departmentIndex: departmentIndex, withRemovedEmployee: employee)
        }
    }
}

// MARK: Private functions

extension EmployeesManager {
    
    private func fetchDepartments() async throws {
        var loadedDepartments: [DepartmentModel] = []
        loadedDepartments = try await database.getDocuments(fromCollection: StaffXCollections.departments.rawValue)
        for index in loadedDepartments.indices {
            loadedDepartments[index].employees = try await fetchEmployees(fromDepartment: loadedDepartments[index])
        }
        departments = loadedDepartments
    }
    
    private func fetchEmployees(fromDepartment department: DepartmentModel) async throws -> [EmployeeModel] {
        let employees: [EmployeeModel] = try await database.getDocuments(fromCollection: StaffXCollections.departments.rawValue,
                                                                         inDocument: department.id,
                                                                         inSubCollection: StaffXSubCollections.employees.rawValue)
        return employees
    }
    
    // The removeThanAdd() function is needed as @Published will trigger changes in array [DepartmentModel] but not in a sub array DepartmentModel.employees. Therefore to trigger changes and reload interface I need to completely re-add DepartmentModel
    
    private func removeThanAdd(departmentIndex: Int,
                               withNewEmployee newEmployee: EmployeeModel? = nil,
                               withRemovedEmployee removedEmployee: EmployeeModel? = nil,
                               withUpdatedEmployee updetedEmployee: EmployeeModel? = nil) {
        let removedDepartment = departments.remove(at: departmentIndex)
        
        
        // In case of ADD
        if let newEmployee {
            let department = removedDepartment.add(employee: newEmployee)
            departments.append(department)
        }
        
        // In case of UPDATE
        if let removedEmployee {
            let department = removedDepartment.delete(employee: removedEmployee)
            departments.append(department)
        }
        
        // In case of DELETE
        if let updetedEmployee {
            let department = removedDepartment.update(employee: updetedEmployee)
            departments.append(department)
        }
    }
}

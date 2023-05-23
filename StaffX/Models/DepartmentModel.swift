//
//  DepartmentModel.swift
//  StaffX
//
//  Created by Danylo Ternovoi on 16.05.2023.
//
import Foundation

struct DepartmentModel: Firestorable {
    let id: String
    var title: String
    var employees: [EmployeeModel]
    
    init(title: String) {
        self.id = UUID().uuidString
        self.title = title
        self.employees = []
    }
    
    private init(id: String, title: String, employees: [EmployeeModel]) {
        self.id = id
        self.title = title
        self.employees = employees
    }
    
    func filterEmployees(byText searchText: String) -> DepartmentModel {
        let lowercasedTextToSearch = searchText.lowercased()
        let filteredEmployees = employees.filter({
            $0.name.lowercased().contains(lowercasedTextToSearch) || $0.surname.lowercased().contains(lowercasedTextToSearch)
        })
        return DepartmentModel(id: self.id, title: self.title, employees: filteredEmployees)
    }
    
    func checkFor(employee: EmployeeModel) -> Bool {
        employees.contains(where: { $0.id == employee.id })
    }
    
    func add(employee: EmployeeModel) -> DepartmentModel {
        var employees = self.employees
        employees.append(employee)
        return DepartmentModel(id: self.id, title: self.title, employees: employees)
    }
    
    func update(employee: EmployeeModel) -> DepartmentModel {
        var employees = self.employees
        employees.removeAll(where: { $0.id == employee.id })
        employees.append(employee)
        return DepartmentModel(id: self.id, title: self.title, employees: employees)
    }
    
    func delete(employee: EmployeeModel) -> DepartmentModel {
        var employees = self.employees
        employees.removeAll(where: { $0.id == employee.id })
        return DepartmentModel(id: self.id, title: self.title, employees: employees)
    }
}

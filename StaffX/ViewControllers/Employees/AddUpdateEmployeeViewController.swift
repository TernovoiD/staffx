//
//  AddUpdateEmployeeViewController.swift
//  StaffX
//
//  Created by Danylo Ternovoi on 17.05.2023.
//

import UIKit

class AddUpdateEmployeeViewController: UIViewController {
    
    private let employee: EmployeeModel?
    private var viewModel: EmployeesViewModel
    private let addUpdateEmployeeView = AddUpdateEmployeeView()
    private var isFormValid: Bool = true
    
    init(employee: EmployeeModel? = nil, viewModel: EmployeesViewModel) {
        self.employee = employee
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func loadView() {
        super.loadView()
        setup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureBackground = UITapGestureRecognizer(target: self, action: #selector(self.backgroundTapped(_:)))
        self.view.addGestureRecognizer(tapGestureBackground)
    }
    
    func setup() {
        if let employee {
            addUpdateEmployeeView.configure(employee: employee, departments: [], delegate: self)
        } else {
            addUpdateEmployeeView.configure(employee: employee, departments: viewModel.allDepartments, delegate: self)
        }
        view = addUpdateEmployeeView
        view.backgroundColor = .systemBackground
    }
    
    @objc func backgroundTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}

extension AddUpdateEmployeeViewController: AddUpdateEmployeeViewDelegate {
    
    
    func didTapSaveButton(name: String?, surname: String?, gender: String, salary: String?, dateOfBirth: Date, department: DepartmentModel?) {
        
        guard let name,
              let surname,
              let salary else { return }
        
        
        // Update Employee
        if let employee {
            guard let employeeDepartment = viewModel.allDepartments.first(where: { $0.checkFor(employee: employee) }) else { return }
            let updatedEmployee = employee.update(withNewName: name, andSurname: surname, andGender: gender, andDateOfBirth: dateOfBirth, andSalary: Int(salary) ?? 0)
            viewModel.update(employee: updatedEmployee, inDepartment: employeeDepartment)
            self.dismiss(animated: true)
        }
        
        // Create Employee
        
        if let department {
            let newEmployee = EmployeeModel(name: name, surname: surname, gender: gender, dateOfBirth: dateOfBirth, salary: Int(salary) ?? 0)
            viewModel.create(employee: newEmployee, idDepartment: department)
            self.dismiss(animated: true)
        }
    }
}

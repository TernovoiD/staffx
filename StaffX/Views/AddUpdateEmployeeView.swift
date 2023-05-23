//
//  AddUpdateEmployeeView.swift
//  StaffX
//
//  Created by Danylo Ternovoi on 18.05.2023.
//

import UIKit

protocol AddUpdateEmployeeViewDelegate: AnyObject {
    func didTapSaveButton(name: String?, surname: String?, gender: String, salary: String?, dateOfBirth: Date, department: DepartmentModel?)
}

class AddUpdateEmployeeView: UIView {
    
    let genders: [String] = ["Male", "Female", "Non-Binary"]
    var departments: [DepartmentModel] = []
    var selectedDepartment: DepartmentModel?
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.contentMode = .scaleAspectFit
        stack.axis = .vertical
        stack.spacing = 15
        return stack
    }()
    
    private lazy var viewLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 36)
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Add name"
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        return textField
    }()
    
    private lazy var surnameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Add surnname"
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 24)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        return button
    }()
    
    private lazy var genderSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: genders)
        control.selectedSegmentIndex = 0
        return control
    }()
    
    private lazy var departmentPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    
    // MARK: Salary
    
    private lazy var salaryStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.contentMode = .scaleAspectFit
        stack.axis = .horizontal
        stack.spacing = 15
        return stack
    }()
    
    private lazy var salaryTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Add salary"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private lazy var dollarSignImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "dollarsign")
        imageView.tintColor = .systemGreen
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    
    // MARK: DatePicker
    
    private lazy var datePickerStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.contentMode = .scaleAspectFit
        stack.axis = .horizontal
        stack.spacing = 15
        return stack
    }()
    
    private lazy var datePickerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.text = "Date of birth"
        return label
    }()
    
    private lazy var birthDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.maximumDate = Date()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.setDate(Date(), animated: true)
        return datePicker
    }()
    
    private weak var delegate: AddUpdateEmployeeViewDelegate?
    private var employee: EmployeeModel?
    
    
    
    // MARK: Configuration
    
    func configure(employee: EmployeeModel?, departments: [DepartmentModel], delegate: AddUpdateEmployeeViewDelegate) {
        
        self.delegate = delegate
        self.employee = employee
        self.departments = departments
        selectedDepartment = departments.first
        
        saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        
        if let employee {
            nameTextField.text = employee.name
            surnameTextField.text = employee.surname
        }
        viewLabel.text = "Employee"
        
        addSubview(stackView)
        addSubview(saveButton)
        
        stackView.addArrangedSubview(viewLabel)
        stackView.addArrangedSubview(genderSegmentedControl)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(surnameTextField)
        stackView.addArrangedSubview(salaryStackView)
        stackView.addArrangedSubview(datePickerStackView)
        
        if employee == nil {
            setupDaprtmentsPicker()
        }
        
        salaryStackView.addArrangedSubview(salaryTextField)
        salaryStackView.addArrangedSubview(dollarSignImageView)
        
        datePickerStackView.addArrangedSubview(datePickerLabel)
        datePickerStackView.addArrangedSubview(birthDatePicker)
        
        
        
        NSLayoutConstraint.activate([
            
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            surnameTextField.heightAnchor.constraint(equalToConstant: 50),
            salaryTextField.heightAnchor.constraint(equalToConstant: 50),
            
            saveButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            saveButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            
        ])
    }
    
    private func setupDaprtmentsPicker() {
        stackView.addArrangedSubview(departmentPicker)
        
        departmentPicker.dataSource = self
        departmentPicker.delegate = self
    }
    
    @objc func didTapSaveButton() {
        delegate?.didTapSaveButton(name: nameTextField.text,
                                   surname: surnameTextField.text,
                                   gender: genders[genderSegmentedControl.selectedSegmentIndex],
                                   salary: salaryTextField.text,
                                   dateOfBirth: birthDatePicker.date,
                                   department: selectedDepartment)
    }
}

// MARK: DepartmentPicker DataSource

extension AddUpdateEmployeeView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        departments.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        departments[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDepartment = departments[row]
    }
}

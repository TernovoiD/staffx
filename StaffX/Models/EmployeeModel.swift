//
//  EmployeeModel.swift
//  StaffX
//
//  Created by Danylo Ternovoi on 16.05.2023.
//

import Foundation

struct EmployeeModel: Firestorable {
    let id: String
    var name: String
    var surname: String
    var gender: String
    var dateOfBirth: Date
    var salary: Int
    
    init(name: String, surname: String, gender: String, dateOfBirth: Date, salary: Int) {
        self.id = UUID().uuidString
        self.name = name
        self.surname = surname
        self.gender = gender
        self.dateOfBirth = dateOfBirth
        self.salary = salary
    }
    
    private init(id: String, name: String, surname: String, gender: String, dateOfBirth: Date, salary: Int) {
        self.id = id
        self.name = name
        self.surname = surname
        self.gender = gender
        self.dateOfBirth = dateOfBirth
        self.salary = salary
    }
    
    func update(withNewName newName: String?,
                andSurname newSurname: String?,
                andGender newGender: String?,
                andDateOfBirth newDOB: Date?,
                andSalary newSalary: Int?) -> EmployeeModel {
        let updatedEmployee = EmployeeModel(id: self.id,
                                            name: newName ?? self.name,
                                            surname: newSurname ?? self.surname,
                                            gender: newGender ?? self.gender,
                                            dateOfBirth: newDOB ?? self.dateOfBirth,
                                            salary: newSalary ?? self.salary)
        return updatedEmployee
    }
}


//
//  DepartmentsViewModel.swift
//  StaffX
//
//  Created by Danylo Ternovoi on 20.05.2023.
//

import Foundation
import Combine

class DepartmentsViewModel {
    
    private lazy var dataChangeSubject = PassthroughSubject<Void, Never>()
    lazy var dataChangePublisher = dataChangeSubject.eraseToAnyPublisher()
    private var cancellables = Set<AnyCancellable>()
    private let manager: EmployeesManager
    
    var departments: [DepartmentModel] = []
    
    init(manager: EmployeesManager) {
        self.manager = manager
        setupBindings()
    }
    
    func createDepartment(_ newDepartment: DepartmentModel) {
        do {
            try manager.createDepartment(newDepartment)
        } catch {
            print("Error while creating department")
        }
    }
    
    func deleteDepartment(department: DepartmentModel) {
        Task {
            try await manager.deleteDepartment(withID: department.id)
        }
    }
    
    private func setupBindings() {
        manager.$departments
            .receive(on: DispatchQueue.main)
            .sink { loadedDepartemnts in
                self.departments = loadedDepartemnts
                self.dataChangeSubject.send()
            }
            .store(in: &cancellables)
    }
}

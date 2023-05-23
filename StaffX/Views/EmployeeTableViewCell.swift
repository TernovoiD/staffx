//
//  EmployeeTableViewCell.swift
//  StaffX
//
//  Created by Danylo Ternovoi on 16.05.2023.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {
    
    static let cellID = "EmployeeTableViewCell"
    
    lazy var employeeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var contentStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var employeeName: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .boldSystemFont(ofSize: 24)
        nameLabel.numberOfLines = 1
        return nameLabel
    }()
    
    func configure(withEmployee employee: EmployeeModel) {
        
        employeeImage.image = UIImage(systemName: "person.circle.fill")
        employeeName.text = employee.name + " " + employee.surname
        
        contentView.addSubview(employeeImage)
        contentView.addSubview(employeeName)
        
        NSLayoutConstraint.activate([
            employeeImage.widthAnchor.constraint(equalToConstant: 65),
            employeeImage.heightAnchor.constraint(equalToConstant: 65),
            employeeImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            employeeImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            employeeName.topAnchor.constraint(equalTo: employeeImage.topAnchor),
            employeeName.leadingAnchor.constraint(equalTo: employeeImage.trailingAnchor, constant: 16),
            employeeName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}

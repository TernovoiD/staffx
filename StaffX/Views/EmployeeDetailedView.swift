//
//  EmployeeDetailedView.swift
//  StaffX
//
//  Created by Danylo Ternovoi on 17.05.2023.
//

import UIKit

class EmployeeDetailedView: UIView {
    
    let employeeImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 40)
        label.numberOfLines = 1
        return label
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .italicSystemFont(ofSize: 19)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(employee: EmployeeModel) {
        employeeImage.image = UIImage(systemName: "person.circle.fill")
        nameLabel.text = employee.name + " " + employee.surname
        
        addSubview(employeeImage)
        addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            employeeImage.widthAnchor.constraint(equalToConstant: 300),
            employeeImage.heightAnchor.constraint(equalToConstant: 300),
            employeeImage.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            employeeImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: employeeImage.bottomAnchor, constant: 16),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    
}

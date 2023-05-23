//
//  DepartmentTableViewCell.swift
//  StaffX
//
//  Created by Danylo Ternovoi on 19.05.2023.
//

import UIKit

class DepartmentTableViewCell: UITableViewCell {
    
    static let cellID = "DepartmentTableViewCell"
    
    lazy var departmentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var departmentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 24)
        label.numberOfLines = 1
        return label
    }()
    
    func configure(withDepartment department: DepartmentModel) {
        
        departmentImageView.image = UIImage(systemName: "building.columns.fill")
        departmentLabel.text = department.title
        
        contentView.addSubview(departmentImageView)
        contentView.addSubview(departmentLabel)
        
        NSLayoutConstraint.activate([
            departmentImageView.widthAnchor.constraint(equalToConstant: 65),
            departmentImageView.heightAnchor.constraint(equalToConstant: 65),
            departmentImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            departmentImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            departmentLabel.topAnchor.constraint(equalTo: departmentImageView.topAnchor),
            departmentLabel.leadingAnchor.constraint(equalTo: departmentImageView.trailingAnchor, constant: 10),
            departmentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}

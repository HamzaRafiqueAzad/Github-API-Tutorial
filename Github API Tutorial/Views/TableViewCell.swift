//
//  TableViewCell.swift
//  iOS Test Assignment
//
//  Created by Hamza Rafique Azad on 10/5/22.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    static let identifier = "TableViewCell"
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.text = "Hamza"
        label.sizeToFit()
        
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.text = "User"
        
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let photoImageSize = width / 8
        photoImageView.frame = CGRect(x: contentView.left + 5, y: contentView.height / 4, width: photoImageSize, height: photoImageSize).integral
        photoImageView.layer.cornerRadius = photoImageView.height / 2.0
        
        let labelHeight = contentView.height / 2
        let labelWidth = (width - 10 - photoImageSize) / 2
        loginLabel.frame = CGRect(x: photoImageView.right + 20,
                                  y: contentView.height / 4,
                                  width: labelWidth - 20,
                                  height: labelHeight)
        
        typeLabel.frame = CGRect(x: loginLabel.right + 10,
                                  y: contentView.height / 4,
                                 width: labelWidth - 20,
                                  height: labelHeight)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(photoImageView)
        contentView.addSubview(loginLabel)
        contentView.addSubview(typeLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(debug userModel: UserModel) {
        photoImageView.load(url: URL(string: userModel.avatar_url)!)
        loginLabel.text = "\(userModel.login)"
        typeLabel.text = "\(userModel.type)"
    }
    
}


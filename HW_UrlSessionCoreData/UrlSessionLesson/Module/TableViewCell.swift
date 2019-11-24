//
//  TableViewCell.swift
//  UrlSessionLesson
//
//  Created by Давид on 24/11/2019.
//  Copyright © 2019 Константин Богданов. All rights reserved.
//

import UIKit

final class TableViewCell: UITableViewCell {
    static let reusedId = "UITableViewCellreuseId"
    
    let mainImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(mainImage)
        
        mainImage.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        mainImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        mainImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        mainImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        mainImage.widthAnchor.constraint(equalTo: mainImage.heightAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainImage.image = nil
    }
}

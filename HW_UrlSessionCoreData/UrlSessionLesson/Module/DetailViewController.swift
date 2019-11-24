//
//  DeatilViewController.swift
//  UrlSessionLesson
//
//  Created by Давид on 24/11/2019.
//  Copyright © 2019 Константин Богданов. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    let mainImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.addSubview(mainImage)
        mainImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        mainImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        mainImage.widthAnchor.constraint(equalTo: mainImage.heightAnchor).isActive = true
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}

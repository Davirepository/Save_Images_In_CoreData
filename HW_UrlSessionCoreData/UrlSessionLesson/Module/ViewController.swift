//
//  ViewController.swift
//  UrlSessionLesson
//
//  Created by Константин Богданов on 06/11/2019.
//  Copyright © 2019 Константин Богданов. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	let tableView = UITableView()
    let detailVC = DetailViewController()
    var images = SaveThreadImageViewModel()
	let reuseId = TableViewCell.reusedId
	let interactor: InteractorInput
    
    private lazy var actionBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(actionBarButtonTapped))
    }()

    init(interactor: InteractorInput) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
	}
	required init?(coder: NSCoder) {
		fatalError("Метод не реализован")
	}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.interactor.getImageFromStorage { models in
            models.forEach{ self.images.data.append($0) }
            if self.images.data.count > 0 {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    print("coredataservice")
                }
            } else {
                self.search(by: "ice")
                print("networcservice")
            }
        }
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
			tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        
		tableView.register(TableViewCell.self, forCellReuseIdentifier: reuseId)
        
		tableView.dataSource = self
        tableView.delegate = self

        self.navigationItem.setRightBarButtonItems([actionBarButtonItem], animated: true)
    }
    
    @objc func actionBarButtonTapped() {
        print("You delete all data from Core Data")
        self.interactor.deleteDataFromStorage()
        self.images.removeAll()
        self.search(by: "ice")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func search(by searchString: String) {
        interactor.loadImageFromNetwork(by: searchString) { [weak self] (models) in
            self?.loadImages(with: models)
        }
    }
    
    private func loadImages(with models: [ImageModel]) {
        let group = DispatchGroup()
        for model in models {
            group.enter()
            interactor.fetchLoadedImage(at: model.path) { [weak self] (image) in
                guard let image = image else {
                    group.leave()
                    return }
                let viewModel = ImageViewModel(image: image)
                self?.images.append(new: viewModel)
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.interactor.sendImageToStorage(data: self.images)
            self.tableView.reloadData()
            print(self.images.data.count)
            print("data was saved")
        }
    }
}

extension ViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return images.data.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! TableViewCell
		let model = images.data[indexPath.row]
		cell.mainImage.image = model.image
		return cell
	}
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        detailVC.mainImage.image = images.data[indexPath.row].image
        guard let navigationVC = navigationController else { return }
        navigationVC.pushViewController(detailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

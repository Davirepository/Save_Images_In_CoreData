//
//  Interactor.swift
//  UrlSessionLesson
//
//  Created by Константин Богданов on 06/11/2019.
//  Copyright © 2019 Константин Богданов. All rights reserved.
//

import UIKit

protocol InteractorInput {
    func fetchLoadedImage(at path: String, completion: @escaping (UIImage?) -> Void)
    func loadImageFromNetwork(by searchString: String, completion: @escaping ([ImageModel]) -> Void)
    func sendImageToStorage(data model: SaveThreadImageViewModel)
    func getImageFromStorage(completion: @escaping ([ImageViewModel]) -> Void)
    func deleteDataFromStorage()
}

class Interactor: InteractorInput {
    
    let networkService: NetworkServiceInput
    let coreDataService: CoreDataServiceInput
    
    init(networkService: NetworkServiceInput, coreDataService: CoreDataServiceInput) {
        self.networkService = networkService
        self.coreDataService = coreDataService
    }
    
    // load images from url that we got
    func fetchLoadedImage(at path: String, completion: @escaping (UIImage?) -> Void) {
        networkService.getData(at: path, parameters: nil) { data in
            guard let data = data else {
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            completion(image)
        }
    }
    
    // load data by string(got url and desc)
    func loadImageFromNetwork(by searchString: String, completion: @escaping ([ImageModel]) -> Void) {
        let url = API.searchPath(text: searchString, extras: "url_m")
        networkService.getDataUrl(at: url) { (data) in
            guard let data = data else {
                completion([])
                return
            }
            
            let responseDictionary = try? JSONSerialization.jsonObject(with: data, options: .init()) as? Dictionary<String, Any>
            
            guard let response = responseDictionary,
                let photosDictionary = response["photos"] as? Dictionary<String, Any>,
                let photosArray = photosDictionary["photo"] as? [[String: Any]] else { return }
            
            
            let models = photosArray.map { (object) -> ImageModel in
                let urlString = object["url_m"] as? String ?? ""
                let title = object["title"] as? String ?? ""
                
                return ImageModel(path: urlString, description: title)
            }
            completion(models)
        }
    }
    

    func sendImageToStorage(data model: SaveThreadImageViewModel) {
        coreDataService.saveInStorage(data: model)
    }

    func getImageFromStorage(completion: @escaping ([ImageViewModel]) -> Void) {
        coreDataService.loadFromStorage { (images) in
            var imageViewModel: [ImageViewModel] = []
            images.forEach {
                guard let image = UIImage(data: $0.image) else { return }
                imageViewModel.append(ImageViewModel(image: image))
            }
            completion(imageViewModel)
        }
    }

    func deleteDataFromStorage() {
        coreDataService.deleteData()
    }
}

//
//  NetworkService.swift
//  UrlSessionLesson
//
//  Created by Константин Богданов on 06/11/2019.
//  Copyright © 2019 Константин Богданов. All rights reserved.
//

import UIKit

protocol NetworkServiceInput {
	func getData(at path: String, parameters: [AnyHashable: Any]?, completion: @escaping (Data?) -> Void)
    func getDataUrl(at url: URL, completion: @escaping (Data?) -> Void)
}

class NetworkService: NetworkServiceInput {
    
    let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    func getData(at path: String, parameters: [AnyHashable: Any]?, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: path) else {
            completion(nil)
            return
        }
        
        let dataTask = session.dataTask(with: url) { data, _, _ in
            completion(data)
        }
        dataTask.resume()
    }
    
    func getDataUrl(at url: URL, completion: @escaping (Data?) -> Void) {
        let dataTask = session.dataTask(with: url) { data, _, _ in
            completion(data)
        }
        dataTask.resume()
    }
}

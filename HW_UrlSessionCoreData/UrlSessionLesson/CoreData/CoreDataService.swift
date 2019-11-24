//
//  CoreDataService.swift
//  UrlSessionLesson
//
//  Created by Давид on 23/11/2019.
//  Copyright © 2019 Константин Богданов. All rights reserved.
//

import CoreData
import UIKit

protocol CoreDataServiceInput {
    func saveInStorage(data model: SaveThreadImageViewModel)
    func loadFromStorage(completion: @escaping ([MOImages]) -> Void)
    func deleteData()
}

class CoreDataService: CoreDataServiceInput {
    let stack = CoreDataStack.shared
    
    func saveInStorage(data model: SaveThreadImageViewModel) {
        stack.persistentContainer.performBackgroundTask { (context) in
            model.data.forEach{
                let image = MOImages(context: context)
                guard let oneImageToSave = $0.image.pngData() else { return }
                image.image = oneImageToSave
            }
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func loadFromStorage(completion: @escaping ([MOImages]) -> Void) {
        stack.persistentContainer.performBackgroundTask { (context) in
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Images")
            do {
                guard let result = try context.fetch(fetch) as? [MOImages] else { return }
                completion(result)
            } catch {
                print(error.localizedDescription)
                completion([MOImages]())
            }
        }
    }
    
    func deleteData() {
        stack.persistentContainer.performBackgroundTask { (context) in
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Images")
            do {
                try context.execute(NSBatchDeleteRequest(fetchRequest: fetch))
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}

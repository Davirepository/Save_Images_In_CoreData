//
//  MOImages.swift
//  UrlSessionLesson
//
//  Created by Давид on 23/11/2019.
//  Copyright © 2019 Константин Богданов. All rights reserved.
//

import Foundation
import CoreData

@objc(MOImages)
internal class MOImages: NSManagedObject {
    @NSManaged var image: Data
}

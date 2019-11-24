//
//  AppDelegate.swift
//  UrlSessionLesson
//
//  Created by Константин Богданов on 06/11/2019.
//  Copyright © 2019 Константин Богданов. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		window = UIWindow(frame: UIScreen.main.bounds)

		let service = NetworkService(session: SessionFactory().createDefaultSession())
        let interactor = Interactor(networkService: service, coreDataService: CoreDataService())
        let viewController = ViewController(interactor: interactor)
        let navigationController = UINavigationController(rootViewController: viewController)

		window?.rootViewController = navigationController
		window?.makeKeyAndVisible()
        
//        interactor.loadImage2(by: "cat", completion: { data in
//            let data = data
//            print(data)
//        })
        
        return true
	}
}


//
//  RootRouter.swift
//  VIPER
//
//  Created by Михаил Щербаков on 23.03.2022.
//

import Foundation
import UIKit


final class RootRouter {
    private let navigationController = UINavigationController(nibName: nil, bundle: nil)

    func start() -> UIViewController {
        let firstRouter = UsersRouter()

        firstRouter.start(parent: navigationController)

        return navigationController
    }
}

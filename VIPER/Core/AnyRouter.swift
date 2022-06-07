//
//  AnyRouter.swift
//  VIPER
//
//  Created by Михаил Щербаков on 23.03.2022.
//

import UIKit

protocol AnyRouter: AnyObject {
    func start(parent: UINavigationController)
}

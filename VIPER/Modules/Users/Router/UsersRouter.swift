//
//  UsersRouter.swift
//  VIPER
//
//  Created by Михаил Щербаков on 22.03.2022.
//

import Foundation
import UIKit

final class UsersRouter: UsersRouterProtocol {
    private weak var parent: UINavigationController?

    func start(parent: UINavigationController) {
        self.parent = parent

        let networkManager = NetworkManager() // Assembly
        let usersDataService = UsersDataService(networkManager: networkManager)
        let interactor = UsersInteractor(usersDataService: usersDataService)
        let presenter = UsersPresenter(router: self, interactor: interactor)
        let viewController = UsersViewController(presenter: presenter)

        presenter.view = viewController
        
        parent.pushViewController(viewController, animated: true)
    }

    func showNextScreen() {
        let otherRouter = UsersRouter()
        otherRouter.start(parent: parent!)
        // TODO: implementation
    }
}

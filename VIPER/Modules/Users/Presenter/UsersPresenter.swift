//
//  UsersPresenter.swift
//  VIPER
//
//  Created by Михаил Щербаков on 22.03.2022.
//

import Foundation
import Combine

// ЭТО АБСТРАКЦИЯ КОТОРАЯ ЗАЯВЛЯЕТ - ЧТО PRESENTER ЖДЕТ ОТ VIEW
protocol UsersViewProtocol: AnyView {
    var shouldUserSelected: AnyPublisher<User, Never> { get }
    // var tapOnUser: AnyPublisher<User, Never> { get } Так плохо так-как мы раскываем в протоколе детали реализации.

    func updateUsers(_ users: [User])
    func showError(_ error: String)
}

protocol UsersRouterProtocol: AnyRouter {
    func showNextScreen()
}

final class UsersPresenter: AnyPresenter {
    weak var view: UsersViewProtocol?

    private let router: UsersRouterProtocol
    private let interactor: UsersInteractorProtocol

    private var cancellableBag: Set<AnyCancellable> = []

    init(router: UsersRouterProtocol, interactor: UsersInteractorProtocol) {
        self.router = router
        self.interactor = interactor

        interactor.users.receive(on: RunLoop.main).sink { [weak self] users in
            self?.view?.updateUsers(users)
        }.store(in: &cancellableBag)

        interactor.receiveError.receive(on: RunLoop.main).sink { [weak self] _ in
            self?.view?.showError("Что то пошло не так")
        }.store(in: &cancellableBag)

        interactor.fetchUsers()
    }
}

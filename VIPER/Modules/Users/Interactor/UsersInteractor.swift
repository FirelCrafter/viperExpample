//
//  Interactor.swift
//  VIPER
//
//  Created by Михаил Щербаков on 22.03.2022.
//

import Foundation
import Combine

protocol UsersInteractorProtocol: AnyInteractor {
    var users: CurrentValueSubject<[User], Never> { get }
    var receiveError: AnyPublisher<Error, Never> { get }

    func fetchUsers()
}

final class UsersInteractor: UsersInteractorProtocol {
    var users: CurrentValueSubject<[User], Never> { usersDataService.users }
    var receiveError: AnyPublisher<Error, Never> { usersDataService.lastError.eraseToAnyPublisher() }
    
    private var cancellables = Set<AnyCancellable>()
    private let usersDataService: UsersDataService
    
    init(usersDataService: UsersDataService) {
        self.usersDataService = usersDataService
    }

    func fetchUsers() {
        usersDataService.fetchUsers()
    }
}

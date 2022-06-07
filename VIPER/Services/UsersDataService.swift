//
//  UsersDataService.swift
//  VIPER
//
//  Created by Михаил Щербаков on 23.03.2022.
//
//
// https://jsonplaceholder.typicode.com/users

import Foundation
import Combine

class UsersDataService {
    
    let users = CurrentValueSubject<[User], Never>([])
    let lastError = PassthroughSubject<Error, Never>() // Обработчик ошибок с сервера
    
    private let networkManager: NetworkManager
    private var fetchUserCancellable: Cancellable?
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    //MARK: Public section
    
    func fetchUsers() {
        
        print("fetching")
        
        fetchUserCancellable?.cancel()
        
        fetchUserCancellable = networkManager.request(method: .get,
                                                      path: "/users",
                                                      body: Optional<Int>.none, // Мы не можем передать сюда nil, это же небольшая хитрость
                                                      headers: nil,
                                                      queryItems: nil)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.lastError.send(error)
                case .finished:
                    break
                }
                // тут передается обработчик ошибок с сервера
            }, receiveValue: { [weak self] (users: [User]) in
                self?.setUserData(users: users)
            })
    }
    
    //MARK: Private section
    
    private func setUserData(users newUsers: [User]) {
        users.send(newUsers)
    }
    
}

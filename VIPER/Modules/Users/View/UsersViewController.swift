//
//  UsersViewController.swift
//  VIPER
//
//  Created by Михаил Щербаков on 22.03.2022.
//

import Foundation
import Combine
import UIKit

final class UsersViewController: UIViewController, UsersViewProtocol {
    var shouldUserSelected: AnyPublisher<User, Never> { userSelectedSubject.eraseToAnyPublisher() }
    private let userSelectedSubject = PassthroughSubject<User, Never>()

    let presenter: AnyPresenter // Нужно только ради захвата, чтобы presenter не удалился.

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.isHidden = true
        return table
    }()

    private var users: [User] = []

    init(presenter: UsersPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateUsers(_ newUsers: [User]) {
        users = newUsers
        tableView.reloadData()
        tableView.isHidden = false
    }

    func showError(_ error: String) {
        let alertController = UIAlertController(title: "ERROR", message: error, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in }))

        present(alertController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBlue
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].name
        return cell
    }
}

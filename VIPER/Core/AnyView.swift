//
//  AnyView.swift
//  VIPER
//
//  Created by Михаил Щербаков on 23.03.2022.
//

import Foundation

protocol AnyView: AnyObject {
    var presenter: AnyPresenter { get }
}

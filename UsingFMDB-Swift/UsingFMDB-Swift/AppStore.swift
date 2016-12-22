//
//  AppStore.swift
//  UsingFMDB-Swift
//
//  Created by akabeko on 2016/12/21.
//  Copyright © 2016年 akabeko. All rights reserved.
//

import UIKit
import FMDB

/// Manage for the application data.
class AppStore: NSObject {
    /// Manage for the books.
    private(set) var bookStore: BookStore!

    /// Factory of a data access objects.
    private let daoFactory = DAOFactory()

    /// Initialize the instance.
    override init() {
        super.init()
        self.bookStore = BookStore(daoFactory: self.daoFactory)
    }
}

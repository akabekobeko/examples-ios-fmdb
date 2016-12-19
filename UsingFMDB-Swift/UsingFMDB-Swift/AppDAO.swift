//
//  AppDAO.swift
//  UsingFMDB-Swift
//
//  Created by akabeko on 2016/12/17.
//  Copyright © 2016年 akabeko. All rights reserved.
//

import UIKit
import FMDB

/// Manager fot the application data.
class AppDAO: NSObject {
    /// Manage for the books data.
    private(set) var bookDAO: BookDAO?

    /// Path of the database file.
    private var filePath = AppDAO.databaseFilePath()

    /// Initialize the instance.
    override init() {
        super.init()
        self.bookDAO = BookDAO(appDAO: self)
        print(self.filePath)
    }

    /// Get the database connection.
    ///
    /// - Returns: Connection.
    func connection() -> FMDatabase? {
        let db = FMDatabase(path: self.filePath)
        return (db?.open())! ? db : nil
    }

    /// Get the path of database file.
    ///
    /// - Returns: Path of the database file.
    private static func databaseFilePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let dir   = paths[0] as NSString
        return dir.appendingPathComponent("app.db")
    }
}

//
//  DAOFactory.swift
//  UsingFMDB-Swift
//
//  Created by akabeko on 2016/12/22.
//  Copyright © 2016年 akabeko. All rights reserved.
//

import UIKit
import FMDB

/// Factory of a data access objects.
class DAOFactory: NSObject {
    /// Path of the database file.
    private let filePath: String

    /// Initialize the instance.
    override init() {
        self.filePath = DAOFactory.databaseFilePath()
        super.init()

        // For debug
        print(self.filePath)

        if let dao = self.bookDAO() {
            dao.create()
        }
    }

    /// Initialize the instance with the path of the database file.
    ///
    /// - Parameter filePath: the path of the database file.
    init(filePath: String) {
        self.filePath = filePath
        super.init()
    }

    /// Create the data access object of the books.
    ///
    /// - Returns: Instance of the data access object.
    func bookDAO() -> BookDAO? {
        if let db = self.connect() {
            return BookDAO(db: db)
        }

        return nil
    }

    /// Connect to the database.
    ///
    /// - Returns: Connection instance if successful, nil otherwise.
    private func connect() -> FMDatabase? {
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

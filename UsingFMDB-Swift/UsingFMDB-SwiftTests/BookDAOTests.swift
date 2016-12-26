//
//  BookDAOTests.swift
//  UsingFMDB-Swift
//
//  Created by akabeko on 2016/12/26.
//  Copyright © 2016年 akabeko. All rights reserved.
//

import XCTest

class BookDAOTests: XCTestCase {
    /// Path of the database file.
    private let filePath = BookDAOTests.databaseFilePath()

    /// Factory of a data access objects.
    private var daoFactory: DAOFactory!

    /// Setup the test instance.
    override func setUp() {
        super.setUp()

        self.clean()

        self.daoFactory = DAOFactory(filePath: self.filePath)
        if let dao = self.daoFactory.bookDAO() {
            dao.create()
        }
    }

    /// Tear down the test instance.
    override func tearDown() {
        self.clean()
        super.tearDown()
    }

    /// Test the additional data processing.
    func testAdd() {
        if let dao = self.daoFactory.bookDAO() {
            let book = dao.add(author: "author", title: "title", releaseDate: Date())
            XCTAssertNotNil(book)
            XCTAssert(dao.remove(bookId: (book?.bookId)!))
        } else {
            XCTAssert(false)
        }
    }

    /// Test the remove data processing.
    func testRemove() {
        if let dao = self.daoFactory.bookDAO() {
            let book = dao.add(author: "author", title: "title", releaseDate: Date())
            XCTAssertNotNil(book)
            XCTAssert(dao.remove(bookId: (book?.bookId)!))

            let books = dao.read()
            XCTAssert(books.count == 0)
        } else {
            XCTAssert(false)
        }
    }

    /// Test the update data processing.
    func testUpdate() {
        if let dao = self.daoFactory.bookDAO() {
            let book = dao.add(author: "author", title: "title", releaseDate: Date())
            XCTAssertNotNil(book)

            // Before
            var books = dao.read()
            XCTAssert(books[0].title == "title")

            // After
            let book2 = Book(bookId: (book?.bookId)!, author: (book?.author)!, title: "title2", releaseDate: (book?.releaseDate)!)
            XCTAssert(dao.update(book: book2))
            books = dao.read()
            XCTAssert(books[0].title == "title2")
            
            XCTAssert(dao.remove(bookId: (book?.bookId)!))

        } else {
            XCTAssert(false)
        }
    }

    /// Clean the database file.
    func clean() {
        let manager = FileManager.default
        if manager.fileExists(atPath: self.filePath) {
            do {
                try manager.removeItem(atPath: self.filePath)
            } catch {
                print("Error: faild to remove database file.")
            }
        }
    }

    /// Get the path of database file.
    ///
    /// - Returns: Path of the database file.
    private static func databaseFilePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let dir   = paths[0] as NSString
        return dir.appendingPathComponent("test.db")
    }
}

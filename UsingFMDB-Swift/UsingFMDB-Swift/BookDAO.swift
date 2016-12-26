//
//  BookDAO.swift
//  UsingFMDB-Swift
//
//  Created by akabeko on 2016/12/17.
//  Copyright © 2016年 akabeko. All rights reserved.
//

import UIKit
import FMDB

/// Manage for the books data table.
class BookDAO: NSObject {
    /// Query for the create table.
    private static let SQLCreate = "" +
    "CREATE TABLE IF NOT EXISTS books (" +
      "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
      "author TEXT, " +
      "title TEXT, " +
      "release_date INTEGER" +
    ");"

    /// Query for the inssert row.
    private static let SQLSelect = "" +
    "SELECT " +
      "id, author, title, release_date " +
    "FROM " +
      "books;" +
    "ORDER BY " +
      "author, title;"

    /// Query for the inssert row.
    private static let SQLInsert = "" +
    "INSERT INTO " +
      "books (author, title, release_date) " +
    "VALUES " +
      "(?, ?, ?);"

    /// Query for the update row.
    private static let SQLUpdate = "" +
    "UPDATE " +
      "books " +
    "SET " +
      "author = ?, title = ?, release_date = ? " +
    "WHERE " +
      "id = ?;"

    /// Query for the delete row.
    private static let SQLDelete = "DELETE FROM books WHERE id = ?;"

    /// Instance of the database connection.
    private let db: FMDatabase

    /// Initialize the instance.
    ///
    /// - Parameter db: Instance of the database connection.
    init(db: FMDatabase) {
        self.db = db
        super.init()
    }

    deinit {
        self.db.close()
    }

    /// Create the table.
    func create() {
        self.db.executeUpdate(BookDAO.SQLCreate, withArgumentsIn: nil)
    }

    /// Add the book.
    ///
    /// - Parameters:
    ///   - author:      Author.
    ///   - title:       Title.
    ///   - releaseDate: Release date.
    /// - Returns: Added the book.
    func add(author: String, title: String, releaseDate: Date) -> Book? {
        var book: Book? = nil
        if self.db.executeUpdate(BookDAO.SQLInsert, withArgumentsIn: [author, title, releaseDate]) {
            let bookId = db.lastInsertRowId()
            book = Book(bookId: Int(bookId), author: author, title: title, releaseDate: releaseDate)
        }

        return book
    }

    /// Read a books.
    ///
    /// - Returns: Readed books.
    func read() -> Array<Book> {
        var books = Array<Book>()
        if let results = self.db.executeQuery(BookDAO.SQLSelect, withArgumentsIn: nil) {
            while results.next() {
                let book = Book(bookId: results.long(forColumnIndex: 0),
                                author: results.string(forColumnIndex: 1),
                                title: results.string(forColumnIndex: 2),
                                releaseDate: results.date(forColumnIndex: 3))
                books.append(book)
            }
        }

        return books
    }

    /// Remove a book.
    ///
    /// - Parameter bookId: The identifier of the book to remove.
    /// - Returns: "true" if successful.
    func remove(bookId: Int) -> Bool {
        return self.db.executeUpdate(BookDAO.SQLDelete, withArgumentsIn: [bookId])
    }

    /// Update a book.
    ///
    /// - Parameter book: The data of the book to update.
    /// - Returns: "true" if successful.
    func update(book: Book) -> Bool {
        return db.executeUpdate(BookDAO.SQLUpdate,
                                withArgumentsIn: [
                                    book.author,
                                    book.title,
                                    book.releaseDate,
                                    book.bookId])
    }
}

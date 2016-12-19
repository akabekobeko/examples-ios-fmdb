//
//  BookDAO.swift
//  UsingFMDB-Swift
//
//  Created by akabeko on 2016/12/17.
//  Copyright © 2016年 akabeko. All rights reserved.
//

import UIKit
import FMDB

/// Manage for the books data.
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

    /// Manager fot the application data.
    private var appDAO: AppDAO

    /// Initialize the instance.
    ///
    /// - Parameter appDAO: Manager fot the application data.
    init(appDAO: AppDAO) {
        self.appDAO = appDAO
        super.init()
        self.create()
    }

    /// Add the book.
    ///
    /// - Parameters:
    ///   - author:      Author.
    ///   - title:       Title.
    ///   - releaseDate: Release date.
    /// - Returns: Added the book.
    func add(author: String, title: String, releaseDate: Date) -> Book? {
        var book: Book? = nil;
        if let db = self.appDAO.connection() {
            if db.executeUpdate(BookDAO.SQLInsert, withArgumentsIn: [author, title, releaseDate]) {
                let bookId = db.lastInsertRowId()
                book = Book(bookId: Int(bookId), author: author, title: title, releaseDate: releaseDate)
            }

            db.close()
        }

        return book
    }

    /// Read a books.
    ///
    /// - Returns: Readed books.
    func read() -> Array<Book> {
        var books = Array<Book>();
        if let db = self.appDAO.connection() {
            let results = db.executeQuery(BookDAO.SQLSelect, withArgumentsIn: nil)
            while (results?.next())! {
                let book = Book(bookId: Int((results?.int(forColumnIndex: 0))!),
                                author: (results?.string(forColumnIndex: 1))!,
                                title: (results?.string(forColumnIndex: 2))!,
                                releaseDate: (results?.date(forColumnIndex: 3))!)
                books.append(book)
            }

            db.close()
        }

        return books
    }

    /// Remove a book.
    ///
    /// - Parameter bookId: The identifier of the book to remove.
    /// - Returns: "true" if successful.
    func remove(bookId: Int) -> Bool {
        if let db = self.appDAO.connection() {
            let succeeded = db.executeUpdate(BookDAO.SQLDelete,
                                             withArgumentsIn: [bookId])
            db.close()
            return succeeded
        }

        return false;
    }

    /// Update a book.
    ///
    /// - Parameter book: The data of the book to update.
    /// - Returns: "true" if successful.
    func update(book: Book) -> Bool {
        if let db = self.appDAO.connection() {
            let succeeded = db.executeUpdate(BookDAO.SQLUpdate,
                                             withArgumentsIn: [
                                                book.author,
                                                book.title,
                                                book.releaseDate,
                                                book.bookId])
            db.close()
            return succeeded
        }

        return false
    }

    /// Create the table.
    private func create() -> Void {
        if let db = self.appDAO.connection() {
            db.executeUpdate(BookDAO.SQLCreate, withArgumentsIn: nil)
            db.close()
        }
    }
}

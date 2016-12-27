//
//  BookStore.swift
//  UsingFMDB-Swift
//
//  Created by akabeko on 2016/12/21.
//  Copyright © 2016年 akabeko. All rights reserved.
//

import UIKit

/// Manage for the books.
class BookStore: NSObject {
    /// Collection of author names.
    var authors: Array<String> {
        get {
            return self.bookCache.authors
        }
    }

    /// Dictionary of book collection classified by author name.
    var booksByAuthor: Dictionary<String, Array<Book>> {
        get {
            return self.bookCache.booksByAuthor
        }
    }

    /// Factory of a data access objects.
    private let daoFactory: DAOFactory

    /// Manager for the book data.
    private var bookCache: BookCache!

    /// Initialize the instance.
    ///
    /// - Parameter daoFactory: Factory of a data access objects.
    init(daoFactory: DAOFactory) {
        self.daoFactory = daoFactory
        super.init()

        if let dao = self.daoFactory.bookDAO() {
            dao.create()
            self.bookCache = BookCache(books: dao.read())
        }
    }

    /// Add the new book.
    ///
    /// - Parameter book: Book data.
    /// - Returns: "true" if successful.
    func add(book: Book) -> Bool {
        if let dao = self.daoFactory.bookDAO(), let newBook = dao.add(author: book.author, title: book.title, releaseDate: book.releaseDate) {
            return self.bookCache.add(book: newBook)
        }

        return false
    }

    /// Remove the book.
    ///
    /// - Parameter book: Book data.
    /// - Returns: "true" if successful.
    func remove(book: Book) -> Bool {
        if let dao = self.daoFactory.bookDAO(), dao.remove(bookId: book.bookId) {
            return self.bookCache.remove(book: book)
        }

        return false
    }

    /// Update the book.
    ///
    /// - Parameter oldBook: New book data.
    /// - Parameter newBook: Old book data.
    /// - Returns: "true" if successful.
    func update(oldBook: Book, newBook: Book) -> Bool {
        if let dao = self.daoFactory.bookDAO(), dao.update(book: newBook) {
            return self.bookCache.update(oldBook: oldBook, newBook: newBook)
        }

        return false
    }
}

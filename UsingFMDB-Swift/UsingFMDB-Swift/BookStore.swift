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
            return self.bookData.authors
        }
    }

    /// Dictionary of book collection classified by author name.
    var booksByAuthor: Dictionary<String, Array<Book>> {
        get {
            return self.bookData.booksByAuthor
        }
    }

    /// Factory of a data access objects.
    private let daoFactory: DAOFactory

    /// Manager for the book data.
    private let bookData = BookData()

    /// Initialize the instance.
    ///
    /// - Parameter bookDAO: Manager for the book data table.
    init(daoFactory: DAOFactory) {
        self.daoFactory = daoFactory
        super.init()

        if let dao = self.daoFactory.bookDAO() {
            self.bookData.setBooks(books: dao.read())
        }
    }

    /// Add the new book.
    ///
    /// - Parameter book: Book data.
    /// - Returns: "true" if successful.
    func add(book: Book) -> Bool {
        if let dao = self.daoFactory.bookDAO(), let newBook = dao.add(author: book.author, title: book.title, releaseDate: book.releaseDate) {
            return self.bookData.add(book: newBook)
        }

        return false
    }

    /// Remove the book.
    ///
    /// - Parameter book: Book data.
    /// - Returns: "true" if successful.
    func remove(book: Book) -> Bool {
        if let dao = self.daoFactory.bookDAO(), dao.remove(bookId: book.bookId) {
            return self.bookData.removeBook(book: book)
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
            return self.bookData.update(oldBook: oldBook, newBook: newBook)
        }

        return false
    }
}

//
//  BookCache.swift
//  UsingFMDB-Swift
//
//  Created by akabeko on 2016/12/22.
//  Copyright © 2016年 akabeko. All rights reserved.
//

import UIKit

/// Manager fot the book data.
class BookCache: NSObject {
    /// A collection of author names.
    var authors = Array<String>()

    /// Dictionary of book collection classified by author name.
    var booksByAuthor = Dictionary<String, Array<Book>>()

    /// Initialize the instance.
    override init() {
        super.init()
    }

    /// Initialize the instance.
    ///
    /// - Parameter books: Collection of the book data.
    init(books: Array<Book>) {
        super.init()

        books.forEach({ (book) in
            if !self.add(book: book) {
                print("Faild to add book: " + book.author + " - " + book.title )
            }
        })
    }

    /// Add the new book.
    ///
    /// - Parameter book: Book data.
    /// - Returns: "true" if successful.
    func add(book: Book) -> Bool {
        if book.bookId == Book.BookIdNone {
            return false
        }

        if var existBooks = self.booksByAuthor[book.author] {
            existBooks.append(book)
            self.booksByAuthor.updateValue(existBooks, forKey: book.author)
        } else {
            var newBooks = Array<Book>()
            newBooks.append(book)
            self.booksByAuthor[book.author] = newBooks
            self.authors.append(book.author)
        }

        return true
    }

    /// Remove the book.
    ///
    /// - Parameter book: Book data.
    /// - Returns: "true" if successful.
    func remove(book: Book) -> Bool {
        if var books = self.booksByAuthor[book.author] {
            for i in 0..<books.count {
                let existBook = books[i]
                if existBook.bookId == book.bookId {
                    books.remove(at: i)
                    self.booksByAuthor.updateValue(books, forKey: book.author)
                    break
                }
            }

            if books.count == 0 {
                return self.removeAuthor(author: book.author)
            }
        }

        return false
    }

    /// Update the book.
    ///
    /// - Parameter oldBook: New book data.
    /// - Parameter newBook: Old book data.
    /// - Returns: "true" if successful.
    func update(oldBook: Book, newBook: Book) -> Bool {
        if oldBook.author == newBook.author {
            return self.replaceBook(newBook: newBook)
        } else if self.remove(book: oldBook) {
            return self.add(book: newBook)
        }

        return false
    }

    /// Remove the author at the inner collection.
    ///
    /// - Parameter author: Name of the author.
    /// - Returns: "true" if successful.
    private func removeAuthor(author: String) -> Bool {
        self.booksByAuthor.removeValue(forKey: author)
        for i in 0..<self.authors.count {
            let existAuthor = self.authors[i]
            if existAuthor == author {
                self.authors.remove(at: i)
                return true
            }
        }

        return false
    }

    /// Replace the book.
    ///
    /// - Parameter newBook: New book data.
    /// - Returns: "true" if successful.
    private func replaceBook(newBook: Book) -> Bool {
        if var books = self.booksByAuthor[newBook.author] {
            for i in 0..<books.count {
                let book = books[i]
                if book.bookId == newBook.bookId {
                    books[i] = newBook
                    self.booksByAuthor.updateValue(books, forKey: newBook.author)
                    return true
                }
            }
        }

        return false
    }
}

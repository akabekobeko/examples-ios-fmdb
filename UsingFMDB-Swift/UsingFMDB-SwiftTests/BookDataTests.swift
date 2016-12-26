//
//  BookCacheTests.swift
//  UsingFMDB-Swift
//
//  Created by akabeko on 2016/12/22.
//  Copyright © 2016年 akabeko. All rights reserved.
//

import XCTest

/// Test the book data.
class BookDataTests: XCTestCase {
    /// Setup the test instance.
    override func setUp() {
        super.setUp()
    }

    /// Tear down the test instance.
    override func tearDown() {
        super.tearDown()
    }

    /// Test the additional data processing.
    func testAdd() {
        let data = BookData()
        var book = Book(bookId: Book.BookIdNone, author: "", title: "", releaseDate: Date())
        XCTAssert(!data.add(book: book))
        XCTAssert(data.authors.count == 0)

        book = Book(bookId: 1, author: "author", title: "title", releaseDate: Date())
        XCTAssert(data.add(book: book))
        XCTAssert(data.authors.count == 1)

        let books = data.booksByAuthor["author"]
        XCTAssert(books?.count == 1)
        XCTAssert(books?[0].title == "title")
    }

    /// Test the remove data processing.
    func testRemove() {
        let data = BookData()
        let book = Book(bookId: 1, author: "author", title: "title", releaseDate: Date())
        XCTAssert(data.add(book: book))
        XCTAssert(data.authors.count == 1)
        XCTAssert(data.remove(book: book))
        XCTAssert(data.authors.count == 0)

        let books = data.booksByAuthor["author"]
        XCTAssertNil(books)
    }

    /// Test the update data with title processing.
    func testUpdateTitle() {
        let data  = BookData()
        let book1 = Book(bookId: 1, author: "author", title: "title", releaseDate: Date())
        XCTAssert(data.add(book: book1))
        XCTAssert(data.authors.count == 1)

        let book2 = Book(bookId: 1, author: "author", title: "title2", releaseDate: Date())
        XCTAssert(data.update(oldBook: book1, newBook: book2))
        XCTAssert(data.authors.count == 1)

        var books = data.booksByAuthor["author"]
        XCTAssert(books?[0].title == "title2")
    }

    /// Test the update data with author and title processing.
    func testUpdateAuthorAndTitle() {
        let data  = BookData()
        let book1 = Book(bookId: 1, author: "author", title: "title", releaseDate: Date())
        XCTAssert(data.add(book: book1))
        XCTAssert(data.authors.count == 1)
        
        let book2 = Book(bookId: 1, author: "author2", title: "title2", releaseDate: Date())
        XCTAssert(data.update(oldBook: book1, newBook: book2))
        XCTAssert(data.authors.count == 1)

        var books = data.booksByAuthor["author"]
        XCTAssertNil(books)

        books = data.booksByAuthor["author2"]
        XCTAssert(books?[0].title == "title2")
    }
}

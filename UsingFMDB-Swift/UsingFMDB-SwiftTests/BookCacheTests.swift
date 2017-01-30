//
//  BookCacheTests.swift
//  UsingFMDB-Swift
//
//  Created by akabeko on 2016/12/22.
//  Copyright © 2016年 akabeko. All rights reserved.
//

import XCTest

/// Test the book data.
class BookCacheTests: XCTestCase {
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
        let cache = BookCache()
        var book  = Book(bookId: Book.BookIdNone, author: "", title: "", releaseDate: Date())
        XCTAssert(!cache.add(book: book))
        XCTAssertEqual(cache.authors.count, 0)

        book = Book(bookId: 1, author: "author", title: "title", releaseDate: Date())
        XCTAssert(cache.add(book: book))
        XCTAssertEqual(cache.authors.count, 1)

        let books = cache.booksByAuthor["author"]
        XCTAssertEqual(books?.count, 1)
        XCTAssertEqual(books?[0].title, "title")
    }

    /// Test the remove data processing.
    func testRemove() {
        let cache = BookCache()
        let book  = Book(bookId: 1, author: "author", title: "title", releaseDate: Date())
        XCTAssert(cache.add(book: book))
        XCTAssertEqual(cache.authors.count, 1)
        XCTAssert(cache.remove(book: book))
        XCTAssertEqual(cache.authors.count, 0)

        let books = cache.booksByAuthor["author"]
        XCTAssertNil(books)

        let book2  = Book(bookId: 2, author: "author", title: "title", releaseDate: Date())
        XCTAssert(cache.add(book: book))
        XCTAssert(cache.add(book: book2))
        XCTAssert(cache.remove(book: book))
        XCTAssertEqual(cache.authors.count, 1)
    }

    /// Test the update data with title processing.
    func testUpdateTitle() {
        let cache = BookCache()
        let book1 = Book(bookId: 1, author: "author", title: "title", releaseDate: Date())
        XCTAssert(cache.add(book: book1))
        XCTAssertEqual(cache.authors.count, 1)

        let book2 = Book(bookId: 1, author: "author", title: "title2", releaseDate: Date())
        XCTAssert(cache.update(oldBook: book1, newBook: book2))
        XCTAssertEqual(cache.authors.count, 1)

        var books = cache.booksByAuthor["author"]
        XCTAssertEqual(books?[0].title, "title2")
    }

    /// Test the update data with author and title processing.
    func testUpdateAuthorAndTitle() {
        let cache = BookCache()
        let book1 = Book(bookId: 1, author: "author", title: "title", releaseDate: Date())
        XCTAssert(cache.add(book: book1))
        XCTAssertEqual(cache.authors.count, 1)

        let book2 = Book(bookId: 1, author: "author2", title: "title2", releaseDate: Date())
        XCTAssert(cache.update(oldBook: book1, newBook: book2))
        XCTAssertEqual(cache.authors.count, 1)

        var books = cache.booksByAuthor["author"]
        XCTAssertNil(books)

        books = cache.booksByAuthor["author2"]
        XCTAssertEqual(books?[0].author, "author2")
        XCTAssertEqual(books?[0].title, "title2")
    }
}

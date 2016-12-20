//
//  Book.swift
//  UsingFMDB-Swift
//
//  Created by akabeko on 2016/12/17.
//  Copyright © 2016年 akabeko. All rights reserved.
//

import UIKit

/// Represents a book.
class Book: NSObject {
    /// Invalid book identifier.
    static let BookIdNone = 0

    /// Identifier.
    private(set) var bookId: Int

    /// Title.
    private(set) var title: String

    /// Author.
    private(set) var author: String

    /// Release date.
    private(set) var releaseDate: Date

    /// Create a book instance.
    ///
    /// - Parameters:
    ///   - bookId:      Identifier
    ///   - title:       Title.
    ///   - author:      Author.
    ///   - releaseDate: Release Date
    init(bookId: Int, author: String, title: String, releaseDate: Date) {
        self.bookId      = bookId
        self.title       = title
        self.author      = author
        self.releaseDate = releaseDate
    }
}

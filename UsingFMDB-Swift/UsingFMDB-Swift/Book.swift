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

    /// Initialize the instance.
    ///
    /// - Parameters:
    ///   - bookId:      Identifier
    ///   - author:      Author.
    ///   - title:       Title.
    ///   - releaseDate: Release Date
    init(bookId: Int, author: String, title: String, releaseDate: Date) {
        self.bookId      = bookId
        self.author      = author
        self.title       = title
        self.releaseDate = releaseDate
    }
}

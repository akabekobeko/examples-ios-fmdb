//
//  BookDAO.m
//  UsingFMDB-Objective-C
//
//  Created by akabeko on 2016/12/03.
//  Copyright © 2016年 akabeko. All rights reserved.
//

#import "BookDAO.h"
#import "Book.h"
#import <FMDatabase.h>
#import <FMResultSet.h>

/** Query for the create table. */
static NSString * const kSQLCreate = @""
"CREATE TABLE IF NOT EXISTS books ("
  "id INTEGER PRIMARY KEY AUTOINCREMENT, "
  "author TEXT, "
  "title TEXT, "
  "release_date INTEGER"
");";

/** Query for the select rows. */
static NSString * const kSQLSelect = @""
"SELECT "
  "id, author, title, release_date "
"FROM "
  "books;"
"ORDER BY "
  "author, title;";

/** Query for the inssert row. */
static NSString * const kSQLInsert = @""
"INSERT INTO "
  "books (author, title, release_date) "
"VALUES "
  "(?, ?, ?);";

/** Query for the update row. */
static NSString * const kSQLUpdate = @""
"UPDATE "
  "books "
"SET "
  "author = ?, title = ?, release_date = ? "
"WHERE "
  "id = ?;";

/** Query for the delete row. */
static NSString * const kSQLDelete = @""
"DELETE FROM books WHERE id = ?;";

@interface BookDAO ()

/** Instance of the database connection. */
@property (nonatomic) FMDatabase *db;

@end

@implementation BookDAO

/**
 * Initialize the instance.
 *
 * @param db Instance of the database connection.
 *
 * @return Instance.
 */
- (instancetype)init:(FMDatabase *)db {
    self = [super init];
    if (self && db) {
        self.db = db;
    }

    return self;
}

/**
 * Deallocates the memory occupied by the receiver.
 */
- (void)dealloc {
    [self.db close];
}

/**
 * Create the table.
 *
 *
 * @return YES if successful.
 */
- (BOOL)create {
    return [self.db executeUpdate:kSQLCreate];
}

/**
 * Add a book.
 *
 * @param author      Author.
 * @param title       Title.
 * @param releaseDate Release date.
 *
 * @return Added book.
 */
- (Book *)add:(NSString *)author title:(NSString *)title releaseDate:(NSDate *)releaseDate {
    Book *book = nil;
    if ([self.db executeUpdate:kSQLInsert, author, title, releaseDate]) {
        NSInteger bookId = [self.db lastInsertRowId];
        book = [Book bookWithId:bookId author:author title:title releaseDate:releaseDate];
    }

    return book;
}

/**
 * Read a books.
 *
 * @return Readed books.
 */
- (NSArray *)read {
    NSMutableArray *books = [NSMutableArray arrayWithCapacity:0];
    FMResultSet    *results = [self.db executeQuery:kSQLSelect];

    while ([results next]) {
        [books addObject:[Book bookWithId:[results intForColumnIndex:0]
                                   author:[results stringForColumnIndex:1]
                                    title:[results stringForColumnIndex:2]
                              releaseDate:[results dateForColumnIndex:3]]];
    }

    return books;
}

/**
 * Remove a book.
 *
 * @param bookId The identifier of the book to remove.
 *
 * @return YES if successful.
 */
- (BOOL)remove:(NSInteger)bookId {
    return [self.db executeUpdate:kSQLDelete, [NSNumber numberWithInteger:bookId]];
}

/**
 * Update a book.
 *
 * @param book The data of the book to update.
 *
 * @return YES if successful.
 */
- (BOOL)update:(Book *)book {
    return [self.db executeUpdate:kSQLUpdate,
            book.author,
            book.title,
            book.releaseDate,
            [NSNumber numberWithInteger:book.bookId]];
}

@end

//
//  BookDAO.m
//  UsingFMDB-Objective-C
//
//  Created by akabeko on 2016/12/03.
//  Copyright © 2016年 akabeko. All rights reserved.
//

#import "BookDAO.h"
#import "Book.h"
#import "AppDAO.h"
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
  "books "
"GROUP BY "
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

/** Manager fot the application data. */
@property (nonatomic, weak) AppDAO *appDAO;

@end

@implementation BookDAO

/**
 * Initialize the instance.
 *
 * @param appDAO Manager fot the application data.
 *
 * @return Instance.
 */
- (instancetype)init:(AppDAO *)appDAO {
    self = [super init];
    if (self) {
        self.appDAO = appDAO;
        [self create];
    }

    return self;
}

/**
 * Add a book.
 *
 * @param title       Title.
 * @param author      Author.
 * @param releaseDate Release date.
 *
 * @return Added book.
 */
- (Book *)add:(NSString *)title author:(NSString *)author releaseDate:(NSDate *)releaseDate {
    FMDatabase *db = [self.appDAO connection];
    if (!(db)) { return nil; }

    Book *book = nil;
    if ([db executeUpdate:kSQLInsert, author, title, releaseDate]) {
        NSInteger bookId = [db lastInsertRowId];
        book = [Book bookWithId:bookId author:author title:title releaseDate:releaseDate];
    }

    [db close];

    return book;
}

/**
 * Read a books.
 *
 * @return Readed books.
 */
- (NSArray *)read {
    NSMutableArray *books = [NSMutableArray arrayWithCapacity:0];
    FMDatabase     *db    = [self.appDAO connection];
    if (!(db)) { return books; }

    FMResultSet *results = [db executeQuery:kSQLSelect];
    while ([results next]) {
        [books addObject:[Book bookWithId:[results intForColumnIndex:0]
                                   author:[results stringForColumnIndex:1]
                                    title:[results stringForColumnIndex:2]
                              releaseDate:[results dateForColumnIndex:3]]];
    }

    [db close];

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
    FMDatabase *db = [self.appDAO connection];
    if (!(db)) { return NO; }

    BOOL succeeded = [db executeUpdate:kSQLDelete, [NSNumber numberWithInteger:bookId]];
    [db close];

    return succeeded;
}

/**
 * Update a book.
 *
 * @param book The data of the book to update.
 *
 * @return YES if successful.
 */
- (BOOL)update:(Book *)book {
    FMDatabase *db = [self.appDAO connection];
    if (!(db)) { return NO; }

    BOOL succeeded = [db executeUpdate:kSQLUpdate,
                      book.author,
                      book.title,
                      book.releaseDate,
                      [NSNumber numberWithInteger:book.bookId]];
    [db close];

    return succeeded;
}

#pragma mark - Private

/**
 * Create the table.
 */
- (void)create {
    FMDatabase *db = [self.appDAO connection];
    if (db) {
        [db executeUpdate:kSQLCreate];
        [db close];
    }
}

@end

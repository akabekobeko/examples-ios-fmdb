//
//  BookDAOTests.m
//  UsingFMDB-Objective-C
//
//  Created by akabeko on 2016/12/26.
//  Copyright © 2016年 akabeko. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Book.h"
#import "BookDAO.h"
#import "DAOFactory.h"

@interface BookDAOTests : XCTestCase

@property (nonatomic) DAOFactory *daoFactory;
@property (nonatomic) NSString *dbFilePath;

@end

/**
 * Test the database access object for the books.
 */
@implementation BookDAOTests

/**
 * Setup the test instance.
 */
- (void)setUp {
    [super setUp];

    self.dbFilePath = [self databaseFilePath];

    // Setup DB
    [self clean];
    self.daoFactory = [[DAOFactory alloc] initWithDBFilePath:self.dbFilePath];
    BookDAO *dao = [self.daoFactory bookDAO];
    [dao create];
}

/**
 * Tear down the test instance.
 */
- (void)tearDown {
    [self clean];
    [super tearDown];
}

/**
 * Test the additional data processing.
 */
- (void)testAdd {
    BookDAO *dao  = [self.daoFactory bookDAO];
    Book    *book = [dao add:@"author" title:@"title" releaseDate:[NSDate date]];
    XCTAssertNotNil(book);
    XCTAssert([dao remove:book.bookId]);
}

/**
 * Test the remove data processing.
 */
- (void)testRemove {
    BookDAO *dao  = [self.daoFactory bookDAO];
    Book    *book = [dao add:@"author" title:@"title" releaseDate:[NSDate date]];
    XCTAssertNotNil(book);
    XCTAssert([dao remove:book.bookId]);

    NSArray *books = [dao read];
    XCTAssert(books.count == 0);
}

/**
 * Test the update data processing.
 */
- (void)testUpdate {
    BookDAO *dao  = [self.daoFactory bookDAO];
    Book    *book = [dao add:@"author" title:@"title" releaseDate:[NSDate date]];
    XCTAssertNotNil(book);

    // Before
    NSArray *books = [dao read];
    XCTAssert(books.count == 1);
    book = [books objectAtIndex:0];
    XCTAssert([book.title compare:@"title"] == NSOrderedSame);

    // After
    book = [Book bookWithId:book.bookId author:book.author title:@"title2" releaseDate:book.releaseDate];
    XCTAssert([dao update:book]);
    books = [dao read];
    XCTAssert(books.count == 1);
    book = [books objectAtIndex:0];
    XCTAssert([book.title compare:@"title2"] == NSOrderedSame);

    XCTAssert([dao remove:book.bookId]);
}

/**
 * Clean the database file.
 */
- (void)clean {
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:self.dbFilePath]) {
        NSError *error = nil;
        [manager removeItemAtPath:self.dbFilePath error:&error];
        if (error) {
            NSLog(@"%@", error.description);
        }
    }
}

/**
 * Get the path of database file.
 *
 * @return file path.
 */
- (NSString *)databaseFilePath {
    NSArray*  paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString* dir   = [paths objectAtIndex:0];
    return [dir stringByAppendingPathComponent:@"test.db"];
}

@end

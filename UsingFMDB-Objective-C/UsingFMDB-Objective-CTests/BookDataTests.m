//
//  BookDataTests.m
//  UsingFMDB-Objective-C
//
//  Created by akabeko on 2016/12/26.
//  Copyright © 2016年 akabeko. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Book.h"
#import "BookData.h"

/**
 * Test the book data.
 */
@interface BookDataTests : XCTestCase

@end

@implementation BookDataTests

/**
 * Setup the test instance.
 */
- (void)setUp {
    [super setUp];
}

/**
 * Tear down the test instance.
 */
- (void)tearDown {
    [super tearDown];
}

/**
 * Test the additional data processing.
 */
- (void)testAdd {
    BookData *data = [[BookData alloc] init];
    Book     *book = [Book bookWithId:kBookIdNone author:@"" title:@"" releaseDate:[NSDate date]];
    XCTAssert(!([data add:book]));
    XCTAssert([data.authors count] == 0);

    book = [Book bookWithId:1 author:@"author" title:@"title" releaseDate:[NSDate date]];
    XCTAssert([data add:book]);
    XCTAssert([data.authors count] == 1);

    NSArray *books = [data.booksByAuthor objectForKey:@"author"];
    XCTAssert([books count] == 1);

    book = [books objectAtIndex:0];
    XCTAssert([book.title compare:@"title"] == NSOrderedSame);
}

/**
 * Test the remove data processing.
 */
- (void)testRemove {
    BookData *data = [[BookData alloc] init];
    Book     *book = [Book bookWithId:1 author:@"author" title:@"title" releaseDate:[NSDate date]];
    XCTAssert([data add:book]);
    XCTAssert([data.authors count] == 1);
    XCTAssert([data remove:book]);
    XCTAssert([data.authors count] == 0);

    NSArray *books = [data.booksByAuthor objectForKey:@"author"];
    XCTAssertNil(books);
}

/**
 * Test the update data with title processing.
 */
- (void)testUpdateTitle {
    BookData *data = [[BookData alloc] init];
    Book     *book1 = [Book bookWithId:1 author:@"author" title:@"title" releaseDate:[NSDate date]];
    XCTAssert([data add:book1]);
    XCTAssert([data.authors count] == 1);

    Book     *book2 = [Book bookWithId:1 author:@"author" title:@"title2" releaseDate:[NSDate date]];
    XCTAssert([data update:book1 newBook:book2]);
    XCTAssert([data.authors count] == 1);

    NSArray *books = [data.booksByAuthor objectForKey:@"author"];
    XCTAssert([books count] == 1);

    book2 = [books objectAtIndex:0];
    XCTAssert([book2.title compare:@"title2"] == NSOrderedSame);
}

/**
 * Test the update data with author and title processing.
 */
- (void)testUpdateAuthorAndTitle {
    BookData *data = [[BookData alloc] init];
    Book     *book1 = [Book bookWithId:1 author:@"author" title:@"title" releaseDate:[NSDate date]];
    XCTAssert([data add:book1]);
    XCTAssert([data.authors count] == 1);

    Book     *book2 = [Book bookWithId:1 author:@"author2" title:@"title2" releaseDate:[NSDate date]];
    XCTAssert([data update:book1 newBook:book2]);
    XCTAssert([data.authors count] == 1);

    NSArray *books = [data.booksByAuthor objectForKey:@"author"];
    XCTAssertNil(books);

    books = [data.booksByAuthor objectForKey:@"author2"];
    XCTAssert([books count] == 1);

    book2 = [books objectAtIndex:0];
    XCTAssert([book2.author compare:@"author2"] == NSOrderedSame);
    XCTAssert([book2.title compare:@"title2"] == NSOrderedSame);
}

@end

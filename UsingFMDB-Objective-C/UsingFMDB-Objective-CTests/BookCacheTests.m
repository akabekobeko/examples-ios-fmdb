//
//  BookCacheTests.m
//  UsingFMDB-Objective-C
//
//  Created by akabeko on 2016/12/26.
//  Copyright © 2016年 akabeko. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Book.h"
#import "BookCache.h"

/**
 * Test the book data.
 */
@interface BookCacheTests : XCTestCase

@end

@implementation BookCacheTests

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
    BookCache *cache = [[BookCache alloc] init];
    Book      *book  = [Book bookWithId:kBookIdNone author:@"" title:@"" releaseDate:[NSDate date]];
    XCTAssert(!([cache add:book]));
    XCTAssertEqual([cache.authors count], 0);

    book = [Book bookWithId:1 author:@"author" title:@"title" releaseDate:[NSDate date]];
    XCTAssert([cache add:book]);
    XCTAssertEqual(cache.authors.count, 1);

    NSArray *books = [cache.booksByAuthor objectForKey:@"author"];
    XCTAssertEqual(books.count, 1);

    book = [books objectAtIndex:0];
    XCTAssertEqualObjects(book.title, @"title");
}

/**
 * Test the remove data processing.
 */
- (void)testRemove {
    BookCache *cache = [[BookCache alloc] init];
    Book      *book  = [Book bookWithId:1 author:@"author" title:@"title" releaseDate:[NSDate date]];
    XCTAssert([cache add:book]);
    XCTAssertEqual(cache.authors.count, 1);
    XCTAssert([cache remove:book]);
    XCTAssertEqual(cache.authors.count, 0);

    NSArray *books = [cache.booksByAuthor objectForKey:@"author"];
    XCTAssertNil(books);
}

/**
 * Test the update data with title processing.
 */
- (void)testUpdateTitle {
    BookCache *cache = [[BookCache alloc] init];
    Book      *book1 = [Book bookWithId:1 author:@"author" title:@"title" releaseDate:[NSDate date]];
    XCTAssert([cache add:book1]);
    XCTAssertEqual([cache.authors count], 1);

    Book     *book2 = [Book bookWithId:1 author:@"author" title:@"title2" releaseDate:[NSDate date]];
    XCTAssert([cache update:book1 newBook:book2]);
    XCTAssertEqual(cache.authors.count, 1);

    NSArray *books = [cache.booksByAuthor objectForKey:@"author"];
    XCTAssertEqual(books.count, 1);

    book2 = [books objectAtIndex:0];
    XCTAssertEqualObjects(book2.title, @"title2");
}

/**
 * Test the update data with author and title processing.
 */
- (void)testUpdateAuthorAndTitle {
    BookCache *cache = [[BookCache alloc] init];
    Book      *book1 = [Book bookWithId:1 author:@"author" title:@"title" releaseDate:[NSDate date]];
    XCTAssert([cache add:book1]);
    XCTAssertEqual(cache.authors.count, 1);

    Book     *book2 = [Book bookWithId:1 author:@"author2" title:@"title2" releaseDate:[NSDate date]];
    XCTAssert([cache update:book1 newBook:book2]);
    XCTAssertEqual(cache.authors.count, 1);

    NSArray *books = [cache.booksByAuthor objectForKey:@"author"];
    XCTAssertNil(books);

    books = [cache.booksByAuthor objectForKey:@"author2"];
    XCTAssertEqual(books.count, 1);

    book2 = [books objectAtIndex:0];
    XCTAssertEqualObjects(book2.author, @"author2");
    XCTAssertEqualObjects(book2.title, @"title2");
}

@end

//
//  BookDAO.m
//  UsingFMDB-Objective-C
//
//  Created by akabeko on 2016/12/03.
//  Copyright © 2016年 akabeko. All rights reserved.
//

#import "BookDAO.h"
#import "Book.h"
#import <FMDB/FMDatabase.h>
#import <FMDB/FMResultSet.h>

@implementation BookDAO

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
    return nil;
}

/**
 * Read a books.
 *
 * @return Readed books.
 */
- (NSArray *)read {
    return nil;
}

/**
 * Remove a book.
 *
 * @param bookId The identifier of the book to remove.
 */
- (void)remove:(NSInteger)bookId {
}

/**
 * Update a book.
 *
 * @param book The data of the book to update.
 */
- (void)update:(Book *)book {
}

@end

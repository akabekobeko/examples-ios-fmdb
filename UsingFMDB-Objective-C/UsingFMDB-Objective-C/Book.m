//
//  Book.m
//  UsingFMDB-Objective-C
//
//  Created by akabeko on 2016/12/03.
//  Copyright © 2016年 akabeko. All rights reserved.
//

#import "Book.h"

NSInteger const kBookIdNone = 0;

@interface Book ()

@property (nonatomic, readwrite) NSInteger bookId;
@property (nonatomic, readwrite) NSString *author;
@property (nonatomic, readwrite) NSString *title;
@property (nonatomic, readwrite) NSDate *releaseDate;

@end

@implementation Book

/**
 * Create a book instance.
 *
 * @param bookId      Identifier.
 * @param author      Author.
 * @param title       Title.
 * @param releaseDate Release date.
 *
 * @return Instance.
 */
+ (instancetype)bookWithId:(NSInteger)bookId author:(NSString *)author title:(NSString *)title releaseDate:(NSDate *)releaseDate {
    return [[Book alloc] init:bookId author:author title:title releaseDate:releaseDate];
}

#pragma mark - Private

/**
 * Initialize this instance.
 *
 * @param bookId      Identifier.
 * @param author      Author.
 * @param title       Title.
 * @param releaseDate Release date.
 *
 * @return Initialized instance.
 */
- (instancetype)init:(NSInteger)bookId author:(NSString *)author title:(NSString *)title releaseDate:(NSDate *)releaseDate {
    self = [super init];
    if (self) {
        self.bookId      = bookId;
        self.title       = title;
        self.author      = author;
        self.releaseDate = releaseDate;
    }

    return self;
}

@end

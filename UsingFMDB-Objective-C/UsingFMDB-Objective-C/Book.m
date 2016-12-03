//
//  Book.m
//  UsingFMDB-Objective-C
//
//  Created by akabeko on 2016/12/03.
//  Copyright © 2016年 akabeko. All rights reserved.
//

#import "Book.h"

@interface Book ()

@property (nonatomic, readwrite) NSInteger bookId;
@property (nonatomic, readwrite) NSString *title;
@property (nonatomic, readwrite) NSString *author;
@property (nonatomic, readwrite) NSDate *releaseDate;

@end

@implementation Book

/**
 * Initialize this instance.
 *
 * @param bookId      Identifier.
 * @param title       Title.
 * @param author      Author.
 * @param releaseDate Release date.
 *
 * @return Initialized instance.
 */
- (instancetype)init:(NSInteger)bookId title:(NSString *)title author:(NSString *)author releaseDate:(NSDate *)releaseDate {
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

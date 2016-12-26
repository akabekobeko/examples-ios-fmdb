//
//  Book.h
//  UsingFMDB-Objective-C
//
//  Created by akabeko on 2016/12/03.
//  Copyright © 2016年 akabeko. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Invalid book identifier. */
extern NSInteger const kBookIdNone;

/**
 * Represents a book.
 */
@interface Book : NSObject

/** Identifier. */
@property (nonatomic, readonly) NSInteger bookId;

/** Author. */
@property (nonatomic, readonly) NSString *author;

/** Title. */
@property (nonatomic, readonly) NSString *title;


/** Release date. */
@property (nonatomic, readonly) NSDate *releaseDate;

+ (instancetype)bookWithId:(NSInteger)bookId author:(NSString *)author title:(NSString *)title releaseDate:(NSDate *)releaseDate;

@end

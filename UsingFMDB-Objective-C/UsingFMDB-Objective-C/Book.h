//
//  Book.h
//  UsingFMDB-Objective-C
//
//  Created by akabeko on 2016/12/03.
//  Copyright © 2016年 akabeko. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Represents a book.
 */
@interface Book : NSObject

/** Identifier. */
@property (nonatomic, readonly) NSInteger bookId;

/** Title. */
@property (nonatomic, readonly) NSString *title;

/** Author. */
@property (nonatomic, readonly) NSString *author;

/** Release date. */
@property (nonatomic, readonly) NSDate *releaseDate;

- (instancetype)init:(NSInteger)bookId title:(NSString *)title author:(NSString *)author releaseDate:(NSDate *)releaseDate;

@end

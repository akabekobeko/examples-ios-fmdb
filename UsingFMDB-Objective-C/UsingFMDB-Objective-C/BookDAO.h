//
//  BookDAO.h
//  UsingFMDB-Objective-C
//
//  Created by akabeko on 2016/12/03.
//  Copyright © 2016年 akabeko. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Book;

/**
 * Manage books.
 */
@interface BookDAO : NSObject

- (Book *)add:(NSString *)title author:(NSString *)author releaseDate:(NSDate *)releaseDate;
- (NSArray *)read;
- (void)remove:(NSInteger)bookId;
- (void)update:(Book *)book;

@end

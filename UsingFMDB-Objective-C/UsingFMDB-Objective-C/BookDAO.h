//
//  BookDAO.h
//  UsingFMDB-Objective-C
//
//  Created by akabeko on 2016/12/03.
//  Copyright © 2016年 akabeko. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AppDAO, Book;

/**
 * Manager for the books data.
 */
@interface BookDAO : NSObject

- (instancetype)init:(AppDAO *)appDAO;
- (Book *)add:(NSString *)author title:(NSString *)title releaseDate:(NSDate *)releaseDate;
- (NSArray *)read;
- (BOOL)remove:(NSInteger)bookId;
- (BOOL)update:(Book *)book;

@end

//
//  BookStore.h
//  UsingFMDB-Objective-C
//
//  Created by akabeko on 2016/12/26.
//  Copyright © 2016年 akabeko. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DAOFactory, Book;

/**
 * Manage for the books.
 */
@interface BookStore : NSObject

/** Collection of author names. */
@property (nonatomic, readonly) NSArray *authors;

/** Dictionary of book collection classified by author name. */
@property (nonatomic, readonly) NSDictionary *booksByAuthor;

- (instancetype)init:(DAOFactory *)daoFactory;
- (BOOL)add:(Book *)book;
- (BOOL)remove:(Book *)book;
- (BOOL)update:(Book *)oldBook newBook:(Book *)newBook;

@end

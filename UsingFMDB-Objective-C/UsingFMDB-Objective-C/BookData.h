//
//  BookData.h
//  UsingFMDB-Objective-C
//
//  Created by akabeko on 2016/12/26.
//  Copyright © 2016年 akabeko. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Book;

/**
 * Manager fot the book data.
 */
@interface BookData : NSObject

/** Collection of author names. */
@property (nonatomic, readonly) NSMutableArray *authors;

/** Dictionary of book collection classified by author name. */
@property (nonatomic, readonly) NSMutableDictionary *booksByAuthor;

- (instancetype)initWithBooks:(NSArray *)books;
- (BOOL)add:(Book *)book;
- (BOOL)remove:(Book *)book;
- (BOOL)update:(Book *)oldBook newBook:(Book *)newBook;

@end

//
//  BookStore.m
//  UsingFMDB-Objective-C
//
//  Created by akabeko on 2016/12/26.
//  Copyright © 2016年 akabeko. All rights reserved.
//

#import "BookStore.h"
#import "DAOFactory.h"
#import "Book.h"
#import "BookCache.h"
#import "BookDAO.h"

@interface BookStore ()

/** Factory of a data access objects. */
@property (nonatomic) DAOFactory *daoFactory;

/** Manager for the book data. */
@property (nonatomic) BookCache *bookCache;

@end

@implementation BookStore

/**
 * Initialize the instance.
 *
 * @param daoFactory Factory of a data access objects.
 *
 * @return Instance.
 */
- (instancetype)init:(DAOFactory *)daoFactory {
    self = [super init];
    if (self && daoFactory) {
        self.daoFactory = daoFactory;

        BookDAO *dao = [self.daoFactory bookDAO];
        [dao create];
        self.bookCache = [[BookCache alloc] initWithBooks:[dao read]];
    }

    return self;
}

/**
 * A collection of author names.
 *
 * @return Names.
 */
- (NSArray *)authors {
    return self.bookCache.authors;
}

/**
 * Dictionary of book collection classified by author name.
 *
 * @reutrn Dictionary.
 */
- (NSDictionary *)booksByAuthor {
    return self.bookCache.booksByAuthor;
}

/**
 * Add the new book.
 *
 * @param book Book data.
 *
 * @return YES if successful.
 */
- (BOOL)add:(Book *)book {
    BookDAO *dao     = [self.daoFactory bookDAO];
    Book    *newBook = [dao add:book.author title:book.title releaseDate:book.releaseDate];
    if (newBook) {
        return [self.bookCache add:newBook];
    }

    return NO;
}

/**
 * Remove the new book.
 *
 * @param book Book data.
 *
 * @return YES if successful.
 */
- (BOOL)remove:(Book *)book {
    BookDAO *dao = [self.daoFactory bookDAO];
    if ([dao remove:book.bookId]) {
        return [self.bookCache remove:book];
    }

    return NO;
}

/**
 * Update the new book.
 *
 * @param oldBook Old book data.
 * @param newBook New book data.
 *
 * @return YES if successful.
 */
- (BOOL)update:(Book *)oldBook newBook:(Book *)newBook {
    BookDAO *dao = [self.daoFactory bookDAO];
    if ([dao update:newBook]) {
        return [self.bookCache update:oldBook newBook:newBook];
    }

    return NO;
}

@end

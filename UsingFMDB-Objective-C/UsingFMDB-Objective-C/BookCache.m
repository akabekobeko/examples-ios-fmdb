//
//  BookCache.m
//  UsingFMDB-Objective-C
//
//  Created by akabeko on 2016/12/26.
//  Copyright © 2016年 akabeko. All rights reserved.
//

#import "BookCache.h"
#import "Book.h"

@interface BookCache ()

/** Collection of author names. */
@property (nonatomic, readwrite) NSMutableArray *authors;

/** Dictionary of book collection classified by author name. */
@property (nonatomic, readwrite) NSMutableDictionary *booksByAuthor;

@end

@implementation BookCache

/**
 * Initialize the instance.
 *
 * @return Instance.
 */
- (instancetype)init {
    self = [super init];
    if (self) {
        self.authors       = [NSMutableArray array];
        self.booksByAuthor = [NSMutableDictionary dictionary];
    }

    return self;
}

/**
 * Initialize the instance.
 *
 * @param books Collection of the book data.
 *
 * @return Instance.
 */
- (instancetype)initWithBooks:(NSArray *)books {
    self = [self init];
    if (self) {
        for (NSInteger i = 0, max = [books count]; i < max; ++i) {
            [self add:[books objectAtIndex:i]];
        }
    }

    return self;
}

/**
 * Add the new book.
 *
 * @param book Book data.
 *
 * @return YES if successful.
 */
- (BOOL)add:(Book *)book {
    if (book.bookId == kBookIdNone) {
        return NO;
    }

    NSMutableArray *books = [self.booksByAuthor objectForKey:book.author];
    if (books) {
        [books addObject:book];
    } else {
        books = [NSMutableArray array];
        [books addObject:book];
        [self.booksByAuthor setObject:books forKey:book.author];
        [self.authors addObject:book.author];
    }

    return YES;
}

/**
 * Remove the new book.
 *
 * @param book Book data.
 *
 * @return YES if successful.
 */
- (BOOL)remove:(Book *)book {
    NSMutableArray *books = [self.booksByAuthor objectForKey:book.author];
    if (!(books)) {
        return NO;
    }

    BOOL succeeded = NO;
    for (NSInteger i = 0, max = [books count]; i < max; ++i) {
        Book *existBook = [books objectAtIndex:i];
        if (existBook.bookId == book.bookId) {
            [books removeObjectAtIndex:i];
            succeeded = YES;
            break;
        }
    }

    if (succeeded && [books count] == 0) {
        succeeded = [self removeAuthor:book.author];
    }

    return succeeded;
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
    if ([oldBook.author compare:newBook.author] == NSOrderedSame) {
        return [self replaceBook:newBook];
    } else if ([self remove:oldBook]) {
        return [self add:newBook];
    }

    return NO;
}

#pragma mark - Private

/**
 * Remove the author at the inner collection.
 *
 * @param author Name of the author.
 *
 * @return YES if successful.
 */
- (BOOL)removeAuthor:(NSString *)author {
    [self.booksByAuthor removeObjectForKey:author];
    for (NSInteger i = 0, max = [self.authors count]; i < max; ++i) {
        NSString *existAuthor = [self.authors objectAtIndex:i];
        if ([existAuthor compare:author] == NSOrderedSame) {
            [self.authors removeObjectAtIndex:i];
            return YES;
        }
    }

    return NO;
}

/**
 * Replace the book.
 *
 * @param book Book data.
 *
 * @return YES if successful.
 */
- (BOOL)replaceBook:(Book *)book {
    NSMutableArray *books = [self.booksByAuthor objectForKey:book.author];
    if (!(books)) {
        return NO;
    }

    for (NSInteger i = 0, max = [books count]; i < max; ++i) {
        Book *existBook = [books objectAtIndex:i];
        if (existBook.bookId == book.bookId) {
            [books replaceObjectAtIndex:i withObject:book];
            return YES;
        }
    }

    return NO;
}

@end

//
//  DAOFactory.m
//  UsingFMDB-Objective-C
//
//  Created by akabeko on 2016/12/26.
//  Copyright © 2016年 akabeko. All rights reserved.
//

#import "DAOFactory.h"
#import "BookDAO.h"
#import <FMDatabase.h>

/** File name of the SQLite database. */
static NSString * const kDBFileName = @"app.db";

@interface DAOFactory ()

/** Path of the SQLite database file. */
@property (nonatomic) NSString *dbFilePath;

@end

@implementation DAOFactory

/**
 * Initialize the instance.
 *
 * @return Instance.
 */
- (instancetype)init {
    self = [super init];
    if (self) {
        self.dbFilePath = [self databaseFilePath];

        // For debug
        NSLog(@"%@", self.dbFilePath);
    }

    return  self;
}

/**
 * Initialize the instance.
 *
 * @param path Path of the database file.
 *
 * @return Instance.
 */
- (instancetype)initWithDBFilePath:(NSString *)path {
    self = [super init];
    if (self) {
        self.dbFilePath = path;

        // For debug
        NSLog(@"%@", self.dbFilePath);
    }

    return self;
}

/**
 * Create the data access object of the books.
 *
 * @return Instance of the data access object.
 */
- (BookDAO *)bookDAO {
    return [[BookDAO alloc] init:[self connection]];
}

#pragma mark - Private

/**
 * Get the database connection.
 *
 * @return Connection.
 */
- (FMDatabase *)connection {
    FMDatabase* db = [FMDatabase databaseWithPath:self.dbFilePath];
    return ([db open] ? db : nil);
}

/**
 * Get the path of database file.
 *
 * @return file path.
 */
- (NSString *)databaseFilePath {
    NSArray*  paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString* dir   = [paths objectAtIndex:0];
    
    return [dir stringByAppendingPathComponent:kDBFileName];
}

@end

//
//  AppDAO.m
//  UsingFMDB-Objective-C
//
//  Created by akabeko on 2016/12/12.
//  Copyright © 2016年 akabeko. All rights reserved.
//

#import "AppDAO.h"
#import <FMDatabase.h>

/** File name of the SQLite database. */
static NSString * const kDBFileName = @"app.db";

@interface AppDAO ()

/** Path of the SQLite database file. */
@property (nonatomic) NSString *dbFilePath;

@end

@implementation AppDAO

/**
 * Initialize the instance.
 *
 * @return Instance.
 */
- (instancetype)init {
    self = [super init];
    if (self) {
        self.dbFilePath = [self databaseFilePath];
        NSLog(@"DB = %@", self.dbFilePath);
    }

    return self;
}

/**
 * Get the database connection.
 *
 * @return Connection.
 */
- (FMDatabase *)connection {
    FMDatabase* db = [FMDatabase databaseWithPath:self.dbFilePath];
    return ([db open] ? db : nil);
}

#pragma mark - Private

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

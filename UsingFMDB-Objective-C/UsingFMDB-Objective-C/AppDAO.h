//
//  AppDAO.h
//  UsingFMDB-Objective-C
//
//  Created by akabeko on 2016/12/12.
//  Copyright © 2016年 akabeko. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabase, BookDAO;

/**
 *  Manager for the application database.
 */
@interface AppDAO : NSObject

/**  Manage for the books data. */
@property (nonatomic, readonly) BookDAO *bookDAO;

- (FMDatabase *)connection;

@end

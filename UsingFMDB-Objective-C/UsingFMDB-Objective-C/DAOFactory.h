//
//  DAOFactory.h
//  UsingFMDB-Objective-C
//
//  Created by akabeko on 2016/12/26.
//  Copyright © 2016年 akabeko. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BookDAO;

/**
 * Factory of a data access objects.
 */
@interface DAOFactory : NSObject

- (instancetype)initWithDBFilePath:(NSString *)path;
- (BookDAO *)bookDAO;

@end

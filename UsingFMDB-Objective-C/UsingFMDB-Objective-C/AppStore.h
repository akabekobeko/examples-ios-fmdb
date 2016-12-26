//
//  AppStore.h
//  UsingFMDB-Objective-C
//
//  Created by akabeko on 2016/12/12.
//  Copyright © 2016年 akabeko. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BookStore;

/**
 *  Manager for the application database.
 */
@interface AppStore : NSObject

/** Manage for the books. */
@property (nonatomic, readonly) BookStore *bookStore;

@end

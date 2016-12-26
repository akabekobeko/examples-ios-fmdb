//
//  AppStore.m
//  UsingFMDB-Objective-C
//
//  Created by akabeko on 2016/12/12.
//  Copyright © 2016年 akabeko. All rights reserved.
//

#import "AppStore.h"
#import "BookStore.h"
#import "DAOFactory.h"

@interface AppStore ()

// Override for the public properties
@property (nonatomic, readwrite) BookStore *bookStore;

/** Factory of a data access objects. */
@property (nonatomic) DAOFactory *daoFactory;

@end

@implementation AppStore

/**
 * Initialize the instance.
 *
 * @return Instance.
 */
- (instancetype)init {
    self = [super init];
    if (self) {
        self.daoFactory = [[DAOFactory alloc] init];
        self.bookStore = [[BookStore alloc] init:self.daoFactory];
    }

    return self;
}

@end

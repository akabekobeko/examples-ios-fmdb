//
//  AppDelegate.h
//  UsingFMDB-Objective-C
//
//  Created by akabeko on 2016/11/21.
//  Copyright © 2016年 akabeko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDAO;

/**
 * Manager for the application.
 */
@interface AppDelegate : UIResponder <UIApplicationDelegate>

/** Main window. */
@property (strong, nonatomic) UIWindow *window;

/** Manager for the application database. */
@property (nonatomic, readonly) AppDAO *appDAO;

@end


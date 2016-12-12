//
//  AppDelegate.m
//  UsingFMDB-Objective-C
//
//  Created by akabeko on 2016/11/21.
//  Copyright © 2016年 akabeko. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDAO.h"

@interface AppDelegate ()

@property (nonatomic, readwrite) AppDAO *appDAO;

@end

@implementation AppDelegate

/**
 * Tells the delegate that the launch process is almost done and the app is almost ready to run.
 *
 * @param application   Your singleton app object.
 * @param launchOptions A dictionary indicating the reason the app was launched (if any). The contents of this dictionary may be empty in situations where the user launched the app directly. For information about the possible keys in this dictionary and how to handle them, see Launch Options Keys.
 *
 * @return NO if the app cannot handle the URL resource or continue a user activity, otherwise return YES. The return value is ignored if the app is launched as a result of a remote notification.
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.appDAO = [[AppDAO alloc] init];

    return YES;
}

@end

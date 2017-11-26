//
//  AppDelegate.h
//  Snipchat
//
//  Created by Ari Fiorino on 10/8/17.
//  Copyright © 2017 Azul Engineering. All rights reserved.
//

#import <UserNotifications/UserNotifications.h>
#import <UIKit/UIKit.h>
#import "Snip.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>

@property NSString *sessionId, *username;
@property NSMutableArray<Snip*>* snips;
@property NSURLSession *urlSession;

@property (strong, nonatomic) UIWindow *window;

@end


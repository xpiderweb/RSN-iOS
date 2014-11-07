//
//  DLAppDelegate.m
//  RSN
//
//  Created by jossiecs on 12/4/13.
//  Copyright (c) 2013 DreamLabs. All rights reserved.
//

#import "DLAppDelegate.h"
#import "DLRSNModel.h"
#import <AudioToolbox/AudioToolbox.h>
@implementation DLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    NSInteger badgeCount = [UIApplication sharedApplication].applicationIconBadgeNumber;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeCount];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults valueForKey:@"magnitud"] == nil) {
        [defaults setValue:@"3" forKey:@"magnitud"];
        [defaults synchronize];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    long badgeCount = [UIApplication sharedApplication].applicationIconBadgeNumber;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeCount];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken");
    NSString *tt = [NSString stringWithFormat:@"%@",deviceToken];
    NSString *devToken = [[tt substringWithRange:NSMakeRange(1, [tt length]-2)]stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@" device  token on  defaults %@",[defaults valueForKey:@"deviceToken"]);
    NSLog(@" devtoken %@",devToken);
    NSLog(@" idToken %@",[defaults valueForKey:@"idToken"]);
    if (![[defaults valueForKey:@"deviceToken"] isEqualToString:devToken]) {
        [defaults setValue:devToken forKey:@"deviceToken"];
        [defaults synchronize];
        if ([defaults valueForKey:@"idToken"] == nil) {
            [[DLRSNModel sharedInstance]setDelegate:self];
            [[DLRSNModel sharedInstance]saveTokenAPNSWithToken:devToken andMagnitud:[defaults valueForKey:@"magnitud"]];
        }else{
            [[DLRSNModel sharedInstance]setDelegate:self];
            NSString *idToken = [defaults valueForKey:@"idToken"];
            [[DLRSNModel sharedInstance]updateTokenAPNSWithToken:devToken andId:idToken];
        }
    }
}


-(void)getLastSismosFromModel{
    [[DLRSNModel sharedInstance]setDelegate:self];
    [[DLRSNModel sharedInstance]getLastSismos];
    
}


#pragma DLRSNModelProtocol Method
-(void)didSaveAPNSTokenWithResult:(NSString*)result{
    NSLog(@"didSaveAPNSTokenWithResult %@",result);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:result forKey:@"idToken"];
    [defaults synchronize];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	//NSLog(@"Received Notification (Active): %@", userInfo);
	/*NSString *message = [NSString stringWithFormat:@"%@", userInfo];
     NSRange rng = [message rangeOfString:@"alert = \""];
     if (rng.length>0)
     {
     message = [message substringFromIndex:rng.location + rng.length];
     }
     rng = [message rangeOfString:@"\""];
     if (rng.length > 0)
     {
     message = [message substringToIndex:rng.location];
     }*/
    
    // Show alert for push notifications recevied while the
    // app is running
    NSString *message = [[userInfo objectForKey:@"aps"]
                         objectForKey:@"alert"];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@""
                          message:message
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];

    //	[self Alert:message :@""];
}


@end

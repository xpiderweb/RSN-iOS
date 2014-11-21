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
#import "TestFlight.h"
#import <AFNetworking/AFNetworking.h>


@implementation DLAppDelegate

NSString *idToken;
int appBadge;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self registerForRemoteNotification];    //[application.registerForRemoteNotifications];
    [[launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey] description];
    NSInteger badgeCount = [UIApplication sharedApplication].applicationIconBadgeNumber;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeCount];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:@"3" forKey:@"magnitud"];
        [defaults synchronize];
    // start of your application:didFinishLaunchingWithOptions // ...
    [TestFlight takeOff:@"dd7686f1-d281-4ab8-987f-c03827b3a333"];
    // The rest of your apdd7686f1-d281-4ab8-987f-c03827b3a333plication:didFinishLaunchingWithOptions method// ...
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
- (void)registerForRemoteNotification {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO( _iOS_8_0) ) {
        NSLog(@"I shoul be in ios 8");
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];

        
    }else{
        NSLog(@"is this working cause this is io7");
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }

    /*
        UIUserNotificationType types = UIUserNotificationTypeSound | UIUserNotificationTypeBadge | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
     */
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}
#endif
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"Did Register for Remote Notifications with Device Token (%@)", token);
    NSString *os_version = [[UIDevice currentDevice] systemVersion];
    NSString *iosVersion = [NSString stringWithFormat:@"iOS %@", os_version];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"token": token , @"minMagnitude" : @"3", @"notificationActive" : @"true", @"os" : iosVersion};
    [manager PUT:@"http://rsnapi.herokuapp.com/api/devices/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // Storing an NSString:
    NSString *userToken = token;
    [prefs setObject:userToken forKey:@"token"];
    [prefs synchronize];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Did Fail to Register for Remote Notifications");
    NSLog(@"%@, %@", error, error.localizedDescription);
    
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
//Your app receives push notification.
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"got a push");
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground){
        application.applicationIconBadgeNumber = 1;
        [self pushLocalNotificationWithString:[NSString stringWithFormat:@"RSN Reporta:\n%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]]];
    }else{
        //You need to customize your alert by yourself for this situation. For ex,
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Nuevo Sismo" message:[NSString stringWithFormat:@"RSN Reporta:\n%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]]delegate:nil cancelButtonTitle:@"GRACIAS" otherButtonTitles:nil];
        [alertView show];

    }
}

-(void) pushLocalNotificationWithString:(NSString*)message{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = message;
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

@end

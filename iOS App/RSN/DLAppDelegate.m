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
#import <AFNetworking/AFNetworking.h>
#import <Parse/Parse.h>
#import <GoogleMaps/GoogleMaps.h>

@implementation DLAppDelegate

NSString *idToken;
int appBadge;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //Parse
    [Parse setApplicationId:@"tCc4Jupa4EfbvNSg4uZZBDoj7UaNk7zRTOvAJyDS"
                  clientKey:@"nXdiI7oWmEGxJTChhyTVeLdGKs2y4pOUUmC5Tg1R"];
    // Register for Push Notitications
    [self registerForRemoteNotification];
    [[launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey] description];
    NSInteger badgeCount = [UIApplication sharedApplication].applicationIconBadgeNumber;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeCount];
    [GMSServices provideAPIKey:@"AIzaSyAkTNtr-qH3QAHzP5ul8YqKHC3helYxhPk"];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.;
    application.applicationIconBadgeNumber = 0;
}

- (void)registerForRemoteNotification {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        //ios8 ++
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
        {
            UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
        }
    }
    else
    {
        // ios7
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotificationTypes:)])
        {
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
        }
    }
}

#ifdef __IPHONE_8_0
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings // available in iOS8
{
    [application registerForRemoteNotifications];
}
#endif

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


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSNumber* sendMeNotifications = @YES;
    NSNumber *parse = @YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"547406e0fa85847666283b61" forHTTPHeaderField:@"Api-key"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:token forKey:@"token"];
    [parameters setValue:@"3" forKey:@"minMagnitude"];
    [parameters setValue: sendMeNotifications forKey:@"notificationActive"];
    [parameters setValue:@"iOS" forKey:@"os"];
    [parameters setValue:parse forKey:@"parseActive"];
    [parameters setValue:parse forKey:@"parse"];
    NSLog(@"%@", parameters);
    [manager POST:@"http://rsnapiusr.ucr.ac.cr/api/devices/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // Storing an NSString:
    NSString *userToken = token;
    [prefs setObject:userToken forKey:@"token"];
    NSString *magButton = @"3";
    [prefs setObject:magButton forKey:@"magButton"];
    [prefs synchronize];
    NSString *userNotification = [prefs stringForKey:@"userNotifications"];
    if (userNotification == nil) {
        NSString *userNotifications = @"true";
        [prefs setObject:userNotifications forKey:@"userNotifications"];
        [prefs synchronize];
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
//Your app receives push notification.
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%@, %@", error, error.localizedDescription);
    
}

//Your app receives push notification.
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
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

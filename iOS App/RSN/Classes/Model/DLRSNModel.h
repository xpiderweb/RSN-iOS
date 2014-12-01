//
//  DLRSNModel.h
//  RSN
//
//  Created by jossiecs on 1/14/14.
//  Copyright (c) 2014 DreamLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DLRSNModelProtocol <NSObject>

-(void)didSaveAPNSTokenWithResult:(NSString*)result;

@end

@interface DLRSNModel : NSObject

+(DLRSNModel *) sharedInstance;

// clue for improper use (produces compile time error)
+(DLRSNModel *) alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
-(DLRSNModel *) init __attribute__((unavailable("init not available, call sharedInstance instead")));
+(DLRSNModel *) new __attribute__((unavailable("new not available, call sharedInstance instead")));

@property (nonatomic,assign) id<DLRSNModelProtocol> delegate;

//NSString used to send the notification through the NSNotificationCenter
extern NSString * const DLModelDidReceiveLastSismos;
extern NSString * const DLModelDidReceiveLastSismosForTableView;
extern NSString * const DLModelDidReceiveLastNoticias;
extern NSString * const DLModelDidReceiveLast10Sismos;


-(void)getLastSismos;
-(void)getLastSismosByWeek;
-(void)getLastNoticias;
-(void)getLast10Sismos;
-(void)getSismosForTableViewWithDate:(NSString*)dateString;
-(void)updateTokenAPNSWithToken:(NSString*)tokenAPNS andId:(NSString*)idToken;
-(void)updateMagnitudAPNSWithMagnitud:(NSString*)magnitud andId:(NSString*)idToken;
@end

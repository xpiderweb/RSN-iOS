//
//  DLAppDelegate.h
//  RSN
//
//  Created by jossiecs on 12/4/13.
//  Copyright (c) 2013 DreamLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLRSNModel.h"
@interface DLAppDelegate : UIResponder <UIApplicationDelegate,DLRSNModelProtocol>

@property (strong, nonatomic) UIWindow *window;

-(void)getLastSismosFromModel;

@end

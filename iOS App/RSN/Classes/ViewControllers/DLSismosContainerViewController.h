//
//  DLSismosContainerViewController.h
//  RSN
//
//  Created by jossiecs on 4/3/14.
//  Copyright (c) 2014 DreamLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLMainViewController.h"

@interface DLSismosContainerViewController : UIViewController

- (void) disableMapView:(BOOL)enable;
@property (nonatomic,strong) DLMainViewController *mainView;
@end

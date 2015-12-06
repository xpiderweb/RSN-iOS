//
//  DLSismosViewController.h
//  RSN
//
//  Created by jossiecs on 12/20/13.
//  Copyright (c) 2013 DreamLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLSismosLegendViewController.h"
#import "DLRSNModel.h"
#import "DLMainViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface DLSismosViewController : UIViewController<DLSismosLegendViewControllerDelegate>
@property (nonatomic, retain) id <UIPageViewControllerDelegate> viewControllerDelegate;
@property (weak, nonatomic) IBOutlet GMSMapView *googleMapView;
@property (nonatomic,strong) DLMainViewController *mainView;
@property (strong, nonatomic) IBOutlet UIButton *menuButton;
@property (nonatomic, strong) UIButton *leftButton;
@property (strong, nonatomic) NSMutableArray *annotationsArray;
@property (assign, nonatomic) BOOL noSismoAlertShown;
-(void) RefreshMap;
@end

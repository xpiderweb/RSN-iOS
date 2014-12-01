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
#import <MapKit/MapKit.h>
#import "DLMainViewController.h"

@protocol DLCenterViewControllerDelegate <NSObject>

@optional
- (void)movePanelLeft;
- (void)movePanelRight;
-(void)buttonGesture;

@required
- (void)movePanelToOriginalPosition;


@end

@interface DLSismosViewController : UIViewController<DLSismosLegendViewControllerDelegate,MKMapViewDelegate>
@property (nonatomic, retain) id <DLCenterViewControllerDelegate> viewControllerDelegate;
@property (nonatomic,weak) IBOutlet MKMapView *mapView;
@property (nonatomic,strong) DLMainViewController *mainView;
@property (strong, nonatomic) IBOutlet UIButton *menuButton;
@property (nonatomic, strong) UIButton *leftButton;
-(void) RefreshMap;
@end

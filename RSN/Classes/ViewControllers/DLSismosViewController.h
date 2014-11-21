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

@protocol DLCenterViewControllerDelegate
 -(void) showMenuButtonPls;
@end

@interface DLSismosViewController : UIViewController<DLSismosLegendViewControllerDelegate,MKMapViewDelegate>
@property (nonatomic, retain) id <DLCenterViewControllerDelegate> viewControllerDelegate;
@property (nonatomic,weak) IBOutlet MKMapView *mapView;
@end

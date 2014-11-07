//
//  DLSismosLegendViewController.h
//  RSN
//
//  Created by jossiecs on 1/14/14.
//  Copyright (c) 2014 DreamLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DLSismosLegendViewControllerDelegate <NSObject>

@required
- (void)didTouchLegend;

@end

@interface DLSismosLegendViewController : UIViewController

@property (nonatomic,assign) id<DLSismosLegendViewControllerDelegate> delegate;

@end

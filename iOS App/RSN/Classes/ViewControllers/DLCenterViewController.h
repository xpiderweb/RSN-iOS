//
//  DLCenterViewController.h
//  RSN
//
//  Created by jossiecs on 12/17/13.
//  Copyright (c) 2013 DreamLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLLeftViewController.h"

@protocol DLCenterViewControllerDelegate <NSObject>

@optional
- (void)movePanelLeft;
- (void)movePanelRight;

@required
- (void)movePanelToOriginalPosition;
-(void)btnMovePanelRight:(UIButton *)sender;

@end

@interface DLCenterViewController : UIViewController<DLLeftPanelViewControllerDelegate>

@property (nonatomic, assign) id<DLCenterViewControllerDelegate> delegate;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic,strong) NSString *currentViewController;
@property (nonatomic, strong) UIViewController *currentShowViewController;

-(void)changeCurrentViewControllerWithString:(NSString*)viewControllerName;
- (void) enableAllViews:(BOOL) enable;



@end

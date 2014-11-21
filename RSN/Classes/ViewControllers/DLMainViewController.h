//
//  DLMainViewController.h
//  RSN
//
//  Created by jossiecs on 12/17/13.
//  Copyright (c) 2013 DreamLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLMainViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *leftButtonMenu;
-(void)resetMainView;
extern NSString * const DLMainViewControllerShowMenu;

@end

//
//  DLLeftViewController.h
//  RSN
//
//  Created by jossiecs on 12/17/13.
//  Copyright (c) 2013 DreamLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DLLeftPanelViewControllerDelegate <NSObject>

@optional
//- (void)imageSelected:(UIImage *)image withTitle:(NSString *)imageTitle withCreator:(NSString *)imageCreator;

@required
- (void)itemMenuSelected:(NSString *)itemMenuSelected;

@end


@interface DLLeftViewController : UIViewController


extern NSString * const DLLeftSismosItem;
extern NSString * const DLLeftNoticiasItem;
extern NSString * const DLLeftContactoItem;
extern NSString * const DLLeftConfiguracionItem;
extern NSString * const DLLeftSugerenciasItem;
extern NSString * const DLLeftUltimosSismosItem;
extern NSString * const DLLeftSismosContainerItem;


@property (nonatomic, assign) id<DLLeftPanelViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ucrLogoBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iceLogoBottomConstraint;


@end

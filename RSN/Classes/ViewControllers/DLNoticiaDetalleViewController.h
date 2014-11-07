//
//  DLNoticiaDetalleViewController.h
//  RSN
//
//  Created by jossiecs on 4/22/14.
//  Copyright (c) 2014 DreamLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLNoticiaVO.h"

@interface DLNoticiaDetalleViewController : UIViewController
@property (nonatomic, strong) DLNoticiaVO *noticiaVO;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@end

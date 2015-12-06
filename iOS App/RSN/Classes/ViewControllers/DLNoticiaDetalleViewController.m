//
//  DLNoticiaDetalleViewController.m
//  RSN
//
//  Created by jossiecs on 4/22/14.
//  Copyright (c) 2014 DreamLabs. All rights reserved.
//

#import "DLNoticiaDetalleViewController.h"


@interface DLNoticiaDetalleViewController ()


@end

@implementation DLNoticiaDetalleViewController
@synthesize noticiaVO;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    NSString *title = [NSString stringWithFormat:@"%@", noticiaVO.title];
    [self.titleLabel setText:title];
    
    NSString *hthmlFixed=[noticiaVO.contentHTML stringByReplacingOccurrencesOfString:@"src=\"images/" withString:@"style=\"width:270px\" src=\"http://www.rsn.ucr.ac.cr/images/"];
    NSString *viewport = [NSString stringWithFormat:@"<meta name='viewport' content='width=350px, initial-scale=1.0', maximum-scale=5.0, user-scalable=1>"];
    hthmlFixed = [NSString stringWithFormat:@"%@%@", viewport, hthmlFixed];
    NSLog(@"%@", hthmlFixed);
    [self.myWebView loadHTMLString:hthmlFixed baseURL:nil];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Atrás" style:UIBarButtonItemStylePlain target:nil action:nil];
}


@end

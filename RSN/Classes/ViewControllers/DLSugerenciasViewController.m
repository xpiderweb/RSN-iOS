//
//  DLSugerenciaViewController.m
//  RSN
//
//  Created by jossiecs on 1/22/14.
//  Copyright (c) 2014 DreamLabs. All rights reserved.
//

#import "DLSugerenciasViewController.h"
#import "DLCenterViewController.h"
@interface DLSugerenciasViewController ()

@end

@implementation DLSugerenciasViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    DLCenterViewController *viewController = (DLCenterViewController*)[self.navigationController parentViewController];
    [viewController changeCurrentViewControllerWithString:DLLeftSugerenciasItem];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

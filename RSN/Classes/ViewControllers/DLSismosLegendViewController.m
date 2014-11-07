//
//  DLSismosLegendViewController.m
//  RSN
//
//  Created by jossiecs on 1/14/14.
//  Copyright (c) 2014 DreamLabs. All rights reserved.
//

#import "DLSismosLegendViewController.h"

@interface DLSismosLegendViewController ()

-(IBAction)didTouchButton:(id)sender;

@end

@implementation DLSismosLegendViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)didTouchButton:(id)sender{
    [self.delegate didTouchLegend];
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

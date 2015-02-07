//
//  DLSismosContainerViewController.m
//  RSN
//
//  Created by jossiecs on 4/3/14.
//  Copyright (c) 2014 DreamLabs. All rights reserved.
//

#import "DLSismosContainerViewController.h"
#import "DLCenterViewController.h"
#import "DLSismosViewController.h"
#import "DLUltimosSismosViewController.h"
#import "DLSismoDetailViewController.h"
#import "DLSismoVO.h"
#import "DLMainViewController.h"

@interface DLSismosContainerViewController ()


@property (nonatomic,strong) DLSismosViewController *sismosViewController;
@property (nonatomic,strong) DLMainViewController *mainViewController;
@property (nonatomic,strong) DLUltimosSismosViewController *sismosUltimosListaController;
@property (nonatomic, strong) DLCenterViewController *centerViewController;
@property (weak, nonatomic) IBOutlet UIView *containerViewController;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (assign) BOOL isMapShowed;



@end

@implementation DLSismosContainerViewController

@synthesize sismosUltimosListaController,sismosViewController,containerViewController;
@synthesize segmentedControl;
@synthesize isMapShowed;
@synthesize mainView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    // Do any additional setup after loading the view.
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]; // change this color
    self.navigationItem.titleView = label;
    label.text = @"Sismos Recientes";
    [label sizeToFit];
     self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Atrás" style:UIBarButtonItemStylePlain target:nil action:nil];
    sismosViewController  = [[self storyboard] instantiateViewControllerWithIdentifier:@"DLSismosViewController"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(RefreshMap:)];
    [sismosViewController willMoveToParentViewController:self];
    [self addChildViewController:sismosViewController];
    [self.containerViewController addSubview:sismosViewController.view];
    
    isMapShowed = YES;
    
    [segmentedControl addTarget:self
                         action:@selector(segmentedValueChanged:)
               forControlEvents:UIControlEventValueChanged];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveSismosTableViewControllerNotification:) name:DLSismosTableViewControllerItemSelected object:nil];
    
}

-(IBAction)RefreshMap:(id)sender
{
    [sismosViewController RefreshMap];
}


- (void) disableMapView:(BOOL)enable{
    if (self.sismosViewController.view !=nil) {
        if (enable) {
            NSLog(@"Enable");
        }else{
            NSLog(@"Disable");
        }
        self.sismosViewController.view.userInteractionEnabled = enable;
    }
}

-(void)didReceiveSismosTableViewControllerNotification:(NSNotification*)notification{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    DLSismoDetailViewController *sismoDetail = (DLSismoDetailViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"DLSismoDetailViewController"];
    //[self.delegate sismoSelected:sismoVO];
    DLSismoVO *sismoVO = (DLSismoVO*)notification.object;
    [sismoDetail setSismoDataVO:sismoVO];
    [self.navigationController pushViewController:sismoDetail animated:YES];
}

- (void)segmentedValueChanged:(id)sender{
    LogInfo(@"estoy haciendo algo");
    
    if (segmentedControl.selectedSegmentIndex == 0) {
        if (!isMapShowed) {
            [self.sismosUltimosListaController.view removeFromSuperview];
            [self.containerViewController addSubview:sismosViewController.view];
            isMapShowed = YES;
            
        }
        //[self.view addSubview:_centerViewController.leftButtonVIew];
    }else{
        if (isMapShowed) {
            if(sismosUltimosListaController == nil){
                sismosUltimosListaController = [[self storyboard] instantiateViewControllerWithIdentifier:@"DLUltimosSismosViewController"];
            }
            NSLog(@"aqui me estaria escondiendo");
            [self.sismosViewController.view removeFromSuperview];
            [self.containerViewController addSubview:sismosUltimosListaController.view];
            isMapShowed = NO;
        }
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    DLCenterViewController *viewController = (DLCenterViewController*)[self.navigationController parentViewController];
    [viewController changeCurrentViewControllerWithString:DLLeftSismosItem];
    
    
}


- (IBAction)didTapSegmentedControl:(id)sender {
}
@end

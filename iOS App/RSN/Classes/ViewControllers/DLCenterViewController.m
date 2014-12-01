//
//  DLCenterViewController.m
//  RSN
//
//  Created by jossiecs on 12/17/13.
//  Copyright (c) 2013 DreamLabs. All rights reserved.
//

#import "DLCenterViewController.h"
#import "DLSismosViewController.h"
#import "DLNoticiasTableViewController.h"
#import "DLContactoViewController.h"
#import "DLConfiguracionViewController.h"
#import "DLSismosTableViewController.h"
#import "DLUltimosSismosViewController.h"
#import "DLSismosContainerViewController.h"
#include "Logging.h"
@interface DLCenterViewController ()<DLSismosTableViewControllerDelegate>

@property (nonatomic,strong) UINavigationController *navController;


@end

@implementation DLCenterViewController



@synthesize navController;
@synthesize currentViewController;
@synthesize currentShowViewController;

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
    // Do any additional setup after loading the view.
    [self setupView];
}

/**
 * Setups the view for this viewcontroller
 */
-(void)setupView{
    [self addNavigationController];
}

/**
 * Adds a navigation controller to the viewcontroller
 */
-(void) addNavigationController{
    navController = [[UINavigationController alloc]init];
    [self addChildViewController:navController];
    [navController didMoveToParentViewController:self];
    [self.view addSubview:navController.view];
    
    DLSismosContainerViewController *sismosContainerViewController  = [[self storyboard] instantiateViewControllerWithIdentifier:@"DLSismosContainerViewController"];
    [navController setViewControllers:@[sismosContainerViewController]];
    navController.navigationBar.alpha = 0.2f;
    navController.navigationBar.translucent = YES;
    currentShowViewController=sismosContainerViewController;
    [self setCurrentViewController:DLLeftSismosContainerItem];
    [self addShowMenuButton];
}

-(void)addShowMenuButton{
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftButton addTarget:self
                        action:@selector(btnMovePanelRight:)
              forControlEvents:UIControlEventTouchDown];
    UIImage *btnImage = [UIImage imageNamed:@"rsn-menu2.png"];
    [self.leftButton setImage:btnImage forState:UIControlStateNormal];
    self.leftButton.frame = CGRectMake(0, 210.0, 27, 126);
    self.leftButton.tag = 1;
    [self.view addSubview:self.leftButton];
}


#pragma mark -
#pragma mark Button Actions

-(void)btnMovePanelRight:(UIButton *)sender {
   
    UIButton *button = sender;
    switch (button.tag) {
        case 0: {
            [_delegate movePanelToOriginalPosition];
            break;
        }
            
        case 1: {
            [_delegate movePanelRight];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - DLLeftPanelViewControllerDelegate

-(void)itemMenuSelected:(NSString *)itemMenuSelected{
    
    BOOL foundViewControllerInNav = NO;
    UIViewController *tempViewController;
    
    if (![itemMenuSelected isEqualToString:currentViewController]) {
        
        if ([itemMenuSelected isEqualToString:DLLeftSismosItem]) {
            [self.navController popToRootViewControllerAnimated:NO];
        }else if ([itemMenuSelected isEqualToString:DLLeftNoticiasItem]) {
            tempViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"DLNoticiasTableViewController"];
            
        } else if ([itemMenuSelected isEqualToString:DLLeftContactoItem]) {
            tempViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"DLContactoViewController"];
            
        } else if ([itemMenuSelected isEqualToString:DLLeftConfiguracionItem]) {
            tempViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"DLConfiguracionViewController"];
            
        } else if ([itemMenuSelected isEqualToString:DLLeftSugerenciasItem]) {
            tempViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"DLSugerenciasViewController"];
            
        } else if ([itemMenuSelected isEqualToString:DLLeftUltimosSismosItem]) {
            
            tempViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"DLUltimosSismosViewController"];
            
            DLUltimosSismosViewController *ultimosSismosViewController = (DLUltimosSismosViewController*)currentShowViewController;
            
            [ultimosSismosViewController addSismosTableViewControllerDelegate:self];
            
            
        }else if([itemMenuSelected isEqualToString:DLLeftSismosContainerItem]){
            tempViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"DLSismosContainerViewController"];
        }
        
        
        for (UIViewController *viewControllerInNav in self.navController.viewControllers) {
            if ([viewControllerInNav isKindOfClass:[tempViewController class]]) {
                [self.navController popToViewController:viewControllerInNav animated:YES];
                currentShowViewController = viewControllerInNav;
                foundViewControllerInNav = YES;
                break;
            }
        }
        
        if (!foundViewControllerInNav) {
            currentShowViewController =tempViewController;
            [self.navController pushViewController:currentShowViewController animated:NO];
        }
        
        
        [self setCurrentViewController:itemMenuSelected];
    }
    [_delegate movePanelToOriginalPosition];
    
}


-(void)sismoSelected:(DLSismoVO *)sismoSelected{
    LogInfo(@"Sismo did selected");
}

/**
 Function created with the purpose of handling the back button on the navigation controller to change the current view controller variable value
 */
-(void)changeCurrentViewControllerWithString:(NSString*)viewControllerName{
    currentViewController = viewControllerName;
}

- (void) enableAllViews:(BOOL) enable{
    for (UIViewController *viewControllerInNav in self.navController.viewControllers) {
        [viewControllerInNav.view setUserInteractionEnabled:enable];
        viewControllerInNav.navigationItem.leftBarButtonItem.enabled= enable;
        [viewControllerInNav.navigationController.navigationBar setUserInteractionEnabled:enable];
    }
}


@end

//
//  DLMainViewController.m
//  RSN
//
//  Created by jossiecs on 12/17/13.
//  Copyright (c) 2013 DreamLabs. All rights reserved.
//

#import "DLMainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DLLeftViewController.h"
#import "DLCenterViewController.h"
#import "DLSismosContainerViewController.h"
#import "DLSismosViewController.h"

#define CENTER_TAG 1
#define LEFT_PANEL_TAG 2
#define RIGHT_PANEL_TAG 3

#define CORNER_RADIUS 4

#define SLIDE_TIMING .15
#define PANEL_WIDTH 35

@interface DLMainViewController ()<UIGestureRecognizerDelegate,DLCenterViewControllerDelegate>

@property (nonatomic, strong) DLCenterViewController *centerViewController;
@property (nonatomic, strong) DLLeftViewController *leftPanelViewController;
@property (nonatomic, strong) DLSismosViewController *sismosViewController;
@property (nonatomic, assign) BOOL showingLeftPanel;
@property (nonatomic, assign) BOOL showingRightPanel;
@property (nonatomic, assign) BOOL showPanel;
@property (nonatomic, assign) CGPoint preVelocity;
@property (nonatomic,strong) UINavigationController *navController;
@end

@implementation DLMainViewController
@synthesize sismosViewController;
@synthesize navController;

NSString * const DLMainViewControllerShowMenu = @"DLMainViewControllerShowMenu";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupView];
}

#pragma mark - Setup View
-(void)setupView {
    self.centerViewController = [[self storyboard]instantiateViewControllerWithIdentifier:@"DLCenterViewController"];
    self.centerViewController.view.tag = CENTER_TAG;
    self.centerViewController.delegate = self;
    [self.view addSubview:self.centerViewController.view];
    [self addChildViewController:_centerViewController];
    [_centerViewController didMoveToParentViewController:self];
    
    [self setupGestures];
}
-(void)showLeftViewWithShadow:(BOOL)value withOffset:(double)offset {
    if (value) {
        [_leftPanelViewController.view.layer setCornerRadius:CORNER_RADIUS];
        [_leftPanelViewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [_leftPanelViewController.view.layer setShadowOpacity:0.100];
        [_leftPanelViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
        
    } else {
        [_leftPanelViewController.view.layer setCornerRadius:0.0f];
        [_leftPanelViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
}
-(void)showCenterViewWithShadow:(BOOL)value withOffset:(double)offset {
    if (value) {
        [_centerViewController.view.layer setCornerRadius:CORNER_RADIUS];
        [_centerViewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [_centerViewController.view.layer setShadowOpacity:0.10];
        [_centerViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
        
    } else {
        [_centerViewController.view.layer setCornerRadius:0.0f];
        [_centerViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
}
-(void)resetMainView {
    // remove left and right views, and reset variables, if needed
    if (_leftPanelViewController != nil) {
        [self.leftPanelViewController.view removeFromSuperview];
        self.leftPanelViewController = nil;
        _centerViewController.leftButton.tag = 1;
        
        self.showingLeftPanel = NO;
        
        [self.centerViewController enableAllViews:YES];
    }
    
    [self showCenterViewWithShadow:NO withOffset:0];
}
-(UIView *)getLeftView {
    // init view if it doesn't already exist
    if (_leftPanelViewController == nil){
        // this is where you define the view for the left panel
        self.leftPanelViewController = [[self storyboard]instantiateViewControllerWithIdentifier:@"DLLeftPanelViewController"];
        self.leftPanelViewController.view.tag = LEFT_PANEL_TAG;
        self.leftPanelViewController.delegate = _centerViewController;
        
        [self.view addSubview:self.leftPanelViewController.view];
        
        [self addChildViewController:_leftPanelViewController];
        [_leftPanelViewController didMoveToParentViewController:self];
        
        _leftPanelViewController.view.frame = CGRectMake(-_leftPanelViewController.view.frame.size.width, 0, 247, self.view.frame.size.height);
    }
    
    self.showingLeftPanel = YES;
    
    
    /*[self.centerViewController.currentShowViewController.view setUserInteractionEnabled:NO];
     [self.centerViewController.currentShowViewController.navigationController.navigationBar setUserInteractionEnabled:NO];*/
    
    [self.centerViewController enableAllViews:NO];
    
    // setup view shadows
    [self showCenterViewWithShadow:NO withOffset:-2];
    [self showLeftViewWithShadow:NO withOffset:0];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanelLeftFirst:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    panRecognizer.cancelsTouchesInView = NO;
    [panRecognizer setDelegate:self];
    
    [_leftPanelViewController.view addGestureRecognizer:panRecognizer];
    
    UIView *view = self.leftPanelViewController.view;
    return view;
}


#pragma mark - setup

-(void)setupGestures {
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    panRecognizer.cancelsTouchesInView = NO;
    [panRecognizer setDelegate:self];
    
    [_centerViewController.view addGestureRecognizer:panRecognizer];
}

-(void)movePanelLeftFirst:(id)sender {
    [[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    CGPoint velocity = [(UIPanGestureRecognizer*)sender velocityInView:[sender view]];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        UIView *childView = nil;
        
        if(velocity.x > 0) {
            if (!_showingRightPanel) {
                childView = [self getLeftView];
            }
        } else {
            if (!_showingLeftPanel) {
                // childView = [self getRightView];
            }
            
        }
        // make sure the view we're working with is front and center
        //[self.view sendSubviewToBack:childView];
        [[sender view] bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    }
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        if (!_showPanel) {
            [self movePanelToOriginalPosition];
        } else {
            if (_showingLeftPanel) {
                [self movePanelRight];
            }  else if (_showingRightPanel) {
                [self movePanelLeft];
            }
        }
    }
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        
        UIView *viewPanel = _centerViewController.view;
        if(velocity.x > 0) {
        } else {
            
            _showPanel = abs([sender view].center.x - _centerViewController.view.frame.size.width/2) < _centerViewController.view.frame.size.width/2;
            
            // allow dragging only in x coordinates by only updating the x coordinate with translation position
            [sender view].center = CGPointMake([sender view].center.x + translatedPoint.x, [sender view].center.y);
            [(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0,0) inView:self.view];
            
            viewPanel.center = CGPointMake(viewPanel.center.x + translatedPoint.x, viewPanel.center.y);
            [(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0,0) inView:self.view];
            
            // if you needed to check for a change in direction, you could use this code to do so
            _preVelocity = velocity;
        }
        
        
    }
}
-(void)movePanel:(id)sender {
    
    [[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
}

-(void)movePanelToOriginalPosition {
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _centerViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self resetMainView];
                         }
                     }];
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _leftPanelViewController.view.frame = CGRectMake(0-_centerViewController.view.frame.size.width, 0, 247, self.view.frame.size.height);
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             //[self resetMainView];
                         }
                     }];
}
-(void)movePanelRight {
    [[NSNotificationCenter defaultCenter] postNotificationName:DLMainViewControllerShowMenu object:nil userInfo:nil];
    UIView *childView = [self getLeftView];
    [self.view sendSubviewToBack:childView];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0.1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        _centerViewController.view.frame = CGRectMake(239, 0, self.view.frame.size.width, self.view.frame.size.height);
        _leftPanelViewController.view.frame = CGRectMake(-10, 0, 247, self.view.frame.size.height);
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             _centerViewController.leftButton.tag = 0;
                         }
                     }];
}

@end

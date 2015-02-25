//
//  DLConfiguracionViewController.m
//  RSN
//
//  Created by jossiecs on 12/28/13.
//  Copyright (c) 2013 DreamLabs. All rights reserved.
//

#import "DLConfiguracionViewController.h"
#import "DLRSNModel.h"
#import "DLCenterViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface DLConfiguracionViewController (){
    int lastButtonPressIndex;
}

@property (nonatomic,weak) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UISwitch *pushOnOff;
@property (nonatomic, assign) int changesMade;
@property (nonatomic, assign) int magSelected;
@property (nonatomic, assign) int sendNotifications;
@property (weak, nonatomic) IBOutlet UISwitch *notifSwitch;
@property (nonatomic, assign) NSNumber* sendMeNotifications;
@end

@implementation DLConfiguracionViewController

@synthesize slider;
@synthesize changesMade;
@synthesize magSelected;
@synthesize sendNotifications;
@synthesize sendMeNotifications;




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
    [self SetSwitchPossition];
    magSelected = 3;
    sendNotifications = 1;
    changesMade = 0;
    [self setNavigationItemConfiguration];
    //SUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //float magnitud = [[defaults valueForKey:@"magnitud"]floatValue];
    [self magButtonLoadConfig];
    
}

-(void) magButtonLoadConfig{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *magButton = [prefs stringForKey:@"magButton"];
    if ([magButton  isEqual: @"3"]) {
        [self level3ButtonHandlerStart:nil];
    }else if ([magButton  isEqual: @"4"]){
        [self level4ButtonHandlerStart:nil];
    }else if ([magButton  isEqual: @"5"]){
        [self level5ButtonHandlerStart:nil];
    }else if ([magButton  isEqual: @"6"]){
        [self level6ButtonHandlerStart:nil];
    }else if ([magButton  isEqual: @"7"]){
        [self level7ButtonHandlerStart:nil];
    }else{
        lastButtonPressIndex=5;
    }
    
}

-(void) SetSwitchPossition{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *userNotification = [prefs stringForKey:@"userNotifications"];
    if ([userNotification  isEqual: @"1"]) {
        [_notifSwitch setOn:YES];
    }else{
        [_notifSwitch setOn:NO];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self SetSwitchPossition];
    DLCenterViewController *viewController = (DLCenterViewController*)[self.navigationController parentViewController];
    changesMade=0;
    [viewController changeCurrentViewControllerWithString:DLLeftConfiguracionItem];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (self.navigationController.visibleViewController != self) {
        //<Do something since we're closing using something else>
        if (changesMade == 1) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"¿Gusta guardar su nueva configuración?" message:nil delegate:self
                                  cancelButtonTitle:@"NO" otherButtonTitles:@"SÍ", nil];
            [alert show];
        }
    } else {
        //<Do something since we're closing because of the back button>
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        //Code for download button
        [self saveAPIUserData];
    }
}

/**
 Sets the navigation item title as a label with blue color and "Configuracion" name
 */
-(void) setNavigationItemConfiguration{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    //label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]; // change this color
    self.navigationItem.titleView = label;
    label.text = @"Configuración";//NSLocalizedString(@"PageThreeTitle", @"");
    [label sizeToFit];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Guardar"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self action:@selector(saveClicked)];
    self.navigationItem.rightBarButtonItem = saveButton;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Atrás" style:UIBarButtonItemStylePlain target:nil action:nil];
}

-(void)saveAPIUserData{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *userToken = [prefs stringForKey:@"token"];
    NSNumber *userNotificationsValue;
    NSString *userNotificationsString = [prefs stringForKey:@"userNotifications"];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    userNotificationsValue = [f numberFromString:userNotificationsString];
    NSString *magitudeSelected = [NSString stringWithFormat:@"%d", magSelected];
    //Sent PUT to API
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"547406e0fa85847666283b61" forHTTPHeaderField:@"Api-key"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:userToken forKey:@"token"];
    [parameters setValue:magitudeSelected forKey:@"minMagnitude"];
    [parameters setValue:userNotificationsValue forKey:@"notificationActive"];
    [parameters setValue:@"iOS" forKey:@"os"];
    NSString *magButton = magitudeSelected;
    [prefs setObject:magButton forKey:@"magButton"];
    [prefs synchronize];
    [manager PUT:@"http://rsnapi.herokuapp.com/api/devices/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Ocurio un Error" message:nil delegate:nil
                              cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }];
}

- (void)saveClicked{
    [self saveAPIUserData];
    changesMade=0;
}

#pragma mark - Button Handlers
- (IBAction)mwButtonHandler:(id)sender{
    
    UIButton *pressButton = (UIButton*) sender;
    pressButton.selected = !pressButton.selected;
    
    if (pressButton.selected) {
        [self.mwPopOverImageView setHidden:NO];
    }else{
        [self.mwPopOverImageView setHidden:YES];
    }
}

- (IBAction)level8ButtonHandler:(id)sender{
    [self unSelectLastPress];
    [self.number8RedImageView setHidden:YES];
    [self.number8WhiteImageView setHidden:NO];
    lastButtonPressIndex=8;
}
- (IBAction)level7ButtonHandler:(id)sender{
    [self unSelectLastPress];
    
    //8
    [self.number8RedImageView setHidden:YES];
    [self.number8WhiteImageView setHidden:NO];
    changesMade=1;
    magSelected=7;
    //7
    [self.number7RedImageView setHidden:YES];
    [self.number7WhiteImageView setHidden:NO];
    
    [self.leyend7ImageView setHidden:NO];
    lastButtonPressIndex=7;
    
}
- (IBAction)level6ButtonHandler:(id)sender{
    changesMade=1;
    magSelected=6;
    
    [self unSelectLastPress];
    //8
    [self.number8RedImageView setHidden:YES];
    [self.number8WhiteImageView setHidden:NO];
    
    //7
    [self.number7RedImageView setHidden:YES];
    [self.number7WhiteImageView setHidden:NO];
    
    //6
    [self.number6RedImageView setHidden:YES];
    [self.number6WhiteImageView setHidden:NO];
    
    [self.leyend6ImageView setHidden:NO];
    lastButtonPressIndex=6;
    //[self saveClicked];
    
}
- (IBAction)level5ButtonHandler:(id)sender{
    changesMade=1;
    magSelected=5;
    [self unSelectLastPress];
    //8
    [self.number8RedImageView setHidden:YES];
    [self.number8WhiteImageView setHidden:NO];
    
    //7
    [self.number7RedImageView setHidden:YES];
    [self.number7WhiteImageView setHidden:NO];
    
    //6
    [self.number6RedImageView setHidden:YES];
    [self.number6WhiteImageView setHidden:NO];
    
    //5
    [self.number5RedImageView setHidden:YES];
    [self.number5WhiteImageView setHidden:NO];
    
    [self.leyend5ImageView setHidden:NO];
    
    lastButtonPressIndex=5;
    //[self saveClicked];
}
- (IBAction)level4ButtonHandler:(id)sender{
    changesMade=1;
    magSelected=4;
    [self unSelectLastPress];
    //8
    [self.number8RedImageView setHidden:YES];
    [self.number8WhiteImageView setHidden:NO];
    
    //7
    [self.number7RedImageView setHidden:YES];
    [self.number7WhiteImageView setHidden:NO];
    
    //6
    [self.number6RedImageView setHidden:YES];
    [self.number6WhiteImageView setHidden:NO];
    
    //5
    [self.number5RedImageView setHidden:YES];
    [self.number5WhiteImageView setHidden:NO];
    
    //4
    [self.number4RedImageView setHidden:YES];
    [self.number4WhiteImageView setHidden:NO];
    
    lastButtonPressIndex=4;
    //[self saveClicked];
}
- (IBAction)level3ButtonHandler:(id)sender{
    changesMade=1;
    magSelected=3;
    [self unSelectLastPress];
    //8
    [self.number8RedImageView setHidden:YES];
    [self.number8WhiteImageView setHidden:NO];
    
    //7
    [self.number7RedImageView setHidden:YES];
    [self.number7WhiteImageView setHidden:NO];
    
    //6
    [self.number6RedImageView setHidden:YES];
    [self.number6WhiteImageView setHidden:NO];
    
    //5
    [self.number5RedImageView setHidden:YES];
    [self.number5WhiteImageView setHidden:NO];
    
    //4
    [self.number4RedImageView setHidden:YES];
    [self.number4WhiteImageView setHidden:NO];
    
    //3
    [self.number3RedImageView setHidden:YES];
    [self.number3WhiteImageView setHidden:NO];
    lastButtonPressIndex=3;
    // [self saveClicked];
}
- (IBAction)level3ButtonHandlerStart:(id)sender{
    changesMade=1;
    magSelected=3;
    [self unSelectLastPress];
    //8
    [self.number8RedImageView setHidden:YES];
    [self.number8WhiteImageView setHidden:NO];
    
    //7
    [self.number7RedImageView setHidden:YES];
    [self.number7WhiteImageView setHidden:NO];
    
    //6
    [self.number6RedImageView setHidden:YES];
    [self.number6WhiteImageView setHidden:NO];
    
    //5
    [self.number5RedImageView setHidden:YES];
    [self.number5WhiteImageView setHidden:NO];
    
    //4
    [self.number4RedImageView setHidden:YES];
    [self.number4WhiteImageView setHidden:NO];
    
    //3
    [self.number3RedImageView setHidden:YES];
    [self.number3WhiteImageView setHidden:NO];
    lastButtonPressIndex=3;
}
- (IBAction)level7ButtonHandlerStart:(id)sender{
    [self unSelectLastPress];
    
    //8
    [self.number8RedImageView setHidden:YES];
    [self.number8WhiteImageView setHidden:NO];
    changesMade=1;
    magSelected=7;
    //7
    [self.number7RedImageView setHidden:YES];
    [self.number7WhiteImageView setHidden:NO];
    
    [self.leyend7ImageView setHidden:NO];
    lastButtonPressIndex=7;
}
- (IBAction)level6ButtonHandlerStart:(id)sender{
    changesMade=1;
    magSelected=6;
    
    [self unSelectLastPress];
    //8
    [self.number8RedImageView setHidden:YES];
    [self.number8WhiteImageView setHidden:NO];
    
    //7
    [self.number7RedImageView setHidden:YES];
    [self.number7WhiteImageView setHidden:NO];
    
    //6
    [self.number6RedImageView setHidden:YES];
    [self.number6WhiteImageView setHidden:NO];
    
    [self.leyend6ImageView setHidden:NO];
    lastButtonPressIndex=6;
    
}
- (IBAction)level5ButtonHandlerStart:(id)sender{
    changesMade=1;
    magSelected=5;
    [self unSelectLastPress];
    //8
    [self.number8RedImageView setHidden:YES];
    [self.number8WhiteImageView setHidden:NO];
    
    //7
    [self.number7RedImageView setHidden:YES];
    [self.number7WhiteImageView setHidden:NO];
    
    //6
    [self.number6RedImageView setHidden:YES];
    [self.number6WhiteImageView setHidden:NO];
    
    //5
    [self.number5RedImageView setHidden:YES];
    [self.number5WhiteImageView setHidden:NO];
    
    [self.leyend5ImageView setHidden:NO];
    
    lastButtonPressIndex=5;
}
- (IBAction)level4ButtonHandlerStart:(id)sender{
    changesMade=1;
    magSelected=4;
    [self unSelectLastPress];
    //8
    [self.number8RedImageView setHidden:YES];
    [self.number8WhiteImageView setHidden:NO];
    
    //7
    [self.number7RedImageView setHidden:YES];
    [self.number7WhiteImageView setHidden:NO];
    
    //6
    [self.number6RedImageView setHidden:YES];
    [self.number6WhiteImageView setHidden:NO];
    
    //5
    [self.number5RedImageView setHidden:YES];
    [self.number5WhiteImageView setHidden:NO];
    
    //4
    [self.number4RedImageView setHidden:YES];
    [self.number4WhiteImageView setHidden:NO];
    
    lastButtonPressIndex=4;
}



- (void) unSelectLastPress{
    
    [self.number3RedImageView setHidden:NO];
    [self.number3WhiteImageView setHidden:YES];
    
    [self.number4RedImageView setHidden:NO];
    [self.number4WhiteImageView setHidden:YES];
    
    [self.number5RedImageView setHidden:NO];
    [self.number5WhiteImageView setHidden:YES];
    [self.leyend5ImageView setHidden:YES];
    
    [self.number6RedImageView setHidden:NO];
    [self.number6WhiteImageView setHidden:YES];
    [self.leyend6ImageView setHidden:YES];
    
    [self.number7RedImageView setHidden:NO];
    [self.number7WhiteImageView setHidden:YES];
    [self.leyend7ImageView setHidden:YES];
    
    [self.number8RedImageView setHidden:NO];
    [self.number8WhiteImageView setHidden:YES];
    
}

- (IBAction)pushOnOff:(id)sender {
    
    if ([self.pushOnOff isOn]) {
        sendMeNotifications = @YES;
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        // Storing an NSString:
        [prefs setObject:sendMeNotifications forKey:@"userNotifications"];
        [prefs synchronize];
        [self saveAPIUserData];
    } else {
        sendMeNotifications = @NO;
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:sendMeNotifications forKey:@"userNotifications"];
        [prefs synchronize];
        [self saveAPIUserData];
    }
}

#pragma mark - Memory
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

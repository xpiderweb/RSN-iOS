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
@end

@implementation DLConfiguracionViewController

@synthesize slider;
@synthesize changesMade;
@synthesize magSelected;
@synthesize sendNotifications;



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
    magSelected = 3;
    sendNotifications = 1;
    changesMade = 0;
    [self setNavigationItemConfiguration];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    float magnitud = [[defaults valueForKey:@"magnitud"]floatValue];
    
    if (magnitud==3.0f) {
        [self level3ButtonHandler:nil];
    }else if (magnitud==4.0f){
        [self level4ButtonHandler:nil];
    }else if (magnitud==5.0f){
        [self level5ButtonHandler:nil];
    }else if (magnitud==6.0f){
        [self level6ButtonHandler:nil];
    }else if (magnitud==7.0f){
        [self level7ButtonHandler:nil];
    }else if (magnitud==8.0f){
        [self level8ButtonHandler:nil];
    }else{
        lastButtonPressIndex=5;
    }
    
    

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    DLCenterViewController *viewController = (DLCenterViewController*)[self.navigationController parentViewController];
    changesMade=0;
    [viewController changeCurrentViewControllerWithString:DLLeftConfiguracionItem];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (self.navigationController.visibleViewController != self) {
        //<Do something since we're closing using something else>
        NSLog(@"ok we pressed or somehting else");
        if (changesMade == 1) {
            NSLog(@"hey ok we are ok");
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Gustas Guardar tu Configuracion?" message:nil delegate:self
                                  cancelButtonTitle:@"NO" otherButtonTitles:@"OK", nil];
            [alert show];
        }
    } else {
        //<Do something since we're closing because of the back button>
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //Code for OK button
        NSLog(@"I cancelled");
    }
    if (buttonIndex == 1)
    {
        //Code for download button
        NSLog(@"Save me");
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
    label.text = @"Configuracion";//NSLocalizedString(@"PageThreeTitle", @"");
    [label sizeToFit];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                       target:self action:@selector(saveClicked:)];
    self.navigationItem.rightBarButtonItem = saveButton;
}

-(void)saveAPIUserData{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *userToken = [prefs stringForKey:@"token"];
    NSString *os_version = [[UIDevice currentDevice] systemVersion];
    NSString *iosVersion = [NSString stringWithFormat:@"iOS %@", os_version];
    NSString *magitudeSelected = [NSString stringWithFormat:@"%d", magSelected];
    NSString *notifications = [NSString stringWithFormat:@"%d", sendNotifications];
    NSLog(@"%@", notifications);
    //Sent PUT to API
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"token": userToken , @"minMagnitude" : magitudeSelected, @"notificationActive" : notifications, @"os" : iosVersion};
    [manager PUT:@"http://rsnapi.herokuapp.com/api/devices/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        
        //need to delete
        UIAlertView *alert5 = [[UIAlertView alloc]
                               initWithTitle:@"Connectado" message:nil delegate:nil
                               cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert5 show];
        // end of need to delete
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Ocurio un Error" message:nil delegate:nil
                              cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Configuracion guardada!" message:nil delegate:nil
                          cancelButtonTitle:nil otherButtonTitles:@"GRACIAS", nil];
    [alert show];
}

- (IBAction)saveClicked:(id)sender {
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
        sendNotifications = 1;
        [self saveAPIUserData];
    } else {
        sendNotifications = 0;
        [self saveAPIUserData];
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Notificaciones fueron desactivadas" message:nil delegate:nil
                              cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

#pragma mark - Memory
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

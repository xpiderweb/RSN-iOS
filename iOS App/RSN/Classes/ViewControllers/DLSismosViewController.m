//
//  DLSismosViewController.m
//  RSN
//
//  Created by jossiecs on 12/20/13.
//  Copyright (c) 2013 DreamLabs. All rights reserved.
//

#import "DLSismosViewController.h"

#import "DLRSNModel.h"
#import "DLMyLocation.h"
#import "DLCenterViewController.h"
#define METERS_PER_MILE 1609


@interface DLSismosViewController ()
@property (nonatomic, assign) BOOL legendOpen;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *animationWait;
@property (nonatomic, strong) DLCenterViewController *centerViewController;
@property (nonatomic,strong) DLSismosLegendViewController *sismosLengend;
@property BOOL isLegendHidden;
@property BOOL showMennu;
@property (weak, nonatomic) IBOutlet UISegmentedControl *hoySemanaSegmented;


-(IBAction)segmentedControlValueChanged:(id)sender;

@end

@implementation DLSismosViewController

@synthesize sismosLengend;
@synthesize isLegendHidden;
@synthesize hoySemanaSegmented;
@synthesize viewControllerDelegate;



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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveLastSismosWithNotification:) name:DLModelDidReceiveLastSismos object:nil];
    self.annotationsArray = [[NSMutableArray alloc] init];
    
    [[DLRSNModel sharedInstance]getLastSismos];
    _legendOpen = FALSE;
    _showMennu = FALSE;
    _animationWait.hidden = FALSE;
    [_animationWait startAnimating];
    self.noSismoAlertShown = false;
    //Create legend view controller
    sismosLengend  = [[self storyboard]instantiateViewControllerWithIdentifier:@"DLSismosLegendViewController"];
    [sismosLengend setDelegate:self];
    [sismosLengend.view setFrame:CGRectMake(295, 210, 205, 123)];
    [sismosLengend willMoveToParentViewController:self];
    [self.view addSubview:sismosLengend.view];
    [self addChildViewController:sismosLengend];
    [self setIsLegendHidden:YES];
    
    NSArray *items = [[NSArray alloc]initWithObjects:@"semana",@"hoy", nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
    segmentedControl.frame = CGRectMake(39,500,251,36);
    segmentedControl.tintColor = [UIColor clearColor];
    UIImage *semanaActive;
    UIImage *hoyActive;
    UIImage *separator;
    
    //Setting imageWithRenderingMode: to imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal for iOS7 is key
    if ([UIImage instancesRespondToSelector:@selector(imageWithRenderingMode:)]) {
        semanaActive = [[UIImage imageNamed:@"RSN-segment1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        hoyActive = [[UIImage imageNamed:@"RSN-segment2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        separator = [[UIImage imageNamed:@"RSN-segment-separator"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
    }
    else {
        semanaActive = [UIImage imageNamed:@"RSN-segment1"];
        hoyActive = [UIImage imageNamed:@"RSN-segment2"];
        separator = [UIImage imageNamed:@"RSN-segment-separator"];
    }
    
    [segmentedControl setImage:semanaActive forSegmentAtIndex:0];
    [segmentedControl setImage:hoyActive forSegmentAtIndex:1];
    [segmentedControl setDividerImage:separator forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    segmentedControl.selectedSegmentIndex = 1;
    [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [_animationWait stopAnimating];
    _animationWait.hidden = TRUE;
    
}

#pragma mark -
#pragma mark Button Actions


-(void)segmentAction:(UISegmentedControl*)sender {
    NSString *imageName = [NSString stringWithFormat:@"RSN-segment%ld",(long)sender.selectedSegmentIndex];
    
    [sender setImage:[UIImage imageNamed:imageName] forSegmentAtIndex:sender.selectedSegmentIndex];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
}

-(IBAction)segmentedControlValueChanged:(id)sender{
    UISegmentedControl *s = (UISegmentedControl *)sender; [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                                                          name:UIApplicationDidBecomeActiveNotification
                                                                                                        object:nil];
    
    if (s.selectedSegmentIndex == 0)
    {
        [[DLRSNModel sharedInstance]getLastSismosByWeek];
    }else if (s.selectedSegmentIndex == 1){
        [[DLRSNModel sharedInstance]getLastSismos];
    }
}

#pragma DLSismosLegendViewControllerProtocol Methods

-(void)didTouchLegend{
    _legendOpen = TRUE;
    if(self.isLegendHidden){
        
        [UIView beginAnimations:@"showLegend" context:nil];
        [UIView setAnimationDuration:0.4];
        [sismosLengend.view setFrame:CGRectMake( 120, 210, 205, 123)]; //notice this is ON screen!
        [UIView commitAnimations];
        
        self.isLegendHidden = NO;
        
    }else{
        [UIView beginAnimations:@"hideLegend" context:nil];
        [UIView setAnimationDuration:0.4];
        [sismosLengend.view setFrame:CGRectMake(295, 210, 205, 123)];
        [UIView commitAnimations];
        self.isLegendHidden = YES;
    }
    
}

#pragma DLRSNModel Protocol

-(void)didReceiveLastSismosWithNotification:(NSNotification*)notification{
    
    LogInfo(@"didReceiveLastSismosWithNotification");
    if (_showMennu == TRUE) {
        //DLCenterViewController *foo = [[DLCenterViewController alloc] init];
        // [foo showMenuButtonBool];
    }
    _showMennu = TRUE;
    [self.annotationsArray removeAllObjects];
    NSDictionary * root = (NSDictionary*)[notification userInfo];
    BOOL isEmpty = ([root count] == 0);
    [self.googleMapView clear];
    if (isEmpty ) {
        GMSCameraPosition *setLocation = [GMSCameraPosition cameraWithLatitude:10.238
                                                                     longitude:-84.125
                                                                          zoom:8];
        [self.googleMapView setCamera:setLocation];
        if (!self.noSismoAlertShown) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hoy no se han detectado sismos."
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            self.noSismoAlertShown = true;
        }
    }else{
        
        BOOL firstPin = YES;
        for (NSDictionary * row in root) {
            
            NSString * address = [row objectForKey:@"description"];
            float size = [[row objectForKey:@"magnitude"]floatValue];
            NSDictionary *location = row[@"location"];
            NSNumber * latitude = (NSNumber*)[location objectForKey:@"lat"];
            NSNumber * longitude = (NSNumber*)[location objectForKey:@"lng"];
            //Time
            NSString *time = [row objectForKey:@"time"];
            NSLocale *posixLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
            [dateFormatter setLocale: posixLocale];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
            NSDate *dateFromString = [[NSDate alloc] init];
            dateFromString = [dateFormatter dateFromString:time];
            // dateFromString= [dateFromString dateByAddingTimeInterval:-3600*6];
            
            NSDateFormatter* df_utc = [[NSDateFormatter alloc] init];
            [df_utc setLocale: posixLocale];
            [df_utc setDateFormat:@"dd-MM-yyyy h:mm a"];
            
            NSString* ts_utc_string = [df_utc stringFromDate:dateFromString];
            time = ts_utc_string;
            NSLog(@"%@", time);
            int color = 0;
            if(firstPin){
                if(size >= 0 && size < 3.5){
                    color = 4;
                }else if(size >= 3.5 && size < 5){
                    color = 5;
                }else if(size >= 5){
                    color = 6;
                }
            }else if(size >= 0 && size < 3.5){
                color = 1;
                
            }else if(size >= 3.5 && size < 5){
                color = 2;
                
            }else if(size >= 5){
                color = 3;
                
            }
           
            // Creates a marker in the center of the map.
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);
            marker.title = [NSString stringWithFormat:@"%.1f Mw / %@ UTC",size,time];
            marker.snippet = address;
            if(color == 1){
                marker.icon = [UIImage imageNamed:@"greenIcon"];
            }else if(color == 2){
                marker.icon = [UIImage imageNamed:@"orangeIcon"];
            }else if(color == 3){
                marker.icon = [UIImage imageNamed:@"redIcon"];
            }else if(color == 4){
                marker.icon = [UIImage imageNamed:@"greenStar"];
            }else if(color == 5){
                marker.icon = [UIImage imageNamed:@"orangeStar"];
            }else if(color == 6){
                marker.icon = [UIImage imageNamed:@"redStar"];
            }
            marker.map =  self.googleMapView;
            
            if (firstPin) {
                firstPin = NO;
                GMSCameraPosition *setLocation = [GMSCameraPosition cameraWithLatitude:latitude.doubleValue
                                                                             longitude:longitude.doubleValue
                                                                            zoom:8.15];
                [self.googleMapView setCamera:setLocation];
                [self.googleMapView setSelectedMarker:marker];
            }

            
        }

    }
}

- (IBAction)tapToHide:(id)sender {
    if (_legendOpen == TRUE) {
        [UIView beginAnimations:@"hideLegend" context:nil];
        [UIView setAnimationDuration:0.4];
        [sismosLengend.view setFrame:CGRectMake(295, 210, 205, 123)];
        [UIView commitAnimations];
        self.isLegendHidden = YES;
    }
}


@end

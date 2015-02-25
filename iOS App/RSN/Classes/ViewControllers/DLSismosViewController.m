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
    
    [[DLRSNModel sharedInstance]getLastSismos];
    _legendOpen = FALSE;
    _showMennu = FALSE;
    _animationWait.hidden = FALSE;
    [_animationWait startAnimating];
    
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
    CLGeocoder *geoCode = [[CLGeocoder alloc] init];
    [geoCode geocodeAddressString:@"Costa Rica" completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            CLPlacemark *place = [placemarks objectAtIndex:0];
            CLLocation *location = place.location;
            CLLocationCoordinate2D coord = location.coordinate;
            
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coord, 160*METERS_PER_MILE, 260*METERS_PER_MILE);
            
            MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
            [_mapView setRegion:adjustedRegion animated:YES];
            [_mapView setDelegate:self];
            _mapView.mapType = MKMapTypeStandard;
        }
        
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(RefreshMap)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
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

-(void) RefreshMap {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveLastSismosWithNotification:) name:DLModelDidReceiveLastSismos object:nil];
        
        [[DLRSNModel sharedInstance]getLastSismos];
        
    });
    
}

#pragma DLRSNModel Protocol

-(void)didReceiveLastSismosWithNotification:(NSNotification*)notification{
    
    LogInfo(@"didReceiveLastSismosWithNotification");
    if (_showMennu == TRUE) {
        //DLCenterViewController *foo = [[DLCenterViewController alloc] init];
        // [foo showMenuButtonBool];
    }
    _showMennu = TRUE;
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        [_mapView removeAnnotation:annotation];
    }
    
    NSDictionary * root = (NSDictionary*)[notification userInfo];
    BOOL firstPin = YES;
    for (NSDictionary * row in root) {
        
        NSString * address = [row objectForKey:@"description"];
        float size = [[row objectForKey:@"magnitude"]floatValue];
        NSDictionary *location = row[@"location"];
        NSNumber * latitude = (NSNumber*)[location objectForKey:@"lat"];
        NSNumber * longitude = (NSNumber*)[location objectForKey:@"lng"];
        //Time
        NSString *time = [row objectForKey:@"time"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        NSDate *dateFromString = [[NSDate alloc] init];
        dateFromString = [dateFormatter dateFromString:time];
        
        NSDateFormatter* df_utc = [[NSDateFormatter alloc] init];
        [df_utc setTimeZone:[NSTimeZone timeZoneWithName:@"GTM"]];
        [df_utc setDateFormat:@"dd-MM-yyyy h:mm a"];
        
        NSString* ts_utc_string = [df_utc stringFromDate:dateFromString];
        time = ts_utc_string;
        int color = 0;
        if(firstPin){
            
            firstPin = NO;
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
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latitude.doubleValue;
        coordinate.longitude = longitude.doubleValue;
        DLMyLocation *annotation = [[DLMyLocation alloc] initWithSize:[NSString stringWithFormat:@"%.1f Mw / %@",size,time] address:address coordinate:coordinate];
        [annotation setColor:color];
        [annotation setAddress: address];
        [_mapView addAnnotation:annotation];
        if(annotation.color >= 4){
            [_mapView selectAnnotation:annotation animated:YES];
        }
    }
}

#pragma MapKitProtocol
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    DLMyLocation *myLocation = annotation;
    NSString *identifier = [NSString stringWithFormat:@"DLMyLocationRsn%d",myLocation.color];
    
    if ([annotation isKindOfClass:[DLMyLocation class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        //DLMyLocation *myLocation = annotation;
        if(myLocation.color == 1){
            annotationView.pinColor = MKPinAnnotationColorGreen;
        }else if(myLocation.color == 2){
            annotationView.image = [UIImage imageNamed:@"RSN-Map-pinOrange"];
        }else if(myLocation.color == 3){
            annotationView.pinColor = MKPinAnnotationColorRed;
        }else if(myLocation.color == 4){
            annotationView.image = [UIImage imageNamed:@"RSN-Map-pinStarGreen"];
        }else if(myLocation.color == 5){
            annotationView.image = [UIImage imageNamed:@"RSN-Map-pinStarOrange"];
        }else if(myLocation.color == 6){
            annotationView.image = [UIImage imageNamed:@"RSN-Map-pinStarRed"];
        }
        
        //        annotationView.image=[UIImage imageNamed:@"arrest.png"];//here we use a nice image instead of the default pins
        
        return annotationView;
    }
    
    return nil;
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

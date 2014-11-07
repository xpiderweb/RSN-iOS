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
#define METERS_PER_MILE 1609.344

@interface DLSismosViewController ()


@property (nonatomic,strong) DLSismosLegendViewController *sismosLengend;
@property BOOL isLegendHidden;
@property (weak, nonatomic) IBOutlet UISegmentedControl *hoySemanaSegmented;

-(IBAction)segmentedControlValueChanged:(id)sender;

@end

@implementation DLSismosViewController

@synthesize sismosLengend;
@synthesize isLegendHidden;
@synthesize hoySemanaSegmented;

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
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]; // change this color
    self.navigationItem.titleView = label;
    label.text = @"Sismos Recientes";
    [label sizeToFit];
    
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
    
}

-(void)segmentAction:(UISegmentedControl*)sender {
    NSString *imageName = [NSString stringWithFormat:@"RSN-segment%ld",(long)sender.selectedSegmentIndex];
    
    [sender setImage:[UIImage imageNamed:imageName] forSegmentAtIndex:sender.selectedSegmentIndex];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveLastSismosWithNotification:) name:DLModelDidReceiveLastSismos object:nil];
    
    [[DLRSNModel sharedInstance]getLastSismos];
    
    CLGeocoder *geoCode = [[CLGeocoder alloc] init];
    [geoCode geocodeAddressString:@"Costa Rica" completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            CLPlacemark *place = [placemarks objectAtIndex:0];
            CLLocation *location = place.location;
            CLLocationCoordinate2D coord = location.coordinate;
            
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coord, 450*METERS_PER_MILE, 450*METERS_PER_MILE);
            
            MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
            [_mapView setRegion:adjustedRegion animated:YES];
            [_mapView setDelegate:self];
            _mapView.mapType = MKMapTypeStandard;
        }
        
        
    }];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ViewIsShowNotification"
     object:self];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

-(IBAction)segmentedControlValueChanged:(id)sender{
    UISegmentedControl *s = (UISegmentedControl *)sender;
    
    if (s.selectedSegmentIndex == 0)
    {
        [[DLRSNModel sharedInstance]getLastSismosByWeek];
    }else if (s.selectedSegmentIndex == 1){
        [[DLRSNModel sharedInstance]getLastSismos];
    }
}

#pragma DLSismosLegendViewControllerProtocol Methods

-(void)didTouchLegend{
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
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        [_mapView removeAnnotation:annotation];
    }
    
    NSDictionary * root = (NSDictionary*)[notification userInfo];
    
    BOOL firstPin = YES;
    for (NSDictionary * row in root) {
        
        NSNumber * latitude = (NSNumber*)[row objectForKey:@"lat"];
        NSNumber * longitude = (NSNumber*)[row objectForKey:@"lon"];
        NSString * address = [row objectForKey:@"local"];
        
        float size = [[row objectForKey:@"magnitude"]floatValue];
        
        //Time
        NSString *time = [row objectForKey:@"time"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *dateFromString = [[NSDate alloc] init];
        dateFromString = [dateFormatter dateFromString:time];
        [dateFormatter setDateFormat:@"dd-MM-yyyy h:mm a"];
        time = [dateFormatter stringFromDate:dateFromString];
        
        
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

@end
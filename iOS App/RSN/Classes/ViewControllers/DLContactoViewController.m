//
//  DLContactoViewController.m
//  RSN
//
//  Created by jossiecs on 12/28/13.
//  Copyright (c) 2013 DreamLabs. All rights reserved.
//

#import "DLContactoViewController.h"
#import "DLCenterViewController.h"
@interface DLContactoViewController ()

-(IBAction)webOptionPressed:(id)sender;
-(IBAction)mapOptionPressed:(id)sender;
-(IBAction)wazeOptionPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *sendSuggestionsButton;
@end

@implementation DLContactoViewController

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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    //label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]; // change this color
    self.navigationItem.titleView = label;
    label.text = @"Contacto";//NSLocalizedString(@"PageThreeTitle", @"");
    [label sizeToFit];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    DLCenterViewController *viewController = (DLCenterViewController*)[self.navigationController parentViewController];
    [viewController changeCurrentViewControllerWithString:DLLeftContactoItem];
}

-(IBAction)webOptionPressed:(id)sender{
    NSURL *webURL =[NSURL URLWithString:@"http://www.rsn.ucr.ac.cr"];
    [[UIApplication sharedApplication] openURL:webURL];
}

-(IBAction)mapOptionPressed:(id)sender{
    NSURL *mapURL= [NSURL URLWithString:@"https://maps.google.com/maps?q=Red+Sismol%C3%B3gica+de+Costa+Rica&hl=en&ie=UTF8&sll=37.0625,-95.677068&sspn=49.310476,94.042969&t=h&z=17&iwloc=A"];
    [[UIApplication sharedApplication] openURL:mapURL];
}

-(IBAction)wazeOptionPressed:(id)sender{
    NSURL *wazeURL =[NSURL URLWithString:@"http://waze.to/hd1u0x29bk"];
    [[UIApplication sharedApplication] openURL:wazeURL];
}

- (IBAction)callPhoneHandler:(id)sender{
    NSString *phoneCallNum = @"tel://22538407";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneCallNum]];
}

- (IBAction)suggestionsButtonPressed:(id)sender {
    NSURL *emailSuggestions;
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mailto:info@idartestudio.com"]]) {
        emailSuggestions = [NSURL URLWithString:@"mailto:info@idartestudio.com"];
    }else{
        emailSuggestions = [NSURL URLWithString:@"mailto:info@idartestudio.com"];
    }
    
    [[UIApplication sharedApplication] openURL:emailSuggestions];
}
@end

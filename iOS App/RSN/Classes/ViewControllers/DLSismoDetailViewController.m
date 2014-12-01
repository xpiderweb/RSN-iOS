//
//  DLSismoDetailViewController.m
//  RSN
//
//  Created by jossiecs on 4/2/14.
//  Copyright (c) 2014 DreamLabs. All rights reserved.
//

#import "DLSismoDetailViewController.h"
#import "DLSismoVO.h"

@interface DLSismoDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *localizacionLabel;
@property (weak, nonatomic) IBOutlet UILabel *coordenadasLabel;
@property (weak, nonatomic) IBOutlet UILabel *depthLabel;
@property (weak, nonatomic) IBOutlet UILabel *magnitudLabel;
@property (weak, nonatomic) IBOutlet UILabel *sismoTitleLabel;
@property (strong, nonatomic) DLSismoVO *sismoData;
@property (weak,nonatomic) IBOutlet UIWebView *webView;
@end

@implementation DLSismoDetailViewController

@synthesize sismoData;
@synthesize webView;

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
    [self changeLabelValues];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)changeLabelValues{
   /* [self.magnitudLabel setText:sismoData.magnitude];
    [self.depthLabel setText:[NSString stringWithFormat:@"%f",sismoData.profundidad]];
    [self.localizacionLabel setText:sismoData.ubicacion];
    [self.dateLabel setText:sismoData.datetime];
    [self.coordenadasLabel setText:[NSString stringWithFormat:@"%.02f y %.02f",sismoData.latitude,sismoData.longitud] ];*/
    [self.sismoTitleLabel setText:[NSString stringWithFormat:@"%@",self.sismoData.title]];
    
    NSString *hthmlFixed=[sismoData.contentHtml stringByReplacingOccurrencesOfString:@"<img" withString:@"<img style=\"width:255px\" "];
	NSLog(@"content %@",hthmlFixed);
    [self.webView loadHTMLString:hthmlFixed baseURL:nil];
}

-(void)setSismoDataVO:(DLSismoVO*)sismoDataVO{
    [self setSismoData:sismoDataVO];
    /*[self.magnitudLabel setText:sismoDataVO.magnitude];
    [self.depthLabel setText:[NSString stringWithFormat:@"%f",sismoDataVO.profundidad]];
    [self.localizacionLabel setText:sismoDataVO.ubicacion];
    [self.dateLabel setText:sismoDataVO.datetime];
    [self.coordenadasLabel setText:[NSString stringWithFormat:@"%f y %f",sismoDataVO.latitude,sismoDataVO.longitud] ];*/
}

@end
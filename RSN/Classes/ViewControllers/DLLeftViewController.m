//
//  DLLeftViewController.m
//  RSN
//
//  Created by jossiecs on 12/17/13.
//  Copyright (c) 2013 DreamLabs. All rights reserved.
//

#import "DLLeftViewController.h"

@interface DLLeftViewController ()

@property (nonatomic, weak) IBOutlet UITableView *myTableView;

@property (nonatomic, strong) NSArray *arrayOfItems;
@property (weak, nonatomic) IBOutlet UIButton *sendSuggestionsButton;




@end

@implementation DLLeftViewController

NSString * const DLLeftSismosItem = @"Sismos";
NSString * const DLLeftNoticiasItem = @"Noticias";
NSString * const DLLeftContactoItem = @"Contacto";
NSString * const DLLeftConfiguracionItem = @"Configuracion";
NSString * const DLLeftSugerenciasItem = @"Sugerencias";
NSString * const DLLeftUltimosSismosItem = @"UltimosSismos";
NSString * const DLLeftSismosContainerItem = @"SismosContainer";


- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupMenuItems];
    /*
    if (!isiPhone5) {
        self.fbButtonConstraintHeight.constant = 40;
        self.fbButtonConstraintWidth.constant = 40;
        
        self.twitterButtonConstraintWidth.constant = 40;
        self.twitterButtonConstraintHeight.constant = 40;
        
        self.twitterButtonConstraintTop.constant = 5;
        self.fbButtonConstraintTop.constant = 5;
        
        self.fbButtonConstraintLeft.constant = 90;
    }*/
}



-(void)setupMenuItems{
    
    
    self.arrayOfItems = @[DLLeftSismosContainerItem, DLLeftNoticiasItem, DLLeftContactoItem, DLLeftConfiguracionItem];
    
    
    [self.myTableView reloadData];
    self.myTableView.scrollEnabled = NO;
    /*
    if (!isiPhone5) {
        self.ucrLogoBottomConstraint.constant = 10;
        self.iceLogoBottomConstraint.constant = 10;
    }*/
}

#pragma mark - ButtonHandler
- (IBAction)facebokHandler:(id)sender{
    
    NSURL *fanPageURL;
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]]) {
        fanPageURL = [NSURL URLWithString:@"fb://profile/266416453421935"];
    }else{
        fanPageURL = [NSURL URLWithString:@"https://www.facebook.com/RSN.CR"];
    }
    
    [[UIApplication sharedApplication] openURL:fanPageURL];
}

- (IBAction)twitterHandler:(id)sender{
    NSURL *twitterPageURL;
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]]) {
        twitterPageURL = [NSURL URLWithString:@"twitter://user?screen_name=RSNcostarica"];
    }else{
        twitterPageURL = [NSURL URLWithString:@"https://twitter.com/RSNcostarica"];
    }
    
    [[UIApplication sharedApplication] openURL:twitterPageURL];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [self.arrayOfItems objectAtIndex:indexPath.row];
  
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:0.961 green:0.51 blue:0.125 alpha:1]; /*#f58220*/
    [cell setSelectedBackgroundView:bgColorView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *itemSelected = [self.arrayOfItems objectAtIndex:indexPath.row];
    [_delegate itemMenuSelected:itemSelected];
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

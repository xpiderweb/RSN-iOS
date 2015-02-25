//
//  DLNoticiasTableViewController.m
//  RSN
//
//  Created by jossiecs on 4/3/14.
//  Copyright (c) 2014 DreamLabs. All rights reserved.
//

#import "DLNoticiasTableViewController.h"
#import "DLRSNModel.h"
#import "DLNoticiasTableViewCell.h"
#import "DLNoticiaVO.h"
#import "DLCenterViewController.h"
#import "DLNoticiaDetalleViewController.h"

@interface DLNoticiasTableViewController ()
@property (nonatomic,strong) NSMutableArray *noticiasArray;
@property (nonatomic,strong) NSDictionary *noticiasDict;
@property (nonatomic, strong) DLCenterViewController *centerViewController;
@end

@implementation DLNoticiasTableViewController

@synthesize noticiasArray,noticiasDict;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.tableView.contentInset = inset;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveLastNoticiasWithNotification:) name:DLModelDidReceiveLastNoticias object:nil];
    [[DLRSNModel sharedInstance]getLastNoticias];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    //label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]; // change this color
    self.navigationItem.titleView = label;
    label.text = @"Últimas Noticias";//NSLocalizedString(@"PageThreeTitle", @"");
    [label sizeToFit];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Atrás" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    
}


-(void)didReceiveLastNoticiasWithNotification:(NSNotification*)notification{
    noticiasArray = (NSMutableArray*)notification.object;
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    if(noticiasArray != nil){
        return noticiasArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NoticiaCell";
    DLNoticiasTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    DLNoticiaVO *noticiaVO = [noticiasArray objectAtIndex:indexPath.row];

    //[cell.date setText:[formatter stringFromDate:noticiaVO.date]];
    [cell.title setText:noticiaVO.title];
    [cell.title setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:8]];
    //[cell.date setFont:[ UIFont fontWithName:@"OpenSans-Light" size:5]];
    
    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
    
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cellBackgroundView.image = background;
    cell.backgroundView = cellBackgroundView;
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:0.961 green:0.51 blue:0.125 alpha:1];
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowCount = [self tableView:[self tableView] numberOfRowsInSection:0];
    NSInteger rowIndex = indexPath.row;
    UIImage *background = nil;
    
    if (rowIndex == 0) {
        background = [UIImage imageNamed:@"cell_top.png"];
    } else if (rowIndex == rowCount - 1) {
        background = [UIImage imageNamed:@"cell_bottom.png"];
    } else {
        background = [UIImage imageNamed:@"cell_middle.png"];
    }
    
    return background;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
     bundle: nil];
    DLNoticiaVO *noticiaVO = [noticiasArray objectAtIndex:indexPath.row];
    
     DLNoticiaDetalleViewController *noticiaDetail = (DLNoticiaDetalleViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"DLNoticiaDetalleViewController"];
     [noticiaDetail setNoticiaVO:noticiaVO];
     [self.navigationController pushViewController:noticiaDetail animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

@end

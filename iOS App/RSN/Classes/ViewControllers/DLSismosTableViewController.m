//
//  DLSismosTableViewController.m
//  RSN
//
//  Created by jossiecs on 3/27/14.
//  Copyright (c) 2014 DreamLabs. All rights reserved.
//

#import "DLSismosTableViewController.h"
#import "DLRSNModel.h"
#import "Logging.h"
#import "DLSismoVO.h"
#import "DLSismoDetailViewController.h"


@interface DLSismosTableViewController ()<UITableViewDelegate>{
    NSString *tableTitle;
}


@property (nonatomic,strong) NSMutableArray *sismosArray;
@property (nonatomic,strong) NSDictionary *sismosDictionary;

@end

@implementation DLSismosTableViewController

NSString* const DLSismosTableViewControllerItemSelected = @"DLSismosTableViewControllerItemSelected";

@synthesize sismosArray;
@synthesize sismosDictionary;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.tableView setDelegate:self];
    tableTitle = @"Últimos 10 sismos";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveLastSismosWithNotification:) name:DLModelDidReceiveLast10Sismos object:nil];
}


-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)didReceiveLastSismosWithNotification:(NSNotification*)notification{
    //sismosArray = notification.object;
    NSMutableArray *temp = notification.object;
        switch (temp.count) {
            case 0:{
                NSLog(@"counting +1");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atención"
                                                                message:@"No hay sismos para la fecha indicada."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            [[NSNotificationCenter defaultCenter]removeObserver:self];
            }break;
            default:{
                if (temp.count < 10) {
                    tableTitle = @"Resultados de búsqueda";
                }
            }break;
        }
        sismosArray = (NSMutableArray*)[self getSortedArray:temp];
    
    [self.tableView reloadData];
}

-(void) reloadTableData{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveLastSismosWithNotification:) name:DLModelDidReceiveLastSismosForTableView object:nil];
}

- (NSArray*) getSortedArray: (NSMutableArray*) unsortedArray{
    NSComparisonResult (^sortBlock)(id, id) = ^(id obj1, id obj2) {
        NSString* title1 = [obj1 title];
        NSString* title2 = [obj2 title];
        
        if([title1 compare:title2] == NSOrderedAscending){
            return (NSComparisonResult) NSOrderedDescending;
        }
        else if([title1 compare:title2] == NSOrderedDescending){
            return (NSComparisonResult) NSOrderedAscending;
        }else{
            return (NSComparisonResult) NSOrderedSame;
        }
        
    };
    
    return unsortedArray; //[unsortedArray sortedArrayUsingComparator:sortBlock];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(sismosArray){
        return sismosArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Sismo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    cell.textLabel.numberOfLines = 2;
    [cell.textLabel setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:8]];
    cell.textLabel.textColor = [UIColor colorWithRed:0.055 green:0.49 blue:0.761 alpha:1]; /*#0e7dc2*/
    cell.textLabel.highlightedTextColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1]; /*#ffffff*/
    DLSismoVO *sismoVO = [sismosArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@",sismoVO.title]];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:0.961 green:0.51 blue:0.125 alpha:1]; /*#f58220*/
    [cell setSelectedBackgroundView:bgColorView];
    return cell;
}

- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath{
    return 85;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)] ;
    UIImage *myImage = [UIImage imageNamed:@"RSN-Sismos-TableHeader"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage] ;
    imageView.frame = CGRectMake(15,0,tableView.bounds.size.width-15,30);
    
    [headerView addSubview:imageView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 3, tableView.bounds.size.width-15, 18)];
    label.text = tableTitle;
    label.backgroundColor = [UIColor clearColor];
    label.center = imageView.center;
    label.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:label];
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DLSismoVO *sismoVO = [sismosArray objectAtIndex:indexPath.row];
    NSNotification *notification = [NSNotification notificationWithName:DLSismosTableViewControllerItemSelected object:sismoVO];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
}
-(void)getSismosWithDateString: (NSString*)dateString{
    [[DLRSNModel sharedInstance]getSismosForTableViewWithDate:dateString];
}

-(void) getLastTenSismos{
    [[DLRSNModel sharedInstance]getLast10Sismos];
    tableTitle = @"Últimos 10 sismos";
    self.getToday= NO;
}

- (void) cleanTable{
    sismosArray= [[NSMutableArray alloc] init];
}
@end

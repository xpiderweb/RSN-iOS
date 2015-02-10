//
//  DLSismosTableViewController.h
//  RSN
//
//  Created by jossiecs on 3/27/14.
//  Copyright (c) 2014 DreamLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLSismoVO.h"
@protocol DLSismosTableViewControllerDelegate<NSObject>

@required
- (void)sismoSelected:(DLSismoVO *)sismoSelected;

@end

@interface DLSismosTableViewController : UITableViewController

@property (nonatomic,weak) id<DLSismosTableViewControllerDelegate>delegate;
@property (nonatomic,assign) BOOL getToday;
@property (nonatomic,assign) BOOL noSismosResponse;

extern NSString* const DLSismosTableViewControllerItemSelected;

-(void) reloadTableData;
-(void) getLastTenSismos;
-(void)getSismosWithDateString: (NSString*)dateString;
- (void) cleanTable;
@end

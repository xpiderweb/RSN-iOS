//
//  DLRSNModel.m
//  RSN
//
//  Created by jossiec on 1/14/14.
//  Copyright (c) 2014 DreamLabs. All rights reserved.
//

#import "DLRSNModel.h"
#import <AFNetworking.h>
#import <AFNetworkActivityIndicatorManager.h>
#import "DLNoticiaVO.h"
#import "DLSismoVO.h"
//#define SERVER_URL  @"http://192.168.2.102/ios" //dev
#define SERVER_URL @"http://163.178.105.86/ios"


@implementation DLRSNModel

NSString * const DLModelDidReceiveLastSismos = @"DidReceiveLastSismos";
NSString * const DLModelDidReceiveLast10Sismos = @"DidReceiveLast10Sismos";
NSString * const DLModelDidReceiveLastSismosForTableView = @"DidReceiveLastSismosForTableView";
NSString * const DLModelDidReceiveLastNoticias = @"DLModelDidReceiveLastNoticias";


+(DLRSNModel *) sharedInstance {
    static dispatch_once_t pred;
    static id shared = nil;
    dispatch_once(&pred, ^{
        shared = [[super alloc] initUniqueInstance];
    });
    return shared;
}

-(DLRSNModel *) initUniqueInstance {
    return [super init];
}


-(void)getLastNoticias{
    NSArray *keys = [[NSArray alloc] initWithObjects:@"action", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:@"lastNoticias", nil];
    NSDictionary *parameters = [[NSDictionary alloc]initWithObjects:values forKeys:keys];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    //[manager GET:@"http://localhost/RSN-Server/seismics.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSString *urlString = [NSString stringWithFormat:@"%@/seismics.php",SERVER_URL];
    [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        //[self.delegate didReceiveLastSismosWithString:responseObject];
        NSDictionary *info = (NSDictionary*)responseObject;
 
        NSMutableArray *sismosArray = [[NSMutableArray alloc]init];
        for (NSDictionary * row in info) {
            DLNoticiaVO *noticiaVO = [[DLNoticiaVO alloc]init];
            
            //Title
            [noticiaVO setTitle:[row objectForKey:@"title"]];
            
            //Content
            [noticiaVO setContentHTML:[row objectForKey:@"introtext"]];
            [sismosArray addObject:noticiaVO];
        }
        
        NSNotification *notification = [NSNotification notificationWithName:DLModelDidReceiveLastNoticias object:sismosArray];
        [[NSNotificationCenter defaultCenter]postNotification:notification];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


- (void) getLast10Sismos{
    NSArray *keys = [[NSArray alloc] initWithObjects:@"action", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:@"last10SismosLista", nil];
    NSDictionary *parameters = [[NSDictionary alloc]initWithObjects:values forKeys:keys];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    NSString *urlString = [NSString stringWithFormat:@"http://rsnapi.herokuapp.com:80/api/seisms/getLastTenSeisms"];
    [manager.requestSerializer setValue:@"547406e0fa85847666283b61" forHTTPHeaderField:@"Api-key"];
    
    [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDic = (NSDictionary*)responseObject;
        
        NSDictionary *info = [(NSDictionary*) responseDic objectForKey:@"seisms"];
        
        NSMutableArray *sismos = [[NSMutableArray alloc]init];
        
        for (NSDictionary *row in info) {
            DLSismoVO *sismoVO = [[DLSismoVO alloc]init];
            [sismoVO setTitle:[row objectForKey:@"title"]];
            [sismoVO setContentHtml:[row objectForKey:@"introtext"]];
            [sismos addObject:sismoVO];
        }
        
        NSNotification *notification = [NSNotification notificationWithName:DLModelDidReceiveLast10Sismos object:sismos];
        [[NSNotificationCenter defaultCenter]postNotification:notification];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}
-(void)getLastSismos{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateStyle:NSDateFormatterShortStyle];
    [dateFormat setDateFormat:@"yyyy'/'MM'/'dd"];
    [dateFormat setDateFormat:@"yyyy/MM/dd"];
    
    
    NSString *dateString = [dateFormat stringFromDate:date];
    NSArray *keys = [[NSArray alloc] initWithObjects:@"action",@"date", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:@"lastSismosByDateMap",dateString, nil];
    
    NSDictionary *parameters = [[NSDictionary alloc]initWithObjects:values forKeys:keys];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    //NSString *urlString = [NSString stringWithFormat:@"%@/seismics.php",SERVER_URL];
    NSString *urlString = [NSString stringWithFormat:@"http://rsnapi.herokuapp.com:80/api/seisms/getLastDaySeisms"];
    [manager.requestSerializer setValue:@"547406e0fa85847666283b61" forHTTPHeaderField:@"Api-key"];
    [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *info1 = (NSDictionary*)responseObject;
        NSDictionary *info = info1[@"seisms"];
        NSNotification *notification = [NSNotification notificationWithName:DLModelDidReceiveLastSismos object:self userInfo:info];
        [[NSNotificationCenter defaultCenter]postNotification:notification];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void)getSismosForTableViewWithDate:(NSString*)dateString{
    //LogInfo(@"date: %@",dateString);
    NSArray *keys = [[NSArray alloc] initWithObjects:@"action",@"date", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:@"lastSismosByDate",dateString, nil];
    NSDictionary *parameters = [[NSDictionary alloc]initWithObjects:values forKeys:keys];
    NSLog(@"%@", parameters);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    //[manager GET:@"http://localhost/RSN-Server/seismics.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSString *urlString = [NSString stringWithFormat:@"http://rsnapi.herokuapp.com:80/api/seisms/getLastSeismsByDate"];
    [manager.requestSerializer setValue:@"547406e0fa85847666283b61" forHTTPHeaderField:@"Api-key"];
    [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDic = (NSDictionary*)responseObject;
        NSLog(@"%@", responseObject);
        NSDictionary *info = [(NSDictionary*) responseDic objectForKey:@"seisms"];
        NSMutableArray *sismos = [[NSMutableArray alloc]init];
        
        for (NSDictionary *row in info) {
            DLSismoVO *sismoVO = [[DLSismoVO alloc]init];
            [sismoVO setTitle:[row objectForKey:@"title"]];
            [sismoVO setContentHtml:[row objectForKey:@"introtext"]];
            [sismos addObject:sismoVO];
        }
        
        
        NSNotification *notification = [NSNotification notificationWithName:DLModelDidReceiveLastSismosForTableView object:sismos];
        [[NSNotificationCenter defaultCenter]postNotification:notification];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void)getLastSismosByWeek{
    NSArray *keys = [[NSArray alloc] initWithObjects:@"action", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:@"lastSismosByweek", nil];
    NSDictionary *parameters = [[NSDictionary alloc]initWithObjects:values forKeys:keys];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    //[manager GET:@"http://localhost/RSN-Server/seismics.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //NSString *urlString = [NSString stringWithFormat:@"%@/seismics.php",SERVER_URL];
    NSString *urlString = [NSString stringWithFormat:@"http://rsnapi.herokuapp.com:80/api/seisms/getLastWeekSeisms"];
    [manager.requestSerializer setValue:@"547406e0fa85847666283b61" forHTTPHeaderField:@"Api-key"];
    [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        
        //[self.delegate didReceiveLastSismosWithString:responseObject];
        NSDictionary *info1 = (NSDictionary*)responseObject;
        NSDictionary *info = info1[@"seisms"];
        NSNotification *notification = [NSNotification notificationWithName:DLModelDidReceiveLastSismos object:self userInfo:info];
        [[NSNotificationCenter defaultCenter]postNotification:notification];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


@end

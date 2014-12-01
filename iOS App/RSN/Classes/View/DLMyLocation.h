//
//  DLMyLocation.h
//  RSN
//
//  Created by jossiecs on 1/14/14.
//  Copyright (c) 2014 DreamLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface DLMyLocation : NSObject<MKAnnotation>{
    NSString *_size;
    NSString *_address;
    CLLocationCoordinate2D _coordinate;
}

@property (copy) NSString *size;
@property (copy) NSString *address;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic) int color;

- (id)initWithSize:(NSString*)size address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;


@end

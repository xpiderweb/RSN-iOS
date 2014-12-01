//
//  DLMyLocation.m
//  RSN
//
//  Created by jossiecs on 1/14/14.
//  Copyright (c) 2014 DreamLabs. All rights reserved.
//

#import "DLMyLocation.h"

@implementation DLMyLocation

@synthesize size = _size;
@synthesize address = _address;
@synthesize coordinate = _coordinate;
@synthesize color;
- (id)initWithSize:(NSString*)size address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        _size = [size copy];
        _address = [address copy];
        _coordinate = coordinate;
    }
    return self;
}

- (NSString *)title {
    if ([_size isKindOfClass:[NSNull class]])
        return @"Unknown charge";
    else
        return _size;
}

- (NSString *)subtitle {
    return _address;
}



@end

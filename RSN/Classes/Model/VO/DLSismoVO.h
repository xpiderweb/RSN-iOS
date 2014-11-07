//
//  DLSismoVO.h
//  RSN
//
//  Created by jossiecs on 4/1/14.
//  Copyright (c) 2014 DreamLabs. All rights reserved.
//

#import "ValueObject.h"

@interface DLSismoVO : ValueObject

@property (nonatomic,strong) NSString *datetime;
@property (nonatomic,strong) NSString *magnitude;
@property (nonatomic,strong) NSString *ubicacion;
@property (nonatomic,strong) NSString *contentHtml;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,assign) float latitude;
@property (nonatomic,assign) float longitud;
@property (nonatomic,assign) float profundidad;


@end

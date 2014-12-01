//
//  DLNoticiaVO.h
//  RSN
//
//  Created by jossiecs on 4/4/14.
//  Copyright (c) 2014 DreamLabs. All rights reserved.
//

#import "ValueObject.h"

@interface DLNoticiaVO : ValueObject
@property (nonatomic,strong) NSDate *date;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *contentHTML;
@end

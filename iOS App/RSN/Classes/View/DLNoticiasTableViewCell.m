    //
//  DLNoticiasTableViewCell.m
//  RSN
//
//  Created by jossiecs on 4/3/14.
//  Copyright (c) 2014 DreamLabs. All rights reserved.
//

#import "DLNoticiasTableViewCell.h"

@implementation DLNoticiasTableViewCell
@synthesize title;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  FilterCell.m
//  Placeley
//
//  Created by APR on 12/22/13.
//  Copyright (c) 2013 APR. All rights reserved.
//

#import "FilterCell.h"

@implementation FilterCell

@synthesize lblFiltername;
@synthesize btnCheckbox;
@synthesize imgCellBackground;

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

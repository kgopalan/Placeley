//
//  LocalTrendscustomCell.m
//  Test
//
//  Created by Rajesh on 18/12/13.
//  Copyright (c) 2013 Rajesh. All rights reserved.
//

#import "LocalTrendscustomCell.h"

@implementation LocalTrendscustomCell

@synthesize imgViewLocalTrends =_imgViewLocalTrends;
@synthesize lblLocalTrendsAddress=_lblLocalTrendsAddress;
@synthesize lblLocalTrendsTitle=_lblLocalTrendsTitle;
@synthesize asynImgView;

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

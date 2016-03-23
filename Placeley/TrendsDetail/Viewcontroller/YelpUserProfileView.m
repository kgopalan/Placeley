//
//  YelpUserProfileView.m
//  Placeley
//
//  Created by APR on 12/21/13.
//  Copyright (c) 2013 APR. All rights reserved.
//

#import "YelpUserProfileView.h"

@implementation YelpUserProfileView

@synthesize review;
@synthesize name;
@synthesize lblRatingImage;
@synthesize lblProfileUrlImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

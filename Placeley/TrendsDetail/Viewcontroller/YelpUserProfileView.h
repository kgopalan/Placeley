//
//  YelpUserProfileView.h
//  Placeley
//
//  Created by APR on 12/21/13.
//  Copyright (c) 2013 APR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YelpUserProfileView : UIView
{
    
}

@property(nonatomic,strong) IBOutlet UILabel *review;
@property(nonatomic,strong) IBOutlet UILabel *name;
@property(nonatomic,strong) IBOutlet UIImageView *lblRatingImage;
@property(nonatomic,strong) IBOutlet UIImageView *lblProfileUrlImage;

@end

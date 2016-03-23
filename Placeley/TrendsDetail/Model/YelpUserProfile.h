//
//  YelpProfile.h
//  Placeley
//
//  Created by APR on 12/21/13.
//  Copyright (c) 2013 APR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YelpUserProfile : NSObject
{
    NSString *rating_img;
    NSString *name;
    NSString *profile_url;
    NSString *review;
}

@property (nonatomic , retain) NSString *rating_img;
@property (nonatomic , retain) NSString *name;
@property (nonatomic , retain) NSString *profile_url;
@property (nonatomic , retain) NSString *review;

@end

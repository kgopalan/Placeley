//
//  Yelp.h
//  Placeley
//
//  Created by APR on 12/21/13.
//  Copyright (c) 2013 APR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Yelp : NSObject
{
    NSString *rating;
    NSString *rating_img;
    NSMutableArray *userProfileDataArr;
    NSString *url;
}

@property (nonatomic , retain) NSString *rating;
@property (nonatomic , retain) NSString *rating_img;
@property (nonatomic , retain) NSMutableArray *userProfileDataArr;
@property (nonatomic , retain) NSString *url;
@end

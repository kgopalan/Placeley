//
//  TwitterHashTagsdate.h
//  Placeley
//
//  Created by APR on 12/18/13.
//  Copyright (c) 2013 APR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitterHashTagsdate : NSObject
{
    NSString *tweet;
    NSString *profileUrl;
    NSString *name;
}

@property (nonatomic , retain) NSString *tweet;
@property (nonatomic , retain) NSString *profileUrl;
@property (nonatomic , retain) NSString *name;

@end

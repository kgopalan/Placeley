//
//  Twitter.h
//  Placeley
//
//  Created by APR on 12/18/13.
//  Copyright (c) 2013 APR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Twitter : NSObject
{
    NSString *followers;
    NSString *following;
    NSString *total_tweet;
    NSString *name;
    NSString *location;
    NSString *description;
    NSString *url;
    NSString *handle;
    NSString *hash_tags;
    
    NSMutableArray *handlerdataArray;
    NSMutableArray *hashtagsdataArray;
}

@property (nonatomic , retain) NSString *followers;
@property (nonatomic , retain) NSString *following;
@property (nonatomic , retain) NSString *total_tweet;
@property (nonatomic , retain) NSString *name;
@property (nonatomic , retain) NSString *location;
@property (nonatomic , retain) NSString *description;
@property (nonatomic , retain) NSString *url;
@property (nonatomic , retain) NSString *handle;
@property (nonatomic , retain) NSString *hash_tags;

@property (nonatomic , retain) NSMutableArray *handlerdataArray;
@property (nonatomic , retain) NSMutableArray *hashtagsdataArray;

@end

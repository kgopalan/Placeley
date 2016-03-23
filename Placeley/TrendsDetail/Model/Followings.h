//
//  Followings.h
//  Placeley
//
//  Created by APR on 2/13/14.
//  Copyright (c) 2014 APR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Followings : NSObject
{
    NSString *logo_url;
    NSString *open_now;
    NSString *post_name;
    NSString *pre_name;

    NSString *address;
    NSString *followers_count;
    NSString *likers_count;
    NSMutableArray *photos_url;
    NSMutableArray *follower_ids;
    NSMutableArray *liker_ids;
    NSString *place_id;
    NSString *my_network;
}

@property (nonatomic , retain) NSString *logo_url;
@property (nonatomic , retain) NSString *open_now;
@property (nonatomic , retain) NSString *post_name;
@property (nonatomic , retain) NSString *address;
@property (nonatomic , retain) NSString *followers_count;
@property (nonatomic , retain) NSString *likers_count;
@property (nonatomic , retain) NSMutableArray *photos_url;
@property (nonatomic , retain) NSMutableArray *follower_ids;
@property (nonatomic , retain) NSMutableArray *liker_ids;
@property (nonatomic , retain) NSString *place_id;
@property (nonatomic , retain) NSString *pre_name;

@property (assign) BOOL IsFollowing;
@property (assign) BOOL IsLike;

@property (nonatomic , retain) NSString *my_network;
@end

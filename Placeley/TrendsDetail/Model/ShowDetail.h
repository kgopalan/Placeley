//
//  ShowDetail.h
//  Placeley
//
//  Created by APR on 12/19/13.
//  Copyright (c) 2013 APR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowDetail : NSObject
{
    NSString *open_now;
    NSString *post_name;
    NSString *pre_name;
    NSString *address;
    NSString *subaddress;
    NSString *open_between;
    NSString *direct;
    NSString *followers_count;
    NSString *phone_number;
    NSString *website_url;
    NSString *logo_url;
    NSString *likers_count;
    NSMutableArray *imageArray;
    NSMutableArray *follower_ids;
    NSMutableArray *liker_ids;
    NSString *place_id;
    NSString *my_network;
    
    NSString *events;
    NSString *deals;
    NSString *updates;

}

@property (nonatomic , retain) NSString *open_now;
@property (nonatomic , retain) NSString *post_name;
@property (nonatomic , retain) NSString *pre_name;
@property (nonatomic , retain) NSString *address;
@property (nonatomic , retain) NSString *subaddress;
@property (nonatomic , retain) NSString *open_between;
@property (nonatomic , retain) NSString *followers_count;
@property (nonatomic , retain) NSString *phone_number;
@property (nonatomic , retain) NSString *website_url;
@property (nonatomic , retain) NSString *logo_url;
@property (nonatomic , retain) NSString *likers_count;
@property (nonatomic , retain) NSMutableArray *imageArray;
@property (nonatomic , retain) NSMutableArray *follower_ids;
@property (nonatomic , retain) NSMutableArray *liker_ids;
@property (nonatomic , retain) NSString *place_id;
@property (nonatomic , retain) NSString *my_network;
@property (nonatomic , retain) NSString *events;
@property (nonatomic , retain) NSString *deals;
@property (nonatomic , retain) NSString *updates;

@end

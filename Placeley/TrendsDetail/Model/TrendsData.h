//
//  GlobalTrends.h
//  Placeley
//
//  Created by APR on 12/22/13.
//  Copyright (c) 2013 APR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrendsData : NSObject

{
    NSString *id_trend;
    NSString *address;
    NSString *city;
    NSString *city_country;
    NSString *computed_name;
    NSString *country;
    NSString *formal_address;
    NSString *formal_name;
    NSString *identifier;
    NSString *name;
    NSString *timezone;
    NSString *open_now;
    NSString *post_name;
    NSString *likers_count;
    NSString *pre_name;
    NSString *followers_count;
    NSString *phone_number;
    NSString *recommend_count; // integer
    NSString *logo_url;
    NSString *website_url;
    NSString *my_network;  // integet
    NSString *open_between;
    NSString *user_id;
    
    NSMutableArray *follower_ids;
    NSMutableArray *location;
    NSMutableArray *photos_url;
    NSMutableArray *place_url;
    
    NSMutableArray *locationLatLngGlobalList;
    NSMutableArray *categoryNameArray;
}

@property (nonatomic , retain)NSString *id_trend;
@property (nonatomic , retain)NSString *address;
@property (nonatomic , retain)NSString *city;
@property (nonatomic , retain)NSString *city_country;
@property (nonatomic , retain)NSString *computed_name;
@property (nonatomic , retain)NSString *country;
@property (nonatomic , retain)NSString *formal_address;
@property (nonatomic , retain)NSString *formal_name;
@property (nonatomic , retain)NSString *identifier;
@property (nonatomic , retain)NSString *name;
@property (nonatomic , retain)NSString *timezone;
@property (nonatomic , retain)NSString *open_now;
@property (nonatomic , retain)NSString *post_name;
@property (nonatomic , retain)NSString *likers_count;
@property (nonatomic , retain)NSString *pre_name;
@property (nonatomic , retain)NSString *followers_count;
@property (nonatomic , retain)NSString *phone_number;
@property (nonatomic , retain)NSString *recommend_count; // integer
@property (nonatomic , retain)NSString *logo_url;
@property (nonatomic , retain)NSString *website_url;
@property (nonatomic , retain)NSString *my_network;  // integet
@property (nonatomic , retain)NSString *open_between;
@property (nonatomic , retain)NSString *user_id;

@property (nonatomic , retain)NSMutableArray *follower_ids;
@property (nonatomic , retain)NSMutableArray *location;
@property (nonatomic , retain)NSMutableArray *photos_url;
@property (nonatomic , retain)NSMutableArray *place_url;

@property (nonatomic , retain)NSMutableArray *locationLatLngGlobalList;

@property (nonatomic , retain)NSMutableArray *categoryNameArray;



@end

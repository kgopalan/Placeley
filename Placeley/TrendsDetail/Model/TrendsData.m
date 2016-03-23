//
//  GlobalTrends.m
//  Placeley
//
//  Created by APR on 12/22/13.
//  Copyright (c) 2013 APR. All rights reserved.
//

#import "TrendsData.h"

@implementation TrendsData

@synthesize id_trend;
@synthesize address;
@synthesize city;
@synthesize city_country;
@synthesize computed_name;
@synthesize country;
@synthesize formal_address;
@synthesize formal_name;
@synthesize identifier;
@synthesize name;
@synthesize timezone;
@synthesize open_now;
@synthesize post_name;
@synthesize likers_count;
@synthesize pre_name;
@synthesize followers_count;
@synthesize phone_number;
@synthesize recommend_count; // integer
@synthesize logo_url;
@synthesize website_url;
@synthesize my_network;  // integet
@synthesize open_between;
@synthesize user_id;

@synthesize follower_ids;
@synthesize location;
@synthesize photos_url;
@synthesize place_url;

@synthesize locationLatLngGlobalList;

@synthesize categoryNameArray;



-(void)encodeWithCoder:(NSCoder *)encoder

{
    [encoder encodeObject:id_trend forKey:@"id_trend"];
    
    [encoder encodeObject:address forKey:@"address"];
    
    [encoder encodeObject:city forKey:@"city"];
    
    [encoder encodeObject:computed_name forKey:@"computed_name"];
    
    [encoder encodeObject:country forKey:@"country"];
    
    [encoder encodeObject:formal_address forKey:@"formal_address"];
    
    
    
    [encoder encodeObject:formal_name forKey:@"formal_name"];
    
    [encoder encodeObject:identifier forKey:@"identifier"];
    
    [encoder encodeObject:name forKey:@"name"];
    
    [encoder encodeObject:timezone forKey:@"timezone"];
    
    [encoder encodeObject:open_now forKey:@"open_now"];
    
    [encoder encodeObject:post_name forKey:@"post_name"];
    
    [encoder encodeObject:followers_count forKey:@"followers_count"];
    
    [encoder encodeObject:phone_number forKey:@"phone_number"];
    
    
    
    [encoder encodeObject:recommend_count forKey:@"recommend_count"];
    
    [encoder encodeObject:logo_url forKey:@"logo_url"];
    
    [encoder encodeObject:website_url forKey:@"website_url"];
    
    [encoder encodeObject:my_network forKey:@"my_network"];
    
    [encoder encodeObject:open_between forKey:@"open_between"];
    
    [encoder encodeObject:user_id forKey:@"user_id"];
    
    
    
    [encoder encodeObject:follower_ids forKey:@"follower_ids"];
    
    [encoder encodeObject:location forKey:@"location"];
    
    [encoder encodeObject:photos_url forKey:@"photos_url"];
    
    [encoder encodeObject:place_url forKey:@"place_url"];
    
    [encoder encodeObject:locationLatLngGlobalList forKey:@"locationLatLngGlobalList"];
    
    [encoder encodeObject:categoryNameArray forKey:@"categoryNameArray"];

    
}

-(id)initWithCoder:(NSCoder *)decoder

{
    
    id_trend  = [decoder decodeObjectForKey:@"id_trend"];
    
    address  = [decoder decodeObjectForKey:@"address"];
    
    city  = [decoder decodeObjectForKey:@"city"];
    
    computed_name  = [decoder decodeObjectForKey:@"computed_name"];
    
    country  = [decoder decodeObjectForKey:@"country"];
    
    formal_address  = [decoder decodeObjectForKey:@"formal_address"];
    
    
    
    formal_name  = [decoder decodeObjectForKey:@"formal_name"];
    
    identifier  = [decoder decodeObjectForKey:@"identifier"];
    
    name  = [decoder decodeObjectForKey:@"name"];
    
    timezone  = [decoder decodeObjectForKey:@"timezone"];
    
    open_now  = [decoder decodeObjectForKey:@"open_now"];
    
    post_name  = [decoder decodeObjectForKey:@"post_name"];
    
    followers_count  = [decoder decodeObjectForKey:@"followers_count"];
    
    phone_number  = [decoder decodeObjectForKey:@"phone_number"];
    
    
    
    recommend_count  = [decoder decodeObjectForKey:@"recommend_count"];
    
    logo_url  = [decoder decodeObjectForKey:@"logo_url"];
    
    website_url  = [decoder decodeObjectForKey:@"website_url"];
    
    my_network  = [decoder decodeObjectForKey:@"my_network"];
    
    open_between  = [decoder decodeObjectForKey:@"open_between"];
    
    user_id  = [decoder decodeObjectForKey:@"user_id"];
    
    
    
    follower_ids  = [decoder decodeObjectForKey:@"follower_ids"];
    
    location  = [decoder decodeObjectForKey:@"location"];
    
    photos_url  = [decoder decodeObjectForKey:@"photos_url"];
    
    place_url  = [decoder decodeObjectForKey:@"place_url"];
    
    locationLatLngGlobalList  = [decoder decodeObjectForKey:@"locationLatLngGlobalList"];
    
    categoryNameArray  = [decoder decodeObjectForKey:@"categoryNameArray"];

    return self;
}





@end

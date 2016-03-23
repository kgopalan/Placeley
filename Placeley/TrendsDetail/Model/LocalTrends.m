//
//  LocalTrends.m
//  Placeley
//
//  Created by APR on 12/20/13.
//  Copyright (c) 2013 APR. All rights reserved.
//

#import "LocalTrends.h"

@implementation LocalTrends

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
@synthesize locationLatLng;

//============

@synthesize Logname,token,uid,provider,email,expires_at;




+(NSString *)LoginDetails:(LocalTrends *) LocalObj
{
    NSMutableString *jsonStringBuilder = nil;
	NSString *jsonString = @"";
    
	@try
	{
        if (jsonStringBuilder == nil)
		{
			jsonStringBuilder = [[NSMutableString alloc] init];
		}
        [jsonStringBuilder appendFormat:@"{"];
        
        [jsonStringBuilder appendFormat:@"\"name\":\"%@\"",[LocalObj Logname]];
        [jsonStringBuilder appendFormat:@"\"token\":\"%@\"",[LocalObj token]];
        
        [jsonStringBuilder appendFormat:@"\"uid\":\"%@\"",[LocalObj uid]];

        [jsonStringBuilder appendFormat:@"\"provider\":\"%@\"",[LocalObj provider]];
        
        [jsonStringBuilder appendFormat:@"\"email\":\"%@\"",[LocalObj email]];
        
        [jsonStringBuilder appendFormat:@"\"expires_at\":\"%@\"",[LocalObj expires_at]];
        
        [jsonStringBuilder appendFormat:@"}"];
        
		jsonString = jsonStringBuilder;
        
	}
	@catch (NSException *exception)
	{
		
		jsonString=nil;
	}
	@finally
	{
		return jsonString;
	}
    
}

@end

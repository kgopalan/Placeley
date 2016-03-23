//
//  ServiceHelper.m
//  NYStateSnowmobiling
//
//  Created by Edward Elliott on 4/11/11.
//  Copyright 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "ServiceHelper.h"
#import "PlaceleyConstants.h"

@implementation ServiceHelper

//NSMutableData *_responseData;

//NSString *_rootUrl = @"https://placeley.com/";

//NSString *_roolUrlLat=@"lat=";

//NSString *_roolUrlLong=@"&long=";

//NSString *_roolUrlLocalTrends = @"http://zuppl.com/trend/geolocation.json?";
//NSString *_roolUrlGlobalTrends = @"https://placeley.com/";
//http://zuppl.com/trend/geolocation.json?lat=12.977540&long=77.599510

@synthesize urls, requests, receivedDatas, finishCount;


#pragma mark HTTP Methods

+ (NSString *)stringWithUrl:(NSURL *)url postData:(NSData *)postData httpMethod:(NSString *)method
{
	NSString *jsonString = nil;
	
	@try
	{
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        
        [urlRequest setHTTPMethod:method];
        
        if(postData != nil)
        {
            [urlRequest setHTTPBody:postData];
        }
        
        [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        NSData *urlData;
    
        NSURLResponse *response;
        
        NSError *error;
        
        urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                        returningResponse:&response
                                                    error:&error];
        
        jsonString = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
        
        return jsonString;
	}
	@catch (NSException *exception)
	{
		//NSLog(@"Error in ServiceHelper.stringWithUrl - Error: %@", [exception description]);
	}
	@finally
	{
		// //NSLog(@"Leaving stringWithUrl");
	}
}

+ (id) objectWithUrl:(NSURL *)url postData:(NSData *)postData httpMethod:(NSString *)method
{
	id theObject = nil;
	
	@try
	{
		NSString *jsonString = [self stringWithUrl:url postData:postData httpMethod:method];

		NSData *theJSONData = [NSData dataWithBytes:[jsonString UTF8String]
											 length:[jsonString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
		
		NSError *theError = nil;
		
		theObject = [[CJSONDeserializer deserializer] deserialize:theJSONData error:&theError];
	}
	@catch (NSException *exception)
	{
		theObject = nil;
	}
	@finally
	{
	}
	return theObject;
}

#pragma mark Login Methods

+(User *)createNewAccount:(NSString *)jsonString
{
    User *currentUser;
    
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/users/connect",_rootUrl];

        NSURL *serviceUrl = [NSURL URLWithString:[serviceOperationUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        
//        jsonString = @"{\"info\": {\"name\": \"Malai\",\"token\": \"ya29.1.AADtN_U6VlTgNaHW7tOTZE2ns5lDSfMjU4Wj9BKLaTOUECrzCzFThNH_TwAeddrV42Kn4w\",\"uid\": \"108457783310241364482\",\"expires_at\": \"2014/02/09 05:57:12 UTC\",\"email\": \"poomalai88@gmail.com\",\"provider\": \"google\"}}";
//        
//        NSLog(@"jsonString = %@",jsonString);
        
        NSLog(@"jsonString ==>%@",jsonString);

        NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy];
        
        id response = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
        
        NSLog(@"response ==>%@",response);

        if (response != nil)
        {
            currentUser = [self createUserObject:response];
            
            [self setUserDefault:response];
        }

        NSLog(@"currentUser ==>%@",currentUser);
        
    }
	@catch (NSException *exception)
	{
		currentUser = nil;
	}
	@finally
	{
		return currentUser;
	}
}


+(void)setUserDefault:(id)userObject
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Facebook"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Twitter Connect"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Instagram"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"FourSquare"];

    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] initWithDictionary:[userObject valueForKey:@"user"]];
    
    NSMutableDictionary *connectedDict = [[NSMutableDictionary alloc] initWithDictionary:[userDict valueForKey:@"connected"]];
    
    if ([connectedDict valueForKey:@"facebook"] != nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[self checkForNull:[connectedDict valueForKey:@"facebook"]] forKey:@"Facebook"];
    }
    if ([connectedDict valueForKey:@"twitter"] != nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[self checkForNull:[connectedDict valueForKey:@"twitter"]] forKey:@"Twitter Connect"];
    }
    if ([connectedDict valueForKey:@"instagram"] != nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[self checkForNull:[connectedDict valueForKey:@"instagram"]] forKey:@"Instagram"];
    }
    if ([connectedDict valueForKey:@"foursquare"] != nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[self checkForNull:[connectedDict valueForKey:@"foursquare"]] forKey:@"FourSquare"];
    }
}

+ (User *)createUserObject:(id)userObject
{
    User *userData = [[User alloc]init];
    
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] initWithDictionary:[userObject valueForKey:@"user"]];
    
    [userData setName:[self checkForNull:[ userDict valueForKey:@"name"]]];
    
    [userData setUserId:[self checkForNull:[userDict valueForKey:@"id"]]];

    [userData setPhone_number:[self checkForNull:[userDict valueForKey:@"phone_number"]]];
    
    [userData setAuth_token:[self checkForNull:[ userDict valueForKey:@"auth_token"]]];
    
    [userData setEmail:[self checkForNull:[ userDict valueForKey:@"email"]]];

    NSMutableDictionary *connectedDict = [[NSMutableDictionary alloc] initWithDictionary:[userDict valueForKey:@"connected"]];
    
    [userData setFacebook:[self checkForNull:[ connectedDict valueForKey:@"facebook"]]];
    
    [userData setTwitter:[self checkForNull:[connectedDict valueForKey:@"twitter"]]];
    
    [userData setInstagram:[self checkForNull:[connectedDict valueForKey:@"instagram"]]];
    
    [userData setFoursquare:[self checkForNull:[ connectedDict valueForKey:@"foursquare"]]];
    
    return userData;
}

#pragma mark Like / UnLike Methods

+(id)likePlace:(NSString *)likeid andAuthToken:(NSString *)authtoken
{
    id response = nil;
    
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/users/like?likable_type=Place&likable_id=%@&auth_token=%@",_rootUrl,likeid,authtoken];
        
        NSURL *serviceUrl = [NSURL URLWithString:[serviceOperationUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        
        response = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"POST"];
        
        NSLog(@"respons ==>%@",response);
        
    }
	@catch (NSException *exception)
	{
		response = nil;
	}
	@finally
	{
		return response;
	}
}

+(id)UnlikePlace:(NSString *)likeid andAuthToken:(NSString *)authtoken
{
    id response = nil;
    
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/users/unlike?likable_type=Place&likable_id=%@&auth_token=%@",_rootUrl,likeid,authtoken];
        
        NSURL *serviceUrl = [NSURL URLWithString:[serviceOperationUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        
        response = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"POST"];
        
        NSLog(@"respons ==>%@",response);
        
    }
	@catch (NSException *exception)
	{
		response = nil;
	}
	@finally
	{
		return response;
	}
}

#pragma mark Follow / Unfollow Methods

+(id)followPlace:(NSString *)jsonString andAuthToken:(NSString *)authtoken
{
    id response = nil;
    
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/places/follow?auth_token=%@",_rootUrl,authtoken];
        
        NSURL *serviceUrl = [NSURL URLWithString:[serviceOperationUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        
        NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy];

        response = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
        
        NSLog(@"respons ==>%@",response);
        
    }
	@catch (NSException *exception)
	{
		response = nil;
	}
	@finally
	{
		return response;
	}
}

+(id)unfollowPlace:(NSString *)placeid andAuthToken:(NSString *)authtoken
{
    id response = nil;
    
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/places/%@/unfollow?auth_token=%@",_rootUrl,placeid,authtoken];
        
        NSURL *serviceUrl = [NSURL URLWithString:[serviceOperationUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        
        response = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"POST"];
        
        NSLog(@"respons ==>%@",response);
        
    }
	@catch (NSException *exception)
	{
		response = nil;
	}
	@finally
	{
		return response;
	}
}

#pragma mark Post Comment Methods

+(void *)postCommentToImage:(NSString *)jsonString andPlaceId:(NSString *)placeId andAuthToken:(NSString *)authToken
{
    User *currentUser;
    
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@//places/%@/posts?auth_token=%@",_rootUrl,placeId,authToken];
        
        NSLog(@"serviceOperationUrl ==>%@",serviceOperationUrl);
        
        NSURL *serviceUrl = [NSURL URLWithString:[serviceOperationUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        
        NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy];
        
        id response = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
        
        NSLog(@"response ==>%@",response);
        
    }
	@catch (NSException *exception)
	{
		currentUser = nil;
	}
	@finally
	{
		return nil;
	}
}

+(void *)postComment:(NSString *)jsonString andPlaceId:(NSString *)placeId andAuthToken:(NSString *)authToken
{
    User *currentUser;
    
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@//places/%@/posts?auth_token=%@",_rootUrl,placeId,authToken];
        
        NSLog(@"serviceOperationUrl ==>%@",serviceOperationUrl);

        NSURL *serviceUrl = [NSURL URLWithString:[serviceOperationUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        
        NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy];
        
        id response = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
        
        NSLog(@"response ==>%@",response);
        
    }
	@catch (NSException *exception)
	{
		currentUser = nil;
	}
	@finally
	{
		return nil;
	}
}

+(void *)postFeedComment:(NSString *)jsonString andPlaceId:(NSString *)placeId andFeedId:(NSString *)feedId andAuthToken:(NSString *)authToken
{
    User *currentUser;
    
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/comments?auth_token=%@",_rootUrl,authToken];
        
        NSLog(@"serviceOperationUrl ==>%@",serviceOperationUrl);
        
        NSURL *serviceUrl = [NSURL URLWithString:[serviceOperationUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        
        NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy];
        
        id response = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
        
        NSLog(@"response ==>%@",response);
        
    }
	@catch (NSException *exception)
	{
		currentUser = nil;
	}
	@finally
	{
		return nil;
	}
}

#pragma mark Fetch Posts Methods

+(NSMutableArray *)fetchPostByUpdate:(NSString *)placeId andAuthToken:(NSString *)authToken
{
    NSMutableArray *allactivityFeeds;
    
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/places/%@/posts.json?type=update&posted_by=all&auth_token=%@",_rootUrl,placeId,authToken];
        
        NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
        
        id activityFeed = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
        
        if(activityFeed != nil)
        {
            if(allactivityFeeds == nil)
            {
                allactivityFeeds = [[NSMutableArray alloc] init];
            }
            [allactivityFeeds addObjectsFromArray:[self createPostbject:activityFeed]];
        }
    }
    @catch (NSException *exception)
    {
        allactivityFeeds = nil;
    }
    @finally
    {
        return allactivityFeeds;
    }
}

+(NSMutableArray *)fetchPostByDeals:(NSString *)placeId andAuthToken:(NSString *)authToken
{
    NSMutableArray *allactivityFeeds;
    
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/places/%@/posts.json?type=deals&posted_by=all&auth_token=%@",_rootUrl,placeId,authToken];
        
        NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
        
        id activityFeed = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
        
        if(activityFeed != nil)
        {
            if(allactivityFeeds == nil)
            {
                allactivityFeeds = [[NSMutableArray alloc] init];
            }
            [allactivityFeeds addObjectsFromArray:[self createPostbject:activityFeed]];
        }
    }
    @catch (NSException *exception)
    {
        allactivityFeeds = nil;
    }
    @finally
    {
        return allactivityFeeds;
    }
}

+(NSMutableArray *)fetchPostByAll:(NSString *)placeId andAuthToken:(NSString *)authToken
{
    NSMutableArray *allactivityFeeds;
    
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/places/%@/posts.json?posted_by=all&auth_token=%@",_rootUrl,placeId,authToken];

        NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
        
        id activityFeed = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
        
        if(activityFeed != nil)
        {
            if(allactivityFeeds == nil)
            {
                allactivityFeeds = [[NSMutableArray alloc] init];
            }
            [allactivityFeeds addObjectsFromArray:[self createPostbject:activityFeed]];
        }
    }
    @catch (NSException *exception)
    {
        allactivityFeeds = nil;
    }
    @finally
    {
        return allactivityFeeds;
    }
}

+ (NSMutableArray *)createPostbject:(NSMutableArray *)postArray
{
    NSMutableArray *allactivityFeeds = [[NSMutableArray alloc] init];
    
    for (int iCount = 0; iCount < [postArray count]; iCount ++)
    {
        ActivityFeed *activityFeed = [[ActivityFeed alloc] init];
        
        activityFeed.last_two_comments = [[NSMutableArray alloc] init];
        
        NSMutableDictionary *currentPostDict = [[NSMutableDictionary alloc] initWithDictionary:[postArray objectAtIndex:iCount]];

        NSMutableDictionary *userDict = [[NSMutableDictionary alloc] initWithDictionary:[currentPostDict objectForKey:@"user"]];
        
        NSMutableDictionary *placeDict = [[NSMutableDictionary alloc] initWithDictionary:[currentPostDict objectForKey:@"place"]];
        
        [activityFeed setFormalname:[placeDict valueForKey:@"formal_name"]];
        [activityFeed setFormaladdress:[placeDict valueForKey:@"formal_address"]];

        [activityFeed setAvatar:[userDict valueForKey:@"avatar"]];
        [activityFeed setName:[userDict valueForKey:@"name"]];
        
        activityFeed.liker_ids = [[NSMutableArray alloc] init];
        
        [activityFeed setComments_count:[userDict valueForKey:@"comments_count"]];
        [activityFeed setCreated_at:[userDict valueForKey:@"created_at"]];
        [activityFeed setLikers_count:[userDict valueForKey:@"likers_count"]];
        [activityFeed setPlaceId:[currentPostDict valueForKey:@"place_id"]];
        [activityFeed setPost_type:[currentPostDict valueForKey:@"post_type"]];
        [activityFeed setBody:[currentPostDict valueForKey:@"body"]];
        [activityFeed set_id:@""];
        
        if ([activityFeed.post_type isEqualToString:@"update"]) {
            [activityFeed setBody:[currentPostDict valueForKey:@"body"]];
        }
        
        [activityFeed setLiker_ids:[[currentPostDict valueForKey:@"liker_ids"] mutableCopy]];
        
        [activityFeed setComputed_name:[placeDict valueForKey:@"computed_name"]];
        
        NSString *colorArray = [currentPostDict valueForKey:@"last_two_comments"];
        
        NSArray *commentArray = [NSJSONSerialization JSONObjectWithData:[colorArray dataUsingEncoding:NSUTF8StringEncoding]
                                                                options:0 error:NULL];
        NSMutableArray *last_two_commentsArray = [[NSMutableArray alloc] init];
        
        if ([commentArray count] > 0)
        {
            for (int iCount = 0; iCount < [commentArray count]; iCount ++)
            {
                NSMutableDictionary *commentDict = [[NSMutableDictionary alloc] initWithDictionary:[commentArray objectAtIndex:iCount]];
                
                Comment *activityComment = [[Comment alloc] init];
                
                NSMutableDictionary *commenterDict = [[NSMutableDictionary alloc] initWithDictionary:[commentDict valueForKey:@"commenter"]];
                
                [activityComment setName:[commenterDict valueForKey:@"name"]];
                [activityComment setBody:[commentDict valueForKey:@"body"]];
                [activityComment setAvatar:[commenterDict valueForKey:@"avatar"]];
                [activityComment setCreated_at:[commentDict valueForKey:@"created_at"]];
                
                [last_two_commentsArray addObject:activityComment];
            }
            [activityFeed setLast_two_comments:last_two_commentsArray];
        }
        [allactivityFeeds addObject:activityFeed];
    }
    
    NSLog(@"allactivityFeeds = %d",[allactivityFeeds count]);
    
    return allactivityFeeds;
}

#pragma mark Activity feed Methods

+(NSMutableArray *)fetchActivityFeedByAuth:(NSString *)authToken
{
    NSMutableArray *allactivityFeeds;
    
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/activity_feed?auth_token=%@",_rootUrl,authToken];
        
        NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
        
        id activityFeed = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
        
        if(activityFeed != nil)
        {
            if(allactivityFeeds == nil)
            {
                allactivityFeeds = [[NSMutableArray alloc] init];
            }
            [allactivityFeeds addObjectsFromArray:[self createActivityFeedbject:activityFeed]];
        }
    }
    @catch (NSException *exception)
    {
        allactivityFeeds = nil;
    }
    @finally
    {
        return allactivityFeeds;
    }
}

+ (NSMutableArray *)createActivityFeedbject:(NSMutableArray *)activityfeedArray
{
    NSMutableArray *allactivityFeeds = [[NSMutableArray alloc] init];
    
    for (int iCount = 0; iCount < [activityfeedArray count]; iCount ++)
    {
        ActivityFeed *activityFeed = [[ActivityFeed alloc] init];
        
        activityFeed.last_two_comments = [[NSMutableArray alloc] init];
        
        NSMutableDictionary *feedDict = [[NSMutableDictionary alloc] initWithDictionary:[activityfeedArray objectAtIndex:iCount]];
        
        NSMutableDictionary *fromDict = [[NSMutableDictionary alloc] initWithDictionary:[feedDict objectForKey:@"from"]];
        
        [activityFeed setAvatar:[fromDict valueForKey:@"avatar"]];
        [activityFeed setName:[fromDict valueForKey:@"name"]];
        
        activityFeed.liker_ids = [[NSMutableArray alloc] init];
        
        NSMutableDictionary *sourceDict = [[NSMutableDictionary alloc] initWithDictionary:[feedDict objectForKey:@"source"]];
        
        [activityFeed setComments_count:[sourceDict valueForKey:@"comments_count"]];
        [activityFeed setCreated_at:[sourceDict valueForKey:@"created_at"]];
        [activityFeed setLikers_count:[sourceDict valueForKey:@"likers_count"]];
        [activityFeed setPlaceId:[sourceDict valueForKey:@"place_id"]];
        [activityFeed setPost_type:[sourceDict valueForKey:@"post_type"]];
        [activityFeed setPost_type:[sourceDict valueForKey:@"post_type"]];
        [activityFeed setBody:@""];
        [activityFeed set_id:[sourceDict valueForKey:@"_id"]];

        if ([activityFeed.post_type isEqualToString:@"update"]) {
            [activityFeed setBody:[sourceDict valueForKey:@"body"]];
        }


        NSMutableDictionary *placeDict = [[NSMutableDictionary alloc] initWithDictionary:[sourceDict valueForKey:@"place"]];
        [activityFeed setFormalname:[placeDict valueForKey:@"formal_name"]];
        [activityFeed setFormaladdress:[placeDict valueForKey:@"formal_address"]];

        [activityFeed setLiker_ids:[[placeDict valueForKey:@"liker_ids"] mutableCopy]];

        [activityFeed setComputed_name:[placeDict valueForKey:@"computed_name"]];
        
        NSString *colorArray = [sourceDict valueForKey:@"last_two_comments"];

        NSArray *commentArray = [NSJSONSerialization JSONObjectWithData:[colorArray dataUsingEncoding:NSUTF8StringEncoding]
                                                              options:0 error:NULL];
        NSMutableArray *last_two_commentsArray = [[NSMutableArray alloc] init];

        if ([commentArray count] > 0)
        {
            for (int iCount = 0; iCount < [commentArray count]; iCount ++) 
            {
                NSMutableDictionary *commentDict = [[NSMutableDictionary alloc] initWithDictionary:[commentArray objectAtIndex:iCount]];
                
                Comment *activityComment = [[Comment alloc] init];

                NSMutableDictionary *commenterDict = [[NSMutableDictionary alloc] initWithDictionary:[commentDict valueForKey:@"commenter"]];
                
                [activityComment setName:[commenterDict valueForKey:@"name"]];
                [activityComment setBody:[commentDict valueForKey:@"body"]];
                [activityComment setAvatar:[commenterDict valueForKey:@"avatar"]];
                [activityComment setCreated_at:[commentDict valueForKey:@"created_at"]];

                [last_two_commentsArray addObject:activityComment];
            }
            [activityFeed setLast_two_comments:last_two_commentsArray];
        }
        
        activityFeed.postedImagesArray = [[NSMutableArray alloc] init];

        NSMutableArray *postedPhotosArray = [[NSMutableArray alloc] initWithArray:[sourceDict valueForKey:@"photos"]];

        for (int iCount = 0; iCount < [postedPhotosArray count]; iCount ++)
        {
            NSMutableDictionary *currentPhotoObject = [[NSMutableDictionary alloc] initWithDictionary:[postedPhotosArray objectAtIndex:iCount]];
            
            NSMutableDictionary *currentfileObject = [[NSMutableDictionary alloc] initWithDictionary:[currentPhotoObject objectForKey:@"file"]];

            [activityFeed.postedImagesArray addObject:[currentfileObject valueForKey:@"url"]];
        }
        
        [allactivityFeeds addObject:activityFeed];
    }
    
    NSLog(@"allactivityFeeds = %d",[allactivityFeeds count]);
    
    return allactivityFeeds;
}




#pragma mark ==== Get the Following Details ============


+ (NSMutableArray *) getFollowingDetailsByLoguthTokenid:(NSString *)logingauthToken
{
    NSMutableArray *arr_trendFollowingDetail=nil;
    
	@try
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/places/following.json?auth_token=%@",_rootUrl,logingauthToken];

		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		id currentTrendDetail = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
        
        if(currentTrendDetail != nil && [currentTrendDetail count] > 0)
		{
			id currentFollow = nil;
			
			NSEnumerator *enumerator = [currentTrendDetail objectEnumerator];
            
          if (arr_trendFollowingDetail == nil )
			{
				arr_trendFollowingDetail = [[NSMutableArray alloc] init];
			}
            while (currentFollow = [enumerator nextObject])
			{
                Followings *objFollowins=[[Followings alloc]init];
                
                [objFollowins setLogo_url:[self checkForNull:[currentFollow valueForKey:@"logo_url"]]];
                
                [objFollowins setOpen_now:[NSString stringWithFormat:@"%@",[self checkForNull:[currentFollow valueForKey:@"open_now"]]]];
                
                [objFollowins setPost_name:[self checkForNull:[currentFollow valueForKey:@"post_name"]]];
                
                 [objFollowins setPre_name:[self checkForNull:[currentFollow valueForKey:@"pre_name"]]];
                
                [objFollowins setAddress:[self checkForNull:[currentFollow valueForKey:@"address"]]];
                
                [objFollowins setFollowers_count:[self checkForNull:[currentFollow valueForKey:@"followers_count"]]];
                
                [objFollowins setLikers_count:[self checkForNull:[currentFollow valueForKey:@"likers_count"]]];
                
                objFollowins.photos_url = [[NSMutableArray alloc] init];

                [objFollowins setPhotos_url:[self checkForNull:[currentFollow valueForKey:@"photos_url"]]];

                [objFollowins setFollower_ids:[[self checkForNull:[currentFollow valueForKey:@"follower_ids"]] mutableCopy]];

                objFollowins.liker_ids = [[NSMutableArray alloc] init];

                [objFollowins setLiker_ids:[[self checkForNull:[currentFollow valueForKey:@"liker_ids"]] mutableCopy]];

                [objFollowins setPlace_id:[self checkForNull:[currentFollow valueForKey:@"_id"]]];

                [objFollowins setMy_network:[self checkForNull:[currentFollow valueForKey:@"my_network"]]];

                [arr_trendFollowingDetail addObject:objFollowins];
            }
            
            NSLog(@"arr_trendFollowingDetail====%@",arr_trendFollowingDetail);

        }
    }
	@catch (NSException *exception)
	{
		arr_trendFollowingDetail = nil;
	}
	@finally
	{
		return arr_trendFollowingDetail;
	}
}


#pragma mark Settings connect/Disconnect Methods

+(id)connectAccount:(NSString *)jsonString andauthToken:(NSString *)authToken
{
    id response;
    
    @try
    {
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/users/connect?auth_token=%@",_rootUrl,authToken];
        
        NSURL *serviceUrl = [NSURL URLWithString:[serviceOperationUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        
        NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy];
        
        response = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];

        NSLog(@"response ==>%@",response);
    }
	@catch (NSException *exception)
	{
		response = nil;
	}
	@finally
	{
		return response;
	}
}

+(id)disconnectAccount:(NSString *)idString andauthToken:(NSString *)authToken
{
    id response;
    
    @try
    {
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/user_setting/disconnect/%@.json?auth_token=%@",_rootUrl,idString, authToken];
        
        NSURL *serviceUrl = [NSURL URLWithString:[serviceOperationUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        
        response = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];

        [self setUserDefault:response];

        NSLog(@"response ==>%@",response);
    }
	@catch (NSException *exception)
	{
		response = nil;
	}
	@finally
	{
		return response;
	}
}


#pragma mark create new place Methods

+(NSString *)findPlaceByGoogleId:(NSMutableArray *)GoogleandReferenceId
{
    NSString *uploadImageResponseStr = nil;
    
	@try
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@places/find?",_rootUrl];
                        
        NSMutableString *completeUrl = [[NSMutableString alloc] init];
        
        [completeUrl appendString:serviceOperationUrl];
        
        for (int iCount = 0; iCount < [GoogleandReferenceId count]; iCount++)
        {
            NSArray *currentGoogleandReferenceId = [GoogleandReferenceId objectAtIndex:iCount];
            
            NSString *GoogleId, *ReferenceId;
            
            GoogleId = [currentGoogleandReferenceId objectAtIndex:0];
            
            ReferenceId = [currentGoogleandReferenceId objectAtIndex:1];
            
            if (iCount == 0)
                [completeUrl appendFormat:@"reference_ids[%d][google_id]=%@&reference_ids[%d][reference_id]=%@",iCount,GoogleId,iCount,ReferenceId];
            else
                [completeUrl appendFormat:@"&reference_ids[%d][google_id]=%@&reference_ids[%d][reference_id]=%@",iCount,GoogleId,iCount,ReferenceId];
        }
        
        NSURL *serviceUrl = [[NSURL alloc] initWithString:completeUrl];
        
        id response = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
        
        NSLog(@"response For UpdateMultipleImages==>%@",response);
        
    }
	@catch (NSException *exception)
	{
		uploadImageResponseStr = nil;
	}
	@finally
	{
		return uploadImageResponseStr;
	}
}

//https://placeley.com/places/create_new?place[google_id]=a5ed901fba946e092be98cc0ea6e31f1e4a5fd46&place[reference]=CoQBdAAAAPa2nn3Lne4Eq08d7LtD50o5Ft71lXj6-0Gys6LADuTjLgW9PbacqP1vmO1ZRzpK67PN4Ftk7raLHwe6MQeBQP_fEU0Srxbw6ZddbBnjIZQt4yb8pQx2oLFl4aJMZVTWWmCZXJg-egEdohS-8niP4TSHJz1B9RmHWD7CEYeOPQ3jEhCyTf2mjTs5-kumQZmdZskAGhTuypiBrI_6T0BibXo_awJ9bez_gg

//a1e2a7e2f7eabe85d947518dbd9a7e8ca2c4809e

+(TrendsData *)createNewPlaceByGoogleandReferenceId:(NSMutableArray *)currentGoogleandReferenceId
{
    TrendsData *localTrendsData;
    
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@places/create_new.json",_rootUrl];
        
        NSString *GoogleId, *ReferenceId;
        
        GoogleId = [currentGoogleandReferenceId objectAtIndex:0];
        
        ReferenceId = [currentGoogleandReferenceId objectAtIndex:1];
        
        NSURL *serviceUrl = [NSURL URLWithString:[serviceOperationUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        
        NSString *jsonString = [NSString stringWithFormat:@"{\"place\":{\"google_id\":\"%@\",\"reference\":\"%@\"}}",GoogleId,ReferenceId];
        
        NSLog(@"jsonString = %@",jsonString);
        
        NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy];
        id response = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
        
        if (response != nil)
        {
            localTrendsData = [self createTrendIndidualObject:response];
        }
        
        NSLog(@"respons ==>%@",response);
        NSLog(@"response For UpdateMultipleImages==>%@",localTrendsData);
        
    }
	@catch (NSException *exception)
	{
		localTrendsData = nil;
	}
	@finally
	{
		return localTrendsData;
	}
}

#pragma mark Aggregation

+ (NSMutableArray *) getAggregationByPlaceId:(NSString *)placeId
{
    NSMutableArray *allaggregations = nil;
	
	@try
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@places/%@/aggregation.json", _rootUrl, placeId];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		id aggregation = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
		
		if(aggregation != nil)
		{
			if(allaggregations == nil)
			{
				allaggregations = [[NSMutableArray alloc] init];
			}
            [allaggregations addObjectsFromArray:[self createAggregationObject:aggregation]];
		}
	}
	@catch (NSException *exception)
	{
		allaggregations = nil;
	}
	@finally
	{
		return allaggregations;
	}
}

+ (NSMutableArray *)createAggregationObject:(Aggregation *)aggregation
{
    NSMutableArray *allaggregations = [[NSMutableArray alloc] init];

    [allaggregations addObject:[self getFaceBookObject:[aggregation valueForKey:@"facebook"]]];
    [allaggregations addObject:[self getTwitterObject:[aggregation valueForKey:@"twitter"]]];
    [allaggregations addObject:[self getInstagramObject:[aggregation valueForKey:@"instagram"]]];
    [allaggregations addObject:[self getFoursquareObject:[aggregation valueForKey:@"foursquare"]]];
    [allaggregations addObject:[self getWikipediaObject:[aggregation valueForKey:@"wikipedia"]]];
    [allaggregations addObject:[self getYelpObject:[aggregation valueForKey:@"yelp"]]];

    NSLog(@"allaggregations = %d",[allaggregations count]);
    
    return allaggregations;
}

+(Facebook *)getFaceBookObject:(NSMutableDictionary *)dictionary
{
    Facebook *facebook = [[Facebook alloc] init];
    facebook.checkins = [self checkForNull:[dictionary valueForKey:@"checkins"]];
    facebook.been_here = [self checkForNull:[dictionary valueForKey:@"been_here"]];
    facebook.likes = [self checkForNull:[dictionary valueForKey:@"likes"]];
    facebook.name = [self checkForNull:[dictionary valueForKey:@"name"]];
    facebook.post_name = [self checkForNull:[dictionary valueForKey:@"post_name"]];
    facebook.talking_about = [self checkForNull:[dictionary valueForKey:@"talking_about"]];
    facebook.url = [self checkForNull:[dictionary valueForKey:@"url"]];
    return facebook;
}

+(id)checkForNull:(id)value
{
    NSString *valueString = [NSString stringWithFormat:@"%@",value];
    
    id objectString = @"";
    
    if (![valueString isEqualToString:@"(null)"] && ![valueString isEqualToString:@"<null>"] && valueString.length != 0)
        return value;
    
    return objectString;
}

+(Yelp *)getYelpObject:(NSMutableDictionary *)dictionary
{
    Yelp *yelp = [[Yelp alloc] init];
    yelp.rating = [self checkForNull:[dictionary valueForKey:@"rating"]];
    yelp.rating_img = [self checkForNull:[dictionary valueForKey:@"rating_img"]];
    yelp.url = [self checkForNull:[dictionary valueForKey:@"url"]];
    
     //NSLog(@"yeeelp url check = %@",[self checkForNull:[NSString stringWithFormat:@"%@",[dictionary valueForKey:@"url"]]]);
    
    yelp.userProfileDataArr = [self getYelpUserProfileDataObject:[self checkForNull:[dictionary valueForKey:@"data"]]];
    
    NSLog(@"yelp = %@",yelp);

    return yelp;
}

+(NSMutableArray *)getYelpUserProfileDataObject:(NSMutableArray *)yelpUserProfileDataArray
{
    NSMutableArray *yelpUserProfileDataObjectArray = [[NSMutableArray alloc] init];
    
    if ([yelpUserProfileDataArray isEqual:@""])
        return yelpUserProfileDataObjectArray;

    YelpUserProfile *YelpUserProfiledate = nil;
    
    for (int iCount = 0; iCount < [yelpUserProfileDataArray count]; iCount++)
    {
        NSMutableDictionary *dictionary1 = [yelpUserProfileDataArray objectAtIndex:iCount];
        
        YelpUserProfiledate = [[YelpUserProfile alloc] init];
        YelpUserProfiledate.name = [self checkForNull:[dictionary1 valueForKey:@"name"]];
        YelpUserProfiledate.rating_img = [self checkForNull:[dictionary1 valueForKey:@"rating_img"]];
        YelpUserProfiledate.profile_url = [self checkForNull:[dictionary1 valueForKey:@"profile_url"]];
        YelpUserProfiledate.review = [self checkForNull:[dictionary1 valueForKey:@"review"]];

        [yelpUserProfileDataObjectArray addObject:YelpUserProfiledate];
    }
    return yelpUserProfileDataObjectArray;
}

+(Twitter *)getTwitterObject:(NSMutableDictionary *)dictionary
{
    Twitter *twitter = [[Twitter alloc] init];
    
    NSLog(@"checkins = %@",[self checkForNull:[dictionary valueForKey:@"followers"]]);
    
    twitter.followers = [self checkForNull:[dictionary valueForKey:@"followers"]];
    twitter.following = [self checkForNull:[dictionary valueForKey:@"following"]];
    twitter.total_tweet = [self checkForNull:[dictionary valueForKey:@"total_tweet"]];
    twitter.name = [self checkForNull:[dictionary valueForKey:@"name"]];
    twitter.location = [self checkForNull:[dictionary valueForKey:@"location"]];
    twitter.description = [self checkForNull:[dictionary valueForKey:@"description"]];
    
    twitter.url = [self checkForNull:[dictionary valueForKey:@"url"]];
    twitter.handle = [self checkForNull:[dictionary valueForKey:@"handle"]];
    twitter.hash_tags = [self checkForNull:[dictionary valueForKey:@"hash_tags"]];
    twitter.handlerdataArray = [self getTwitterHandlerdateObject:[self checkForNull:[dictionary valueForKey:@"handler_data"]]];
    twitter.hashtagsdataArray = [self getTwitterHashTagsdateObject:[self checkForNull:[dictionary valueForKey:@"hash_tags_data"]]];
    
    return twitter;
}

+(NSMutableArray *)getTwitterHandlerdateObject:(NSMutableArray *)twitterHandlerdataArray
{
    NSMutableArray *twitterHandlerObjectArray = [[NSMutableArray alloc] init];

    if ([twitterHandlerdataArray isEqual:@""])
        return twitterHandlerObjectArray;
    
    TwitterHandlerdate *twitterHandlerdate = nil;
    
    for (int iCount = 0; iCount < [twitterHandlerdataArray count]; iCount++)
    {
        NSMutableDictionary *dictionary1 = [twitterHandlerdataArray objectAtIndex:iCount];
        
        twitterHandlerdate = [[TwitterHandlerdate alloc] init];
        twitterHandlerdate.tweet = [self checkForNull:[dictionary1 valueForKey:@"tweet"]];
        twitterHandlerdate.profileUrl = [self checkForNull:[dictionary1 valueForKey:@"profile_url"]];
        [twitterHandlerObjectArray addObject:twitterHandlerdate];
    }
    return twitterHandlerObjectArray;
}

+(NSMutableArray *)getTwitterHashTagsdateObject:(NSMutableArray *)twitterHashTagsDataArray
{
    TwitterHashTagsdate *twitterHashTagsdate;
    
    NSMutableArray *twitterHashTagsObjectArray = [[NSMutableArray alloc] init];
    
    if ([twitterHashTagsDataArray isEqual:@""])
        return twitterHashTagsObjectArray;

    for (int iCount = 0; iCount < [twitterHashTagsDataArray count]; iCount++)
    {
        NSMutableDictionary *dictionary1 = [twitterHashTagsDataArray objectAtIndex:iCount];

        twitterHashTagsdate = [[TwitterHashTagsdate alloc] init];
        twitterHashTagsdate.tweet = [self checkForNull:[dictionary1 valueForKey:@"tweet"]];
        twitterHashTagsdate.profileUrl = [self checkForNull:[dictionary1 valueForKey:@"profile_url"]];
        twitterHashTagsdate.name = [self checkForNull:[dictionary1 valueForKey:@"name"]];
        [twitterHashTagsObjectArray addObject:twitterHashTagsdate];
    }

    return twitterHashTagsObjectArray;
}

+(Instagram *)getInstagramObject:(NSMutableDictionary *)dictionary
{
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    [imageArray addObjectsFromArray:[dictionary valueForKey:@"images"]];
    Instagram *instagram = [[Instagram alloc] init];
    instagram.imageArray = imageArray;
    return instagram;
}

+(Foursquare *)getFoursquareObject:(NSMutableDictionary *)dictionary
{
    Foursquare *foursquare = [[Foursquare alloc] init];
    
    foursquare.rating = [self checkForNull:[dictionary valueForKey:@"rating"]];
    foursquare.here_now = [self checkForNull:[dictionary valueForKey:@"here_now"]];
    foursquare.checkins = [self checkForNull:[dictionary valueForKey:@"checkins"]];
    foursquare.total_vistors = [self checkForNull:[dictionary valueForKey:@"total_vistors"]];
    foursquare.summary = [self checkForNull:[dictionary valueForKey:@"summary"]];
    foursquare.place_id = [self checkForNull:[dictionary valueForKey:@"place_id"]];
    foursquare.url = [self checkForNull:[dictionary valueForKey:@"url"]];

    return foursquare;
}

+(Wikipedia *)getWikipediaObject:(NSMutableDictionary *)dictionary
{
    Wikipedia *wikipedia = [[Wikipedia alloc] init];
    
    NSLog(@"[dictionary valueForKey:] = %@",[dictionary valueForKey:@"content"]);
    
    wikipedia.content = [self checkForNull:[dictionary valueForKey:@"content"]];
    wikipedia.title = [self checkForNull:[dictionary valueForKey:@"title"]];
    wikipedia.url = [self checkForNull:[dictionary valueForKey:@"url"]];
    return wikipedia;
}

#pragma mark Trend Detail

+ (ShowDetail *) getTrendDetailByPlaceName:(NSString *)placename andAuthToken:(NSString *)authToken
{
    ShowDetail *trendDetail;
    
	@try
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/%@.json?auth_token=%@", _rootUrl, placename,authToken];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		id currentTrendDetail = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
		
		if ((trendDetail == nil) && (currentTrendDetail != nil))
		{
			trendDetail = [[ShowDetail alloc] init];
		}
        
        trendDetail.follower_ids = [[NSMutableArray alloc] init];
        trendDetail.liker_ids = [[NSMutableArray alloc] init];

		[trendDetail setOpen_now:[self checkForNull:[currentTrendDetail valueForKey:@"open_now"]]];
        [trendDetail setPost_name:[self checkForNull:[currentTrendDetail valueForKey:@"post_name"]]];
		[trendDetail setPre_name:[self checkForNull:[currentTrendDetail valueForKey:@"pre_name"]]];
        [trendDetail setAddress:[self checkForNull:[currentTrendDetail valueForKey:@"address"]]];
        [trendDetail setSubaddress:[self checkForNull:[currentTrendDetail valueForKey:@"address"]]];
        [trendDetail setOpen_between:@"Today 06:00 AM - 09:30 PM"];//[currentTrendDetail valueForKey:@"open_between"]];
		[trendDetail setFollowers_count:[self checkForNull:[currentTrendDetail valueForKey:@"followers_count"]]];
        [trendDetail setPhone_number:[self checkForNull:[currentTrendDetail valueForKey:@"phone_number"]]];
		[trendDetail setWebsite_url:[self checkForNull:[currentTrendDetail valueForKey:@"website_url"]]];
        [trendDetail setLogo_url:[self checkForNull:[currentTrendDetail valueForKey:@"logo_url"]]];
        [trendDetail setLikers_count:[self checkForNull:[currentTrendDetail valueForKey:@"likers_count"]]];
		[trendDetail setImageArray:[self checkForNull:[currentTrendDetail valueForKey:@"photos_url"]]];
        [trendDetail setFollower_ids:[[self checkForNull:[currentTrendDetail valueForKey:@"follower_ids"]] mutableCopy]];
		[trendDetail setLiker_ids:[[self checkForNull:[currentTrendDetail valueForKey:@"liker_ids"]] mutableCopy]];
        [trendDetail setPlace_id:[self checkForNull:[currentTrendDetail valueForKey:@"_id"]]];
        [trendDetail setMy_network:[self checkForNull:[currentTrendDetail valueForKey:@"my_network"]]];
        [trendDetail setDeals:[self checkForNull:[currentTrendDetail valueForKey:@"deals"]]];
        [trendDetail setEvents:[self checkForNull:[currentTrendDetail valueForKey:@"events"]]];
        [trendDetail setUpdates:[self checkForNull:[currentTrendDetail valueForKey:@"updates"]]];

    }
	@catch (NSException *exception)
	{
		trendDetail = nil;
	}
	@finally
	{
		return trendDetail;
	}
}

+ (NSMutableArray *) getLocalTrendListByLatandLong:(NSString *)latitude Longitude:(NSString *)longitude;
{
    NSMutableArray *localTrendsArray = [[NSMutableArray alloc] init];
    
    @try
    {
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@%@%@%@%@%@",_rootUrl,@"trend/geolocation.json?",_roolUrlLat,latitude,_roolUrlLong,longitude];
        
        NSLog(@"serviceOperationUrl for local trends====%@",serviceOperationUrl);
        
        NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
        
        id trendsLocal = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
        
        [localTrendsArray addObjectsFromArray:[self createTrendObject:trendsLocal]];
    }
    @catch (NSException *exception)
    {
        localTrendsArray = nil;
    }
    @finally
    {
        return localTrendsArray;
    }
}


+ (NSMutableArray *) getGlobalTrendsList
{
    NSMutableArray *globalTrendsArray = [[NSMutableArray alloc] init];
    
    @try
    {
       // NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@%@",_rootUrl,@"trend/global.json"];
        
         NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@trend/global.json",_rootUrl];
        
        NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
        
        id trendsGlobal = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
        
        [globalTrendsArray addObjectsFromArray:[self createTrendObject:trendsGlobal]];
    }
    @catch (NSException *exception)
    {
        globalTrendsArray = nil;
    }
    @finally
    {
        return globalTrendsArray;
    }
}


+ (NSMutableArray *) getLocalFilterListWithLatLong:(NSString *)latitude Longitude:(NSString *)longitude LocalFilterName:(NSString *)localfiltername;
{
    NSMutableArray *localTrendsFilterArray = [[NSMutableArray alloc] init];
    
    @try
    {
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",_rootUrl,@"trend/geolocation.json?",_roolUrlLat,latitude,_roolUrlLong,longitude,_localCat,localfiltername];
        
        NSLog(@"serviceOperationUrl====%@",serviceOperationUrl);
        
        NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
        
        id trendsLocal = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
        
        [localTrendsFilterArray addObjectsFromArray:[self createTrendObject:trendsLocal]];
    }
    @catch (NSException *exception)
    {
        localTrendsFilterArray = nil;
    }
    @finally
    {
        return localTrendsFilterArray;
    }
}

#pragma mark Near me

+ (NSMutableArray *) getNearMeTrendListByLatandLong:(NSString *)latitude Longitude:(NSString *)longitude
{
    NSMutableArray *localTrendsArray = [[NSMutableArray alloc] init];
    
    @try
    {
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@%@%@%@%@%@",_rootUrl,@"around_me.json?",_roolUrlLat,latitude,_roolUrlLong,longitude];
        
        NSLog(@"serviceOperationUrl for local trends====%@",serviceOperationUrl);
        
        NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
        
        id trendsLocal = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
        
        [localTrendsArray addObjectsFromArray:[self createTrendObject:trendsLocal]];
    }
    @catch (NSException *exception)
    {
        localTrendsArray = nil;
    }
    @finally
    {
        return localTrendsArray;
    }
}

+ (NSMutableArray *) getNearFilterListWithLatLong:(NSString *)latitude Longitude:(NSString *)longitude LocalFilterName:(NSString *)localfiltername;
{
    NSMutableArray *localTrendsFilterArray = [[NSMutableArray alloc] init];
    
    @try
    {
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",_rootUrl,@"around_me.json?",_roolUrlLat,latitude,_roolUrlLong,longitude,_localCat,localfiltername];
        
        NSLog(@"serviceOperationUrl====%@",serviceOperationUrl);
        
        NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
        
        id trendsLocal = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
        
        [localTrendsFilterArray addObjectsFromArray:[self createTrendObject:trendsLocal]];
    }
    @catch (NSException *exception)
    {
        localTrendsFilterArray = nil;
    }
    @finally
    {
        return localTrendsFilterArray;
    }
}

+ (TrendsData *)createTrendIndidualObject:(id)currentLocalTrends
{
    TrendsData *localTrendsData = [[TrendsData alloc]init];
    
    [localTrendsData setId_trend:[self checkForNull:[currentLocalTrends valueForKey:@"_id"]]];
    [localTrendsData setAddress:[self checkForNull:[currentLocalTrends valueForKey:@"address"]]];
    [localTrendsData setCity:[self checkForNull:[currentLocalTrends valueForKey:@"city"]]];
    
    [localTrendsData setCity_country:[ self checkForNull:[ currentLocalTrends valueForKey:@"city_country"]]];
    [localTrendsData setComputed_name:[self checkForNull:[ currentLocalTrends valueForKey:@"computed_name"]]];
    
    [localTrendsData setCountry:[self checkForNull:[ currentLocalTrends valueForKey:@"country"]]];
    [localTrendsData setFollower_ids:[self checkForNull:[ currentLocalTrends valueForKey:@"follower_ids"]]]; // array
    
    [localTrendsData setFormal_address:[self checkForNull:[ currentLocalTrends valueForKey:@"formal_address"]]];
    
    [localTrendsData setFormal_name:[self checkForNull:[currentLocalTrends valueForKey:@"formal_name"]]];
    
    [localTrendsData setIdentifier:[self checkForNull:[ currentLocalTrends valueForKey:@"identifier"]]];
    
    [localTrendsData setLocation:[self checkForNull:[ currentLocalTrends valueForKey:@"location"]]]; // array
    
    [localTrendsData setName:[self checkForNull:[ currentLocalTrends valueForKey:@"name"]]];
    
    [localTrendsData setTimezone:[self checkForNull:[currentLocalTrends valueForKey:@"timezone"]]];
    
    [localTrendsData setOpen_now:[self checkForNull:[ currentLocalTrends valueForKey:@"open_now"]]];
    
    [localTrendsData setPost_name:[self checkForNull:[ currentLocalTrends valueForKey:@"post_name"]]];
    
    [localTrendsData setPre_name:[self checkForNull:[ currentLocalTrends valueForKey:@"pre_name"]]];
    
    [localTrendsData setFollowers_count:[self checkForNull:[currentLocalTrends valueForKey:@"followers_count"]]];
    
    [localTrendsData setRecommend_count:[self checkForNull:[currentLocalTrends valueForKey:@"recommend_count"]]];
    
    [localTrendsData setLogo_url:[self checkForNull:[ currentLocalTrends valueForKey:@"logo_url"]]];
    
    [localTrendsData setLikers_count: [NSString stringWithFormat:@"%@",[ currentLocalTrends valueForKey:@"likers_count"]]];
    
    [localTrendsData setLogo_url:[self checkForNull:[ currentLocalTrends valueForKey:@"logo_url"]]];
    
    [localTrendsData setPhotos_url:[self checkForNull:[ currentLocalTrends valueForKey:@"photos_url"]]]; // array
    
    [localTrendsData setWebsite_url:[self checkForNull:[ currentLocalTrends valueForKey:@"website_url"]]];
    
    [localTrendsData setMy_network:[self checkForNull:[ currentLocalTrends valueForKey:@"my_network"]]];
    
    [localTrendsData setOpen_between:[self checkForNull:[currentLocalTrends valueForKey:@"open_between"]]];
    
    [localTrendsData setPhone_number:[self checkForNull:[currentLocalTrends valueForKey:@"phone_number"]]];
    
    [localTrendsData setUser_id:[self checkForNull:[currentLocalTrends valueForKey:@"user_id"]]];
    
    [localTrendsData setCategoryNameArray:[self checkForNull:[currentLocalTrends valueForKey:@"categories"]]];
    
    
    NSMutableDictionary *dict = [currentLocalTrends valueForKey:@"info"];
    NSMutableDictionary *locationdict = [dict valueForKey:@"geometry"];
    NSMutableDictionary *locationdetaildict = [locationdict valueForKey:@"location"];
    
    localTrendsData.locationLatLngGlobalList = [[NSMutableArray alloc] init];
    [localTrendsData.locationLatLngGlobalList addObject:[locationdetaildict valueForKey:@"lat"]];
    [localTrendsData.locationLatLngGlobalList addObject:[locationdetaildict valueForKey:@"lng"]];
    return localTrendsData;
}

+ (NSMutableArray *)createTrendObject:(id)trendsLocal
{
    NSMutableArray *globalTrendsFilterArray = [[NSMutableArray alloc] init];

    id trendsGlobalList = [trendsLocal valueForKey:@"places"];
    
    if(trendsLocal != nil && [trendsLocal count] > 0)
    {
        id currentLocalTrends = nil;
        
        NSEnumerator *enumerator = [trendsGlobalList objectEnumerator];
        
        while (currentLocalTrends = [enumerator nextObject])
        {
            [globalTrendsFilterArray addObject:[self createTrendIndidualObject:currentLocalTrends]];
            
            //  NSLog(@"Name ==>%@,%@ EmpID = %@",[currentTicket valueForKey:@"FirstName"], [currentTicket valueForKey:@"EmployeeID"], [employeeData EmployeeId]);
            
             NSLog(@"globalTrendsFilterArray===>%@ ",globalTrendsFilterArray);
        }
        
       // NSLog(@"All Global filter response===>%@ and count====>%d",globalTrendsFilterArray,[globalTrendsFilterArray count]);
    }
    return globalTrendsFilterArray;
}

+ (NSMutableArray *) getGlobalFilterList:(NSString *)globalFilterName GlobalCity:(NSString *)globalcity;
{
    NSMutableArray *globalTrendsFilterArray = [[NSMutableArray alloc] init];

    @try
    {
        
        // https://placeley.com/trend/mobile_global?page=1&perPage=3&location=albany_united_states&category=establishment
       // NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@%@%@%@",_rootUrlGlobalFilter,globalcity,@"_united_states.json?category=",globalFilterName];
        
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@%@%@%@",_rootUrlGlobalFilter,globalcity,@"_united_states&category=",globalFilterName];
        
        NSLog(@"serviceOperationUrl Global====%@",serviceOperationUrl);
        
        NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
        
        id trendsLocal = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
        
        [globalTrendsFilterArray addObjectsFromArray:[self createTrendObject:trendsLocal]];
    }
    @catch (NSException *exception)
    {
        globalTrendsFilterArray = nil;
    }
    @finally
    {
        return globalTrendsFilterArray;
    }
    

}

#pragma mark ======== FILTER GET THE CITY==========================

+ (NSMutableDictionary *) getGlobalCity
{
    NSMutableDictionary *globalCityGet;
	
    @try
	{
		
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@trend/countries_and_categories",_rootUrl];

		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		globalCityGet = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
        
	}
	@catch (NSException *exception)
	{
		globalCityGet = nil;
	}
	@finally
	{
		return globalCityGet;
	}
}


+ (NSMutableDictionary *) getGlobalCityBasedCategoryname:(NSString *)GlobalCityname
{
    NSMutableDictionary *globalCategoryGet;
	
    @try
	{
		//https://placeley.com/trend/
      //  countries_and_categories?location=aloha_united_states
        
       // NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@trend/%@_united_states.json",_rootUrl,GlobalCityname];

        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@trend/countries_and_categories?location=%@_united_states",_rootUrl,GlobalCityname];
        
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		globalCategoryGet = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
        
	}
	@catch (NSException *exception)
	{
		globalCategoryGet = nil;
	}
	@finally
	{
		return globalCategoryGet;
	}
}





//=========

/*
+(NSMutableArray *)LoginDetails:(LocalTrends *)retail
{
    LocalTrends *retailer;
    NSMutableArray *allStores = nil;
 
    @try
    {
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"http://198.168.1.3:3000/users/connect"];
	
        NSURL *serviceUrl = [NSURL URLWithString:[serviceOperationUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        
        
        NSString *jsonString = [LocalTrends LoginDetails:retail];
        
        
		NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy];
        
        		id response = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];

       // id response = [ServiceHelper stringWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
        
        response=[response valueForKey:@"info"];
        
        if ((response != nil) && [response count]>0)
        {
            id retailerList=nil;
            
            if(allStores == nil)
			{
				allStores = [[NSMutableArray alloc] init];
			}
            
            
            NSEnumerator *enumerator = [response objectEnumerator];
            
            while(retailerList=[enumerator nextObject])
            {
                retailer= [[LocalTrends alloc] init];
                
                [retailer setLogname:[self checkEmptyValue:[retailerList valueForKey:@"name"]]];
                [retailer setToken:[self checkEmptyValue:[retailerList valueForKey:@"token"]]];
                
                [retailer setUid:[self checkEmptyValue:[retailerList valueForKey:@"uid"]]];
                
                [retailer setProvider:[self checkEmptyValue:[retailerList valueForKey:@"provider"]]];
                
                  [retailer setEmail:[self checkEmptyValue:[retailerList valueForKey:@"email"]]];
                
                 [retailer setExpires_at:[self checkEmptyValue:[retailerList valueForKey:@"expires_at"]]];
                
                [allStores addObject:retailer];
                
                NSLog(@"allStores====>%@",allStores);
                
                
            }
		}
        
        
    }
    @catch (NSException *exception)
    {
        allStores=nil;
    }
    @finally
    {
        return allStores;
    }
}
*/



- init {
    if ((self = [super init])) {
		self.finishCount = 0;
		NSMutableArray *array = [[NSMutableArray alloc] init];
		self.receivedDatas = array;
		
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
		self.requests = dict;
    }
    return self;
}

- (void)setDelegate:(id)val
{
    delegate = val;
}

- (id)delegate
{
    return delegate;
}


#pragma mark Methods
- (id)initWithUrls:(NSArray *)aUrls {
    if ((self = [self init]))
		[self requestWithUrls:aUrls];
	return self;
}

- (void)requestWithUrls:(NSArray *)aUrls {
    
	[receivedDatas removeAllObjects];
	[requests removeAllObjects];
	urls = [aUrls copy];
	
	for(NSInteger i=0; i< [urls count]; i++){
		NSMutableData *aData = [[NSMutableData alloc] init];
		[receivedDatas addObject: aData];
		
		NSURLRequest *request = [[NSURLRequest alloc]
								 initWithURL: [NSURL URLWithString: [urls objectAtIndex:i]]
								 cachePolicy: NSURLRequestReloadIgnoringLocalCacheData
								 timeoutInterval: 150
								 ];
		NSURLConnection *connection = [[NSURLConnection alloc]
									   initWithRequest:request
									   delegate:self];
		
		[requests setObject: [NSNumber numberWithInt: i] forKey: [NSValue valueWithNonretainedObject:connection]];
	}
}

- (NSData *)dataAtIndex:(NSInteger)idx {
	return [receivedDatas objectAtIndex:idx];
}

- (NSString *)dataAsStringAtIndex:(NSInteger)idx {
	return [[NSString alloc] initWithData:[receivedDatas objectAtIndex:idx] encoding:NSUTF8StringEncoding];
}

#pragma mark NSURLConnection Delegates
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	//NSInteger i = [[requests objectForKey: [NSValue valueWithNonretainedObject:connection]] intValue];
    // [[receivedDatas objectAtIndex:i] setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	NSInteger i = [[requests objectForKey: [NSValue valueWithNonretainedObject:connection]] intValue];
    [[receivedDatas objectAtIndex:i] appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSInteger i = [[requests objectForKey: [NSValue valueWithNonretainedObject:connection]] intValue];
	finishCount++;
	
	if ([delegate respondsToSelector:@selector(didFinishDownload:)])
        [delegate performSelector:@selector(didFinishDownload:) withObject: [NSNumber numberWithInt: i]];
	
	if(finishCount >= [urls count]){
		if ([delegate respondsToSelector:@selector(didFinishAllDownload)])
			[delegate didFinishAllDownload];
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	if ([delegate respondsToSelector:@selector(didFailDownloadWithError:)])
        [delegate performSelector:@selector(didFailDownloadWithError:) withObject: error];
}




@end

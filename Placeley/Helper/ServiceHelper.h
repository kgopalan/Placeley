//
//  ServiceHelper.h
//  NYStateSnowmobiling
//
//  Created by Edward Elliott on 4/11/11.
//  Copyright 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"

#import "Utility.h"

#import "Aggregation.h"
#import "Facebook.h"
#import "Twitter.h"
#import "Instagram.h"
#import "Foursquare.h"
#import "TwitterHandlerdate.h"
#import "TwitterHashTagsdate.h"
#import "Wikipedia.h"
#import "YelpUserProfile.h"
#import "Yelp.h"

#import "ShowDetail.h"
#import "LocalTrends.h"
#import "TrendsData.h"
#import "ActivityFeed.h"

#import "User.h"
#import "Comment.h"
#import "trendsDetailsViewController.h"
#import "Followings.h"

@class ServiceHelper;

@interface ServiceHelper : NSObject<NSURLConnectionDelegate>
{
	NSMutableArray *urls;
	NSMutableDictionary *requests;
	NSMutableArray *receivedDatas;
	NSInteger finishCount;
	id delegate;
}

@property (nonatomic,retain) NSMutableArray *urls;
@property (nonatomic,retain) NSMutableDictionary *requests;
@property (nonatomic,retain) NSMutableArray *receivedDatas;
@property NSInteger finishCount;
@property (retain) id delegate;

#pragma mark Login Methods

+(User *)createNewAccount:(NSString *)jsonString;

#pragma mark Like / UnLike Methods

+(id)likePlace:(NSString *)likeid andAuthToken:(NSString *)authtoken;

+(id)UnlikePlace:(NSString *)likeid andAuthToken:(NSString *)authtoken;

#pragma mark Fetch Posts Methods

+(NSMutableArray *)fetchPostByUpdate:(NSString *)placeId andAuthToken:(NSString *)authToken;

+(NSMutableArray *)fetchPostByDeals:(NSString *)placeId andAuthToken:(NSString *)authToken;

+(NSMutableArray *)fetchPostByAll:(NSString *)placeId andAuthToken:(NSString *)authToken;

#pragma mark Follow / Unfollow Methods

+(id)followPlace:(NSString *)jsonString andAuthToken:(NSString *)authtoken;

+(id)unfollowPlace:(NSString *)placeid andAuthToken:(NSString *)authtoken;

#pragma mark Activity feed Methods

+(NSMutableArray *)fetchActivityFeedByAuth:(NSString *)authToken;

#pragma mark Post Comment Methods

+(void *)postCommentToImage:(NSString *)jsonString andPlaceId:(NSString *)placeId andAuthToken:(NSString *)authToken;

+(void *)postComment:(NSString *)jsonString andPlaceId:(NSString *)placeId andAuthToken:(NSString *)authToken;

+(void *)postFeedComment:(NSString *)jsonString andPlaceId:(NSString *)placeId andFeedId:(NSString *)feedId andAuthToken:(NSString *)authToken;

#pragma mark Settings connect/Disconnect Methods

+(id)connectAccount:(NSString *)jsonString andauthToken:(NSString *)authToken;

+(id)disconnectAccount:(NSString *)idString andauthToken:(NSString *)authToken;

#pragma mark Aggregation

+ (NSMutableArray *) getAggregationByPlaceId:(NSString *)placeId;

+ (NSMutableArray *)createAggregationObject:(Aggregation *)aggregation;

+(Facebook *)getFaceBookObject:(NSMutableDictionary *)dictionary;

+(Yelp *)getYelpObject:(NSMutableDictionary *)dictionary;

+(NSMutableArray *)getYelpUserProfileDataObject:(NSMutableArray *)yelpUserProfileDataArray;

+(Twitter *)getTwitterObject:(NSMutableDictionary *)dictionary;

+(NSMutableArray *)getTwitterHandlerdateObject:(NSMutableArray *)twitterHandlerdataArray;

+(NSMutableArray *)getTwitterHashTagsdateObject:(NSMutableArray *)twitterHashTagsDataArray;

+(Instagram *)getInstagramObject:(NSMutableDictionary *)dictionary;

+(Foursquare *)getFoursquareObject:(NSMutableDictionary *)dictionary;

+(Wikipedia *)getWikipediaObject:(NSMutableDictionary *)dictionary;

#pragma mark Get Local Trends List

+ (NSMutableArray *) getLocalTrendListByLatandLong:(NSString *)latitude Longitude:(NSString *)longitude;

#pragma mark Get Global Trends List

+ (NSMutableArray *) getGlobalTrendsList;


+ (NSMutableArray *) getFollowingDetailsByLoguthTokenid:(NSString *)logingauthToken;




#pragma mark Trend Detail

+ (ShowDetail *) getTrendDetailByPlaceName:(NSString *)placename andAuthToken:(NSString *)authToken;
+(NSMutableArray *)LoginDetails:(LocalTrends *)retail;

#pragma mark Get Filter List

//http://zuppl.com/trend/geolocation.json?lat=12.977540&long=77.599510&category=cafe

+ (NSMutableArray *) getGlobalFilterList:(NSString *)globalFilterName GlobalCity:(NSString *)globalcity;

+ (NSMutableArray *) getLocalFilterListWithLatLong:(NSString *)latitude Longitude:(NSString *)longitude LocalFilterName:(NSString *)localfiltername;

+ (NSMutableDictionary *) getGlobalCity;
+ (NSMutableDictionary *) getGlobalCityBasedCategoryname:(NSString *)GlobalCityname;



- (id)initWithUrls:(NSArray *)aUrls;
- (void)requestWithUrls:(NSArray *)aUrls;
- (NSData *)dataAtIndex:(NSInteger)idx;
- (NSString *)dataAsStringAtIndex:(NSInteger)idx;
- (void)setDelegate:(id)val;
- (id)delegate;

@end

@interface NSObject (MultipleDownloadDelegateMethods)

- (void)didFinishDownload:(NSNumber*)idx;
- (void)didFinishAllDownload;
- (void)didFailDownloadWithError;

+(NSString *)findPlaceByGoogleId:(NSMutableArray *)GoogleandReferenceId;

#pragma mark Near me

+ (NSMutableArray *) getNearMeTrendListByLatandLong:(NSString *)latitude Longitude:(NSString *)longitude;
+ (NSMutableArray *) getNearFilterListWithLatLong:(NSString *)latitude Longitude:(NSString *)longitude LocalFilterName:(NSString *)localfiltername;

+(TrendsData *)createNewPlaceByGoogleandReferenceId:(NSMutableArray *)GoogleandReferenceId;

@end


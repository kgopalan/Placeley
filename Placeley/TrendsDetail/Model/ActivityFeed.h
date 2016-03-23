//
//  ActivityFeed.h
//  Placeley
//
//  Created by Krishnan Ziggma on 2/9/14.
//  Copyright (c) 2014 APR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityFeed : NSObject
{
    NSString *avatar;
    NSString *name;
    NSString *computed_name;
    NSString *likers_count;
    NSString *comments_count;
    NSString *created_at;
    NSMutableArray *last_two_comments;
    NSString *placeId;
    NSMutableArray *liker_ids;
    NSString *post_type;
    NSString *body;
    NSString *_id;
    NSMutableArray *postedImagesArray;
    NSString *formalname;
    NSString *formaladdress;

}
@property (nonatomic , retain) NSString *placeId;
@property (nonatomic , retain) NSString *avatar;
@property (nonatomic , retain) NSString *name;
@property (nonatomic , retain) NSString *computed_name;
@property (nonatomic , retain) NSString *likers_count;
@property (nonatomic , retain) NSString *comments_count;
@property (nonatomic , retain) NSString *created_at;
@property (nonatomic , retain) NSMutableArray *last_two_comments;
@property (nonatomic , retain) NSMutableArray *liker_ids;
@property (nonatomic , retain) NSString *post_type;
@property (nonatomic , retain) NSString *body;
@property (nonatomic , retain) NSString *_id;
@property (nonatomic , retain) NSMutableArray *postedImagesArray;
@property (nonatomic , retain) NSString *formalname;
@property (nonatomic , retain) NSString *formaladdress;

@end

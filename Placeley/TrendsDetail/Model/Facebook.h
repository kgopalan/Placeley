//
//  Facebook.h
//  Placeley
//
//  Created by APR on 12/18/13.
//  Copyright (c) 2013 APR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Facebook : NSObject
{
    NSString *checkins;
    NSString *been_here;
    NSString *likes;
    NSString *name;
    NSString *post_name;
    NSString *talking_about;
    NSString *url;
}

@property (nonatomic , retain) NSString *checkins;
@property (nonatomic , retain) NSString *been_here;
@property (nonatomic , retain) NSString *likes;
@property (nonatomic , retain) NSString *name;
@property (nonatomic , retain) NSString *post_name;
@property (nonatomic , retain) NSString *talking_about;
@property (nonatomic , retain) NSString *url;

@end

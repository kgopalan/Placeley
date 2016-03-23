//
//  Foursquare.h
//  Placeley
//
//  Created by APR on 12/18/13.
//  Copyright (c) 2013 APR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Foursquare : NSObject
{
    NSString *rating;
    NSString *here_now;
    NSString *checkins;
    NSString *total_vistors;
    NSString *summary;
    NSString *place_id;
    NSString *url;
}

@property (nonatomic , retain) NSString *rating;
@property (nonatomic , retain) NSString *here_now;
@property (nonatomic , retain) NSString *checkins;
@property (nonatomic , retain) NSString *total_vistors;
@property (nonatomic , retain) NSString *summary;
@property (nonatomic , retain) NSString *place_id;
@property (nonatomic , retain) NSString *url;


@end

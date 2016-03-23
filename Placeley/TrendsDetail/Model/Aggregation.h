//
//  Aggregation.h
//  Placeley
//
//  Created by APR on 12/18/13.
//  Copyright (c) 2013 APR. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Facebook.h"
#import "Twitter.h"
#import "Instagram.h"
#import "Foursquare.h"
#import "TwitterHandlerdate.h"
#import "TwitterHashTagsdate.h"
#import "Wikipedia.h"

@interface Aggregation : NSObject
{
    Facebook *facebook;
    Twitter *twitter;
    Instagram *instagram;
    Foursquare *foursquare;
    TwitterHandlerdate *twitterHandlerdate;
    TwitterHashTagsdate *twitterHashTagsdate;
    Wikipedia *wikipedia;
}

@property (nonatomic , retain) Facebook *facebook;
@property (nonatomic , retain) Twitter *twitter;
@property (nonatomic , retain) Instagram *instagram;
@property (nonatomic , retain) Foursquare *foursquare;
@property (nonatomic , retain) TwitterHandlerdate *twitterHandlerdate;
@property (nonatomic , retain) TwitterHashTagsdate *twitterHashTagsdate;
@property (nonatomic , retain) Wikipedia *wikipedia;
@end

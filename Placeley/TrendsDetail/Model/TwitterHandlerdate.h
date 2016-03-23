//
//  TwitterHandlerdate.h
//  Placeley
//
//  Created by APR on 12/18/13.
//  Copyright (c) 2013 APR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitterHandlerdate : NSObject
{
    NSString *tweet;
    NSString *profileUrl;
}

@property (nonatomic , retain) NSString *tweet;
@property (nonatomic , retain) NSString *profileUrl;

@end

//
//  User.h
//  Placeley
//
//  Created by APR on 2/9/14.
//  Copyright (c) 2014 APR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
{
    NSString *userId;
    NSString *name;
    NSString *phone_number;
    NSString *auth_token;
    NSString *email;
    NSString *facebook;
    NSString *twitter;
    NSString *instagram;
    NSString *foursquare;
}

@property (nonatomic , retain) NSString *userId;
@property (nonatomic , retain) NSString *name;
@property (nonatomic , retain) NSString *phone_number;
@property (nonatomic , retain) NSString *auth_token;
@property (nonatomic , retain) NSString *email;
@property (nonatomic , retain) NSString *facebook;
@property (nonatomic , retain) NSString *twitter;
@property (nonatomic , retain) NSString *instagram;
@property (nonatomic , retain) NSString *foursquare;

@end

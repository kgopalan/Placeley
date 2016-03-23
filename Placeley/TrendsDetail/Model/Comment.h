//
//  Comment.h
//  Placeley
//
//  Created by APR on 2/12/14.
//  Copyright (c) 2014 APR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject
{
    NSString *body;
    NSString *avatar;
    NSString *created_at;
    NSString *name;
}

@property (nonatomic , retain) NSString *body;
@property (nonatomic , retain) NSString *avatar;
@property (nonatomic , retain) NSString *created_at;
@property (nonatomic , retain) NSString *name;

@end

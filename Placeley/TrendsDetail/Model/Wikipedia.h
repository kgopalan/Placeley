//
//  Wikipedia.h
//  Placeley
//
//  Created by APR on 12/19/13.
//  Copyright (c) 2013 APR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Wikipedia : NSObject
{
    NSString *content;
    NSString *title;
    NSString *url;
}

@property (nonatomic , retain) NSString *content;
@property (nonatomic , retain) NSString *title;
@property (nonatomic , retain) NSString *url;

@end

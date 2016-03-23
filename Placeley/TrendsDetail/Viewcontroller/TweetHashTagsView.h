//
//  TweetHashTagsView.h
//  Placeley
//
//  Created by APR on 12/24/13.
//  Copyright (c) 2013 APR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface TweetHashTagsView : UIView
{
    
}
@property(nonatomic,strong) IBOutlet UILabel *lblTweetHashTagTweet;
@property(nonatomic,strong) IBOutlet UILabel *lblTweetHashTagname;
@property(nonatomic,strong) IBOutlet UIButton *btnTweetHashTag;
@property(nonatomic,strong) IBOutlet AsyncImageView *vwHashAsyncImageView;

@end

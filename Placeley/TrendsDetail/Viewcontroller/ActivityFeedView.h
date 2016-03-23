//
//  customView.h
//  sample
//
//  Created by APR on 2/11/14.
//  Copyright (c) 2014 APR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"


@interface ActivityFeedView : UIView
{
    IBOutlet UIScrollView *scrolViewActComment;
    
    IBOutlet UIView *viewActMain,*viewActComment,*viewActCommentWrite;
    
    IBOutlet  AsyncImageView *asyImgViewActivityLogo,*asyImgViewActivityCommentLogo,*asyImgViewActivityCommentWriteLogo;
    
    
    IBOutlet UILabel *lblActivityName,*lblActLikeComment,*lblActHorsAgo,*lblActLike,*lblActComment,*lblActCommentName,*lblActCommentPost,*lblActCommentMinAgo;
    IBOutlet UIButton *btnActLink,*btnActLike,*btnActShare,*btnActCommentPost,*btnShowAllComments;
    
    IBOutlet UITextField *txtFldActCommentWrite;
}

@property (nonatomic , retain)  IBOutlet UIButton *btnShowAllComments;

@end

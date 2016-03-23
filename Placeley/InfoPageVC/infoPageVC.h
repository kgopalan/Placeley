//
//  infoPageVC.h
//  Placeley
//
//  Created by Krishnan Ziggma on 3/1/14.
//  Copyright (c) 2014 APR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface infoPageVC : UIViewController<UIScrollViewDelegate,MFMailComposeViewControllerDelegate>
{
    IBOutlet UIScrollView* scrollView;
	IBOutlet UIPageControl* pageControl;
	NSMutableArray *arrImages;
    UIImageView *imageView;

    IBOutlet UIButton *btnNext;
    
    IBOutlet UIView *viewBottom;
    
    
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl* pageControl;

@end

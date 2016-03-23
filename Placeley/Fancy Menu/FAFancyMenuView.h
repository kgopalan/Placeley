//
//  FAFancyMenuView.h
//  TestAnimation
//
//  Created by Ben Xu on 12-11-21.
//  Copyright (c) 2012年 Fancy App. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FAFancyButton.h"
@class FAFancyMenuView;
@protocol FAFancyMenuViewDelegate <NSObject>
- (void)fancyMenu:(FAFancyMenuView *)menu didSelectedButtonAtIndex:(NSUInteger)index;
@end

@interface FAFancyMenuView : UIView
{
    BOOL shouldAllowPan;
    FAFancyButton *firstTransform;
    FAFancyButton * secondTransform;
    FAFancyButton * thirdTransform;
    FAFancyButton * fourthTransform;
    FAFancyButton * fifthTransform;
    FAFancyButton * sixthTransform;

    UILabel  * textlabel;
    int lastIndex;
}
@property (nonatomic, assign) id<FAFancyMenuViewDelegate> delegate;
@property (nonatomic, strong) NSArray *buttonImages;
@property (nonatomic) BOOL onScreen;
- (void)show;
- (void)hide;

@property (strong, nonatomic) NSTimer *timer;

@end

//
//  FAFancyMenuView.m
//  TestAnimation
//
//  Created by Ben Xu on 12-11-21.
//  Copyright (c) 2012年 Fancy App. All rights reserved.
//

#import "FAFancyMenuView.h"
#import "FAFancyButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation FAFancyMenuView

@synthesize timer;

- (void)addButtons{
    shouldAllowPan = NO;
    self.frame = CGRectMake(100, 100, ((UIImage *)[self.buttonImages lastObject]).size.height * 4, ((UIImage *)[self.buttonImages lastObject]).size.height * 4);
    if (self.subviews.count > 0)
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger i = 0;
    CGFloat degree = 360.f/self.buttonImages.count;
    for (UIImage *image in self.buttonImages){
      //  FAFancyButton *fancyButton = [[FAFancyButton alloc] initWithFrame:CGRectMake(self.frame.size.width/4 - image.size.width/4, 0, image.size.width, image.size.height)];
        FAFancyButton *fancyButton = [[FAFancyButton alloc] initWithFrame:CGRectMake(image.size.width + 20, image.size.height + 30, image.size.width, image.size.height)];
        [fancyButton setBackgroundImage:image forState:UIControlStateNormal];
        fancyButton.degree = i*degree;
        fancyButton.hidden = YES;
        fancyButton.tag = i + 292;
        [fancyButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:fancyButton];
        if (i == 0)
        {
            firstTransform = fancyButton;
        }
        else if (i == 1)
        {
            secondTransform = fancyButton;
        }
        else if (i == 2)
        {
            thirdTransform = fancyButton;
        }
        else if (i == 3)
        {
            fourthTransform = fancyButton;
        }
        else if (i == 4)
        {
            fifthTransform = fancyButton;
        }
        else if (i == 5)
        {
            sixthTransform = fancyButton;
        }
        i++;
    }
    textlabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 70, 300, 50)];
    textlabel.backgroundColor = [UIColor clearColor];
    textlabel.textAlignment = NSTextAlignmentCenter;
    textlabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    textlabel.textColor=[UIColor whiteColor];
    textlabel.text = @"";
    textlabel.hidden = YES;
    [self addSubview:textlabel];

}


- (void)handleLongPress:(UILongPressGestureRecognizer *)sender{
    if(UIGestureRecognizerStateBegan == sender.state) {
        shouldAllowPan = NO;
        if (self.onScreen) return;
        UIView *superView = [sender view];
        CGPoint pressedPoint = [sender locationInView:superView];
        CGPoint newCenter = pressedPoint;
        if ((pressedPoint.x - self.frame.size.width/2) < 0){
            newCenter.x = self.frame.size.width/2;
        }
        if ((pressedPoint.x + self.frame.size.width/2) > superView.frame.size.width){
            newCenter.x = superView.frame.size.width - self.frame.size.width/2;
        }
        if ((pressedPoint.y - self.frame.size.height/2) <0){
            newCenter.y = self.frame.size.height/2;
        }
        if ((pressedPoint.y + self.frame.size.height/2) > superView.frame.size.height){
            newCenter.y = superView.frame.size.height - self.frame.size.height/2;
        }
       // self.center = newCenter;
        self.center = CGPointMake(self.superview.frame.size.width/2, self.superview.frame.size.height/2);

        [self show];
    }
    
    
    if(UIGestureRecognizerStateChanged == sender.state) {
        UIView *superView = [sender view];
        CGPoint pressedPoint = [sender locationInView:superView];

        UIButton *button1 =  (UIButton *)[self viewWithTag:292];
        CGRect frame1 = [button1 convertRect:button1.bounds toView:self.superview];
        UIButton *button2 =  (UIButton *)[self viewWithTag:293];
        CGRect frame2 = [button2 convertRect:button2.bounds toView:self.superview];
        UIButton *button3 =  (UIButton *)[self viewWithTag:294];
        CGRect frame3 = [button3 convertRect:button3.bounds toView:self.superview];
        UIButton *button4 =  (UIButton *)[self viewWithTag:295];
        CGRect frame4 = [button4 convertRect:button4.bounds toView:self.superview];
        UIButton *button5 =  (UIButton *)[self viewWithTag:296];
        CGRect frame5 = [button5 convertRect:button5.bounds toView:self.superview];
        UIButton *button6 =  (UIButton *)[self viewWithTag:297];
        CGRect frame6 = [button6 convertRect:button6.bounds toView:self.superview];


        
        CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [ani setDuration:0.5];
        [ani setRepeatCount:100];
        [ani setFromValue:[NSNumber numberWithFloat:1.0]];
        [ani setToValue:[NSNumber numberWithFloat:1.2]];
        [ani setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];

        if (CGRectContainsPoint(frame1, pressedPoint) && lastIndex != button1.tag){
            NSLog(@"1111111");
            [self removeAllAnimation];
            textlabel.hidden = NO;
            textlabel.center = CGPointMake(button1.center.x , button1.center.y - 135);
            textlabel.text = @"Trending";
            [[button1 layer] addAnimation:ani forKey:@"zoom"];
            lastIndex = button1.tag;
        }
        else if (CGRectContainsPoint(frame2, pressedPoint) && lastIndex != button2.tag){
            NSLog(@"2222222");
            [self removeAllAnimation];
            textlabel.hidden = NO;
            textlabel.center = CGPointMake(button1.center.x + 90, button1.center.y - 52);
            textlabel.text = @"Activity Feed";
            [[button2 layer] addAnimation:ani forKey:@"zoom"];
            lastIndex = button2.tag;
        }
        else if (CGRectContainsPoint(frame3, pressedPoint) && lastIndex != button3.tag){
            NSLog(@"3333333");
            [self removeAllAnimation];
            textlabel.hidden = NO;
            textlabel.center = CGPointMake(button1.center.x + 10, button1.center.y + 35);
            textlabel.text = @"Following";
            [[button3 layer] addAnimation:ani forKey:@"zoom"];
            lastIndex = button3.tag;
        }
        
        else if (CGRectContainsPoint(frame4, pressedPoint) && lastIndex != button4.tag){
            NSLog(@"4444444");
            [self removeAllAnimation];
            textlabel.hidden = NO;
            textlabel.center = CGPointMake(button1.center.x -70, button1.center.y -50 );
            textlabel.text = @"Settings";
            [[button4 layer] addAnimation:ani forKey:@"zoom"];
            lastIndex = button4.tag;
        }
        
//        else if (CGRectContainsPoint(frame5, pressedPoint) && lastIndex != button5.tag)
//        {
//            NSLog(@"5555555");
//            [self removeAllAnimation];
//            textlabel.hidden = NO;
//            textlabel.center = CGPointMake(button1.center.x - 70, button1.center.y - 80);
//            textlabel.text = @"Near Me";
//            [[button5 layer] addAnimation:ani forKey:@"zoom"];
//            lastIndex = button5.tag;
//        }
//        else if (CGRectContainsPoint(frame6, pressedPoint) && lastIndex != button6.tag){
//            NSLog(@"6666666");
//            [self removeAllAnimation];
//            textlabel.hidden = NO;
//            textlabel.center = CGPointMake(button6.center.x , button6.center.y );
//            textlabel.text = @"Trends";
//            [[button6 layer] addAnimation:ani forKey:@"zoom"];
//            lastIndex = button6.tag;
//        }
        else if(!CGRectContainsPoint(frame1, pressedPoint) && !CGRectContainsPoint(frame2, pressedPoint) && !CGRectContainsPoint(frame3, pressedPoint) && !CGRectContainsPoint(frame4, pressedPoint) && !CGRectContainsPoint(frame5, pressedPoint) && !CGRectContainsPoint(frame6, pressedPoint))
        {
            NSLog(@"else");
            lastIndex = 0;
            [self removeAllAnimation];
        }
    }
    if(UIGestureRecognizerStateEnded == sender.state)
    {
        FAFancyButton *button1 =  (FAFancyButton *)[self viewWithTag:292];
        FAFancyButton *button2 =  (FAFancyButton *)[self viewWithTag:293];
        FAFancyButton *button3 =  (FAFancyButton *)[self viewWithTag:294];
        FAFancyButton *button4 =  (FAFancyButton *)[self viewWithTag:295];
        FAFancyButton *button5 =  (FAFancyButton *)[self viewWithTag:296];
        FAFancyButton *button6 =  (FAFancyButton *)[self viewWithTag:297];

        [self removeAllAnimation];
        
        if (lastIndex == button1.tag){
            [self buttonPressed:firstTransform];
        }
        else if (lastIndex == button2.tag){
            [self buttonPressed:secondTransform];
        }
        else if (lastIndex == button3.tag){
            [self buttonPressed:thirdTransform];
        }
        else if (lastIndex == button4.tag){
            [self buttonPressed:fourthTransform];
        }
        else if (lastIndex == button5.tag){
            [self buttonPressed:fifthTransform];
        }
        else if (lastIndex == button6.tag){
            [self buttonPressed:sixthTransform];
        }
    }
}

-(void)removeAllAnimation
{
    textlabel.hidden = YES;

    [firstTransform.layer removeAllAnimations];
    [secondTransform.layer removeAllAnimations];
    [thirdTransform.layer removeAllAnimations];
    [fourthTransform.layer removeAllAnimations];
    [fifthTransform.layer removeAllAnimations];
    [sixthTransform.layer removeAllAnimations];
}

- (void)handleTap:(UITapGestureRecognizer *)tap{
    if (!self.onScreen) return;
    [self hide];
}


- (void)addGestureRecognizerForView:(UIView *)view{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [view.superview addGestureRecognizer:longPress];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [view addGestureRecognizer:tap];
//    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(move:)];
//    [panRecognizer setMinimumNumberOfTouches:1];
//    [panRecognizer setMaximumNumberOfTouches:1];
//    [view.superview addGestureRecognizer:panRecognizer];
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    [self addGestureRecognizerForView:newSuperview];
}


- (void)buttonPressed:(FAFancyButton *)button{
    NSLog(@"%i",button.tag - 292);
    if (self.delegate){
        if ([self.delegate respondsToSelector:@selector(fancyMenu:didSelectedButtonAtIndex:)]){
            [self.delegate fancyMenu:self didSelectedButtonAtIndex:button.tag - 292];
        }
    }
}

- (void)showButton:(FAFancyButton *)button{
    [button show];
}

- (void)hideButton:(FAFancyButton *)button{
    [button hide];
}

- (void)hide{
    for (id object in self.subviews){
        if ([object isKindOfClass:[FAFancyButton class]])
        {
            FAFancyButton *button = (FAFancyButton *)object;
            [button hide];
        }
    }
    self.superview.hidden = YES;
    self.onScreen = NO;
}

- (void)show{
    self.onScreen = YES;
    self.superview.hidden = NO;
    float delay = 0.f;
    for (id object in self.subviews){
        if ([object isKindOfClass:[FAFancyButton class]])
        {
            FAFancyButton *button = (FAFancyButton *)object;
            [self performSelector:@selector(showButton:) withObject:button afterDelay:delay];
        }
        delay += 0.05;
    }
}

- (void)setButtonImages:(NSArray *)buttonImages{
    if (_buttonImages != buttonImages){
        _buttonImages = buttonImages;
        [self addButtons];
    }
}
@end

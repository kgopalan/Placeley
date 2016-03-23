//
//  AppDelegate.h
//  Placeley
//
//  Created by APR on 12/17/13.
//  Copyright (c) 2013 APR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceleyConstants.h"

#import "LoginViewController.h"

#import "LoginPlaceleyViewController.h"
#import "LocalTrendsViewController.h"

#import "ServiceHelper.h"
#import <GooglePlus/GooglePlus.h>

@class LoginViewController;
@class GTMOAuth2Authentication;
@class LoginPlaceleyViewController;

#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import "User.h"

#import "trendsDetailsViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,GPPDeepLinkDelegate,GPPSignInDelegate>
{

    LocalTrendsViewController *Obj_LocalTrendsViewController;
    
    LoginPlaceleyViewController *loginPlaceleyVC_obj;
    
    trendsDetailsViewController *objtrendsDetailsViewController;
    
    User *currentLoggedInUser;

}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *NavigationVC_obj;

@property (strong,nonatomic)  LoginPlaceleyViewController *loginPlaceleyVC_obj;
@property (strong,nonatomic)  LocalTrendsViewController *Obj_LocalTrendsViewController;

@property (nonatomic , retain) User *currentLoggedInUser;


- (void)createActiveIndicatorView;
+ (void)activeIndicatorStartAnimating:(UIView*)view;
+ (void)activeIndicatorStopAnimating;


-(BOOL)checkReachability;

+(AppDelegate *)appDelegate;


@end

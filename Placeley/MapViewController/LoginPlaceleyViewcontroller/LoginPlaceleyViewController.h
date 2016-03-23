//
//  LoginPlaceleyViewController.h
//  Placeley
//
//  Created by APR on 12/23/13.
//  Copyright (c) 2013 APR. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MenuViewController.h"
#import "FBFunLoginDialog.h"

#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import <QuartzCore/QuartzCore.h>
#import "ServiceHelper.h"

#import "LocalTrends.h"

#import "LocalTrendsViewController.h"



@class MenuViewController;
@class GPPSignInButton;
typedef enum {
    LoginStateStartup,
    LoginStateLoggingIn,
    LoginStateLoggedIn,
    LoginStateLoggedOut
} LoginState;

@interface LoginPlaceleyViewController : UIViewController<FBFunLoginDialogDelegate,GPPSignInDelegate>
{
    BOOL loginexecuted;
    
    MenuViewController *menuVC_obj;
    
    LocalTrendsViewController *objLocalTrendsViewController;
    
    
    UIButton *_loginButton;
    LoginState _loginState;
    FBFunLoginDialog *_loginDialog;
    UIView *_loginDialogView;
    UIWebView *_webView;
    NSString *_accessToken;
    NSDate *expiryDate;
    int count;
    UIImageView *_imageView;
    UILabel *_loginStatusLabel;

    GPPSignIn *signIn;
    NSDateFormatter *dateFormat;
    NSMutableArray *LogList;
    
}

@property (retain) IBOutlet UIButton *facebookButton;
@property (retain) IBOutlet UIButton *googleButton;


@property (retain) IBOutlet UIButton *loginButton;
@property (retain) FBFunLoginDialog *loginDialog;
@property (retain) IBOutlet UIView *loginDialogView;
@property (retain) IBOutlet UIWebView *webView;
@property (copy) NSString *accessToken;
@property (copy) NSDate *expiryDate;

@property(retain, nonatomic) IBOutlet GPPSignInButton *signInButton;
// A label to display the result of the sign-in action.
@property(retain, nonatomic) IBOutlet UILabel *signInAuthStatus;
// A label to display the signed-in user's display name.
@property(retain, nonatomic) IBOutlet UILabel *userName;
// A label to display the signed-in user's email address.
@property(retain, nonatomic) IBOutlet UILabel *userEmailAddress;
// An image view to display the signed-in user's avatar image.
@property(retain, nonatomic) IBOutlet UIImageView *userAvatar;
// A button to sign out of this application.
@property(retain, nonatomic) IBOutlet UIButton *signOutButton;
// A button to disconnect user from this application.
@property(retain, nonatomic) IBOutlet UIButton *disconnectButton;
// A button to inspect the authorization object.
@property(retain, nonatomic) IBOutlet UIButton *credentialsButton;
// A dynamically-created slider for controlling the sign-in button width.
@property(retain, nonatomic) UISlider *signInButtonWidthSlider;

// Called when the user presses the "Sign out" button.
- (IBAction)signOut:(id)sender;
// Called when the user presses the "Disconnect" button.
- (IBAction)disconnect:(id)sender;

-(IBAction)btnFBLogin_Clicked:(id)sender;
-(IBAction)btnGoogleLogin_Clicked:(id)sender;

-(LocalTrends *)createUser;



@end

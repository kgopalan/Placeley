//
//  lonigViewController.h
//  Placeley
//
//  Created by APR on 12/17/13.
//  Copyright (c) 2013 APR. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "trendsDetailsViewController.h"
#import "trendsListViewController.h"
#import "LocalTrendsViewController.h"
#import "FHSTwitterEngine.h"

#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>

@class LocalTrendsViewController;
@class trendsDetailsViewController;
@class trendsListViewController;


@interface LoginViewController : UIViewController<FHSTwitterEngineAccessTokenDelegate, UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate,GPPSignInDelegate>
{
    UITableView *theTableView;
    
    trendsDetailsViewController *trendsDetailsVC_obj;
    trendsListViewController *trendsListVC_obj;
    LocalTrendsViewController *localTrendsVC;

    GPPSignIn *signIn;
}

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



@property (nonatomic, strong) UITableView *theTableView;
@property(nonatomic,strong)IBOutlet UIButton *btnLogin;


-(IBAction)btnPostTweetClicked:(id)sender;

// Called when the user presses the "Sign out" button.
- (IBAction)signOut:(id)sender;
// Called when the user presses the "Disconnect" button.
- (IBAction)disconnect:(id)sender;

@end

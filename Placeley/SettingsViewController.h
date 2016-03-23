//
//  SettingsViewController.h
//  Placeley
//
//  Created by APR on 1/3/14.
//  Copyright (c) 2014 APR. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FHSTwitterEngine.h"
#import "FBFunLoginDialog.h"
#import "AppDelegate.h"

@interface SettingsViewController : UIViewController<UITextFieldDelegate,FHSTwitterEngineAccessTokenDelegate,UIWebViewDelegate,FBFunLoginDialogDelegate>
{
    AppDelegate *appDelegate;
    
    IBOutlet UITableView *settingsTableView;
    
    NSMutableArray *dataArray;
    
    IBOutlet UIButton *personalButton;
    
    IBOutlet UIButton *networkButton;
    
    BOOL isPersonal;
    UIImageView *logoImageView;
    UIButton *instagramCancel;
    
    NSMutableArray *selectedShareIndexPaths;
    
    NSMutableArray *selectedActivityIndexPaths;

    UIWebView* mywebview;

    UIButton *_loginButton;
    LoginState _loginState;
    FBFunLoginDialog *_loginDialog;
    UIView *_loginDialogView;
    UIWebView *_webView;
    NSString *_accessToken;
    NSDate *expiryDate;
    int count;
    NSDateFormatter *dateFormat;

}

@property (retain) IBOutlet UIButton *loginButton;
@property (retain) FBFunLoginDialog *loginDialog;
@property (retain) IBOutlet UIView *loginDialogView;
@property (retain) IBOutlet UIWebView *webView;
@property (copy) NSString *accessToken;
@property (copy) NSDate *expiryDate;

@property (strong, nonatomic) IBOutlet UIButton *connectToFoursquare;

-(IBAction)personalButtonClicked:(id)sender;

-(IBAction)networkButtonClicked:(id)sender;

- (IBAction)connect:(id)sender;

#pragma mark Instagram

- (IBAction)InstagramClick:(id)sender;

-(void)setUserDefault:(id)userObject;

-(id)checkForNull:(id)value;
@end

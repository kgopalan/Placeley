//
//  LoginPlaceleyViewController.m
//  Placeley
//
//  Created by APR on 12/23/13.
//  Copyright (c) 2013 APR. All rights reserved.
//

#import "LoginPlaceleyViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"

#import "AppDelegate.h"

@interface LoginPlaceleyViewController ()
{
    AppDelegate *appDelegate;
}
@property (nonatomic, copy) void (^confirmActionBlock)(void);
@property (nonatomic, copy) void (^cancelActionBlock)(void);

@end

@implementation LoginPlaceleyViewController

@synthesize loginButton = _loginButton;
@synthesize loginDialog = _loginDialog;
@synthesize loginDialogView = _loginDialogView;
@synthesize webView = _webView;
@synthesize accessToken = _accessToken;
@synthesize facebookButton;
@synthesize googleButton;

@synthesize expiryDate = _expiryDate;

static NSString * const kPlaceholderUserName = @"<Name>";
static NSString * const kPlaceholderEmailAddress = @"<Email>";
static NSString * const kPlaceholderAvatarImageName = @"PlaceholderAvatar.png";

// Labels for the cells that have in-cell control elements
static NSString * const kGetUserIDCellLabel = @"Get user ID";
static NSString * const kSingleSignOnCellLabel = @"Use Single Sign-On";
static NSString * const kButtonWidthCellLabel = @"Width";

// Labels for the cells that drill down to data pickers
static NSString * const kColorSchemeCellLabel = @"Color scheme";
static NSString * const kStyleCellLabel = @"Style";
static NSString * const kAppActivitiesCellLabel = @"App activity types";

// Strings for Alert Views
static NSString * const kSignOutAlertViewTitle = @"Warning";
static NSString * const kSignOutAlertViewMessage =
@"Modifying this element will sign you out of G+. Are you sure you wish to continue?";
static NSString * const kSignOutAlertCancelTitle = @"Cancel";
static NSString * const kSignOutAlertConfirmTitle = @"Continue";

- (void)gppInit {
    // Make sure the GPPSignInButton class is linked in because references from
    // xib file doesn't count.
    [GPPSignInButton class];
    
    signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;
    
    signIn.delegate = self;
}



- (void)viewWillAppear:(BOOL)animated {
    
    [self refresh];

    dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy hhmma"];

    loginexecuted = NO;
    
  /*  UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //[button addTarget:self   action:@selector(aMethod:)  forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"open" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(250.0, 10.0, 100.0, 20.0);
    [self.view addSubview:button];
    button.transform = CGAffineTransformMakeRotation(45);
   */
    
    

//    [self reportAuthStatus];
//    [self updateButtons];
    
}

#pragma mark - GPPSignInDelegate

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth
                   error:(NSError *)error {


    if (error) {
        _signInAuthStatus.text =
        [NSString stringWithFormat:@"Status: Authentication error: %@", error];
        return;
    }
    
    // 1. Create a |GTLServicePlus| instance to send a request to Google+.
    GTLServicePlus* plusService = [[GTLServicePlus alloc] init] ;
    plusService.retryEnabled = YES;
    
    // 2. Set a valid |GTMOAuth2Authentication| object as the authorizer.
    [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
    
    
    GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
    
    // *4. Use the "v1" version of the Google+ API.*
    plusService.apiVersion = @"v1";
    
    [plusService executeQuery:query
            completionHandler:^(GTLServiceTicket *ticket,
                                GTLPlusPerson *person,
                                NSError *error) {
                if (error) {
                    
                    //Handle Error
                    
                } else
                {
                    
//                    NSLog(@"userEmail %@", signIn.authentication.userEmail);
//                    NSLog(@"Received Access Token:%@",auth.accessToken);
//                    NSLog(@"Received expiry date:%@",auth.expirationDate);
//                    NSLog(@"profile id=%@",person.identifier);
//                    NSLog(@"User Name=%@",[person.name.givenName stringByAppendingFormat:@" %@",person.name.familyName]);
                    
                    NSString *expirationdateString = [dateFormat stringFromDate:auth.expirationDate];

                    NSMutableDictionary *originalDictionary = [[NSMutableDictionary alloc] init];
                    
                    [originalDictionary setValue:signIn.authentication.userEmail forKey:@"email"];
                    [originalDictionary setValue:person.identifier forKey:@"uid"];
                    [originalDictionary setValue:auth.accessToken forKey:@"token"];
                    [originalDictionary setValue:@"google" forKey:@"provider"];
                    [originalDictionary setValue:person.name.familyName forKey:@"name"];

                    NSMutableDictionary *finalDict=[[NSMutableDictionary alloc]init];
                    
                    NSLog(@"auth.accessToken: %@", auth.accessToken);

                    
                    NSString *s = @"yyyy-MM-dd HH:mm:ss zzz";
                    
                    // about input date(GMT)
                    NSDateFormatter *inDateFormatter = [[NSDateFormatter alloc] init];
                    inDateFormatter.dateFormat = s;
                    inDateFormatter.timeZone = [NSTimeZone systemTimeZone];
                    NSDate *inDate = [inDateFormatter dateFromString:[NSString stringWithFormat:@"%@",auth.expirationDate]];
                    
                    NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"]; // Sets the right time.
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setTimeZone:timeZone];
                    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
                    
                    NSString *dateString = [formatter stringFromDate:inDate];
                    

                    [originalDictionary setValue:[NSString stringWithFormat:@"%@ UTC",dateString] forKey:@"expires_at"];

                    
                    //[finalDict addEntriesFromDictionary:originalDictionary];
                    
                   // NSMutableArray *arrFinal=[[NSMutableArray alloc]init];
                    
                    [finalDict addEntriesFromDictionary:originalDictionary];
                    
                    NSDictionary *arDict = [NSDictionary dictionaryWithObject:finalDict forKey:@"info"];

                    
                    
                    SBJsonWriter *jsonWriter = [SBJsonWriter new];
                    
                    NSString *jsonString = [jsonWriter stringWithObject:arDict];
                    
                    
                    [[NSUserDefaults standardUserDefaults] setObject:jsonString forKey:@"GooglePlus"];
                    
                    if (loginexecuted == NO)
                    {
                       // NSLog(@"Gmail jsonString ====> %@",jsonString);

                        loginexecuted = YES;
                        
                        appDelegate.currentLoggedInUser = [ServiceHelper createNewAccount:jsonString];
                        
                        NSLog(@"appDelegate.currentLoggedInUser ====> %@",appDelegate.currentLoggedInUser.auth_token);
                        
                        if (appDelegate.currentLoggedInUser != nil)
                        {
                          //  NSLog(@"appDelegate.currentLoggedInUser ====> %@",[ServiceHelper fetchPostByDeals:@"5122f18774b1c4c305000009" andAuthToken:appDelegate.currentLoggedInUser.auth_token]);

                            [AppDelegate performSelector:@selector(activeIndicatorStopAnimating) withObject:nil];
                            self.view.userInteractionEnabled = YES;
                            
                            if (![self.navigationController.topViewController isKindOfClass:[LocalTrendsViewController class]])
                            {
                                objLocalTrendsViewController=[[LocalTrendsViewController alloc]initWithNibName:@"LocalTrendsViewController" bundle:nil];
                                [self.navigationController pushViewController:objLocalTrendsViewController animated:YES];
                            }
                        }

                    }

                }
            }];


//    [self reportAuthStatus];
//    [self updateButtons];
    //objLocalTrendsViewController
}


/*
-(void)CrearePlacelyUser


{
    {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),  ^{
            
          
           // dispatch_async(dispatch_get_main_queue(),
                       //    ^{
                
                  LogList=[ServiceHelper LoginDetails:[self createUser]];
           // });
        });
        
    }

}


-(LocalTrends *)createUser
{
    LocalTrends *retailerObj=nil;
    
    if (retailerObj==nil)
    {
        retailerObj=[[LocalTrends alloc] init];
    }
    
    [retailerObj setLogname:@"kumar"];
    [retailerObj setToken:@"AADtN_XKMa1QnObPolnf58SQANFMnPy5igvPywzG9wGqpm22lTNqqVjXpMEDzWmwAmNiDQc"];
     [retailerObj setUid:@"104455367737521358151"];
     [retailerObj setProvider:@"google"];
    [retailerObj setEmail:@"rajeshinvotech@gmail.co"];
    [retailerObj setExpires_at:@"12/01/2014 0612PM"];

    return retailerObj;
}

*/


    
    
- (void)didDisconnectWithError:(NSError *)error
{
    if (error) {
        _signInAuthStatus.text =
        [NSString stringWithFormat:@"Status: Failed to disconnect: %@", error];
    } else {
        _signInAuthStatus.text =
        [NSString stringWithFormat:@"Status: Disconnected"];
    }
//    [self refreshUserInfo];
//    [self updateButtons];
}

#pragma mark - Helper methods

//- (void)reportAuthStatus {
//    if ([GPPSignIn sharedInstance].authentication) {
//        _signInAuthStatus.text = @"Status: Authenticated";
//    } else {
//        // To authenticate, use Google+ sign-in button.
//        _signInAuthStatus.text = @"Status: Not authenticated";
//    }
//    [self refreshUserInfo];
//}

//// Update the interface elements containing user data to reflect the
//// currently signed in user.
//- (void)refreshUserInfo {
//    if ([GPPSignIn sharedInstance].authentication == nil) {
//        self.userName.text = kPlaceholderUserName;
//        self.userEmailAddress.text = kPlaceholderEmailAddress;
//        self.userAvatar.image = [UIImage imageNamed:kPlaceholderAvatarImageName];
//        return;
//    }
//    
//    self.userEmailAddress.text = [GPPSignIn sharedInstance].userEmail;
//    
//    // The googlePlusUser member will be populated only if the appropriate
//    // scope is set when signing in.
//    GTLPlusPerson *person = [GPPSignIn sharedInstance].googlePlusUser;
//    if (person == nil) {
//        return;
//    }
//    
//    self.userName.text = person.displayName;
//    
//    // Load avatar image asynchronously, in background
//    dispatch_queue_t backgroundQueue =
//    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    
//    dispatch_async(backgroundQueue, ^{
//        NSData *avatarData = nil;
//        NSString *imageURLString = person.image.url;
//        if (imageURLString) {
//            NSURL *imageURL = [NSURL URLWithString:imageURLString];
//            avatarData = [NSData dataWithContentsOfURL:imageURL];
//        }
//        
//        if (avatarData) {
//            // Update UI from the main thread when available
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.userAvatar.image = [UIImage imageWithData:avatarData];
//            });
//        }
//    });
//}
//
//// Adjusts "Sign in", "Sign out", and "Disconnect" buttons to reflect
//// the current sign-in state (ie, the "Sign in" button becomes disabled
//// when a user is already signed in).
//- (void)updateButtons {
//    BOOL authenticated = ([GPPSignIn sharedInstance].authentication != nil);
//    
//    self.signInButton.enabled = !authenticated;
//    self.signOutButton.enabled = authenticated;
//    self.disconnectButton.enabled = authenticated;
//    self.credentialsButton.hidden = !authenticated;
//    
//    if (authenticated) {
//        self.signInButton.alpha = 0.5;
//        self.signOutButton.alpha = self.disconnectButton.alpha = 1.0;
//    } else {
//        self.signInButton.alpha = 1.0;
//        self.signOutButton.alpha = self.disconnectButton.alpha = 0.5;
//    }
//    
//    self.signInButton.frame = CGRectMake(self.signInButton.frame.origin.x, self.signInButton.frame.origin.y, self.signInButton.frame.size.width + 100, self.signInButton.frame.size.height + 100);
//
//}

#pragma mark - IBActions

- (IBAction)signOut:(id)sender
{
    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        
    }
    
    
    [[GPPSignIn sharedInstance] signOut];
//    [self reportAuthStatus];
//    [self updateButtons];
}

- (IBAction)disconnect:(id)sender {
    [[GPPSignIn sharedInstance] disconnect];
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self gppInit];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self gppInit];
    }
    return self;
}

- (void)viewDidLoad
{
    
    facebookButton.layer.cornerRadius=5.0;
    googleButton.layer.cornerRadius=5.0;
    
    LogList=[[NSMutableArray alloc]init];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

   // [self CrearePlacelyUser];
    
    
    //facebookButton.layer.borderColor=[[UIColor lightGrayColor]CGColor];
   // googleButton.layer.borderColor=[[UIColor lightGrayColor]CGColor];
   // facebookButton.layer.borderWidth=2.0;
   // googleButton.layer.borderWidth=2.0;
    

    
    if (IS_IPHONE_5)
    {
        facebookButton.frame=CGRectMake(7, 354, 306, 59);
        googleButton.frame=CGRectMake(7, 432, 306, 59);
        
    }
    else
    {
        facebookButton.frame=CGRectMake(7, 334, 306, 59);
        googleButton.frame=CGRectMake(7, 401, 306, 59);
    }
    
    
    [super viewDidLoad];
   
    
    [self setNeedsStatusBarAppearanceUpdate];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle

{
    return UIStatusBarStyleLightContent;
}


-(IBAction)btnFBLogin_Clicked:(id)sender
{

//    menuVC_obj=[[MenuViewController alloc]initWithNibName:@"MenuViewController" bundle:nil];
//   [self.navigationController pushViewController:menuVC_obj animated:YES];
    
//    objLocalTrendsViewController=[[LocalTrendsViewController alloc]initWithNibName:@"LocalTrendsViewController" bundle:nil];
//    [self.navigationController pushViewController:objLocalTrendsViewController animated:YES];

    [self loginFBButtonTapped:nil];
}

-(IBAction)btnGoogleLogin_Clicked:(id)sender
{
    [AppDelegate performSelector:@selector(activeIndicatorStartAnimating:) withObject:self.view afterDelay:0.2];
    self.view.userInteractionEnabled = NO;
    
    [[GPPSignIn sharedInstance] trySilentAuthentication];

    [signIn authenticate];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Login Button

- (IBAction)loginFBButtonTapped:(id)sender

{
    [AppDelegate performSelector:@selector(activeIndicatorStartAnimating:) withObject:self.view afterDelay:0.2];
    self.view.userInteractionEnabled = NO;

    
    NSString *appId = @"408481352616594";
    NSString *permissions = @"publish_stream,email";
   // [_loginDialog logout];
    if (_loginDialog == nil) {
        self.loginDialog = [[FBFunLoginDialog alloc] initWithAppId:appId requestedPermissions:permissions delegate:self];
        self.loginDialogView = _loginDialog.view;
    }
    count = 0;
    
    if (_loginState == LoginStateStartup || _loginState == LoginStateLoggedOut) {
        _loginState = LoginStateLoggingIn;
        [_loginDialog login];
    } else if (_loginState == LoginStateLoggedIn) {
        _loginState = LoginStateLoggedOut;
        [_loginDialog logout];
    }
    
    [self refresh];
    
}
- (void)refresh

{
    if (_loginState == LoginStateStartup || _loginState == LoginStateLoggedOut) {
        _loginStatusLabel.text = @"Not connected to Facebook";
        [_loginButton setTitle:@"Login" forState:UIControlStateNormal];
        _loginButton.hidden = NO;
    } else if (_loginState == LoginStateLoggingIn) {
        _loginStatusLabel.text = @"Connecting to Facebook...";
        _loginButton.hidden = YES;
    } else if (_loginState == LoginStateLoggedIn) {
        _loginStatusLabel.text = @"Connected to Facebook";
        [_loginButton setTitle:@"Logout" forState:UIControlStateNormal];
        _loginButton.hidden = NO;
    }
}

#pragma mark FB Requests

- (void)showLikeButton
{
    // Source: http://developers.facebook.com/docs/reference/plugins/like-box
    NSString *likeButtonIframe = @"<iframe src=\"http://www.facebook.com/plugins/likebox.php?id=122723294429312&amp;width=292&amp;connections=0&amp;stream=false&amp;header=false&amp;height=62\" scrolling=\"no\" frameborder=\"0\" style=\"border:none; overflow:hidden; width:282px; height:62px;\" allowTransparency=\"true\"></iframe>";
    NSString *likeButtonHtml = [NSString stringWithFormat:@"<HTML><BODY>%@</BODY></HTML>", likeButtonIframe];
    
    [_webView loadHTMLString:likeButtonHtml baseURL:[NSURL URLWithString:@""]];
}

- (void)getFacebookProfile {
    
    NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/me?access_token=%@", [_accessToken stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDidFinishSelector:@selector(getFacebookProfileFinished:)];
    
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)rateTapped:(id)sender {
    
    NSString *likeString;
    NSString *filePath = nil;
    if (_imageView.image == [UIImage imageNamed:@"angelina.jpg"]) {
        filePath = [[NSBundle mainBundle] pathForResource:@"angelina" ofType:@"jpg"];
        likeString = @"babe";
    } else if (_imageView.image == [UIImage imageNamed:@"depp.jpg"]) {
        filePath = [[NSBundle mainBundle] pathForResource:@"depp" ofType:@"jpg"];
        likeString = @"dude";
    } else if (_imageView.image == [UIImage imageNamed:@"maltese.jpg"]) {
        filePath = [[NSBundle mainBundle] pathForResource:@"maltese" ofType:@"jpg"];
        likeString = @"puppy";
    }
    if (filePath == nil) return;
    
    NSString *adjectiveString;
    adjectiveString = @"ugly";
    
    NSString *message = [NSString stringWithFormat:@"I think this is a %@ %@!", adjectiveString, likeString];
    
    NSURL *url = [NSURL URLWithString:@"https://graph.facebook.com/me/photos"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addFile:filePath forKey:@"file"];
    [request setPostValue:message forKey:@"message"];
    [request setPostValue:_accessToken forKey:@"access_token"];
    [request setDidFinishSelector:@selector(sendToPhotosFinished:)];
    
    [request setDelegate:self];
    [request startAsynchronous];
    
}

- (void)sendToPhotosFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    NSMutableDictionary *responseJSON = [responseString JSONValue];
    NSString *photoId = [responseJSON objectForKey:@"id"];
    NSLog(@"Photo id is: %@", photoId);
    
    NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/%@?access_token=%@", photoId, [_accessToken stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *newRequest = [ASIHTTPRequest requestWithURL:url];
    [newRequest setDidFinishSelector:@selector(getFacebookPhotoFinished:)];
    
    [newRequest setDelegate:self];
    [newRequest startAsynchronous];
    
}

#pragma mark FB Responses

- (void)getFacebookProfileFinished:(ASIHTTPRequest *)request
{
    NSMutableDictionary *responseJSON = [[request responseString] JSONValue];
    
    NSString *expirationdateString = [dateFormat stringFromDate:self.expiryDate];

    NSMutableDictionary *originalDictionary = [[NSMutableDictionary alloc] init];
    
    [originalDictionary setValue:[responseJSON objectForKey:@"email"] forKey:@"email"];
    [originalDictionary setValue:[responseJSON objectForKey:@"id"] forKey:@"uid"];
    [originalDictionary setValue:self.accessToken forKey:@"token"];
   // [originalDictionary setValue:expirationdateString forKey:@"expires_at"];
    [originalDictionary setValue:@"facebook" forKey:@"provider"];
    [originalDictionary setValue:[responseJSON objectForKey:@"name"] forKey:@"name"];
    
//    NSDateFormatter *inDateFormatter = [[NSDateFormatter alloc] init]; // 2014-04-14 17:45:45 +0000
//    inDateFormatter.dateFormat = @"yyyy/MM/dd HHmma";
//    inDateFormatter.timeZone = [NSTimeZone systemTimeZone];
//    NSDate *inDate = [inDateFormatter dateFromString:[NSString stringWithFormat:@"%@",self.expiryDate]];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"]; // Sets the right time.
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    
    NSString *dateString = [formatter stringFromDate:self.expiryDate];
    
    
    [originalDictionary setValue:[NSString stringWithFormat:@"%@ UTC",dateString] forKey:@"expires_at"];

    NSMutableDictionary *finalDict=[[NSMutableDictionary alloc]init];

    [finalDict addEntriesFromDictionary:originalDictionary];
    
    NSDictionary *arDict = [NSDictionary dictionaryWithObject:finalDict forKey:@"info"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    
    NSString *jsonString = [jsonWriter stringWithObject:arDict];

    NSLog(@"jsonString = %@",jsonString);

    [[NSUserDefaults standardUserDefaults] setObject:jsonString forKey:@"Facebook"];

    appDelegate.currentLoggedInUser = [ServiceHelper createNewAccount:jsonString];

    NSLog(@"appDelegate.currentLoggedInUser ====> %@",appDelegate.currentLoggedInUser.auth_token);
    
    if (appDelegate.currentLoggedInUser != nil)
    {
        [AppDelegate performSelector:@selector(activeIndicatorStopAnimating) withObject:nil];
        self.view.userInteractionEnabled = YES;
        
        if (![self.navigationController.topViewController isKindOfClass:[LocalTrendsViewController class]])
        {
            objLocalTrendsViewController=[[LocalTrendsViewController alloc]initWithNibName:@"LocalTrendsViewController" bundle:nil];
            [self.navigationController pushViewController:objLocalTrendsViewController animated:YES];
        }
    }

//    NSString *likesString;
//    NSMutableDictionary *responseJSON = [responseString JSONValue];
//    NSArray *interestedIn = [responseJSON objectForKey:@"interested_in"];
//    if (interestedIn != nil) {
//        NSString *firstInterest = [interestedIn objectAtIndex:0];
//        if ([firstInterest compare:@"male"] == 0) {
//            [_imageView setImage:[UIImage imageNamed:@"depp.jpg"]];
//            likesString = @"dudes";
//        } else if ([firstInterest compare:@"female"] == 0) {
//            [_imageView setImage:[UIImage imageNamed:@"angelina.jpg"]];
//            likesString = @"babes";
//        }
//    } else {
//        [_imageView setImage:[UIImage imageNamed:@"maltese.jpg"]];
//        likesString = @"puppies";
//    }
//    
//    NSString *username;
//    NSString *firstName = [responseJSON objectForKey:@"first_name"];
//    NSString *lastName = [responseJSON objectForKey:@"last_name"];
//    if (firstName && lastName) {
//        username = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
//    } else {
//        username = @"mysterious user";
//    }
//    
//    [self refresh];
}

- (void)getFacebookPhotoFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    NSLog(@"Got Facebook Photo: %@", responseString);
    
    NSMutableDictionary *responseJSON = [responseString JSONValue];
    
    NSString *link = [responseJSON objectForKey:@"link"];
    if (link == nil) return;
    NSLog(@"Link to photo: %@", link);
}

- (void)postToWallFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    NSMutableDictionary *responseJSON = [responseString JSONValue];
    NSString *postId = [responseJSON objectForKey:@"id"];
    NSLog(@"Post id is: %@", postId);
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Sucessfully posted to photos & wall!"
												  message:@"Check out your Facebook to see!"
												 delegate:nil
										cancelButtonTitle:@"OK"
										otherButtonTitles:nil];
	[av show];
    
}

#pragma mark uploadPhoto

-(void)uploadText
{
    NSURL *url = [NSURL URLWithString:@"https://graph.facebook.com/me/feed"];
    ASIFormDataRequest *newRequest = [ASIFormDataRequest requestWithURL:url];
    [newRequest setPostValue:@"I'm learning how to post to Facebook from an iPhone app!" forKey:@"message"];
    [newRequest setPostValue:@"Check out the tutorial!" forKey:@"name"];
    [newRequest setPostValue:@"This tutorial shows you how to post to Facebook using the new Open Graph API." forKey:@"caption"];
    //[newRequest setPostValue:[NSString stringWithFormat:@"And by the way - check out this %@ pic.", adjectiveString] forKey:@"description"];
    [newRequest setPostValue:@"From Ray Wenderlich's blog - an blog about iPhone and iOS development." forKey:@"description"];
    [newRequest setPostValue:@"http://www.raywenderlich.com" forKey:@"link"];
    //[newRequest setPostValue:@"http://www.raywenderlich.com/wp-content/themes/raywenderlich/images/logo.png" forKey:@"picture"];
    [newRequest setPostValue:_accessToken forKey:@"access_token"];
    [newRequest setDidFinishSelector:@selector(postToWallFinished:)];
    
    [newRequest setDelegate:self];
    [newRequest startAsynchronous];
}
-(void)uploadPhoto
{
    UIImage* image = [UIImage imageNamed:@"images.jpeg"];
    
    NSString *filePath;
    
    NSString  *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.png"];
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.jpg"];
    
    [UIImageJPEGRepresentation(image, 1.0) writeToFile:jpgPath atomically:YES];
    [UIImagePNGRepresentation(image) writeToFile:pngPath atomically:YES];
    
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *tst=@"/Test.jpg";
    
    filePath = [documentsDirectory stringByAppendingString:tst];
    
    NSString *list = _accessToken;
    NSArray *listItems = [list componentsSeparatedByString:@"&"];
    NSString *finalstr=[listItems objectAtIndex:0];
    _accessToken=finalstr;
    
    NSString *message = [NSString stringWithFormat:@"Hi there!!"];
    NSURL *url = [NSURL URLWithString:@"https://graph.facebook.com/me/photos"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addFile:filePath forKey:@"file"];
    [request setPostValue:message forKey:@"message"];
    [request setPostValue:_accessToken forKey:@"access_token"];
    [request setDidFinishSelector:@selector(sendToPhotosFinished:)];
    [request setDelegate:self];
    [request startAsynchronous];
    self.view.userInteractionEnabled=YES;
    
}
#pragma mark FBFunLoginDialogDelegate

- (void)accessTokenFound:(NSString *)accessToken  andExpiryDate:(NSDate *)expiryDateString{
    NSLog(@"Access token found: %@", accessToken);
    
    self.expiryDate = expiryDateString;
    self.accessToken = accessToken;
    _loginState = LoginStateLoggedIn;
    [self dismissViewControllerAnimated:YES completion:nil];
    [self getFacebookProfile];
    //[self showLikeButton];
   // [self uploadText];
   // [self uploadPhoto];
    [self refresh];
    count = 0;
}

- (void)displayRequired
{
    if (count == 0)
    {
        count = 1;
        [self presentViewController:_loginDialog animated:YES completion:nil];
    }
}

- (void)closeTapped
{
    [AppDelegate performSelector:@selector(activeIndicatorStopAnimating) withObject:nil];
    self.view.userInteractionEnabled = YES;
    
    count = 0;
    [self dismissViewControllerAnimated:YES completion:nil];
    _loginState = LoginStateLoggedOut;
    [_loginDialog logout];
    [self refresh];
}

@end

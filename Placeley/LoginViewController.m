//
//  lonigViewController.m
//  Placeley
//
//  Created by APR on 12/17/13.
//  Copyright (c) 2013 APR. All rights reserved.
//

#import "LoginViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"


@interface LoginViewController ()

@property (nonatomic, copy) void (^confirmActionBlock)(void);
@property (nonatomic, copy) void (^cancelActionBlock)(void);

@end

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


@implementation LoginViewController

@synthesize btnLogin=_btnLogin;


@synthesize theTableView = _theTableView;
#pragma mark - View lifecycle

- (void)gppInit {
    // Make sure the GPPSignInButton class is linked in because references from
    // xib file doesn't count.
    [GPPSignInButton class];
    
    signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;
    
    signIn.delegate = self;
    

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

-(IBAction)btnLogin_Clicked:(id)sender
{
//    trendsDetailsVC_obj=[[trendsDetailsViewController alloc]initWithNibName:@"trendsDetailsViewController" bundle:nil];
//    [self.navigationController pushViewController:trendsDetailsVC_obj animated:YES];
    
//    trendsListVC_obj=[[trendsListViewController alloc]initWithNibName:@"trendsListViewController" bundle:nil];
//    [self.navigationController pushViewController:trendsListVC_obj animated:YES];
    
    
//  localTrendsVC=[[LocalTrendsViewController alloc]initWithNibName:@"LocalTrendsViewController" bundle:nil];
//    [self.navigationController pushViewController:localTrendsVC animated:YES];
    
  //  [self loginButtonTapped:nil];
}

-(IBAction)btnPostTweetClicked:(id)sender
{
    [self postTweet];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Login Button


- (void)viewWillAppear:(BOOL)animated {
    
    [[GPPSignIn sharedInstance] trySilentAuthentication];
    [self reportAuthStatus];
    [self updateButtons];

}

#pragma mark - GPPSignInDelegate

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth
                   error:(NSError *)error {
    if (error) {
        _signInAuthStatus.text =
        [NSString stringWithFormat:@"Status: Authentication error: %@", error];
        return;
    }
    NSLog(@"%@", signIn.authentication.userEmail);
    
    [self reportAuthStatus];
    [self updateButtons];
}

- (void)didDisconnectWithError:(NSError *)error {
    if (error) {
        _signInAuthStatus.text =
        [NSString stringWithFormat:@"Status: Failed to disconnect: %@", error];
    } else {
        _signInAuthStatus.text =
        [NSString stringWithFormat:@"Status: Disconnected"];
    }
    [self refreshUserInfo];
    [self updateButtons];
}

#pragma mark - Helper methods

// Temporarily force the sign in button to adopt its minimum allowed frame
// so that we can find out its minimum allowed width (used for setting the
// range of the width slider).
- (CGFloat)minimumButtonWidth {
    CGRect frame = self.signInButton.frame;
    self.signInButton.frame = CGRectZero;
    
    CGFloat minimumWidth = self.signInButton.frame.size.width;
    self.signInButton.frame = frame;
    
    return minimumWidth;
}

- (void)reportAuthStatus {
    if ([GPPSignIn sharedInstance].authentication) {
        _signInAuthStatus.text = @"Status: Authenticated";
    } else {
        // To authenticate, use Google+ sign-in button.
        _signInAuthStatus.text = @"Status: Not authenticated";
    }
    [self refreshUserInfo];
}

// Update the interface elements containing user data to reflect the
// currently signed in user.
- (void)refreshUserInfo {
    if ([GPPSignIn sharedInstance].authentication == nil) {
        self.userName.text = kPlaceholderUserName;
        self.userEmailAddress.text = kPlaceholderEmailAddress;
        self.userAvatar.image = [UIImage imageNamed:kPlaceholderAvatarImageName];
        return;
    }
    
    self.userEmailAddress.text = [GPPSignIn sharedInstance].userEmail;
    
    // The googlePlusUser member will be populated only if the appropriate
    // scope is set when signing in.
    GTLPlusPerson *person = [GPPSignIn sharedInstance].googlePlusUser;
    if (person == nil) {
        return;
    }
    
    self.userName.text = person.displayName;
    
    // Load avatar image asynchronously, in background
    dispatch_queue_t backgroundQueue =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(backgroundQueue, ^{
        NSData *avatarData = nil;
        NSString *imageURLString = person.image.url;
        if (imageURLString) {
            NSURL *imageURL = [NSURL URLWithString:imageURLString];
            avatarData = [NSData dataWithContentsOfURL:imageURL];
        }
        
        if (avatarData) {
            // Update UI from the main thread when available
            dispatch_async(dispatch_get_main_queue(), ^{
                self.userAvatar.image = [UIImage imageWithData:avatarData];
            });
        }
    });
}

// Adjusts "Sign in", "Sign out", and "Disconnect" buttons to reflect
// the current sign-in state (ie, the "Sign in" button becomes disabled
// when a user is already signed in).
- (void)updateButtons {
    BOOL authenticated = ([GPPSignIn sharedInstance].authentication != nil);
    
    self.signInButton.enabled = !authenticated;
    self.signOutButton.enabled = authenticated;
    self.disconnectButton.enabled = authenticated;
    self.credentialsButton.hidden = !authenticated;
    
    if (authenticated) {
        self.signInButton.alpha = 0.5;
        self.signOutButton.alpha = self.disconnectButton.alpha = 1.0;
    } else {
        self.signInButton.alpha = 1.0;
        self.signOutButton.alpha = self.disconnectButton.alpha = 0.5;
    }
}

#pragma mark - IBActions

- (IBAction)signOut:(id)sender
{
    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        
    }
    
    
    [[GPPSignIn sharedInstance] signOut];
    [self reportAuthStatus];
    [self updateButtons];
}

- (IBAction)disconnect:(id)sender {
    [[GPPSignIn sharedInstance] disconnect];
}


#pragma mark Twitter

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    
    UINavigationBar *bar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, (UIDevice.currentDevice.systemVersion.floatValue >= 7.0f)?64:44)];
    bar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    UINavigationItem *navItem = [[UINavigationItem alloc]initWithTitle:@"Twitter Login"];
	navItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    navItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(loginOAuth)];
	[bar pushNavigationItem:navItem animated:NO];
    [self.view addSubview:bar];
    
    [[FHSTwitterEngine sharedEngine]permanentlySetConsumerKey:@"Xg3ACDprWAH8loEPjMzRg" andSecret:@"9LwYDxw1iTc6D9ebHdrYCZrJP4lJhQv5uf4ueiPHvJ0"];
    [[FHSTwitterEngine sharedEngine]setDelegate:self];
    [[FHSTwitterEngine sharedEngine]loadAccessToken];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Created by Nathaniel Symer (@natesymer)";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return FHSTwitterEngine.sharedEngine.isAuthorized?3:2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self postTweet];
    } else if (indexPath.row == 1) {
        [self logTimeline];
    } else if (indexPath.row == 2) {
        [self logout];
    }
    [_theTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"CellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellID];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Post Tweet";
        cell.detailTextLabel.text = nil;
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"NSLog() Timeline";
        cell.detailTextLabel.text = nil;
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"Logout";
        cell.detailTextLabel.text = FHSTwitterEngine.sharedEngine.authenticatedUsername;
    }
    
    return cell;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView.title isEqualToString:@"Tweet"]) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @autoreleasepool {
                NSString *tweet = [alertView textFieldAtIndex:0].text;
                id returned = [[FHSTwitterEngine sharedEngine]postTweet:tweet];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
                NSString *title = nil;
                NSString *message = nil;
                
                if ([returned isKindOfClass:[NSError class]]) {
                    NSError *error = (NSError *)returned;
                    title = [NSString stringWithFormat:@"Error %ld",(long)error.code];
                    message = error.localizedDescription;
                } else {
                    NSLog(@"%@",returned);
                    title = @"Tweet Posted";
                    message = tweet;
                }
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    @autoreleasepool {
                        UIAlertView *av = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [av show];
                    }
                });
            }
        });
    } else {
        if (buttonIndex == 1) {
            NSString *username = [alertView textFieldAtIndex:0].text;
            NSString *password = [alertView textFieldAtIndex:1].text;
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                @autoreleasepool {
                    // getXAuthAccessTokenForUsername:password: returns an NSError, not id.
                    NSError *returnValue = [[FHSTwitterEngine sharedEngine]getXAuthAccessTokenForUsername:username password:password];
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        @autoreleasepool {
                            NSString *title = returnValue?[NSString stringWithFormat:@"Error %ld",(long)returnValue.code]:@"Success";
                            NSString *message = returnValue?returnValue.localizedDescription:@"You have successfully logged in via XAuth";
                            UIAlertView *av = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            [av show];
                            [_theTableView reloadData];
                        }
                    });
                }
            });
        }
    }
}

- (void)storeAccessToken:(NSString *)accessToken {
    [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:@"SavedAccessHTTPBody"];
}

- (NSString *)loadAccessToken {
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"SavedAccessHTTPBody"];
}

- (void)loginOAuth {
    UIViewController *loginController = [[FHSTwitterEngine sharedEngine]loginControllerWithCompletionHandler:^(BOOL success) {
        NSLog(success?@"L0L success":@"O noes!!! Loggen faylur!!!");
        [_theTableView reloadData];
    }];
    [self presentViewController:loginController animated:YES completion:nil];
}

- (void)loginXAuth {
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"xAuth Login" message:@"Enter your Twitter login credentials:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
    [av setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    [[av textFieldAtIndex:0]setPlaceholder:@"Username"];
    [[av textFieldAtIndex:1]setPlaceholder:@"Password"];
    [av show];
}

- (void)logout {
    [[FHSTwitterEngine sharedEngine]clearAccessToken];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *each in cookieStorage.cookies)
    {
        if ([[each valueForKey:@"domain"] isEqualToString:@".twitter.com"])
            [cookieStorage deleteCookie:each];
    }
    
    [_theTableView reloadData];
}

- (void)logTimeline {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            NSLog(@"%@",[[FHSTwitterEngine sharedEngine]getTimelineForUser:[[FHSTwitterEngine sharedEngine]authenticatedID] isID:YES count:10]);
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                @autoreleasepool {
                    [[[UIAlertView alloc]initWithTitle:@"Complete" message:@"Your list of followers has been fetched. Check your debugger." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                }
            });
        }
    });
}

#pragma mark uploadPhoto & text

- (void)postTweet {
    
    id returned = [[FHSTwitterEngine sharedEngine]getFriendsIDs];
    
    NSLog(@"%@",returned);
    
    UIImage *rainyImage =[UIImage imageNamed:@"images.jpeg"];
    
    NSData *imageData = UIImagePNGRepresentation(rainyImage);
    
    [[FHSTwitterEngine sharedEngine] postTweet:@"tweet string posted successfully." withImageData:imageData];
    
}

@end

//
//  SettingsViewController.m
//  Placeley
//
//  Created by APR on 1/3/14.
//  Copyright (c) 2014 APR. All rights reserved.
//

#import "SettingsViewController.h"
#import "FoursquareAuthentication.h"
#import <QuartzCore/QuartzCore.h>

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"

#define KAUTHURL @"https://api.instagram.com/oauth/authorize/?"
#define kAPIURl @"https://api.instagram.com/v1/users/"
#define KCLIENTID @"415dd621735d4031bb1d16c60ce7b494"
#define KCLIENTSERCRET @"54953046065e49559dbce77f9a57afec"
#define kREDIRECTURI @"http://instagram.com/developer/"
#define KACCESS_TOKEN @"access_token"


@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize loginButton = _loginButton;
@synthesize loginDialog = _loginDialog;
@synthesize loginDialogView = _loginDialogView;
@synthesize webView = _webView;
@synthesize accessToken = _accessToken;
@synthesize expiryDate = _expiryDate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    selectedShareIndexPaths = [[NSMutableArray alloc] init];
    selectedActivityIndexPaths = [[NSMutableArray alloc] init];

    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    settingsTableView.tableHeaderView.layer.cornerRadius=5.0;
    settingsTableView.tableHeaderView.layer.borderWidth=2.0;
    
    
    settingsTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(5.0f, 0.0f, settingsTableView.bounds.size.width, 10)];
    settingsTableView.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:230.0/255.0 blue:225.0/255.0 alpha:1.0];
    
    [self setNeedsStatusBarAppearanceUpdate];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    

    settingsTableView.separatorInset = UIEdgeInsetsZero;

   // [self personalButtonClicked:nil];
    
    [self networkButtonClicked:nil];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setNeedsStatusBarAppearanceUpdate];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    [settingsTableView reloadData];
}

-(IBAction)btn_Back_Clicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)personalButtonClicked:(id)sender
{
    isPersonal = YES;
    
    dataArray = [[NSMutableArray alloc] init];
    
    //First section data
    NSArray *firstItemsArray = [[NSArray alloc] initWithObjects:@"Public", @"Followers", @"Only me", nil];
    
    NSDictionary *firstItemsArrayDict = [NSDictionary dictionaryWithObject:firstItemsArray forKey:@"data"];
    [dataArray addObject:firstItemsArrayDict];
    
    //Second section data
    NSArray *secondItemsArray = [[NSArray alloc] initWithObjects:@"From all users", @"Friend's activity and Owner's activity", @"Show only Owner's activity", nil];
    
    NSArray *thirdItemsArray = [[NSArray alloc] initWithObjects:@"Name", @"Email", @"Phone", @"Password", @"Retype Password", nil];
    
    NSDictionary *secondItemsArrayDict = [NSDictionary dictionaryWithObject:secondItemsArray forKey:@"data"];
    [dataArray addObject:secondItemsArrayDict];
    
    NSDictionary *thirdItemsArrayDict = [NSDictionary dictionaryWithObject:thirdItemsArray forKey:@"data"];
    [dataArray addObject:thirdItemsArrayDict];

    personalButton.backgroundColor = [UIColor clearColor];
    networkButton.backgroundColor = [UIColor whiteColor];
    [personalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [networkButton setTitleColor:[UIColor colorWithRed:27/255.0 green:122.0/255.0 blue:191.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [settingsTableView reloadData];
}

-(IBAction)networkButtonClicked:(id)sender
{
    isPersonal = NO;
    
    dataArray = [[NSMutableArray alloc] init];
    
    //First section data
    NSArray *firstItemsArray = [[NSArray alloc] initWithObjects:@"Facebook", @"Twitter", @"Instagram", @"Foursquare", nil];
    
    NSDictionary *firstItemsArrayDict = [NSDictionary dictionaryWithObject:firstItemsArray forKey:@"data"];
    [dataArray addObject:firstItemsArrayDict];
    
    personalButton.backgroundColor = [UIColor whiteColor];
    networkButton.backgroundColor = [UIColor clearColor];
    [personalButton setTitleColor:[UIColor colorWithRed:27/255.0 green:122.0/255.0 blue:191.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [networkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [settingsTableView reloadData];
}

-(void)connectClicked:(UIButton *)button
{
    NSLog(@"button = %d",button.tag);
    
    if (button.tag == 0)
    {
        if (([[NSUserDefaults standardUserDefaults] objectForKey:@"Facebook"] != nil))
        {
            NSString *fbId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Facebook"];
            
            [self setUserDefault:[ServiceHelper disconnectAccount:fbId andauthToken:appDelegate.currentLoggedInUser.auth_token]];
            
            [settingsTableView reloadData];
        }
        else
        [self loginFBButtonTapped:nil];
    }
    else if (button.tag == 1)
    {
        if (([[NSUserDefaults standardUserDefaults] objectForKey:@"Twitter"] != nil))
        {
            NSString *fbId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Twitter"];
            
            [self setUserDefault:[ServiceHelper disconnectAccount:fbId andauthToken:appDelegate.currentLoggedInUser.auth_token]];
            
            [settingsTableView reloadData];
        }
        else
            [self loginOAuth];
    }
    else if (button.tag == 2)
    {
        if (([[NSUserDefaults standardUserDefaults] objectForKey:@"Instagram"] != nil))
        {
            NSString *fbId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Instagram"];
            
            [self setUserDefault:[ServiceHelper disconnectAccount:fbId andauthToken:appDelegate.currentLoggedInUser.auth_token]];
            
            [settingsTableView reloadData];
        }
        else
            [self InstagramClick:nil];
    }
    else if (button.tag == 3)
    {
        if (([[NSUserDefaults standardUserDefaults] objectForKey:@"FourSquare"] != nil))
        {
            NSString *fbId = [[NSUserDefaults standardUserDefaults] objectForKey:@"FourSquare"];
            
            [self setUserDefault:[ServiceHelper disconnectAccount:fbId andauthToken:appDelegate.currentLoggedInUser.auth_token]];
            
            [settingsTableView reloadData];
        }
        else
            [self connect:nil];
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //Number of rows it should expect should be based on the section
    NSDictionary *dictionary = [dataArray objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"data"];
    return [array count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    /*
    UIView* customView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, tableView.bounds.size.width, 44.0)];
    customView.backgroundColor = [UIColor whiteColor];
    
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44.0)];
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:18];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    switch (section) {
        case 0:
            if (isPersonal)
                headerLabel.text = @"Share my posts";
            else
                headerLabel.text = @"Connected Networks";
            break;
        case 1:
            headerLabel.text = @"Captain";
            break;
        case 2:
            headerLabel.text = @"General settings";
            break;
        default:
            break;
    }
    
    [customView addSubview:headerLabel];
    return customView;
     */
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    int height = 10;
    switch (section) {
        case 2:
        {
            height = 74;
        }
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    /*
    UIView* customView;
    customView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, tableView.bounds.size.width, 1.0)];

    switch (section) {
        case 2:
        {
            customView.frame = CGRectMake(0.0, 0.0, tableView.bounds.size.width, 44.0);
            customView.backgroundColor = [UIColor clearColor];
            
            UIButton *saveSettingsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            saveSettingsButton.frame = CGRectMake(10, 10, 300, 54.0);
            [saveSettingsButton setTitle:@"Save settings" forState:UIControlStateNormal];
            saveSettingsButton.layer.borderColor = [UIColor colorWithRed:27/255.0 green:122.0/255.0 blue:191.0/255.0 alpha:1.0].CGColor;
            saveSettingsButton.layer.borderWidth = 1.0f;
            [customView addSubview:saveSettingsButton];
        }
    }
    return customView;
     
     */
    return NO;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell ;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        /*
        if (isPersonal)
        {
            UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44.0)];
            headerLabel.tag = 200 + indexPath.row;
            headerLabel.backgroundColor = [UIColor clearColor];
            [cell addSubview:headerLabel];
            if (indexPath.section == 2)
            {
                headerLabel.frame = CGRectMake(10, 0, tableView.bounds.size.width/2, 44.0);
                
                UITextField * rightSideLabel = [[UITextField alloc] initWithFrame:CGRectMake(140, 0, tableView.bounds.size.width/2, 44.0)];
                rightSideLabel.font = [UIFont systemFontOfSize:14];
                rightSideLabel.delegate = self;
                rightSideLabel.tag = 100 + indexPath.row;
                rightSideLabel.backgroundColor = [UIColor clearColor];
                [cell addSubview:rightSideLabel];
            }
        }
         
         */
        
        if (!isPersonal && indexPath.section == 0)
        {
            logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5,20,20,10)];
            logoImageView.backgroundColor = [UIColor redColor];
            logoImageView.contentMode=UIViewContentModeBottomLeft;
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button addTarget:self action:@selector(connectClicked:)  forControlEvents:UIControlEventTouchDown];
            [button setTitle:@"Connect" forState:UIControlStateNormal];
            
            switch (indexPath.row)
            {
                case 0:
                    logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"face_iconSet.png"]];
                    [cell addSubview:logoImageView];
                    break;
                case 1:
                    logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"twittIconSet.png"]];
                    [cell addSubview:logoImageView];
                    break;
                case 2:
                    logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"instgr_iconSet.png"]];
                    [cell addSubview:logoImageView];
                    break;

                case 3:
                    logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fqus_iconSet.png"]];
                    [cell addSubview:logoImageView];

                    break;


                default:
                    break;
            }
            [button setTitleColor:[UIColor colorWithRed:27/255.0 green:122.0/255.0 blue:191.0/255.0 alpha:1.0] forState:UIControlStateNormal];

            if ((indexPath.row == 0) && ([[NSUserDefaults standardUserDefaults] objectForKey:@"Facebook"] != nil))
            {
                [button setTitle:@"Disconnect" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                
                 }
            else if ((indexPath.row == 1) && ([[NSUserDefaults standardUserDefaults] objectForKey:@"Twitter"] != nil))
            {
               [button setTitle:@"Disconnect" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

            }
            else if ((indexPath.row == 2) && ([[NSUserDefaults standardUserDefaults] objectForKey:@"Instagram"] != nil))
            {
                [button setTitle:@"Disconnect" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

            }
            else if ((indexPath.row == 3) && ([[NSUserDefaults standardUserDefaults] objectForKey:@"FourSquare"] != nil))
            {
                [button setTitle:@"Disconnect" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

            }
            
            button.tag = indexPath.row;
            button.frame = CGRectMake(150, 5, tableView.bounds.size.width/2, 34.0);
            [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
            [cell addSubview:button];
            
            UILabel * headerLabel = [[UILabel alloc] init];
            headerLabel.frame = CGRectMake(54, 0, 130, 44.0);
            headerLabel.tag = 200 + indexPath.row;
            headerLabel.backgroundColor = [UIColor clearColor];
            [cell addSubview:headerLabel];

        }

    }
    UILabel * headerLabel = (UILabel *)[cell viewWithTag:200 + indexPath.row];
    
    NSDictionary *dictionary = [dataArray objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"data"];
    NSString *cellValue = [array objectAtIndex:indexPath.row];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.textColor = [UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.0];
    headerLabel.text = cellValue;
    headerLabel.font = [UIFont boldSystemFontOfSize:14];

    if (indexPath.section == 2)
    {
        headerLabel.textAlignment = NSTextAlignmentLeft;
        headerLabel.frame = CGRectMake(10, 0, 130, 44.0);
        headerLabel.textColor = [UIColor blackColor];

        UITextField * rightSideLabel = (UITextField *)[cell viewWithTag:100 + indexPath.row];
        rightSideLabel.textAlignment = NSTextAlignmentLeft;
        rightSideLabel.textColor = [UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.0];
        rightSideLabel.text = @"";
    }
    if (!isPersonal && indexPath.section == 0)
    {
        headerLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//Get the selected country
    
    NSString *selectedCell = nil;
    NSDictionary *dictionary = [dataArray objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"data"];
    selectedCell = [array objectAtIndex:indexPath.row];
    
    NSLog(@"%d", indexPath.row);
    
    [settingsTableView deselectRowAtIndexPath:indexPath animated:NO];
}



- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.5 delay:0
                        options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear
                     animations:^{
                         settingsTableView.contentOffset = CGPointMake(settingsTableView.contentOffset.x, 300 + (textField.tag - 100)* 44);
                     }
                     completion:NULL];

}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [UIView animateWithDuration:0.5 delay:0
                        options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear
                     animations:^{
                         settingsTableView.contentOffset = CGPointMake(settingsTableView.contentOffset.x, 300 + (textField.tag - 100)* 44);
                     }
                     completion:NULL];
    return YES;

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [UIView animateWithDuration:0.5 delay:0
                        options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear
                     animations:^{
                         settingsTableView.contentOffset = CGPointMake(settingsTableView.contentOffset.x, 300);
                     }
                     completion:NULL];
    [textField resignFirstResponder];

    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Twitter

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [[FHSTwitterEngine sharedEngine]permanentlySetConsumerKey:@"Xg3ACDprWAH8loEPjMzRg" andSecret:@"9LwYDxw1iTc6D9ebHdrYCZrJP4lJhQv5uf4ueiPHvJ0"];
    [[FHSTwitterEngine sharedEngine]setDelegate:self];
    [[FHSTwitterEngine sharedEngine]loadAccessToken];
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
                        }
                    });
                }
            });
        }
    }
}

- (void)storeAccessToken:(NSString *)accessToken {
    [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:@"Twitter"];
    NSLog(@" %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"Twitter"]);
    
    NSString *jsonString = [[NSUserDefaults standardUserDefaults] objectForKey:@"Twitter Json"];
    
    if (![jsonString isEqualToString:@""])
    {
        [self setUserDefault:[ServiceHelper connectAccount:jsonString andauthToken:appDelegate.currentLoggedInUser.auth_token]];
    }

}

- (NSString *)loadAccessToken {
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"Twitter"];
    NSLog(@" %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"Twitter"]);
}

- (void)loginOAuth {
    UIViewController *loginController = [[FHSTwitterEngine sharedEngine]loginControllerWithCompletionHandler:^(BOOL success) {
        NSLog(success?@"L0L success":@"O noes!!! Loggen faylur!!!");
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

-(IBAction)btnPostTweetClicked:(id)sender
{
    [self postTweet];
}

- (void)postTweet {
    
    id returned = [[FHSTwitterEngine sharedEngine]getFriendsIDs];
    
    NSLog(@"%@",returned);
    
    UIImage *rainyImage =[UIImage imageNamed:@"slider-1.png"];
    
    NSData *imageData = UIImagePNGRepresentation(rainyImage);
    
    [[FHSTwitterEngine sharedEngine] postTweet:@"tweet string posted successfully." withImageData:imageData];
    
}

#pragma mark Foursquare

- (IBAction)connect:(id)sender {
	FoursquareAuthentication *controller = [[FoursquareAuthentication alloc] init];
	[self presentViewController:controller animated:NO completion:nil];
	[self.connectToFoursquare setHidden:YES];
}

#pragma mark Instagram

- (IBAction)InstagramClick:(id)sender
{
    [AppDelegate performSelector:@selector(activeIndicatorStartAnimating:) withObject:self.view afterDelay:0.2];

    mywebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    NSString *fullURL = [NSString stringWithFormat:@"%@client_id=%@&redirect_uri=%@&response_type=token",KAUTHURL,KCLIENTID,kREDIRECTURI];
    NSURL *url = [NSURL URLWithString:[fullURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url]; [mywebview loadRequest:requestObj];
    mywebview.delegate = self;
    [self.view addSubview:mywebview];
    
    
    instagramCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [instagramCancel addTarget:self
               action:@selector(cancelInstagramClicked:)
     forControlEvents:UIControlEventTouchDown];
    [instagramCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [instagramCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    instagramCancel.frame = CGRectMake(80.0, self.view.frame.size.height - 80.0, 160.0, 40.0);
    [instagramCancel setBackgroundColor:[UIColor colorWithRed:86.0/255.0 green:157.0/255.0 blue:119.0/255.0 alpha:1.0]];
    [self.view addSubview:instagramCancel];

}

-(void)cancelInstagramClicked:(id)sender
{
    [mywebview removeFromSuperview];
    [instagramCancel removeFromSuperview];
    [AppDelegate performSelector:@selector(activeIndicatorStopAnimating) withObject:nil];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString* urlString = [[request URL] absoluteString];
    NSLog(@"URL STRING : %@ ",urlString);
    NSArray *UrlParts = [urlString componentsSeparatedByString:[NSString stringWithFormat:@"#"]];
    if ([UrlParts count] > 1) {
        // do any of the following here
        urlString = [UrlParts objectAtIndex:1];
        NSRange accessToken = [urlString rangeOfString: @"access_token="];
        if (accessToken.location != NSNotFound) {
            NSString* strAccessToken = [urlString substringFromIndex: NSMaxRange(accessToken)];
            // Save access token to user defaults for later use.
            // Add contant key #define KACCESS_TOKEN @”access_token” in contant //class
            
            [[ NSUserDefaults standardUserDefaults] setValue:strAccessToken forKey:@"Instagram Json"];
            
            NSLog(@"AccessToken = %@ ",strAccessToken);
            [mywebview removeFromSuperview];
            [self loadRequestForMediaData];
            [AppDelegate performSelector:@selector(activeIndicatorStopAnimating) withObject:nil];
            [settingsTableView reloadData];
        }
        return NO;
    }
    else if ([urlString rangeOfString:@"login/?next="].location!=NSNotFound)
    {
        NSLog(@"Substring Found");
        [AppDelegate performSelector:@selector(activeIndicatorStopAnimating) withObject:nil];
    }

    
    return YES;
}

-(void)loadRequestForMediaData {
    
    NSLog(@"standardUserDefaults = %@",[NSURL URLWithString:[NSString stringWithFormat:@"%@self/?access_token=%@",kAPIURl,[[ NSUserDefaults standardUserDefaults] valueForKey:@"Instagram Json"]]]);
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@self/?access_token=%@",kAPIURl,[[ NSUserDefaults standardUserDefaults]valueForKey:@"Instagram Json"]]]];
    // Here you can handle response as well
    NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"Response : %@",dictResponse);
    
    if (dictResponse != nil)
    {
        NSMutableDictionary *originalDictionary = [[NSMutableDictionary alloc] init];
        
        [originalDictionary setValue:@"" forKey:@"email"];
        [originalDictionary setValue:[dictResponse objectForKey:@"id"] forKey:@"uid"];
        [originalDictionary setValue:[[ NSUserDefaults standardUserDefaults] valueForKey:@"Instagram Json"] forKey:@"token"];
        [originalDictionary setValue:@"instagram" forKey:@"provider"];
        [originalDictionary setValue:[dictResponse objectForKey:@"username"] forKey:@"name"];
        
        [originalDictionary setValue:@"" forKey:@"expires_at"];
        
        NSMutableDictionary *finalDict=[[NSMutableDictionary alloc]init];
        
        [finalDict addEntriesFromDictionary:originalDictionary];
        
        NSDictionary *arDict = [NSDictionary dictionaryWithObject:finalDict forKey:@"info"];
        
        SBJsonWriter *jsonWriter = [SBJsonWriter new];
        
        NSString *jsonString = [jsonWriter stringWithObject:arDict];
        
        NSLog(@"jsonString = %@",jsonString);
        
        [self setUserDefault:[ServiceHelper connectAccount:jsonString andauthToken:appDelegate.currentLoggedInUser.auth_token]];
    }

}

-(void)showErrorAlert:(NSString *)message
{
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Alert" message:message
                                                        delegate:self
                                               cancelButtonTitle:@"Ok."
                                               otherButtonTitles:nil];
    [errorAlert show];
    
}

-(void)setUserDefault:(id)userObject
{
    if ([userObject valueForKey:@"error"])
    {
        [self showErrorAlert:[userObject valueForKey:@"error"]];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Facebook"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Twitter Connect"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Instagram"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"FourSquare"];
        
        NSMutableDictionary *userDict = [[NSMutableDictionary alloc] initWithDictionary:[userObject valueForKey:@"user"]];
        
        NSMutableDictionary *connectedDict = [[NSMutableDictionary alloc] initWithDictionary:[userDict valueForKey:@"connected"]];
        
        if ([connectedDict valueForKey:@"facebook"] != nil)
        {
            [[NSUserDefaults standardUserDefaults] setObject:[self checkForNull:[connectedDict valueForKey:@"facebook"]] forKey:@"Facebook"];
        }
        if ([connectedDict valueForKey:@"twitter"] != nil)
        {
            [[NSUserDefaults standardUserDefaults] setObject:[self checkForNull:[connectedDict valueForKey:@"twitter"]] forKey:@"Twitter Connect"];
        }
        if ([connectedDict valueForKey:@"instagram"] != nil)
        {
            [[NSUserDefaults standardUserDefaults] setObject:[self checkForNull:[connectedDict valueForKey:@"instagram"]] forKey:@"Instagram"];
        }
        if ([connectedDict valueForKey:@"foursquare"] != nil)
        {
            [[NSUserDefaults standardUserDefaults] setObject:[self checkForNull:[connectedDict valueForKey:@"foursquare"]] forKey:@"FourSquare"];
        }
    }
}

-(id)checkForNull:(id)value
{
    NSString *valueString = [NSString stringWithFormat:@"%@",value];
    
    id objectString = @"";
    
    if (![valueString isEqualToString:@"(null)"] && ![valueString isEqualToString:@"<null>"] && valueString.length != 0)
        return value;
    
    return objectString;
}

#pragma mark Facebook Login Button

- (IBAction)loginFBButtonTapped:(id)sender
{
    [AppDelegate performSelector:@selector(activeIndicatorStartAnimating:) withObject:self.view afterDelay:0.2];
    self.view.userInteractionEnabled = NO;
    
    
    NSString *appId = @"408481352616594";
    NSString *permissions = @"publish_stream,email";
    _loginState = LoginStateLoggedOut;
    [_loginDialog logout];
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
    
    NSMutableDictionary *originalDictionary = [[NSMutableDictionary alloc] init];
    
    [originalDictionary setValue:[responseJSON objectForKey:@"email"] forKey:@"email"];
    [originalDictionary setValue:[responseJSON objectForKey:@"id"] forKey:@"uid"];
    [originalDictionary setValue:self.accessToken forKey:@"token"];
    [originalDictionary setValue:@"facebook" forKey:@"provider"];
    [originalDictionary setValue:[responseJSON objectForKey:@"name"] forKey:@"name"];
    
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
    
    [self setUserDefault:[ServiceHelper connectAccount:jsonString andauthToken:appDelegate.currentLoggedInUser.auth_token]];
    
    [AppDelegate performSelector:@selector(activeIndicatorStopAnimating) withObject:nil];

    self.view.userInteractionEnabled = YES;

    [settingsTableView reloadData];
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
}


@end

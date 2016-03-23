//
//  AppDelegate.m
//  Placeley
//
//  Created by APR on 12/17/13.
//  Copyright (c) 2013 APR. All rights reserved.
//

#import "AppDelegate.h"
#import <GooglePlus/GooglePlus.h>
#import "UIImage+animatedGIF.h"

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"

 UIView  *loadingBgView;
 UIView *loadingView;
static UIImageView  *imgAnimation;


@implementation AppDelegate

@synthesize loginPlaceleyVC_obj=_loginPlaceleyVC_obj;

@synthesize Obj_LocalTrendsViewController=_Obj_LocalTrendsViewController;

@synthesize currentLoggedInUser;


// DO NOT USE THIS CLIENT ID. IT WILL NOT WORK FOR YOUR APP.
// Please use the client ID created for you by Google.
//static NSString * const kClientID =@"452265719636-qbqmhro0t3j9jip1npl69a3er7biidd2.apps.googleusercontent.com";

static NSString * const kClientID =
@"866259634138-ptc61epcb8g6tqssjp8p3jnktqv52uod.apps.googleusercontent.com";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Set app's client ID for |GPPSignIn| and |GPPShare|.
    
    [GPPSignIn sharedInstance].clientID = kClientID;

    // Create Loading Indicator===============
    [self createActiveIndicatorView];
    
    //[ServiceHelper createNewAccount:@""];
    
  //  [ServiceHelper likePlace:@"52790d2f49c88aa98300001d" andAuthToken:@"962e541d6caaa2d8c3a77394b6a1d45fdd202307"];
 //   [ServiceHelper UnlikePlace:@"52790d2f49c88aa98300001d" andAuthToken:@"962e541d6caaa2d8c3a77394b6a1d45fdd202307"];

    // Ststus bar=====================
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Login View
    self.loginPlaceleyVC_obj = [[LoginPlaceleyViewController alloc] initWithNibName:@"LoginPlaceleyViewController" bundle:nil];
    self.NavigationVC_obj=[[UINavigationController alloc]initWithRootViewController:self.loginPlaceleyVC_obj];
    self.NavigationVC_obj.navigationBarHidden = YES;
    self.window.rootViewController = self.NavigationVC_obj;
    
    
    // Details View
    
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//   objtrendsDetailsViewController = [[trendsDetailsViewController alloc] initWithNibName:@"trendsDetailsViewController" bundle:nil];
//    self.NavigationVC_obj=[[UINavigationController alloc]initWithRootViewController:objtrendsDetailsViewController];
//    self.NavigationVC_obj.navigationBarHidden = YES;
//    self.window.rootViewController = self.NavigationVC_obj;

    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // Read Google+ deep-link data.
    [GPPDeepLink setDelegate:self];
    [GPPDeepLink readDeepLinkAfterInstall];

    
//    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/image.jpg"];
//    UIImage *img = [UIImage imageNamed:@"icon.png"];
//    
//    
//    // Write a UIImage to JPEG with minimum compression (best quality)
//    [UIImageJPEGRepresentation(img, 0.5) writeToFile:jpgPath atomically:YES];
//    
//    NSString *photoPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/image.jpg"];
//    
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://zuppl.com/photos"]];
//    //[request setPostValue:@"Hi uploading photo" forKey:@"data"];
//    [request setFile:photoPath forKey:@"file"];
//    [request setDidFinishSelector:@selector(sendToPhotosFinished:)];
//    [request setDelegate:self];
//    [request startSynchronous];

    
    return YES;
}

- (void)sendToPhotosFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]
                                                            options:0 error:NULL];

    NSMutableArray *responseIdArray = [[NSMutableArray alloc] init];
    
    for (int iCount = 0; iCount < [responseArray count]; iCount++) {
        NSMutableDictionary *responseDictionary = [[NSMutableDictionary alloc] initWithDictionary:[responseArray objectAtIndex:iCount]];
        [responseIdArray addObject:[responseDictionary objectForKey:@"id"]];
    }
    
    NSLog(@"responseIdArray = %@",responseIdArray);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [AppDelegate performSelector:@selector(activeIndicatorStopAnimating) withObject:nil];
    UIViewController *viewController = (UIViewController *)self.NavigationVC_obj.topViewController;
    viewController.view.userInteractionEnabled = YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - ====================ActiveIndicatorMethods for Gif image Animation=========================

- (void)createActiveIndicatorView
{
    loadingBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
    loadingBgView.backgroundColor = [UIColor greenColor]  ;
    loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.window.frame.size.width, self.window.frame.size.height)];
    loadingView.backgroundColor=[UIColor greenColor];
    
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"loadingblue" withExtension:@"gif"];
    UIImageView *imgGifAnimation = [[UIImageView alloc]init];
    imgGifAnimation.contentMode = UIViewContentModeScaleAspectFill;
    
    if (IS_IPHONE_5)
    {
        imgGifAnimation.frame=CGRectMake(0, 0, 320, 568);
    }
    else
    {
        imgGifAnimation.frame=CGRectMake(0, 0, 320, 480);
        
    }
    imgGifAnimation.image= [UIImage animatedImageWithAnimatedGIFURL:url];
    
    
    [loadingView addSubview:imgGifAnimation];
    
    [loadingBgView addSubview:loadingView];

    
}
+ (void)activeIndicatorStartAnimating:(UIButton*)view
{
    
    [view addSubview:loadingBgView];
}

+ (void)activeIndicatorStopAnimating
{
    if (![imgAnimation isAnimating])
    {
        [imgAnimation stopAnimating];
        [loadingBgView removeFromSuperview];
    }
}


/*
#pragma mark - ActiveIndicatorMethods

- (void)createActiveIndicatorView
{
    loadingBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
    loadingBgView.backgroundColor = [UIColor clearColor];
    loadingBgView.center = CGPointMake(self.window.frame.size.width / 2, self.window.frame.size.height / 2);
    
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
    grayView.backgroundColor = [UIColor grayColor];
    grayView.alpha = 0.5;
    grayView.center = CGPointMake(self.window.frame.size.width / 2, self.window.frame.size.height / 2);
    [loadingBgView addSubview:grayView];
    
    loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 90)];
    // loadingView.backgroundColor = [UIColor grayColor];
    
    loadingView.backgroundColor = [UIColor  colorWithRed:208.0/255.0 green:213.0/255.0 blue:221.0/255.0 alpha:1];
    loadingView.layer.cornerRadius = 10;
    loadingView.layer.borderWidth = 1;
    loadingView.layer.borderColor = [UIColor clearColor].CGColor;
    loadingView.center = CGPointMake(self.window.frame.size.width / 2, self.window.frame.size.height / 2);
    
    UIActivityIndicatorView  *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = CGRectMake(0, 0,40, 40);;
    [loadingView addSubview:activityIndicator];
    activityIndicator.center = CGPointMake(loadingView.frame.size.width / 2, 70 / 2);
    [activityIndicator startAnimating];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 120, 20)];
    textLabel.text =@"Loading...";
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.textColor = [UIColor grayColor];
    textLabel.backgroundColor = [UIColor clearColor];
    [loadingView addSubview:textLabel];
    
    [loadingBgView addSubview:loadingView];
}

+ (void)activeIndicatorStartAnimating:(UIView*)view
{
    loadingBgView.center = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2);
    [activityIndicator startAnimating];
    [view addSubview:loadingBgView];
}

+ (void)activeIndicatorStopAnimating
{
    [activityIndicator stopAnimating];
    [loadingBgView removeFromSuperview];
}
*/



#pragma mark - GPPDeepLinkDelegate
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [GPPURLHandler handleURL:url
                  sourceApplication:sourceApplication
                         annotation:annotation];
}

- (void)didReceiveDeepLink:(GPPDeepLink *)deepLink {
    // An example to handle the deep link data.
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Deep-link Data"
                          message:[deepLink deepLinkID]
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}


#pragma mark =======Reachablity Check==========

-(BOOL)checkReachability
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    if(networkStatus == NotReachable)
    {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Internet is not Available", nil) message:NSLocalizedString(@"Please connect to Internet", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        return NO;
        
    }
    else
    {
        return YES;
    }
}


static AppDelegate *temp=nil;
+(AppDelegate *)appDelegate
{
    if (!temp)
    {
        temp=[[AppDelegate alloc]init];
        
    }
    return temp;
}


@end

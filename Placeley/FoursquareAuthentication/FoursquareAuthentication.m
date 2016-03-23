//
//  FoursquareAuthentication.m
//  foursquaredemo
//
//  Created by Keith Elliott on 4/18/13.
//  Copyright (c) 2013 gittielabs. All rights reserved.
//

#import "FoursquareAuthentication.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "ServiceHelper.h"

	// 5. setup some helpers so we don't have to hard-code everything
#define FOURSQUARE_AUTHENTICATE_URL @"https://foursquare.com/oauth2/authorize"
#define FOURSQUARE_CLIENT_ID @"EIVV14MS4USTLYTBYACBWRHFYWUKDIJSIKQPM0DW3HJUWHMK"
#define FOURSQUARE_CLIENT_SECRET @"WJH0MXM55NHCO3AKNDO043T2T4RTWRY0VKWQES1NR3MEA2SZ"
#define FOURSQUARE_REDIRECT_URI @"https://developer.foursquare.com/overview/auth"

@interface FoursquareAuthentication ()
	// 1. create webview property
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation FoursquareAuthentication

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
	// Do any additional setup after loading the view.
	
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [AppDelegate performSelector:@selector(activeIndicatorStartAnimating:) withObject:self.view afterDelay:0.2];

		// initialize the webview and add it to the view
	
		//2. init with the available window dimensions
	self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
		//3. set the delegate to self so that we can respond to web activity
	self.webView.delegate = self;
		//4. add the webview to the view
	[self.view addSubview:self.webView];
	
    foursquareCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [foursquareCancel addTarget:self
                        action:@selector(cancelfoursquareClicked:)
              forControlEvents:UIControlEventTouchDown];
    [foursquareCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [foursquareCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    foursquareCancel.frame = CGRectMake(80.0, self.view.frame.size.height - 50.0, 160.0, 40.0);
    [foursquareCancel setBackgroundColor:[UIColor colorWithRed:36.0/255.0 green:154.0/255.0 blue:208.0/255.0 alpha:1.0]];
    [self.view addSubview:foursquareCancel];

		//6. Create the authenticate string that we will use in our request to foursquare
		// we have to provide our client id and the same redirect uri that we used in setting up our app
		// The redirect uri can be any scheme we want it to be... it's not actually going anywhere as we plan to
		// intercept it and get the access token off of it
	NSString *authenticateURLString = [NSString stringWithFormat:@"%@?client_id=%@&response_type=token&redirect_uri=%@", FOURSQUARE_AUTHENTICATE_URL, FOURSQUARE_CLIENT_ID, FOURSQUARE_REDIRECT_URI];
		//7. Make the request and load it into the webview
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:authenticateURLString]];
	[self.webView loadRequest:request];

}

-(void)cancelfoursquareClicked:(id)sender
{
    // 10. dismiss the view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Web view delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    NSLog(@"request.URL.scheme = %@",request.URL.scheme);
    
 if([request.URL.scheme isEqualToString:@"https"]){
		 // 8. get the url and check for the access token in the callback url
		NSString *URLString = [[request URL] absoluteString];
		if ([URLString rangeOfString:@"access_token="].location != NSNotFound) {
				// 9. Store the access token in the user defaults
			NSString *accessToken = [[URLString componentsSeparatedByString:@"="] lastObject];
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.foursquare.com/v2/users/self?oauth_token=%@&v=20140219",accessToken]];
            
            NSData *myData = [NSData dataWithContentsOfURL:url];
            
            NSString* newStr = [NSString stringWithUTF8String:[myData bytes]];
            
            NSLog(@"[newStr %@",newStr);
            
            if (![newStr isEqualToString:@""])
            {
                NSMutableDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding]  options:0 error:NULL];
                
                NSMutableDictionary *responseTag = [[NSMutableDictionary alloc] initWithDictionary:[responseDictionary objectForKey:@"response"]];
                NSMutableDictionary *userTag = [[NSMutableDictionary alloc] initWithDictionary:[responseTag objectForKey:@"user"]];
                NSMutableDictionary *contactTag = [[NSMutableDictionary alloc] initWithDictionary:[userTag objectForKey:@"contact"]];

                NSMutableDictionary *originalDictionary = [[NSMutableDictionary alloc] init];
                
                [originalDictionary setValue:[contactTag objectForKey:@"email"] forKey:@"email"];
                [originalDictionary setValue:[userTag objectForKey:@"id"] forKey:@"uid"];
                [originalDictionary setValue:accessToken forKey:@"token"];
                [originalDictionary setValue:@"foursquare" forKey:@"provider"];
                [originalDictionary setValue:[userTag objectForKey:@"firstName"] forKey:@"firstName"];
                
                [originalDictionary setValue:@"" forKey:@"expires_at"];
                
                NSMutableDictionary *finalDict=[[NSMutableDictionary alloc]init];
                
                [finalDict addEntriesFromDictionary:originalDictionary];
                
                NSDictionary *arDict = [NSDictionary dictionaryWithObject:finalDict forKey:@"info"];
                
                SBJsonWriter *jsonWriter = [SBJsonWriter new];
                
                NSString *jsonString = [jsonWriter stringWithObject:arDict];
                
                NSLog(@"jsonString = %@",jsonString);
                
                [ServiceHelper connectAccount:jsonString andauthToken:appDelegate.currentLoggedInUser.auth_token];
            }
				// 10. dismiss the view controller
			[self dismissViewControllerAnimated:YES completion:nil];
		}
        else if ([URLString rangeOfString:@"response_type=token&redirect_uri"].location ==NSNotFound)
        {
            NSLog(@"Substring not Found");
            [AppDelegate performSelector:@selector(activeIndicatorStopAnimating) withObject:nil];
        }

	}
	return YES;
}

@end

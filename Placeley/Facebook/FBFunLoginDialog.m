//
//  FBFunLoginDialog.m
//  FBFun
//
//  Created by Ray Wenderlich on 7/13/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import "FBFunLoginDialog.h"

@implementation FBFunLoginDialog
@synthesize webView = _webView;
@synthesize apiKey = _apiKey;
@synthesize requestedPermissions = _requestedPermissions;
@synthesize delegate = _delegate;

#pragma mark Main

- (id)initWithAppId:(NSString *)apiKey requestedPermissions:(NSString *)requestedPermissions delegate:(id<FBFunLoginDialogDelegate>)delegate {
    if ((self = [super initWithNibName:@"FBFunLoginDialog" bundle:[NSBundle mainBundle]])) {
        self.apiKey = apiKey;
        self.requestedPermissions = requestedPermissions;
        self.delegate = delegate;
    }
    return self;
}

- (void)dealloc {
    self.webView = nil;
    self.apiKey = nil;
    self.requestedPermissions = nil;
    [super dealloc];
}

#pragma mark Login / Logout functions

- (void)login {
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    
    NSString *redirectUrlString = @"http://www.facebook.com/connect/login_success.html";
    NSString *authFormatString = @"https://graph.facebook.com/oauth/authorize?client_id=%@&redirect_uri=%@&scope=%@&type=user_agent&display=touch";
    
    NSString *urlString = [NSString stringWithFormat:authFormatString, _apiKey, redirectUrlString, _requestedPermissions];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

-(void)logout {
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie* cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [cookies deleteCookie:cookie];
    }
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *urlString = request.URL.absoluteString;
    
    [self checkForAccessToken:urlString];
    [self checkLoginRequired:urlString];
    
    return TRUE;
}

#pragma mark Helper functions

-(void)checkForAccessToken:(NSString *)urlString {
    NSLog(@"urlString = %@",urlString);
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"access_token=(.*)&" options:0 error:&error];
    if (regex != nil) {
        NSTextCheckingResult *firstMatch = [regex firstMatchInString:urlString options:0 range:NSMakeRange(0, [urlString length])];
        if (firstMatch) {
            NSRange accessTokenRange = [firstMatch rangeAtIndex:1];
            NSString *accessToken = [urlString substringWithRange:accessTokenRange];
            accessToken = [accessToken stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSMutableDictionary *queryStringDictionary = [[NSMutableDictionary alloc] init];
            NSArray *urlComponents = [urlString componentsSeparatedByString:@"&"];

            for (NSString *keyValuePair in urlComponents)
            {
                NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
                NSString *key = [pairComponents objectAtIndex:0];
                NSString *value = [pairComponents objectAtIndex:1];
                
                [queryStringDictionary setObject:value forKey:key];
            }
            
            NSString *expTime = [queryStringDictionary objectForKey:@"expires_in"]; //[params valueForKey:@"expires_in"];
            NSDate *expirationDate = [NSDate distantFuture];
            if (expTime != nil) {
                int expVal = [expTime intValue];
                if (expVal != 0) {
                    expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
                    
                    NSLog(@"expirationDate:%@",expirationDate);
                }
            }
            [_delegate accessTokenFound:accessToken andExpiryDate:expirationDate];

        }
    }
}

-(void)checkLoginRequired:(NSString *)urlString {
    NSLog(@"Url: %@",urlString);
    if ([urlString rangeOfString:@"login.php"].location != NSNotFound && [urlString rangeOfString:@"refid"].location == NSNotFound) {
        [_delegate displayRequired];
    } else if ([urlString rangeOfString:@"user_denied"].location != NSNotFound) {
        [_delegate closeTapped];
    }
}

- (IBAction)closeTapped:(id)sender

{
    

    [_delegate closeTapped];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please check your network connection and try again later..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //	[alert show];
    //    alert.tag=1;
    //	[alert release];
	
	
	
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"close");
    [_delegate closeTapped];
}

@end

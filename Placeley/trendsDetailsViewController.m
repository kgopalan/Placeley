//
//  trendsDetailsViewController.m
//  Placeley
//
//  Created by APR on 12/17/13.
//  Copyright (c) 2013 APR. All rights reserved.
//

#import "trendsDetailsViewController.h"
#import "ServiceHelper.h"
#import "MTPopupWindow.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "SettingsViewController.h"


#import "FilterCell.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"

#define KAUTHURL @"https://api.instagram.com/oauth/authorize/?"
#define kAPIURl @"https://api.instagram.com/v1/users/"
#define KCLIENTID @"415dd621735d4031bb1d16c60ce7b494"
#define KCLIENTSERCRET @"54953046065e49559dbce77f9a57afec"
#define kREDIRECTURI @"http://instagram.com/developer/"
#define KACCESS_TOKEN @"access_token"

#import "WhatsAppKit.h"
#import "ComposeMsgVC.h"


@interface trendsDetailsViewController()
{
    AppDelegate *appDelegate;
    
    ComposeMsgVC *objComposeMsgVC;
}
@end

@interface trendsDetailsViewController ()
{
    SettingsViewController *objsettingsViewController;
}
@end

@implementation trendsDetailsViewController

@synthesize trendDetailView = _trendDetailView;
@synthesize selectedOption;

@synthesize loginButton = _loginButton;
@synthesize loginDialog = _loginDialog;
@synthesize loginDialogView = _loginDialogView;
@synthesize webView = _webView;
@synthesize accessToken = _accessToken;
@synthesize expiryDate = _expiryDate;

@synthesize placeId;

@synthesize placeName;

@synthesize currentLocation;
@synthesize destLocation;

@synthesize detailProfileImgView = _detailProfileImgView;
@synthesize detailLogoImgView = _detailLogoImgView;

@synthesize lblAdditionalPreName = _lblAdditionalPreName;
@synthesize lblAdditionalAddress = _lblAdditionalAddress;

@synthesize scrllViewMain=_scrllViewMain;
@synthesize scrllViewAddtionalimg=_scrllViewAddtionalimg;

@synthesize imgTrendsMain=_imgTrendsMain;
@synthesize imgLogo=_imgLogo;
@synthesize imgIcon=_imgIcon;
@synthesize imgTrendsAdditional=_imgTrendsAdditional;

@synthesize lblTrendTittle=_lblTrendTittle;
@synthesize lblTrendAddress=_lblTrendAddress;
@synthesize lblTrendFollower=_lblTrendFollower;
@synthesize lblTrendBuddies=_lblTrendBuddies;
@synthesize lblTrendThumpsup=_lblTrendThumpsup;
@synthesize lblTrendSubTittle=_lblTrendSubTittle;
@synthesize lblTrendSubAddress=_lblTrendSubAddress;
@synthesize lblOpenBetween=_lblOpenBetween;

@synthesize btnFollowing=_btnFollowing;
@synthesize btnLike=_btnLike;
@synthesize btnShare=_btnShare;
@synthesize btnActivity=_btnActivity;
@synthesize btnDeals=_btnDeals;
@synthesize btnSocial=_btnSocial;

@synthesize viewActivity=_viewActivity;
@synthesize viewFollowins=_viewFollowins;
@synthesize viewSocial=_viewSocial;
@synthesize viewTopBorder;
@synthesize viewInstgramBorder;

@synthesize btnFBicon,btnFeqicon,btnInsticon,btnTwitticon,btnWikiicon,btnYelpicon;
@synthesize imgOpenCloseTop,imgOpenCloseTopBand;


@synthesize detailScrollView = _detailScrollView;

@synthesize twitterPageButton = _twitterPageButton;

//===============================Social page objects=============

@synthesize scrllViewInstgram=_scrllViewInstgram;

@synthesize lblYelpChat=_lblYelpChat;
//@synthesize lblYelpChatPersonName=_llblYelpChatPersonName;
//@synthesize lblYelpChatPersonAddress=_lblYelpChatPersonAddress;

@synthesize scrllViewYelpChat=_scrllViewYelpChat;

@synthesize lblFbTalkingabt=_lblFbTalkingabt;
@synthesize lblFbTotalLikes=_lblFbTotalLikes;
@synthesize lblFbVisited=_lblFbVisited;
@synthesize lblFbTotalcheckins=_lblFbTotalcheckins;

@synthesize lblFqsPopularity=_lblFqsPopularity;
@synthesize lblFqsHerenow=_lblFqsHerenow;
@synthesize lblFqsTotalVisiters=_lblFqsTotalVisiters;
@synthesize lblFqsTotalcheckin=_lblFqsTotalcheckin;

@synthesize lblTweets=_lblTweets;
@synthesize lblTwittFollowing=_llblTwittFollowing;
@synthesize lblTwittFollowers=_lblTwittFollowers;
@synthesize btnAtTweets=_btnAtTweets;
@synthesize btnHashTweets=_btnHashTweets;
@synthesize scrllViewTweets=_scrllViewTweets;
@synthesize scrllViewTweetHashtags=_scrllViewTweetHashtags;
@synthesize lblTweetsShopDetails=_lblTweetsShopDetails;
@synthesize webViewWikiContent=_webViewWikiContent;
@synthesize tweetHandlerView = _tweetHandlerView;
@synthesize tweetHashTagsView = _tweetHashTagsView;


@synthesize instagramView = _instagramView;
@synthesize yelpView = _yelpView;
@synthesize yelpBottomView = _yelpBottomView;
@synthesize yelpContentView = _yelpContentView;
@synthesize facebookView = _facebookView;
@synthesize foursquareView = _foursquareView;
@synthesize twitterView = _twitterView;
@synthesize twitterHashTagsView = _twitterHashTagsView;
@synthesize bottomSocialIconBar = _bottomSocialIconBar;
@synthesize wikiView = _wikiView;

@synthesize topBandView = _topBandView;
@synthesize topBandMessageView = _topBandMessageView;
@synthesize topBandPreName = _topBandPreName;
@synthesize topBandAddress = _topBandAddress;
@synthesize topBandLogoImage = _topBandLogoImage;

@synthesize topActivityName = _topActivityName;
@synthesize topDetailOf = _topDetailOf;
@synthesize fancyContainer;
@synthesize selectedTrend;
@synthesize viewInstgramLargeImg;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)shareClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;

    if (selectedOption == 1)
    {
        [self performSelectorInBackground:@selector(downloadImage:) withObject:[NSString stringWithFormat:@"%@",[[trendDetail.imageArray objectAtIndex:0] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];

        if ([trendDetail.imageArray count] > 0)
        {
            [self performSelectorInBackground:@selector(downloadImage:) withObject:[NSString stringWithFormat:@"%@",[[trendDetail.imageArray objectAtIndex:0] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            
           // shareLink = [NSString stringWithFormat:@"%@",[[trendDetail.imageArray objectAtIndex:0] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
        
        shareText = [NSString stringWithFormat:@"Hello There - %@ share the place %@ Pictures with you. Feel free to click on the link to view more details. %@/%@        Thanks - Placeley Team'    ",appDelegate.currentLoggedInUser.name,trendDetail.pre_name,_rootUrl,trendDetail.place_id];
    }
    else if (selectedOption == 2)
    {
        NSLog(@"button.superview.tag = %d",button.superview.tag);

        ActivityFeed *activityFeed = [allactivityFeedsArray objectAtIndex:button.superview.tag - 500];
        
        shareimage = nil;
        
        
        shareText = [NSString stringWithFormat:@"%@ has recommended %@ %@/%@",activityFeed.computed_name,_rootUrl,activityFeed.placeId,activityFeed.name];
    }
    else if (selectedOption == 3)
    {
        NSLog(@"button.superview.tag = %d",button.superview.tag);
        
        Followings *currentFollowing = [allFollowingsArray objectAtIndex:button.superview.tag - 5000];
        
        shareText = [NSString stringWithFormat:@"Hello There - %@ share the place %@ Pictures with you. Feel free to click on the link to view more details. %@/%@        Thanks - Placeley Team'    ",appDelegate.currentLoggedInUser.name,currentFollowing.pre_name,_rootUrl,currentFollowing.place_id];

        if ([currentFollowing.photos_url count] > 0)
        {
            [self performSelectorInBackground:@selector(downloadImage:) withObject:[NSString stringWithFormat:@"%@",[NSURL URLWithString:[NSString stringWithFormat:@"%@",[currentFollowing.photos_url objectAtIndex:0]]]]];
            
           // shareLink = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[NSURL URLWithString:[NSString stringWithFormat:@"%@",[currentFollowing.photos_url objectAtIndex:0]]]]];
        }
    }

    if (self.sideMenu.isOpen)
        [self.sideMenu close];
    else
        [self.sideMenu open];
}

-(void)downloadImage:(NSString *)urlString
{
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];
    
    shareimage = [[UIImage alloc] initWithData:data];
    
    NSString  *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.png"];
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.jpg"];
    
    [UIImageJPEGRepresentation(shareimage, 1.0) writeToFile:jpgPath atomically:YES];
    [UIImagePNGRepresentation(shareimage) writeToFile:pngPath atomically:YES];
    
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *tst=@"/Test.jpg";
    
    shareLink = [documentsDirectory stringByAppendingString:tst];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   /*
    NSArray *images = @[[UIImage imageNamed:@"menutrends.png"],[UIImage imageNamed:@"menuactivity.png"],[UIImage imageNamed:@"menufollowing.png"],[UIImage imageNamed:@"menusettings.png"]];
    
       UIView *transparentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    transparentView.backgroundColor = [UIColor blackColor];
    transparentView.alpha = 0.5;
    [fancyContainer addSubview:transparentView];
    
    self.menu = [[FAFancyMenuView alloc] init];
    self.menu.delegate = self;
    self.menu.buttonImages = images;
    [fancyContainer addSubview:self.menu];
    fancyContainer.hidden = YES;
    */
    

    [self setNeedsStatusBarAppearanceUpdate];

    _topBandView.hidden = YES;
    
    [self.scrllViewMain setFrame:CGRectMake(0, 36, 320, 569)];
    
    postType = @"All";
    
    
    
    //====================SideMenu Animation View================
    
    UIView *twitterItem = [[UIView alloc] initWithFrame:CGRectMake(0, 6, 40, 40)];
    [twitterItem setMenuActionWithBlock:^{
        [self.sideMenu close];
        NSLog(@"tapped twitter item");
        [AppDelegate performSelector:@selector(activeIndicatorStartAnimating:) withObject:self.view afterDelay:0.0];
        NSString *twitterAccessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"Twitter"];
        if ([twitterAccessToken isEqualToString:@""] || twitterAccessToken == nil) {
            [self loginOAuth];
        }
        else
        {
            [self performSelector:@selector(postTweet) withObject:nil afterDelay:0.1];
        }
    }];
    UIImageView *twitterIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [twitterIcon setImage:[UIImage imageNamed:@"twitterLogo"]];
    [twitterItem addSubview:twitterIcon];
    
    
    UIView *emailItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [emailItem setMenuActionWithBlock:^{
        [self.sideMenu close];
        [self sendEmail];
    }];
    UIImageView *emailIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40 , 40)];
    [emailIcon setImage:[UIImage imageNamed:@"mailLogo"]];
    [emailItem addSubview:emailIcon];
    
    UIView *facebookItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 42, 42)];
    [facebookItem setMenuActionWithBlock:^{
        [self.sideMenu close];
        [AppDelegate performSelector:@selector(activeIndicatorStartAnimating:) withObject:self.view afterDelay:0.0];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Facebook"] != nil)
        {
            NSMutableDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:[[[NSUserDefaults standardUserDefaults] objectForKey:@"Facebook"] dataUsingEncoding:NSUTF8StringEncoding]  options:0 error:NULL];
            
            NSString *accessToken = [responseDictionary valueForKey:@"token"];
            
            NSLog(@"accessToken====>%@",accessToken);
            
            if ([accessToken isEqualToString:@""] || accessToken == nil)
            {
                [self loginFBButtonTapped:nil];
            }
            else
            {
                if (selectedOption == 2)
                {
                    [self uploadText];
                }
                else
                {
                    [self uploadPhoto];
                }
            }
        }
        else
        {
            [self loginFBButtonTapped:nil];
        }
    }];
    UIImageView *facebookIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 42, 42)];
    [facebookIcon setImage:[UIImage imageNamed:@"facebookLogo"]];
    [facebookItem addSubview:facebookIcon];
    
    
    
    UIView *watsItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 38, 38)];
    [watsItem setMenuActionWithBlock:
     ^{
         [self WatsAppShare];
        [self.sideMenu close];
    }];
    UIImageView *WatsIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 38, 38)];
    [WatsIcon setImage:[UIImage imageNamed:@"watsAppLogo"]];
    [watsItem addSubview:WatsIcon];
    
    self.sideMenu = [[HMSideMenu alloc] initWithItems:@[twitterItem, emailItem, facebookItem, watsItem]];
    [self.sideMenu setItemSpacing:5.0f];
    [self.view addSubview:self.sideMenu];
    
    //===========================================================
    
    self.topBandMessageView.hidden = YES;
    bottomIconsNumber = [[NSMutableArray alloc] init];
    
    facebookUrl = @"";
    yelpUrl = @"";
    twitterUrl = @"";
    instagramUrl = @"";
    foursquareUrl = @"";
    wikiUrl = @"";
    
    self.bottomSocialIconBar.hidden = YES;
    
    
    _twitterPageButton.layer.borderWidth = 1.0f;
    _twitterPageButton.layer.borderColor = [UIColor colorWithRed:0.0/255.0 green:128.0/255.0 blue:238.0/255.0 alpha:1.0].CGColor;
    
    viewTopBorder.layer.borderWidth = 0.1f;
    viewTopBorder.layer.borderColor =[[UIColor lightGrayColor]CGColor];
    viewTopBorder.layer.cornerRadius = 3.0;
   
    viewInstgramBorder.layer.borderWidth = 0.1f;
    
    //=====================
    
    SwipeFromTrendsDetailsVC =[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFormTrendsDetailVC)];
    [SwipeFromTrendsDetailsVC setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:SwipeFromTrendsDetailsVC];
    
    viewInstgramLargeImg.layer.borderWidth = 0.1f;
    viewInstgramLargeImg.layer.borderColor =[[UIColor lightGrayColor]CGColor];
    viewInstgramLargeImg.layer.cornerRadius = 3.0;

    
    //==================WatsApp==============
    
    [self requestAddressBookWithCompletionHandler:^(ABAddressBookRef theAddressBookRef, BOOL available) {
        // do your addressbook stuff in here
    }];
    
    NSLog([WhatsAppKit isWhatsAppInstalled]? @"installed" : @"not installed");
    
    //=================================
    
    [self.view addSubview:viewManuoptions];
    if (IS_IPHONE_5)
    {
        viewManuoptions.frame=CGRectMake(0, 568, 320, 568);
        btnInfoPage.frame=CGRectMake(257, 524, 30, 30);
        
    }
    else
    {
        viewManuoptions.frame=CGRectMake(0, 480, 320, 480);
        btnInfoPage.frame=CGRectMake(257, 440, 30, 30);
        
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureCloseMenus:)];
    [viewManuoptions addGestureRecognizer:tapGesture];
    
    btnInfoPage.layer.borderWidth = 1.f;
    btnInfoPage.layer.borderColor =[[UIColor whiteColor]CGColor];
    btnInfoPage.layer.cornerRadius = 12.0;


}


-(IBAction)btnMenuTrending_Clicked:(id)sender
{
    viewManuoptions.hidden=YES;
    [self trendingsPopToVC];
    
}

-(IBAction)btnMenuFollowing_Clicked:(id)sender
{
    viewManuoptions.hidden=YES;
    selectedOption = 3; // Following
    [self viewWillAppear:YES];
    
}

-(IBAction)btnMenuActivity_Clicked:(id)sender
{
    viewManuoptions.hidden=YES;
    selectedOption = 2; // Activity
    [self viewWillAppear:YES];
}
-(IBAction)btnMenuSettings_Clicked:(id)sender
{
    viewManuoptions.hidden=YES;
    [self pushToSettingsVC];
}


/*
- (void)fancyMenu:(FAFancyMenuView *)menu didSelectedButtonAtIndex:(NSUInteger)index{
    NSLog(@"Selected index====>%i",index);
    switch (index)
    {
        case 0:
            [self trendingsPopToVC];
            break;
        case 1:
        {
            selectedOption = 2;
            [self viewWillAppear:YES];
        }
            break;
        case 2:
        {
            selectedOption = 3;
            [self viewWillAppear:YES];
        }
            break;
        case 3:
            [self pushToSettingsVC];
            //[self nearMePopToVC];
            break;
        case 4:
            //[self pushToSettingsVC];
            break;
            
        default:
            break;
    }
    [self.menu hide];
}


*/



-(void)trendingsPopToVC
{
    for (UIViewController *viewcontroller in [self.navigationController viewControllers])
    {
        if ([viewcontroller isKindOfClass:[LocalTrendsViewController class]])
        {
            objLocalTrendsViewController =(LocalTrendsViewController *)viewcontroller;
            objLocalTrendsViewController.strSelectedVC=@"Trendings";
            [self.navigationController popToViewController:viewcontroller animated:YES];
        }
    }
}


-(void)nearMePopToVC
{
    for (UIViewController *viewcontroller in [self.navigationController viewControllers])
    {
        if ([viewcontroller isKindOfClass:[LocalTrendsViewController class]])
        {
            objLocalTrendsViewController =(LocalTrendsViewController *)viewcontroller;
            objLocalTrendsViewController.strSelectedVC=@"NearMe";
            [self.navigationController popToViewController:viewcontroller animated:YES];
        }
    }
}

-(void)pushToSettingsVC
{
    objsettingsViewController=[[SettingsViewController alloc]initWithNibName:@"SettingsViewController" bundle:nil];
    [self.navigationController pushViewController:objsettingsViewController animated:YES];

    
}

-(void)handleSwipeFormTrendsDetailVC
{
    for (UIViewController *viewcontroller in [self.navigationController viewControllers])
    {
        if ([viewcontroller isKindOfClass:[LocalTrendsViewController class]])
        {
            [self.navigationController popToViewController:viewcontroller animated:YES];
        }
    }
}



#pragma mark ========= WatsApp Methods Start ============================

- (BOOL) isStatusAvailable:(AddressBookAuthStatus)theStatus
{
    return (theStatus == kABAuthStatusAuthorized || theStatus == kABAuthStatusRestricted);
}

- (void) requestAddressBookWithCompletionHandler:(AddressbookRequestHandler)handler
{
    ABAddressBookRef addressBookRef = NULL;
    
    addressBookRef = ABAddressBookCreateWithOptions(nil, nil);
    ABAuthorizationStatus curStatus = ABAddressBookGetAuthorizationStatus();
    if(curStatus == kABAuthorizationStatusNotDetermined)
    {
        status = kABAuthStatusPending;
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            status = ABAddressBookGetAuthorizationStatus();
            if(handler != NULL){
                handler(addressBookRef, [self isStatusAvailable:status]);
            }
        });
    }else
    {
        status = curStatus;
        dispatch_async( (dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)), ^{
            if(handler != NULL){
                handler(addressBookRef, [self isStatusAvailable:status]);
            }
        });
    }
}

- (AddressBookAuthStatus) addressBookAuthLevel
{
    return status;
}


-(void)WatsAppShare
{
    
    UIAlertView *alertWatsApp = [[UIAlertView alloc]
                          initWithTitle:@"WhatsApp Share"
                          message:@""
                          delegate:self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"Launch with image", @"Launch with message", nil];
    [alertWatsApp show];
    alertWatsApp.tag=5757;
    
}

- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    
   self.documentationInteractionController =
    
    [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    
    self.documentationInteractionController.delegate = interactionDelegate;
    
    return self.documentationInteractionController;
    
}

- (void)launchWhatsAppwithImage
{
    if ([WhatsAppKit isWhatsAppInstalled])
    {
        if ([[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"whatsapp://app"]]){
//            NSString *pathToResourceFile = [[NSBundle mainBundle] pathForResource:@"unlike" ofType:@"png"];
//            NSURL *imageFileURL =[NSURL fileURLWithPath:pathToResourceFile];
           NSURL *imageFileURL =[NSURL fileURLWithPath:shareLink];

            NSLog(@"imag %@",imageFileURL);
            self.documentationInteractionController.delegate = self;
            self.documentationInteractionController.UTI = @"net.whatsapp.image";
            self.documentationInteractionController = [self setupControllerWithURL:imageFileURL usingDelegate:self];
            [self.documentationInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
        }
    }
}


- (void)launchWhatsAppWithMessage
{
    if ([WhatsAppKit isWhatsAppInstalled])
    {
        [WhatsAppKit launchWhatsAppWithMessage:@"this is demo message"];
    }
}



#pragma mark ========= WatsApp Methods End ============================


-(void)viewWillAppear:(BOOL)animated
{
    pagingView.hidden = YES;

    if (selectedOption == 1)
    {
      //  [self loadInfiniteScrollingData];

        self.viewActivity.hidden = YES;
        self.viewSocial.hidden = NO;
        self.trendDetailView.hidden = NO;

        [AppDelegate performSelector:@selector(activeIndicatorStartAnimating:) withObject:self.view afterDelay:0.0];
      
        self.view.userInteractionEnabled = NO;
        
        [self performSelector:@selector(fetchDetailDataFromServer) withObject:nil afterDelay:0.2];
        
        [self performSelector:@selector(fetchAggregationDataFromServer:) withObject:nil afterDelay:0.5];
    }
    else if (selectedOption == 2)
    {
        [self performSelector:@selector(btnActivity_Clicked:) withObject:nil afterDelay:0.0];
    }
    else if (selectedOption == 3)
    {
        [self performSelector:@selector(btnDeals_Clicked:) withObject:nil afterDelay:0.0];

        self.trendDetailView.hidden = YES;


    }
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)loadInfiniteScrollingData
{
    if (IS_IPHONE_5)
    {
       pagingView = [[InfinitePagingView alloc] initWithFrame:CGRectMake(0.f, self.view.frame.size.height - 50, self.view.frame.size.width, 50.f)];
        
        [self.view addSubview:pagingView];
    }
    else
    {
        pagingView = [[InfinitePagingView alloc] initWithFrame:CGRectMake(0.f, self.view.frame.size.height - 50, self.view.frame.size.width, 50.f)];
        [self.view addSubview:pagingView];
    }
   
    pagingView.hidden = NO;
    pagingView.backgroundColor = [UIColor blackColor];
    pagingView.pageSize = CGSizeMake(170.f, self.view.frame.size.height);
    pagingView.isFilter = NO;
    pagingView.delegate = self;
    _topActivityName.text=@"Social Aggregation";
    
    NSMutableArray *activityNames = [[NSMutableArray alloc] initWithObjects:@"All",@"Social Aggregation",  nil];

    if ([trendDetail.updates boolValue]) {
        [activityNames addObject:@"Updates"];
    } else if ([trendDetail.events boolValue]) {
        [activityNames addObject:@"Events"];
    } else if ([trendDetail.deals boolValue]) {
        [activityNames addObject:@"Deals"];
    }
   // NSMutableArray *activityNames = [[NSMutableArray alloc] initWithObjects:@"Followings",@"Social Aggregation",@"Activity Feeds",  nil];
   // NSMutableArray *activityNames = [[NSMutableArray alloc] initWithObjects:@"Social Aggregation",  nil];

    for (NSUInteger i = 0; i < [activityNames count]; ++i) {
        UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [myButton setTitle:[activityNames objectAtIndex:i] forState:UIControlStateNormal];
        [myButton setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
        myButton.frame = CGRectMake(0.f , 0, 320.f, pagingView.frame.size.height);
        [myButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        
        [pagingView addPageView:myButton];
    }
}

- (void)pageIndexTitle:(NSString *)pageIndexTitle
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(btnSocial_Clicked:) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(btnDeals_Clicked:) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(btnActivity_Clicked:) object:nil];

    _topActivityName.text = pageIndexTitle;

    if ([pageIndexTitle isEqualToString:@"Social Aggregation"])
    {
        selectedOption = 1;
        [self performSelector:@selector(btnSocial_Clicked:) withObject:nil afterDelay:0.2];
    }
    else  if ([pageIndexTitle isEqualToString:@"All"])
    {
        selectedOption = 2;
        postType = @"All";

        [self performSelector:@selector(btnActivity_Clicked:) withObject:nil afterDelay:0.2];
    }
    else  if ([pageIndexTitle isEqualToString:@"Updates"])
    {
        selectedOption = 2;
        postType = @"Updates";
        
        [self performSelector:@selector(btnActivity_Clicked:) withObject:nil afterDelay:0.2];
    }
    else  if ([pageIndexTitle isEqualToString:@"Deals"])
    {
        selectedOption = 2;
        postType = @"Deals";
        
        [self performSelector:@selector(btnActivity_Clicked:) withObject:nil afterDelay:0.2];
    }
}

#pragma mark - ===========BUTTON ACTIONS METHODS=================

-(IBAction)btnAtHashTagTweets:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (![[button currentTitle] isEqualToString:@""])
    {
        NSString *hash = [NSString stringWithFormat:@"https://twitter.com/search?q=%@&src=hash",[[button currentTitle] stringByReplacingOccurrencesOfString:@"@" withString:@""]];
        [MTPopupWindow showWindowWithHTMLFile:hash insideView:self.view];
    }
}
-(IBAction)btnAtHandlerTweets:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (![[button currentTitle] isEqualToString:@""])
    {
        NSString *hash = [NSString stringWithFormat:@"https://twitter.com/%@",[[button currentTitle] stringByReplacingOccurrencesOfString:@"@" withString:@""]];
        [MTPopupWindow showWindowWithHTMLFile:hash insideView:self.view];
    }
}
-(IBAction)btnDeals_Clicked:(id)sender
{
//    [self resetScrollviewToZeroPosition];
//    [self hideViewWithAnimation:self.bottomSocialIconBar andToFrame:pagingView.frame];
//    [self.viewActivity removeFromSuperview];
//    [self.viewSocial removeFromSuperview];
    
    self.viewActivity.hidden = YES;
    self.viewSocial.hidden = YES;
    self.trendDetailView.hidden = YES;
    self.bottomSocialIconBar.hidden=YES;
    self.viewFollowins.hidden = YES;
    
    _topActivityName.text=@"Following";
    
    [self.viewFollowins setFrame:CGRectMake(0, 0, 320, 568)];
    [self.scrllViewMain addSubview:self.viewFollowins];
    [self.scrllViewMain setContentSize:CGSizeMake(320, 1000)];
    
    
    [self performSelector:@selector(fetchFollowingDetailsFromServer) withObject:nil afterDelay:0];
    
    FollowingView *currentFollowingView = [[[NSBundle mainBundle] loadNibNamed:@"FollowingView"
                                                                         owner:self
                                                                       options:nil]objectAtIndex:0];
    currentFollowingView.frame = CGRectMake(10 , 10, currentFollowingView.frame.size.width, currentFollowingView.frame.size.height);
    
    [scrolViewMainFollowing addSubview:currentFollowingView];

}

-(IBAction)btnActivity_Clicked:(id)sender
{
    self.viewFollowins.hidden = YES;
    self.viewSocial.hidden = YES;
    self.trendDetailView.hidden = YES;
    self.viewActivity.hidden = NO;
    self.bottomSocialIconBar.hidden=YES;
    
    [self.viewActivity setFrame:CGRectMake(self.viewActivity.frame.origin.x, self.viewActivity.frame.origin.y, self.viewActivity.frame.size.width, 568)];
    [self.scrllViewMain addSubview:self.viewActivity];
    [self.scrllViewMain setContentSize:CGSizeMake(320, 1200)];

    _topActivityName.text=@"Activity Feed";

    [AppDelegate performSelector:@selector(activeIndicatorStartAnimating:) withObject:self.view afterDelay:0];
    
    self.view.userInteractionEnabled = NO;

    for (int iCount = 0; iCount < [allactivityFeedsArray count]; iCount ++)
    {
        ActivityFeedView *currentActivityFeedView = (ActivityFeedView *)[scrolViewMainActivity viewWithTag:iCount + 500];
        
        if (currentActivityFeedView != nil)
        {
            [currentActivityFeedView removeFromSuperview];
        }
    }

    [self performSelector:@selector(fetchActivityFeedsFromServer) withObject:nil afterDelay:0.1];
}

-(IBAction)btnSocial_Clicked:(id)sender
{
    isInitialLoad = YES;
    
    if (imgNodata != nil)
    {
        [imgNodata removeFromSuperview];
    }

    self.viewFollowins.hidden = YES;
    self.viewSocial.hidden = NO;
    self.trendDetailView.hidden = NO;
    self.viewActivity.hidden = YES;
    self.bottomSocialIconBar.hidden=NO;

    if (self.bottomSocialIconBar.frame.origin.y != 451)
    {
        int subviewcount = 0;
        for (UIButton *subview in [self.bottomSocialIconBar subviews])
        {
            subview.hidden = NO;

            if ([bottomIconsNumber containsObject:[NSString stringWithFormat:@"%d",subview.tag]])
            {
                NSLog(@"subview.tag = %d",subview.tag);
                subview.frame = CGRectMake(subviewcount * 50 + 3, subview.frame.origin.y, subview.frame.size.width, subview.frame.size.height);
                subviewcount ++;
            }
            else
            {
                subview.hidden = YES;
            }
        }
       
        
        self.bottomSocialIconBar.frame = CGRectMake(self.bottomSocialIconBar.frame.origin.x, self.bottomSocialIconBar.frame.origin.y, subviewcount * 50, self.bottomSocialIconBar.frame.size.height);
        self.bottomSocialIconBar.center = CGPointMake(self.view.frame.size.width / 2, (self.bottomSocialIconBar.frame.origin.y + self.bottomSocialIconBar.frame.size.height)/2);
        
        [self resetScrollviewToZeroPosition];
        self.bottomSocialIconBar.hidden = NO;
        [self showViewWithAnimation:self.bottomSocialIconBar andFromFrame:pagingView.frame];
        
        [self.viewFollowins removeFromSuperview];
        [self.viewActivity removeFromSuperview];
        [self.viewSocial setFrame:CGRectMake(0, 328, 320, 2567)];
        [self.scrllViewMain addSubview:self.viewSocial];
        [self.scrllViewMain setContentSize:CGSizeMake(320, tempHeight + 328 + 130)];
    }
    [self Instgram_Clicked:nil];
}


-(IBAction)btnInstgramPage_Clicked:(id)sender;
{
    if (![instagramUrl isEqualToString:@""])
        [self openRemoteUrl:instagramUrl];
}

-(IBAction)btnYelpPage_Clicked:(id)sender
{
    if (![yelpUrl isEqualToString:@""])
        [self openRemoteUrl:yelpUrl];
}

-(IBAction)btnFBPage_Clicked:(id)sender;
{
    if (![facebookUrl isEqualToString:@""])
        [self openRemoteUrl:facebookUrl];
}

-(IBAction)btnFqsPage_Clicked:(id)sender
{
    if (![foursquareUrl isEqualToString:@""])
        [self openRemoteUrl:foursquareUrl];
}

-(IBAction)btnTwitterPage_Clicked:(id)sender
{
    if (![twitterUrl isEqualToString:@""])
        [self openRemoteUrl:twitterUrl];
}

-(IBAction)btnWikipediaPage_Clicked:(id)sender;
{
    if (![wikiUrl isEqualToString:@""])
        [self openRemoteUrl:wikiUrl];
}


-(IBAction)Instgram_Clicked:(id)sender;
{
    [btnInsticon setImage:[UIImage imageNamed:@"instagram.png"] forState:UIControlStateNormal];
     [btnYelpicon setImage:[UIImage imageNamed:@"Icon-yelp-inActive.png"] forState:UIControlStateNormal];
     [btnFBicon setImage:[UIImage imageNamed:@"Icon-FB-inactive.png"] forState:UIControlStateNormal];
     [btnFeqicon setImage:[UIImage imageNamed:@"Icon-4Square-inactive.png"] forState:UIControlStateNormal];
     [btnTwitticon setImage:[UIImage imageNamed:@"Icon-twitter-inactive.png"] forState:UIControlStateNormal];
     [btnWikiicon setImage:[UIImage imageNamed:@"Icon-wiki-inactive.png"] forState:UIControlStateNormal];
    
    if (!isInitialLoad)
    {
        [self animatingViewToTop:_instagramView];
    }
    isInitialLoad = NO;
}

-(IBAction)Yelp_Clicked:(id)sender;
{
    [btnYelpicon setImage:[UIImage imageNamed:@"yelp.png"] forState:UIControlStateNormal];
    
    [btnInsticon setImage:[UIImage imageNamed:@"Icon-Instagram-inActive.png"] forState:UIControlStateNormal];
    [btnFBicon setImage:[UIImage imageNamed:@"Icon-FB-inactive.png"] forState:UIControlStateNormal];
    [btnFeqicon setImage:[UIImage imageNamed:@"Icon-4Square-inactive.png"] forState:UIControlStateNormal];
    [btnTwitticon setImage:[UIImage imageNamed:@"Icon-twitter-inactive.png"] forState:UIControlStateNormal];
    [btnWikiicon setImage:[UIImage imageNamed:@"Icon-wiki-inactive.png"] forState:UIControlStateNormal];
    
    [self animatingViewToTop:_yelpView];

}
-(IBAction)Facebook_Clicked:(id)sender;
{
    [self animatingViewToTop:_facebookView];
    [btnFBicon setImage:[UIImage imageNamed:@"fb.png"] forState:UIControlStateNormal];
    
    [btnInsticon setImage:[UIImage imageNamed:@"Icon-Instagram-inActive.png"] forState:UIControlStateNormal];
    [btnYelpicon setImage:[UIImage imageNamed:@"Icon-yelp-inActive.png"] forState:UIControlStateNormal];
    [btnFeqicon setImage:[UIImage imageNamed:@"Icon-4Square-inactive.png"] forState:UIControlStateNormal];
    [btnTwitticon setImage:[UIImage imageNamed:@"Icon-twitter-inactive.png"] forState:UIControlStateNormal];
    [btnWikiicon setImage:[UIImage imageNamed:@"Icon-wiki-inactive.png"] forState:UIControlStateNormal];

}
-(IBAction)Foursquare_Clicked:(id)sender;
{
    [btnFeqicon setImage:[UIImage imageNamed:@"4square.png"] forState:UIControlStateNormal];
    
    
    [btnInsticon setImage:[UIImage imageNamed:@"Icon-Instagram-inActive.png"] forState:UIControlStateNormal];
    [btnYelpicon setImage:[UIImage imageNamed:@"Icon-yelp-inActive.png"] forState:UIControlStateNormal];
    [btnFBicon setImage:[UIImage imageNamed:@"Icon-FB-inactive.png"] forState:UIControlStateNormal];
    [btnTwitticon setImage:[UIImage imageNamed:@"Icon-twitter-inactive.png"] forState:UIControlStateNormal];
    [btnWikiicon setImage:[UIImage imageNamed:@"Icon-wiki-inactive.png"] forState:UIControlStateNormal];

    [self animatingViewToTop:_foursquareView];

}
-(IBAction)Twitter_Clicked:(id)sender
{
    [btnTwitticon setImage:[UIImage imageNamed:@"twitter.png"] forState:UIControlStateNormal];
    [btnInsticon setImage:[UIImage imageNamed:@"Icon-Instagram-inActive.png"] forState:UIControlStateNormal];
    [btnYelpicon setImage:[UIImage imageNamed:@"Icon-yelp-inActive.png"] forState:UIControlStateNormal];
    [btnFBicon setImage:[UIImage imageNamed:@"Icon-FB-inactive.png"] forState:UIControlStateNormal];
    [btnFeqicon setImage:[UIImage imageNamed:@"Icon-4Square-inactive.png"] forState:UIControlStateNormal];
    [btnWikiicon setImage:[UIImage imageNamed:@"Icon-wiki-inactive.png"] forState:UIControlStateNormal];
    
    [self animatingViewToTop:_twitterView];

}
-(IBAction)Wikipedia_Clicked:(id)sender
{
    [btnWikiicon setImage:[UIImage imageNamed:@"wordpress.png"] forState:UIControlStateNormal];
    
    [btnInsticon setImage:[UIImage imageNamed:@"Icon-Instagram-inActive.png"] forState:UIControlStateNormal];
    [btnYelpicon setImage:[UIImage imageNamed:@"Icon-yelp-inActive.png"] forState:UIControlStateNormal];
    [btnFBicon setImage:[UIImage imageNamed:@"Icon-FB-inactive.png"] forState:UIControlStateNormal];
    [btnFeqicon setImage:[UIImage imageNamed:@"Icon-4Square-inactive.png"] forState:UIControlStateNormal];
    [btnTwitticon setImage:[UIImage imageNamed:@"Icon-twitter-inactive.png"] forState:UIControlStateNormal];
    
    
    [self animatingViewToTop:_wikiView];
}

-(IBAction)btnCompose_Clicked:(id)sende
{
    objComposeMsgVC=[[ComposeMsgVC alloc]initWithNibName:@"ComposeMsgVC" bundle:nil];
    objComposeMsgVC.trendDetail = trendDetail;
    [self.navigationController pushViewController:objComposeMsgVC animated:YES];
    
}

-(IBAction)btnBack_Clicked:(id)sender
{
    //[self.navigationController popViewControllerAnimated:YES];
    for (UIViewController *viewcontroller in [self.navigationController viewControllers])
    {
        if ([viewcontroller isKindOfClass:[LocalTrendsViewController class]])
        {
            objLocalTrendsViewController =(LocalTrendsViewController *)viewcontroller;
            objLocalTrendsViewController.strSelectedVC=@"";
            [self.navigationController popToViewController:viewcontroller animated:YES];
        }
    }
    
}



-(IBAction)callBtnClicked:(id)sender;
{
    NSString *number = [trendDetail.phone_number stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *phoneNumber = [@"Call " stringByAppendingString:number];

    UIAlertView *alertCall=[[UIAlertView alloc]initWithTitle:@"ALERT" message:phoneNumber  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    alertCall.tag = 1000;
    [alertCall show];
    
   }



-(IBAction)directionBtnClicked:(id)sender
{
    [self openDirectionUrl];
    
    NSLog(@"direcction url====%@",trendDetail.website_url);
    
    
    
}
-(IBAction)websiteBtnClicked:(id)sender
{
    [self openRemoteUrl:trendDetail.website_url];
    
    NSLog(@"websiteBtnClicked url====%@",trendDetail.website_url);

}

-(void)showViewWithAnimation:(UIView *)viewToShow andFromFrame:(CGRect )frame
{
    CGRect originalFrame = viewToShow.frame;
    viewToShow.frame = CGRectMake(viewToShow.frame.origin.x, frame.origin.y, viewToShow.frame.size.width, viewToShow.frame.size.height);
    viewToShow.alpha = 0.2;
    [UIView animateWithDuration:0.3 animations:^{
        viewToShow.alpha = 1.0;
        
        if (IS_IPHONE_5)
        {
            viewToShow.frame = CGRectMake(originalFrame.origin.x, 472, viewToShow.frame.size.width, frame.size.height);

        }
        else
        {
            viewToShow.frame = CGRectMake(originalFrame.origin.x, 380, viewToShow.frame.size.width, frame.size.height);

        }
        
    }];
}
-(void)hideViewWithAnimation:(UIView *)viewToHide andToFrame:(CGRect )frame
{
    viewToHide.alpha = 1.0;
    [UIView animateWithDuration:0.3 animations:^{
        viewToHide.alpha = 0.2;
        viewToHide.frame = CGRectMake(viewToHide.frame.origin.x, frame.origin.y, viewToHide.frame.size.width, viewToHide.frame.size.height);
    }];
}

-(void)animatingViewToTop:(UIView *)viewToTop
{
    [UIView animateWithDuration:0.3 animations:^{
       
        [self.scrllViewMain setContentOffset:CGPointMake(self.scrllViewMain.frame.origin.x , viewToTop.frame.origin.y + 210)];
    }];
}
-(void)resetScrollviewToZeroPosition
{
    [UIView animateWithDuration:0.3 animations:^{
        //
       // [self.scrllViewMain setContentOffset:CGPointMake(self.scrllViewMain.frame.origin.x , self.scrllViewMain.frame.origin.y)];
    }];
}

-(IBAction)back_clicked:(id)sender
{
   // [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)imgLoad_Instrgram:(NSMutableArray *)instagramImages
{
    NSInteger intXpos=20,intYpos=0;
    
    for (id subview in [self.scrllViewInstgram subviews])
    {
        [subview removeFromSuperview];
    }
    for (int i=0; i<[instagramImages count]; i++)
    {
        asyInstagramImgView = [[AsyncImageView alloc] initWithFrame:CGRectMake(intXpos, intYpos, 130, 130)];
        NSString *imgUrlStr=[instagramImages objectAtIndex:i];
        NSURL *imagUrl = [NSURL URLWithString:imgUrlStr];
        [asyInstagramImgView loadImageFromURL:imagUrl];
        [self.scrllViewInstgram addSubview:asyInstagramImgView];
        TapOn_InstrgarmImages = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(tapDetectedpOnInstgramimage:)] ;
        TapOn_InstrgarmImages.numberOfTapsRequired = 1;
        [asyInstagramImgView addGestureRecognizer:TapOn_InstrgarmImages];

        intXpos=intXpos+140;
    }
    
    [self.scrllViewInstgram setContentSize:CGSizeMake(intXpos,130)];
    
	self.scrllViewInstgram.showsHorizontalScrollIndicator = NO;
    
    if ([instagramImages count] == 0)
        _instagramView.hidden = YES;
    else
    {
        tempHeight += _instagramView.frame.origin.y + _instagramView.frame.size.height;
        [bottomIconsNumber addObject:@"1"];
    }

}

-(void)imgLoadMainPageAdditionalImages:(NSMutableArray *)photosArray // need to check Crash (null)
{
    //2014-02-21 11:33:23.542 Placeley[2121:70b] -[NSNull length]: unrecognized selector sent to instance 0x2e78068

    NSInteger intXpos=20,intYpos=10;
    
    for (id subview in [self.scrllViewAddtionalimg subviews])
    {
        [subview removeFromSuperview];
    }
    for (int i=0; i<[photosArray count]; i++)
    {
        asyImgView = [[AsyncImageView alloc] initWithFrame:CGRectMake(intXpos, intYpos, 108, 108)];
        NSString *imgUrlStr=[photosArray objectAtIndex:i];
        NSURL *imagUrl = [NSURL URLWithString:imgUrlStr];
        [asyImgView loadImageFromURL:imagUrl];
        [self.scrllViewAddtionalimg addSubview:asyImgView];
        intXpos=intXpos+118;
    }
    
    [self.scrllViewAddtionalimg setContentSize:CGSizeMake(intXpos,108)];
	self.scrllViewAddtionalimg.showsHorizontalScrollIndicator = NO;
    if ([photosArray count] == 0)
        self.scrllViewAddtionalimg.hidden = YES;

}

#pragma mark Fetch date from server

-(void)fetchDetailDataFromServer
{
    trendDetail = [[ShowDetail alloc] init];
    trendDetail = [ServiceHelper getTrendDetailByPlaceName:placeId andAuthToken:appDelegate.currentLoggedInUser.auth_token];

    
    // starbucks_boston ID to get all social aggregations
   // trendDetail = [ServiceHelper getTrendDetailByPlaceName:@"starbucks_boston@boston"];
   // trendDetail = [ServiceHelper getTrendDetailByPlaceName:@"5253970f5578b5fcbb000025"];
    //trendDetail = [ServiceHelper getTrendDetailByPlaceName:placeName];

    [self performSelectorOnMainThread:@selector(setDetailDataAfterFetchingFromServer) withObject:nil waitUntilDone:NO];
}

-(void)fetchAggregationDataFromServer:(id)sender      // Dynamic place ID
{
    allaggregationsArray = [[NSMutableArray alloc] init];
  
    [allaggregationsArray addObjectsFromArray:[ServiceHelper getAggregationByPlaceId:placeId]];

    // starbucks_boston ID to get all social aggregations
 // [allaggregationsArray addObjectsFromArray:[ServiceHelper getAggregationByPlaceId:@"5253970f5578b5fcbb000025"]];
    
        NSLog(@"allaggregationsArray = %d",[allaggregationsArray count]);
    
    [self performSelectorOnMainThread:@selector(setDataAfterFetchingFromServer) withObject:nil waitUntilDone:NO];
}


-(void)fetchActivityFeedsFromServer      // Dynamic place ID
{
    NSLog(@"appDelegate.currentLoggedInUser ====> %@",appDelegate.currentLoggedInUser.auth_token);
    
    allactivityFeedsArray = [[NSMutableArray alloc] init];
    
    if ([postType isEqualToString:@"All"])
    {
        [allactivityFeedsArray addObjectsFromArray:[ServiceHelper fetchActivityFeedByAuth:appDelegate.currentLoggedInUser.auth_token]];
    }
    else  if ([postType isEqualToString:@"Updates"])
    {
        [allactivityFeedsArray addObjectsFromArray:[ServiceHelper fetchPostByUpdate:placeId andAuthToken:appDelegate.currentLoggedInUser.auth_token]];
    }
    else  if ([postType isEqualToString:@"Deals"])
    {
        [allactivityFeedsArray addObjectsFromArray:[ServiceHelper fetchPostByDeals:placeId andAuthToken:appDelegate.currentLoggedInUser.auth_token]];
    }

    // starbucks_boston ID to get all social aggregations
    // [allaggregationsArray addObjectsFromArray:[ServiceHelper getAggregationByPlaceId:@"5253970f5578b5fcbb000025"]];
    
    NSLog(@"allaggregationsArray = %d",[allactivityFeedsArray count]);
    
    if ([allactivityFeedsArray count] > 0)
    {
        [self performSelectorOnMainThread:@selector(setActivityFeedAfterFetchingFromServer) withObject:nil waitUntilDone:NO];
        self.viewActivity.hidden=NO;
    }
    else
    {
         NSLog(@"noact");
        imgNodata=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320,  568)];
        [imgNodata setImage:[UIImage imageNamed: @"bg_logo.jpg"]];
        [self showErrorAlert:@"No Activity data available"];
        [self.scrllViewMain setContentSize:CGSizeMake(320, 568)];
        [self.scrllViewMain addSubview:imgNodata];
        self.viewActivity.hidden=YES;
    }
    [AppDelegate performSelector:@selector(activeIndicatorStopAnimating) withObject:nil];
    
    self.view.userInteractionEnabled = YES;
}

-(IBAction)btnShowAllCommentsClicked:(id)sender
{
    UIButton *btnShowAllComments = (UIButton *)sender;
    
    NSLog(@"btnShowAllComments = %d",btnShowAllComments.superview.tag);
    
    int y = 10;
    
    for (int iCount = 0; iCount < [allactivityFeedsArray count]; iCount ++)
    {
        ActivityFeed *activityFeed = [allactivityFeedsArray objectAtIndex:iCount];

        ActivityFeedView *currentActivityFeedView = (ActivityFeedView *)[scrolViewMainActivity viewWithTag:iCount + 500];
        
        if (currentActivityFeedView.tag == btnShowAllComments.superview.tag)
        {
            for (int iCount = 1; iCount < [activityFeed.last_two_comments count]; iCount ++)
            {
                UIScrollView *currentShowCommentView = (UIScrollView *)[currentActivityFeedView viewWithTag:iCount + 1000];
                
                if (currentShowCommentView != nil)
                {
                    [currentShowCommentView removeFromSuperview];
                }
            }

            if ([[btnShowAllComments currentTitle] isEqualToString:@"Show all comments"])
            {
                [btnShowAllComments setTitle:@"Hide all comments" forState:UIControlStateNormal];
                currentActivityFeedView.frame = CGRectMake(10 , y, currentActivityFeedView.frame.size.width, currentActivityFeedView.frame.size.height + 96 * [activityFeed.last_two_comments count] + 10);
                
                int yPos = 0;
                for (int i=0; i<[activityFeed.last_two_comments count]; i++)
                {
                    UIScrollView *originalShowCommentView = (UIScrollView *)[currentActivityFeedView viewWithTag:1000];
                    
                    if (i == 0)
                    {
                        originalShowCommentView.frame = CGRectMake(originalShowCommentView.frame.origin.x, currentActivityFeedView.btnShowAllComments.frame.origin.y + currentActivityFeedView.btnShowAllComments.frame.size.height, originalShowCommentView.frame.size.width , originalShowCommentView.frame.size.height);
                    }
                    else
                    {
                        yPos = currentActivityFeedView.btnShowAllComments.frame.origin.y + currentActivityFeedView.btnShowAllComments.frame.size.height;
                        
                        UIScrollView *currentShowCommentView = (UIScrollView *)[self cloneView:[currentActivityFeedView viewWithTag:1000]];
                        currentShowCommentView.frame = CGRectMake(currentShowCommentView.frame.origin.x, yPos + 10 + i*96, currentShowCommentView.frame.size.width , currentShowCommentView.frame.size.height);
                        currentShowCommentView.tag = i+1000;
                        [currentActivityFeedView addSubview:currentShowCommentView];
                    }
                }

                for (int inCount = 0; inCount < [activityFeed.last_two_comments count]; inCount ++)
                {
                    UIScrollView *currentShowCommentView = (UIScrollView *)[currentActivityFeedView viewWithTag:1000 + inCount];
                    currentShowCommentView.hidden = NO;

                    Comment *currentComment = (Comment *)[activityFeed.last_two_comments objectAtIndex:inCount];
               
                    [((AsyncImageView *)[currentShowCommentView viewWithTag:201]) loadImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",currentComment.avatar]]];
                    ((AsyncImageView *)[currentShowCommentView viewWithTag:201]).layer.cornerRadius = 5;
                    ((AsyncImageView *)[currentShowCommentView viewWithTag:201]).layer.masksToBounds = YES;
                    
                    ((UILabel *)[currentShowCommentView viewWithTag:202]).text = [NSString stringWithFormat:@"%@",currentComment.name];
                    ((UILabel *)[currentShowCommentView viewWithTag:203]).text = [NSString stringWithFormat:@"\"%@\"",currentComment.body];
                    ((UILabel *)[currentShowCommentView viewWithTag:204]).text = [self calculateTimeDifference:currentComment.created_at];

                }

            }
            else
            {
                [btnShowAllComments setTitle:@"Show all comments" forState:UIControlStateNormal];
                UIScrollView *originalShowCommentView = (UIScrollView *)[currentActivityFeedView viewWithTag:1000];
                originalShowCommentView.hidden = YES;

//                if ([activityFeed.comments_count intValue] == 0)
//                {
//                    currentActivityFeedView.btnShowAllComments.hidden = YES;
//                    currentActivityFeedView.frame = CGRectMake(10 , y, currentActivityFeedView.frame.size.width, 597);
//                }
//                else
//                {
                    currentActivityFeedView.btnShowAllComments.hidden = NO;
                    currentActivityFeedView.frame = CGRectMake(10 , y, currentActivityFeedView.frame.size.width, currentActivityFeedView.frame.size.height - (96 * [activityFeed.last_two_comments count] + 10));
               // }
            }
        }
        else
        {
            if ([activityFeed.comments_count intValue] == 0)
            {
                currentActivityFeedView.btnShowAllComments.hidden = YES;
                currentActivityFeedView.frame = CGRectMake(10 , y, currentActivityFeedView.frame.size.width, currentActivityFeedView.frame.size.height);
            }
            else
            {
                currentActivityFeedView.btnShowAllComments.hidden = NO;
                currentActivityFeedView.frame = CGRectMake(10 , y, currentActivityFeedView.frame.size.width, currentActivityFeedView.frame.size.height);
            }
        }
        y = y + currentActivityFeedView.frame.size.height + 10;
    }
    [scrolViewMainActivity setContentSize:CGSizeMake(scrolViewMainActivity.frame.size.width , y)];
}

//-(void)btnPostCommentsClicked:(UIButton *)sender
//{
//    if(selectedTextField != nil)
//    {
//        if(![selectedTextField.text isEqualToString:@""])
//        {
//            [selectedTextField resignFirstResponder];
//            
//            NSLog(@"btnPostCommentsClicked = %d",selectedTextField.superview.superview.tag);
//            
//            NSMutableDictionary *originalDictionary = [[NSMutableDictionary alloc] init];
//            
//            [originalDictionary setValue:@"user" forKey:@"posted_by"];
//            [originalDictionary setValue:@"update" forKey:@"post_type"];
//            [originalDictionary setValue:@"" forKey:@"starts_at"];
//            [originalDictionary setValue:@"" forKey:@"ends_at"];
//            [originalDictionary setValue:selectedTextField.text forKey:@"body"];
//            [originalDictionary setValue:@"0" forKey:@"share_on_facebook"];
//            [originalDictionary setValue:@"0" forKey:@"share_on_twitter"];
//            
//            NSMutableDictionary *finalDict = [[NSMutableDictionary alloc] init];
//            
//            [finalDict addEntriesFromDictionary:originalDictionary];
//            
//            NSDictionary *arDict = [NSDictionary dictionaryWithObject:finalDict forKey:@"post"];
//            
//            SBJsonWriter *jsonWriter = [SBJsonWriter new];
//            
//            NSString *jsonString = [jsonWriter stringWithObject:arDict];
//            
//            ActivityFeed *activityFeed = [allactivityFeedsArray objectAtIndex:selectedTextField.superview.superview.tag - 500];
//            
//            [AppDelegate performSelector:@selector(activeIndicatorStartAnimating:) withObject:self.view afterDelay:0];
//            
//            self.view.userInteractionEnabled = NO;
//            
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
//           ^{
//                 [ServiceHelper postComment:jsonString andPlaceId:activityFeed.placeId andAuthToken:appDelegate.currentLoggedInUser.auth_token];
//               
//               dispatch_async(dispatch_get_main_queue(),
//                              ^{
//                                  selectedTextField.text = @"";
//                                  
//                                  [AppDelegate performSelector:@selector(activeIndicatorStopAnimating) withObject:nil];
//                                  
//                                  self.view.userInteractionEnabled = YES;
//                              });
//               
//           });
//        }
//        else
//        {
//            UIAlertView *alertCall=[[UIAlertView alloc]initWithTitle:@"ALERT" message:@"Oops..looks like you've missed out to enter the text!"  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
//            [alertCall show];
//        }
//    }
//}
-(void)btnPostCommentsClicked:(UIButton *)sender
{
    if(selectedTextField != nil)
    {
        if(![selectedTextField.text isEqualToString:@""])
        {
            [selectedTextField resignFirstResponder];

            NSLog(@"btnPostCommentsClicked = %d",selectedTextField.superview.superview.tag);
            
            ActivityFeed *activityFeed = [allactivityFeedsArray objectAtIndex:selectedTextField.superview.superview.tag - 500];

           // placeId = activityFeed.placeId;
            
            [AppDelegate performSelector:@selector(activeIndicatorStartAnimating:) withObject:self.view afterDelay:0];
            
            self.view.userInteractionEnabled = NO;

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
           ^{
               NSMutableDictionary *originalDictionary = [[NSMutableDictionary alloc] init];
               
               [originalDictionary setValue:selectedTextField.text forKey:@"body"];
               [originalDictionary setValue:activityFeed._id forKey:@"commentable_id"];
               [originalDictionary setValue:@"Post" forKey:@"commentable_type"];
               
               SBJsonWriter *jsonWriter = [SBJsonWriter new];
               
               NSString *jsonString = [jsonWriter stringWithObject:originalDictionary];

               [ServiceHelper postFeedComment:jsonString andPlaceId:activityFeed.placeId andFeedId:activityFeed._id andAuthToken:appDelegate.currentLoggedInUser.auth_token];

               dispatch_async(dispatch_get_main_queue(),
                      ^{
                          selectedTextField.text = @"";
                          
                          [self performSelector:@selector(fetchActivityFeedsFromServer) withObject:nil afterDelay:0.1];

                          [AppDelegate performSelector:@selector(activeIndicatorStopAnimating) withObject:nil];
                          
                          self.view.userInteractionEnabled = YES;
                      });
           });
        }
        else
        {
            UIAlertView *alertCall=[[UIAlertView alloc]initWithTitle:@"ALERT" message:@"Oops..looks like you've missed out to enter the text!"  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
            [alertCall show];
        }
    }
}


-(IBAction)btnPlaceNameClickedInActivity:(UIButton *)sender
{
    UIButton *button = (UIButton *)sender;
    
    NSLog(@"button.superview.tag = %d",button.superview.tag);
    
    if (button != nil && [allactivityFeedsArray count] > 0)
    {
        ActivityFeed *activityFeed = [allactivityFeedsArray objectAtIndex:(button.superview.tag - 500)];
        
        placeId = activityFeed.placeId;
        
        selectedOption = 1;
        
        [self viewWillAppear:NO];
    }
}

-(IBAction)followingTapDetected:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"%@", [gestureRecognizer view]);
    
    UIImageView *imageView = (UIImageView *)[gestureRecognizer view];
    
    NSLog(@"button.superview.tag = %d",imageView.superview.tag);
    
    if (imageView != nil && [allFollowingsArray count] > 0)
    {
        Followings *currentFollowing = [allFollowingsArray objectAtIndex:(imageView.superview.tag - 5000)];
        
        placeId = currentFollowing.place_id;
        
        selectedOption = 1;
        
        [self viewWillAppear:NO];
    }
}


-(IBAction)btnLikeClicked:(UIButton *)sender
{
    UIButton *button = (UIButton *)sender;
    
    NSLog(@"button.superview.tag = %d",button.superview.tag);
    
    if (button != nil && [allactivityFeedsArray count] > 0 && button.superview.tag >= 500 && selectedOption == 2)
    {
        ActivityFeed *activityFeed = [allactivityFeedsArray objectAtIndex:(button.superview.tag - 500)];
        
        [AppDelegate performSelector:@selector(activeIndicatorStartAnimating:) withObject:self.view afterDelay:0];
        
        self.view.userInteractionEnabled = NO;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
       ^{
           if (![activityFeed.liker_ids containsObject:appDelegate.currentLoggedInUser.userId])
           {
             //  [self performSelectorInBackground:@selector(performActivityLikeInBackground:) withObject:activityFeed.placeId];

               id response = [ServiceHelper likePlace:activityFeed.placeId andAuthToken:appDelegate.currentLoggedInUser.auth_token];
               
               if (response != nil)
               {
                   [activityFeed.liker_ids addObject:appDelegate.currentLoggedInUser.userId];
               }
           }
           else
           {
             //  [self performSelectorInBackground:@selector(performActivityUnLikeInBackground:) withObject:activityFeed.placeId];

               id response = [ServiceHelper UnlikePlace:activityFeed.placeId andAuthToken:appDelegate.currentLoggedInUser.auth_token];
               
               if (response != nil)
               {
                   [activityFeed.liker_ids removeObject:appDelegate.currentLoggedInUser.userId];
               }
           }
           dispatch_async(dispatch_get_main_queue(),
          ^{
              [self performSelector:@selector(fetchActivityFeedsFromServer) withObject:nil afterDelay:0.1];
          });
       });
    }
    else if(button.superview.tag == 1 && selectedOption == 1)
    {
        if (![trendDetail.liker_ids containsObject:appDelegate.currentLoggedInUser.userId])
        {
         //   [self performSelectorInBackground:@selector(performTrendLikeInBackground:) withObject:trendDetail.place_id];
            
            id response = [ServiceHelper likePlace:trendDetail.place_id andAuthToken:appDelegate.currentLoggedInUser.auth_token];
            
            if (response != nil)
            {
                [self viewWillAppear:NO];
            }
        }
        else
        {
          //  [self performSelectorInBackground:@selector(performTrendUnLikeInBackground:) withObject:trendDetail.place_id];

            id response = [ServiceHelper UnlikePlace:trendDetail.place_id andAuthToken:appDelegate.currentLoggedInUser.auth_token];
            
            if (response != nil)
            {
                [self viewWillAppear:NO];
            }
        }
    }
    else if (button != nil && [allFollowingsArray count] > 0 && button.superview.tag >= 5000  && selectedOption == 3)
    {
        Followings *currentFollowing = [allFollowingsArray objectAtIndex:(button.superview.tag - 5000)];
        
        [AppDelegate performSelector:@selector(activeIndicatorStartAnimating:) withObject:self.view afterDelay:0];
        
        self.view.userInteractionEnabled = NO;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
       ^{
           if (![currentFollowing.liker_ids containsObject:appDelegate.currentLoggedInUser.userId])
           {
             //  [self performSelectorInBackground:@selector(performFollowLikeInBackground:) withObject:currentFollowing.place_id];

               id response = [ServiceHelper likePlace:currentFollowing.place_id andAuthToken:appDelegate.currentLoggedInUser.auth_token];
               
               if (response != nil)
               {
                   [currentFollowing.liker_ids addObject:appDelegate.currentLoggedInUser.userId];
               }
           }
           else
           {
              // [self performSelectorInBackground:@selector(performFollowUnLikeInBackground:) withObject:currentFollowing.place_id];

               id response = [ServiceHelper UnlikePlace:currentFollowing.place_id andAuthToken:appDelegate.currentLoggedInUser.auth_token];
               
               if (response != nil)
               {
                   [currentFollowing.liker_ids removeObject:appDelegate.currentLoggedInUser.userId];
               }
               
           }
           
           dispatch_async(dispatch_get_main_queue(),
          ^{
              [self performSelector:@selector(fetchFollowingDetailsFromServer) withObject:nil afterDelay:0.1];
          });
       });
    }
}

-(void)performTrendLikeInBackground:(NSString *)_id
{
    id response = [ServiceHelper likePlace:_id andAuthToken:appDelegate.currentLoggedInUser.auth_token];
    
    if (response != nil)
    {
        [self fetchDetailDataFromServer];
        
        [self fetchAggregationDataFromServer:nil];
    }
}

-(void)performTrendUnLikeInBackground:(NSString *)_id
{
    id response = [ServiceHelper UnlikePlace:_id andAuthToken:appDelegate.currentLoggedInUser.auth_token];
    
    if (response != nil)
    {
        [self fetchDetailDataFromServer];
        
        [self fetchAggregationDataFromServer:nil];
    }
}


-(void)performActivityLikeInBackground:(NSString *)_id
{
    id response = [ServiceHelper likePlace:_id andAuthToken:appDelegate.currentLoggedInUser.auth_token];
    
    [self reloadActivityFeed:response];
}

-(void)reloadActivityFeed:(id)response
{
    if (response != nil)
    {
        allactivityFeedsArray = [[NSMutableArray alloc] init];
        
        if ([postType isEqualToString:@"All"])
        {
            [allactivityFeedsArray addObjectsFromArray:[ServiceHelper fetchActivityFeedByAuth:appDelegate.currentLoggedInUser.auth_token]];
        }
        else  if ([postType isEqualToString:@"Updates"])
        {
            [allactivityFeedsArray addObjectsFromArray:[ServiceHelper fetchPostByUpdate:placeId andAuthToken:appDelegate.currentLoggedInUser.auth_token]];
        }
        else  if ([postType isEqualToString:@"Deals"])
        {
            [allactivityFeedsArray addObjectsFromArray:[ServiceHelper fetchPostByDeals:placeId andAuthToken:appDelegate.currentLoggedInUser.auth_token]];
        }
        
        [self performSelectorOnMainThread:@selector(setActivityFeedAfterFetchingFromServer) withObject:nil waitUntilDone:NO];
    }
}
-(void)performActivityUnLikeInBackground:(NSString *)_id
{
    id response = [ServiceHelper UnlikePlace:_id andAuthToken:appDelegate.currentLoggedInUser.auth_token];
    
    [self reloadActivityFeed:response];
}

-(void)performFollowLikeInBackground:(NSString *)_id
{
    id response = [ServiceHelper likePlace:_id andAuthToken:appDelegate.currentLoggedInUser.auth_token];
    
    if (response != nil)
    {
        NSMutableArray *getFollowListArray = [ServiceHelper getFollowingDetailsByLoguthTokenid:appDelegate.currentLoggedInUser.auth_token];
        
        [self performSelectorOnMainThread:@selector(loadFollowingDatas:) withObject:getFollowListArray waitUntilDone:YES];
    }
}

-(void)performFollowUnLikeInBackground:(NSString *)_id
{
    id response = [ServiceHelper UnlikePlace:_id andAuthToken:appDelegate.currentLoggedInUser.auth_token];
    
    if (response != nil)
    {
        NSMutableArray *getFollowListArray = [ServiceHelper getFollowingDetailsByLoguthTokenid:appDelegate.currentLoggedInUser.auth_token];
        
        [self performSelectorOnMainThread:@selector(loadFollowingDatas:) withObject:getFollowListArray waitUntilDone:YES];
    }
}

-(IBAction)btnFollowClicked:(UIButton *)sender
{
    UIButton *button = (UIButton *)sender;
    
    NSLog(@"button.superview.tag = %d",button.superview.tag);
    
    if (button != nil && [allFollowingsArray count] > 0  && button.superview.tag >= 5000)
    {
        Followings *currentFollowing = [allFollowingsArray objectAtIndex:(button.superview.tag - 5000)];

        [AppDelegate performSelector:@selector(activeIndicatorStartAnimating:) withObject:self.view afterDelay:0];
        
        self.view.userInteractionEnabled = NO;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
       ^{
           NSMutableDictionary *originalDictionary = [[NSMutableDictionary alloc] init];
           
           [originalDictionary setValue:currentFollowing.place_id forKey:@"place_id"];
           
           SBJsonWriter *jsonWriter = [SBJsonWriter new];
           
           NSString *jsonString = [jsonWriter stringWithObject:originalDictionary];

           if (![currentFollowing.follower_ids containsObject:appDelegate.currentLoggedInUser.userId])
           {
               id response = [ServiceHelper followPlace:jsonString andAuthToken:appDelegate.currentLoggedInUser.auth_token];
               
               if (response != nil)
               {
                   [currentFollowing.follower_ids addObject:appDelegate.currentLoggedInUser.userId];
               }
           }
           else
           {
               id response = [ServiceHelper unfollowPlace:currentFollowing.place_id andAuthToken:appDelegate.currentLoggedInUser.auth_token];
               
               if (response != nil)
               {
                   [currentFollowing.follower_ids removeObject:appDelegate.currentLoggedInUser.userId];
               }

           }
           
           [self fetchFollowingDetailsFromServer];

           dispatch_async(dispatch_get_main_queue(),
                          ^{
//                              [AppDelegate performSelector:@selector(activeIndicatorStopAnimating) withObject:nil];
//                              
//                              self.view.userInteractionEnabled = YES;
                          });
       });
    }
    else if(button.superview.tag == 1)
    {
        NSMutableDictionary *originalDictionary = [[NSMutableDictionary alloc] init];
        
        [originalDictionary setValue:placeId forKey:@"place_id"];
        
        SBJsonWriter *jsonWriter = [SBJsonWriter new];
        
        NSString *jsonString = [jsonWriter stringWithObject:originalDictionary];
        
        if (![trendDetail.follower_ids containsObject:appDelegate.currentLoggedInUser.userId])
        {
            id response = [ServiceHelper followPlace:jsonString andAuthToken:appDelegate.currentLoggedInUser.auth_token];
            
            if (response != nil)
            {
                [self viewWillAppear:NO];
            }
        }
        else
        {
            id response = [ServiceHelper unfollowPlace:trendDetail.place_id andAuthToken:appDelegate.currentLoggedInUser.auth_token];
            
            if (response != nil)
            {
                [self viewWillAppear:NO];
            }
            
        }
    }
}

#pragma mark set date after fetching from server

-(void)setActivityFeedAfterFetchingFromServer
{
    if (imgNodata != nil)
    {
        [imgNodata removeFromSuperview];
    }
    for (int iCount = 0; iCount < [allactivityFeedsArray count]; iCount ++)
    {
        ActivityFeedView *currentActivityFeedView = (ActivityFeedView *)[scrolViewMainActivity viewWithTag:iCount + 500];
        
        if (currentActivityFeedView != nil)
        {
            [currentActivityFeedView removeFromSuperview];
        }
    }

    int y = 10;
    int imageHeight = 0;
    
    for (int iCount = 0; iCount < [allactivityFeedsArray count]; iCount ++)
    {
        ActivityFeed *activityFeed = [allactivityFeedsArray objectAtIndex:iCount];

        ActivityFeedView *currentActivityView = [[[NSBundle mainBundle] loadNibNamed:@"ActivityFeedView"
                                                                               owner:self
                                                                             options:nil]
                                                 objectAtIndex:0];
   
        imageHeight = 0;
        
        UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Shapes-Activity-Card-WhiteBg.png"]];
        currentActivityView.backgroundColor = background;

//        UIButton *placeNameButton = (UIButton *)[currentActivityView viewWithTag:4];
//        [placeNameButton setTitle:activityFeed.computed_name forState:UIControlStateNormal];
//        int numberOfLines = [self heightForButton:placeNameButton withText:activityFeed.computed_name] / 17;
//        [placeNameButton setFrame:CGRectMake(placeNameButton.frame.origin.x, placeNameButton.frame.origin.y, placeNameButton.frame.size.width, numberOfLines * 21)];

        AsyncImageView *postImageView = (AsyncImageView *)[currentActivityView viewWithTag:14];
       // [postImageView setFrame:CGRectMake(postImageView.frame.origin.x, placeNameButton.frame.origin.y + placeNameButton.frame.size.height, postImageView.frame.size.width, postImageView.frame.size.height)];

        if ([activityFeed.postedImagesArray count] == 0)
        {
            postImageView.hidden = YES;

            if ([activityFeed.body isEqualToString:@""])
            {
                UILabel *bodyTextLabel = (UILabel *)[currentActivityView viewWithTag:15];
                bodyTextLabel.hidden = YES;
                UIView *socialview = (UIView *)[currentActivityView viewWithTag:13];
                [socialview setFrame:CGRectMake(socialview.frame.origin.x, postImageView.frame.origin.y, socialview.frame.size.width, socialview.frame.size.height)];
                UIView *postCommentview = (UIView *)[currentActivityView viewWithTag:10];
                [postCommentview setFrame:CGRectMake(postCommentview.frame.origin.x, socialview.frame.origin.y + socialview.frame.size.height, postCommentview.frame.size.width, postCommentview.frame.size.height)];
            }
            else
            {
                UILabel *bodyTextLabel = (UILabel *)[currentActivityView viewWithTag:15];
                bodyTextLabel.text = [NSString stringWithFormat:@"\"%@\"",activityFeed.body];
                [bodyTextLabel setFrame:CGRectMake(bodyTextLabel.frame.origin.x, postImageView.frame.origin.y, bodyTextLabel.frame.size.width, bodyTextLabel.frame.size.height)];
                int numberOfLines = [self heightForLabel:bodyTextLabel withText:activityFeed.body] / 14;
                [bodyTextLabel setFrame:CGRectMake(bodyTextLabel.frame.origin.x, postImageView.frame.origin.y, bodyTextLabel.frame.size.width, numberOfLines * 20)];
                
                UIView *socialview = (UIView *)[currentActivityView viewWithTag:13];
                [socialview setFrame:CGRectMake(socialview.frame.origin.x, bodyTextLabel.frame.origin.y + bodyTextLabel.frame.size.height, bodyTextLabel.frame.size.width, socialview.frame.size.height)];
                UIView *postCommentview = (UIView *)[currentActivityView viewWithTag:10];
                [postCommentview setFrame:CGRectMake(postCommentview.frame.origin.x, socialview.frame.origin.y + socialview.frame.size.height, postCommentview.frame.size.width, postCommentview.frame.size.height)];
            }
        }
        else
        {
            if ([activityFeed.body isEqualToString:@""])
            {
                UILabel *bodyTextLabel = (UILabel *)[currentActivityView viewWithTag:15];
                bodyTextLabel.hidden = YES;

                UIView *socialview = (UIView *)[currentActivityView viewWithTag:13];
                [socialview setFrame:CGRectMake(socialview.frame.origin.x, bodyTextLabel.frame.origin.y, socialview.frame.size.width, socialview.frame.size.height)];
                UIView *postCommentview = (UIView *)[currentActivityView viewWithTag:10];
                [postCommentview setFrame:CGRectMake(postCommentview.frame.origin.x, socialview.frame.origin.y + socialview.frame.size.height, postCommentview.frame.size.width, postCommentview.frame.size.height)];
            }
        }
        if ([activityFeed.comments_count intValue] == 0)
        {
            currentActivityView.btnShowAllComments.hidden = YES;
            UIView *postCommentview = (UIView *)[currentActivityView viewWithTag:10];
            currentActivityView.frame = CGRectMake(10 , y, currentActivityView.frame.size.width, postCommentview.frame.origin.y + postCommentview.frame.size.height + 10);
        }
        else
        {
            currentActivityView.btnShowAllComments.hidden = NO;
            UIView *postCommentview = (UIView *)[currentActivityView viewWithTag:10];
            currentActivityView.btnShowAllComments.frame = CGRectMake(currentActivityView.btnShowAllComments.frame.origin.x , postCommentview.frame.origin.y + postCommentview.frame.size.height, currentActivityView.btnShowAllComments.frame.size.width, currentActivityView.btnShowAllComments.frame.size.height);

            currentActivityView.frame = CGRectMake(10 , y, currentActivityView.frame.size.width, currentActivityView.btnShowAllComments.frame.origin.y + currentActivityView.btnShowAllComments.frame.size.height + 10);
        }
        y = y + (currentActivityView.frame.size.height + 10);
        
        currentActivityView.tag = iCount+500;
        
        [(UIButton *)[currentActivityView viewWithTag:4] addTarget:self action:@selector(btnPlaceNameClickedInActivity:) forControlEvents:UIControlEventTouchDown];
        [(UIButton *)[currentActivityView viewWithTag:8] addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchDown];
        [(UIButton *)[currentActivityView viewWithTag:9] addTarget:self action:@selector(btnLikeClicked:) forControlEvents:UIControlEventTouchDown];

        [scrolViewMainActivity addSubview:currentActivityView];
    }
    [scrolViewMainActivity setFrame:CGRectMake(scrolViewMainActivity.frame.origin.x, 0,  scrolViewMainActivity.frame.size.width , 512)];
    
  self.viewActivity.frame = CGRectMake(self.viewActivity.frame.origin.x , self.viewActivity.frame.origin.y, 320, y);  // Exapand the View Based on Scroll
    
    [self.scrllViewMain setContentSize:CGSizeMake(320, scrolViewMainActivity.frame.size.height)];// + 328+ 20
    
    [scrolViewMainActivity setContentSize:CGSizeMake(scrolViewMainActivity.frame.size.width , y)];

    for (int iCount = 0; iCount < [allactivityFeedsArray count]; iCount ++)
    {
        ActivityFeed *activityFeed = [allactivityFeedsArray objectAtIndex:iCount];
        
        NSLog(@"activityFeed.likers_count = %@",activityFeed.likers_count);

        
        ActivityFeedView *currentActivityFeedView = (ActivityFeedView *)[scrolViewMainActivity viewWithTag:iCount + 500];
        
        currentActivityFeedView.layer.cornerRadius = 5;

        ((AsyncImageView *)[currentActivityFeedView viewWithTag:1]).layer.cornerRadius = 5;
        ((AsyncImageView *)[currentActivityFeedView viewWithTag:1]).layer.masksToBounds = YES;

        if ([activityFeed.postedImagesArray count] > 0)
        {
            AsyncImageView *postImageView = (AsyncImageView *)[currentActivityFeedView viewWithTag:14];
            [postImageView loadImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[activityFeed.postedImagesArray objectAtIndex:0]]]];
        }

        UILabel *bodyTextLabel = (UILabel *)[currentActivityFeedView viewWithTag:15];
        bodyTextLabel.text = [NSString stringWithFormat:@"\"%@\"",activityFeed.body];

        [((AsyncImageView *)[currentActivityFeedView viewWithTag:1]) loadImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",activityFeed.avatar]]];
        ((UILabel *)[currentActivityFeedView viewWithTag:2]).text = [NSString stringWithFormat:@"%@",activityFeed.name];
        ((UILabel *)[currentActivityFeedView viewWithTag:3]).text = @"Likes";
        if ([activityFeed.post_type isEqualToString:@"update"]) {
            ((UILabel *)[currentActivityFeedView viewWithTag:3]).text = @"has posted a comment";
        } else  if ([activityFeed.post_type isEqualToString:@"event"]) {
            ((UILabel *)[currentActivityFeedView viewWithTag:3]).text = @"has posted an event";
        } else  if ([activityFeed.post_type isEqualToString:@"deal"]) {
            ((UILabel *)[currentActivityFeedView viewWithTag:3]).text = @"has posted a deal";
        } else  if ([activityFeed.post_type isEqualToString:@"photo"]) {
            ((UILabel *)[currentActivityFeedView viewWithTag:3]).text = @"has posted a photo";
        }

        NSArray *computedName = [activityFeed.computed_name componentsSeparatedByString:@"@"];
        if ([computedName count] > 1)
        {
            [((UIButton *)[currentActivityFeedView viewWithTag:16]) setTitle:[NSString stringWithFormat:@"@%@",activityFeed.formaladdress] forState:UIControlStateNormal];
            [((UIButton *)[currentActivityFeedView viewWithTag:4]) setTitle:activityFeed.formalname forState:UIControlStateNormal];
        }
        ((UILabel *)[currentActivityFeedView viewWithTag:5]).text = [self calculateTimeDifference:activityFeed.created_at];
        ((UILabel *)[currentActivityFeedView viewWithTag:6]).text = [NSString stringWithFormat:@"%@ Likes",activityFeed.likers_count];
        ((UILabel *)[currentActivityFeedView viewWithTag:7]).text = [NSString stringWithFormat:@"%@ Comments",activityFeed.comments_count];
        [((UIButton *)[currentActivityFeedView viewWithTag:12]) addTarget:self action:@selector(btnShowAllCommentsClicked:) forControlEvents:UIControlEventTouchDown];
        
        if ([activityFeed.liker_ids containsObject:appDelegate.currentLoggedInUser.userId])
        {
            [((UIButton *)[currentActivityFeedView viewWithTag:9]) setImage:[UIImage imageNamed:@"like.png"]  forState:UIControlStateNormal];
            
        }
        else
        {
            [((UIButton *)[currentActivityFeedView viewWithTag:9]) setImage:[UIImage imageNamed:@"unlike.png"]  forState:UIControlStateNormal];
            
          
        }

        UIView *currentWriteCommentView = (UIView *)[currentActivityFeedView viewWithTag:10];
        
        [((AsyncImageView *)[currentWriteCommentView viewWithTag:101]) loadImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",activityFeed.avatar]]];
        ((UITextField *)[currentWriteCommentView viewWithTag:102]).delegate = self;
        [(UIButton *)[currentWriteCommentView viewWithTag:103] addTarget:self action:@selector(btnPostCommentsClicked:) forControlEvents:UIControlEventTouchDown];

        UIScrollView *currentShowCommentView = (UIScrollView *)[currentActivityFeedView viewWithTag:1000];
        currentShowCommentView.hidden = YES;
        
        ((AsyncImageView *)[currentWriteCommentView viewWithTag:101]).layer.cornerRadius = 5;
        ((AsyncImageView *)[currentWriteCommentView viewWithTag:101]).layer.masksToBounds = YES;

//        currentWriteCommentView.layer.cornerRadius = 5;
//        currentWriteCommentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        currentWriteCommentView.layer.borderWidth = 1;

//        currentShowCommentView.layer.cornerRadius = 5;
//        currentShowCommentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        currentShowCommentView.layer.borderWidth = 1;

   }
}

-(NSString *)getSpaceAddedString:(NSString *)string
{
    NSRegularExpression *regexp = [NSRegularExpression
                                   regularExpressionWithPattern:@"([a-z])([A-Z])"
                                   options:0
                                   error:NULL];
    NSString *newString = [regexp
                           stringByReplacingMatchesInString:string
                           options:0
                           range:NSMakeRange(0, string.length) 
                           withTemplate:@"$1 $2"];
    NSLog(@"Changed '%@' -> '%@'", string, newString);
    return newString;
}

-(CGFloat)heightForLabel:(UILabel *)label withText:(NSString *)text
{
    CGSize maxSize = CGSizeMake(label.frame.size.width - 20, 9999);
    
    CGRect labelRect = [label.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil];
    
    NSLog(@"labelRect height = %f",labelRect.size.height);
    
    return labelRect.size.height;
}

-(CGFloat)heightForButton:(UIButton *)label withText:(NSString *)text
{
    CGSize maxSize = CGSizeMake(label.frame.size.width - 60, 9999);
    
    CGRect labelRect = [label.currentTitle boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.titleLabel.font} context:nil];
    
    NSLog(@"labelRect height = %f",labelRect.size.height);
    
    return labelRect.size.height;
}

-(NSString *)calculateTimeDifference:(NSString *)createdDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *startDate = [dateFormatter dateFromString:createdDate];
    
    NSDate *endDate = [NSDate date];
    
    NSTimeInterval timeDifference = [endDate timeIntervalSinceDate:startDate];
    
    int minutes = timeDifference / 60;
    
    int hours = minutes / 60;
    
    int seconds = timeDifference;
    
    int days = minutes / 1440;
    
    NSLog(@"%d, %d, %d, %d", days, hours, minutes, seconds);
    
    if (days > 1)
        return [NSString stringWithFormat:@"%d days ago",days];
    else if (days > 0)
        return [NSString stringWithFormat:@"%d day ago",days];
    else if (hours > 1)
        return [NSString stringWithFormat:@"%d hours ago",hours];
    else if (hours > 0)
        return [NSString stringWithFormat:@"%d hour ago",hours];
    else if (minutes > 1)
        return [NSString stringWithFormat:@"%d minutes ago",minutes];
    else if (minutes > 0)
        return [NSString stringWithFormat:@"%d minute ago",minutes];
    
    return 0;
}

-(void)setDetailDataAfterFetchingFromServer
{
    
    NSLog(@"setDetailDataAfterFetchingFromServer");
    
    [self loadInfiniteScrollingData];

    if(IS_IPHONE_5)
    {
        _detailScrollView.contentSize = CGSizeMake(320, _detailScrollView.frame.size.height);
    }
    else
    {
        _detailScrollView.contentSize = CGSizeMake(320, _detailScrollView.frame.size.height);
    }
   
    _detailScrollView.pagingEnabled = YES;
    
    if (trendDetail != nil)
    {
        NSLog(@"trendDetail.open_between = %@",trendDetail.open_between);
        
        _lblTrendBuddies.text = [NSString stringWithFormat:@"%@",trendDetail.my_network];
        _lblTrendFollower.text = [NSString stringWithFormat:@"%@",trendDetail.followers_count];
        _lblTrendThumpsup.text = [NSString stringWithFormat:@"%@",trendDetail.likers_count];
        _lblTrendAddress.text = [NSString stringWithFormat:@"%@",trendDetail.address];
        _lblTrendTittle.text = [NSString stringWithFormat:@"%@",trendDetail.pre_name];
        _lblTrendSubAddress.text = [NSString stringWithFormat:@"%@",trendDetail.address];
        _lblOpenBetween.text = [NSString stringWithFormat:@"%@",trendDetail.open_between];
        _lblAdditionalPreName.text = [NSString stringWithFormat:@"%@",trendDetail.pre_name];
        _topBandPreName.text = [NSString stringWithFormat:@"%@",trendDetail.pre_name];
        _lblAdditionalAddress.text = [NSString stringWithFormat:@"%@",trendDetail.address];
        _topBandAddress.text = [NSString stringWithFormat:@"%@",trendDetail.address];
        _topDetailOf.text = [NSString stringWithFormat:@"%@",trendDetail.pre_name];
        // OpenClose images======================
        
        NSString *strOpenClose=[NSString stringWithFormat:@"%@",trendDetail.open_now];
        NSLog(@"strOpenClose====>%@",strOpenClose);
        if ([strOpenClose isEqualToString:@"open"])
        {
            [ imgOpenCloseTopBand setImage:[UIImage imageNamed:@"open.png"]];
            [ imgOpenCloseTop setImage:[UIImage imageNamed:@"open.png"]];
        }
        else
        {
            [ imgOpenCloseTopBand setImage:[UIImage imageNamed:@"closed.png"]];
            [ imgOpenCloseTop setImage:[UIImage imageNamed:@"closed.png"]];
        }
        
        if ([trendDetail.follower_ids containsObject:appDelegate.currentLoggedInUser.userId])
        {
            [self.btnFollowing setImage:[UIImage imageNamed:@"following.png"] forState:UIControlStateNormal];
        }
        else
        {
            [self.btnFollowing setImage:[UIImage imageNamed:@"follow_blue.png"] forState:UIControlStateNormal];
        }
        if ([trendDetail.liker_ids containsObject:appDelegate.currentLoggedInUser.userId])
        {
            [self.btnLike setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
        }
        else
        {
            [self.btnLike setImage:[UIImage imageNamed:@"unlike.png"] forState:UIControlStateNormal];
        }

        
        NSLog(@"trendDetail.logo_url = %@",trendDetail.logo_url);
        
        if ([trendDetail.imageArray count]>0)
        {
         [_detailProfileImgView loadImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[trendDetail.imageArray objectAtIndex:0] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
            
            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[trendDetail.imageArray objectAtIndex:0] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
            
            shareimage = [[UIImage alloc] initWithData:data];

        }
        else
        {
            UIImageView *noImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 38, 38)];
            [noImgView setImage:[UIImage imageNamed:@"pinBlue.png"]];
            [_detailLogoImgView addSubview:noImgView];
            [_imgLogo addSubview:noImgView];
            [_topBandLogoImage addSubview:noImgView];
        }
        
        NSString *imageUrl1=[trendDetail.logo_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (![imageUrl1 isEqualToString:@""])
        {
            NSURL *imagUrl1 = [NSURL URLWithString:imageUrl1];
           
            _detailLogoImgView.layer.masksToBounds = YES;
            _detailLogoImgView.layer.cornerRadius = 5.0;
            [_detailLogoImgView setBackgroundColor:[UIColor clearColor]];
            _detailLogoImgView.layer.masksToBounds = YES;
            _imgLogo.layer.cornerRadius = 5.0;
            _imgLogo.layer.masksToBounds = YES;
            
            _topBandLogoImage.layer.cornerRadius = 5.0;
            _topBandLogoImage.layer.masksToBounds = YES;
            
            [_detailLogoImgView loadImageFromURL:imagUrl1];
            [_imgLogo loadImageFromURL:imagUrl1];
            [_topBandLogoImage loadImageFromURL:imagUrl1];

        }
        else
        {
            UIImageView *noImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 38, 38)];
            [noImgView setImage:[UIImage imageNamed:@"pinBlue.png"]];
            [_detailLogoImgView addSubview:noImgView];
             [_imgLogo addSubview:noImgView];
            [_topBandLogoImage addSubview:noImgView];

        }

       // [_imgLogo loadImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[trendDetail.logo_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
      
       // [_topBandLogoImage loadImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[trendDetail.logo_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
        
       //_topBandLogoImage.layer.cornerRadius = 5.0;
       // [_topBandLogoImage setBackgroundColor:[UIColor lightGrayColor]];
       // _topBandLogoImage.layer.masksToBounds = YES;
        
      //  [self imgLoadMainPageAdditionalImages:trendDetail.imageArray];
    }
    
}

#pragma mark ====== Following Detils Methods=============================


-(void)fetchFollowingDetailsFromServer
{
    allFollowingsArray=[[NSMutableArray alloc]init];
    
    NSLog(@"appDelegate.currentLoggedInUser ====> %@",appDelegate.currentLoggedInUser.auth_token);
    
    [AppDelegate performSelector:@selector(activeIndicatorStartAnimating:) withObject:self.view afterDelay:0.0];
    
    self.view.userInteractionEnabled = NO;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
    ^{
        NSMutableArray *getFollowListArray = [ServiceHelper getFollowingDetailsByLoguthTokenid:appDelegate.currentLoggedInUser.auth_token];

        dispatch_async(dispatch_get_main_queue(),
                       ^{
            [self loadFollowingDatas:getFollowListArray];
                           
           [AppDelegate performSelector:@selector(activeIndicatorStopAnimating) withObject:nil];
           
           self.view.userInteractionEnabled = YES;
        });
    });
}


-(void)loadFollowingDatas:(NSMutableArray *)arr_FollowList
{
    [allFollowingsArray removeAllObjects];
    
    [allFollowingsArray addObjectsFromArray:arr_FollowList];
    
    NSLog(@"allFollowingsArray====%@",allFollowingsArray);
    
    if ([allFollowingsArray count]>0)
    {
        self.viewFollowins.hidden = NO;
        
        [self performSelectorOnMainThread:@selector(setFollowingsAfterFetchingFromServer) withObject:nil waitUntilDone:NO];
    }
    else
    {
         self.viewFollowins.hidden = YES;
        
        self.bottomSocialIconBar.hidden=YES;
        
        UIImageView *imgNodata=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320,  568)];

        [imgNodata setImage:[UIImage imageNamed: @"bg_logo.jpg"]];
        
        [self showErrorAlert:@"No Followings data available"];
        
        self.scrllViewMain.frame=CGRectMake(0, 0, 320,  568);
        [self.scrllViewMain setContentSize:CGSizeMake(320, 568)];
        [self.scrllViewMain addSubview:imgNodata];
        
    }
}

-(void)setFollowingsAfterFetchingFromServer
{
    if (imgNodata != nil)
    {
        [imgNodata removeFromSuperview];
    }

    for (int iCount = 0; iCount < [allFollowingsArray count]; iCount ++)
    {
        FollowingView *currentFollowingView = (FollowingView *)[scrolViewMainFollowing viewWithTag:iCount + 5000];
        
        if (currentFollowingView != nil)
        {
            [currentFollowingView removeFromSuperview];
        }
    }

    int y = 10;

    for (int iCount = 0; iCount < [allFollowingsArray count]; iCount ++)
    {
    FollowingView *currentFollowingView = [[[NSBundle mainBundle] loadNibNamed:@"FollowingView"
                                                                             owner:self
                                                                           options:nil]objectAtIndex:0];
        if (iCount == 0)
        {
            currentFollowingView.frame = CGRectMake(10 , y, currentFollowingView.frame.size.width, currentFollowingView.frame.size.height);
        }
        else
        {
            currentFollowingView.frame = CGRectMake(10 , y, currentFollowingView.frame.size.width, currentFollowingView.frame.size.height);
        }
        y = y + (currentFollowingView.frame.size.height + 10);
        
        currentFollowingView.tag = iCount+5000;
        
        [scrolViewMainFollowing addSubview:currentFollowingView];
        
    }
    
    [scrolViewMainFollowing setFrame:CGRectMake(scrolViewMainFollowing.frame.origin.x, 0,  scrolViewMainFollowing.frame.size.width , 512)];
    
    self.viewFollowins.frame = CGRectMake(self.viewFollowins.frame.origin.x , self.viewFollowins.frame.origin.y, 320, y);
    
    [self.scrllViewMain setContentSize:CGSizeMake(320, scrolViewMainFollowing.frame.size.height )];//+ 328+ [allFollowingsArray count] * 15
    
    [scrolViewMainFollowing setContentSize:CGSizeMake(scrolViewMainFollowing.frame.size.width , y)];

    for (int iCount = 0; iCount < [allFollowingsArray count]; iCount ++)
    {
        Followings *currentFollowing = [allFollowingsArray objectAtIndex:iCount];
        
        FollowingView *currentFollowingView = (FollowingView *)[scrolViewMainFollowing viewWithTag:iCount + 5000];
        
//        currentFollowingView.layer.cornerRadius = 5;
//        currentFollowingView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        currentFollowingView.layer.borderWidth = 2;
        
        ((AsyncImageView *)[currentFollowingView viewWithTag:2]).layer.cornerRadius = 5;
        ((AsyncImageView *)[currentFollowingView viewWithTag:2]).layer.masksToBounds = YES;
        
        NSLog(@"currentFollowing.photos_url = %@",currentFollowing.photos_url);

        if ([currentFollowing.photos_url count] > 0)
        [((AsyncImageView *)[currentFollowingView viewWithTag:1]) loadImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[currentFollowing.photos_url objectAtIndex:0]]]];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(followingTapDetected:)];
        singleTap.numberOfTapsRequired = 1;
        ((AsyncImageView *)[currentFollowingView viewWithTag:1]).userInteractionEnabled = YES;
        [((AsyncImageView *)[currentFollowingView viewWithTag:1]) addGestureRecognizer:singleTap];

        [((AsyncImageView *)[currentFollowingView viewWithTag:2]) loadImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",currentFollowing.logo_url]]];
        ((UILabel *)[currentFollowingView viewWithTag:3]).text = [NSString stringWithFormat:@"%@",currentFollowing.pre_name];
        ((UILabel *)[currentFollowingView viewWithTag:4]).text = [NSString stringWithFormat:@"%@",currentFollowing.address];
        ((UILabel *)[currentFollowingView viewWithTag:5]).text = [NSString stringWithFormat:@"%@",currentFollowing.my_network];
        ((UILabel *)[currentFollowingView viewWithTag:6]).text = [NSString stringWithFormat:@"%@",currentFollowing.likers_count];
        ((UILabel *)[currentFollowingView viewWithTag:7]).text = [NSString stringWithFormat:@"%@",currentFollowing.followers_count];

        NSLog(@"pre name======= >>>%@",currentFollowing.pre_name);

        [(UIButton *)[currentFollowingView viewWithTag:10] addTarget:self action:@selector(btnFollowClicked:) forControlEvents:UIControlEventTouchDown];
        
        [(UIButton *)[currentFollowingView viewWithTag:8] addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchDown];
        
        [(UIButton *)[currentFollowingView viewWithTag:9] addTarget:self action:@selector(btnLikeClicked:) forControlEvents:UIControlEventTouchDown];

        if ([currentFollowing.open_now isEqualToString:@"1"] || [currentFollowing.open_now isEqualToString:@"open"])
        {
            [((UIImageView *)[currentFollowingView viewWithTag:11]) setImage:[UIImage imageNamed:@"open.png"]];
        }
        else
        {
            [((UIImageView *)[currentFollowingView viewWithTag:11]) setImage:[UIImage imageNamed:@"closed.png"]];
        }
        
        if ([currentFollowing.liker_ids containsObject:appDelegate.currentLoggedInUser.userId])
        {
            [((UIButton *)[currentFollowingView viewWithTag:9]) setImage:[UIImage imageNamed:@"like.png"]  forState:UIControlStateNormal];
        }
        else
        {
            [((UIButton *)[currentFollowingView viewWithTag:9]) setImage:[UIImage imageNamed:@"unlike.png"]  forState:UIControlStateNormal];
        }

    }

    

}

-(void)setDataAfterFetchingFromServer
{
    if ([allaggregationsArray count] > 0)
    {
       // [pagingView scrollToNextPage];
        if ([pagingView._pageViews count] > 2)
        {
            UIButton *myButton = (UIButton *)[pagingView._pageViews objectAtIndex:1];
            [myButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        }
        
        isInitialLoad = YES;
        
        [self performSelector:@selector(btnSocial_Clicked:) withObject:nil afterDelay:0.2];

        tempHeight = 0; socialViewgap = 40;

        [bottomIconsNumber removeAllObjects];
        
        //Instagram
        Instagram *instagram=[[Instagram alloc]init];
        
        instagram=[allaggregationsArray objectAtIndex:2];
        
        instagramUrl = @"http://www.instagram.com/";
        
        [self imgLoad_Instrgram:instagram.imageArray];

        Yelp *yelp = [[Yelp alloc] init];
        
        yelp = [allaggregationsArray objectAtIndex:5];
        
        yelpUrl = [NSString stringWithFormat:@"%@",yelp.url];
        
        [self loadYelpUserProfileData:yelp];

        Facebook *facebook = [[Facebook alloc] init];
        
        facebook = [allaggregationsArray objectAtIndex:0];
        
        if (([[NSString stringWithFormat:@"%@",facebook.checkins] intValue] == 0) && ([[NSString stringWithFormat:@"%@",facebook.been_here] intValue] == 0) && ([[NSString stringWithFormat:@"%@",facebook.likes] intValue] == 0) && ([[NSString stringWithFormat:@"%@",facebook.talking_about] intValue] == 0))
        {
            _facebookView.hidden = YES;
        }
        else
        {
            _lblFbTotalcheckins.text = [self addingCommaToCounts:[[NSString stringWithFormat:@"%@",facebook.checkins] stringByReplacingOccurrencesOfString:@"₹" withString:@""]];
            _lblFbVisited.text = [self addingCommaToCounts:[[NSString stringWithFormat:@"%@",facebook.been_here] stringByReplacingOccurrencesOfString:@"₹" withString:@""]];
            _lblFbTotalLikes.text = [self addingCommaToCounts:[[NSString stringWithFormat:@"%@",facebook.likes] stringByReplacingOccurrencesOfString:@"₹" withString:@""]] ;
            _lblFbTalkingabt.text =[self addingCommaToCounts:[[NSString stringWithFormat:@"%@",facebook.talking_about] stringByReplacingOccurrencesOfString:@"₹" withString:@""]];
            facebookUrl = [NSString stringWithFormat:@"%@",facebook.url];
            _facebookView.frame = CGRectMake(_facebookView.frame.origin.x, tempHeight + socialViewgap, _facebookView.frame.size.width, _facebookView.frame.size.height);
            tempHeight += socialViewgap + _facebookView.frame.size.height;
            [bottomIconsNumber addObject:@"3"];
        }
        
        Twitter *twitter = [[Twitter alloc] init];
        
        twitter = [allaggregationsArray objectAtIndex:1];
        
        if (([[NSString stringWithFormat:@"%@",twitter.total_tweet] intValue] == 0) && ([[NSString stringWithFormat:@"%@",twitter.following] intValue] == 0) && ([[NSString stringWithFormat:@"%@",twitter.followers] intValue] == 0) && ([[NSString stringWithFormat:@"%@",twitter.description] length] == 0) && ([twitter.handlerdataArray count] == 0) && ([twitter.hashtagsdataArray count] == 0))
        {
            _twitterView.hidden = YES;
        }
        else
        {
            _lblTweets.text = [self addingCommaToCounts:[NSString stringWithFormat:@"%@",twitter.total_tweet]];
            _llblTwittFollowing.text = [self addingCommaToCounts:[NSString stringWithFormat:@"%@",twitter.following]];
            _lblTwittFollowers.text = [self addingCommaToCounts:[NSString stringWithFormat:@"%@",twitter.followers]];
            _lblTweetsShopDetails.text = [NSString stringWithFormat:@"%@",twitter.description];
            twitterUrl = [NSString stringWithFormat:@"%@",twitter.url];
            _twitterView.frame = CGRectMake(_twitterView.frame.origin.x, tempHeight + socialViewgap, _twitterView.frame.size.width, _twitterView.frame.size.height);
            tempHeight += socialViewgap + _twitterView.frame.size.height;
            
            [bottomIconsNumber addObject:@"5"];
        }
        [self loadTweetHandlerData:twitter];
        [self loadTweetHashTagsData:twitter];
        
        
        Foursquare *foursquare = [[Foursquare alloc] init];

        foursquare = [allaggregationsArray objectAtIndex:3];

        if (([[NSString stringWithFormat:@"%@",foursquare.rating] intValue] == 0) && ([[NSString stringWithFormat:@"%@",foursquare.here_now] intValue] == 0) && ([[NSString stringWithFormat:@"%@",foursquare.checkins] intValue] == 0) && ([[NSString stringWithFormat:@"%@",foursquare.total_vistors] intValue] == 0))
        {
            _foursquareView.hidden = YES;
        }
        else
        {
            _lblFqsPopularity.text = [NSString stringWithFormat:@"%@/10",foursquare.rating];
            _lblFqsHerenow.text = [self addingCommaToCounts:[NSString stringWithFormat:@"%@",foursquare.here_now]];
            _lblFqsTotalcheckin.text = [self addingCommaToCounts:[NSString stringWithFormat:@"%@",foursquare.checkins]];
            _lblFqsTotalVisiters.text = [self addingCommaToCounts:[NSString stringWithFormat:@"%@",foursquare.total_vistors]];
            foursquareUrl = [NSString stringWithFormat:@"%@",foursquare.url];
            _foursquareView.frame = CGRectMake(_foursquareView.frame.origin.x, tempHeight + socialViewgap, _foursquareView.frame.size.width, _foursquareView.frame.size.height);
            tempHeight += socialViewgap + _foursquareView.frame.size.height;
            
            [bottomIconsNumber addObject:@"4"];
        }
        
        Wikipedia *wikipedia = [[Wikipedia alloc] init];
        
        wikipedia = [allaggregationsArray objectAtIndex:4];
        wikiUrl = [NSString stringWithFormat:@"%@",wikipedia.url];

        NSLog(@"wikipedia.content = %@",wikipedia.content);
        
        if ([[NSString stringWithFormat:@"%@",wikipedia.content] isEqualToString:@"<null>"] || [[NSString stringWithFormat:@"%@",wikipedia.content] isEqualToString:@""])
        {
            _wikiView.hidden = YES;

        }
        else
        {
            _wikiView.frame = CGRectMake(_wikiView.frame.origin.x, tempHeight + socialViewgap, _wikiView.frame.size.width, _wikiView.frame.size.height);
            tempHeight += socialViewgap + _wikiView.frame.size.height;
            [_webViewWikiContent loadHTMLString:[NSString stringWithFormat:@"%@",wikipedia.content] baseURL:nil];
            [bottomIconsNumber addObject:@"6"];
        }
    }
    
    [AppDelegate performSelector:@selector(activeIndicatorStopAnimating) withObject:nil];
    self.view.userInteractionEnabled = YES;
}

-(void)loadYelpUserProfileData:(Yelp *)yelp
{
    YelpUserProfile *yelpUserProfile = [[YelpUserProfile alloc] init];
    
    for (int i=1; i<[yelp.userProfileDataArr count]; i++)
    {
       // _lblYelpChat.layer.borderColor = [UIColor lightGrayColor].CGColor;
     //   _lblYelpChat.layer.borderWidth = 1.0;
        YelpUserProfileView *currentYelpUserProfileView = (YelpUserProfileView *)[self cloneView:[self.scrllViewYelpChat viewWithTag:1]];
        currentYelpUserProfileView.frame = CGRectMake(i*251, currentYelpUserProfileView.frame.origin.y, currentYelpUserProfileView.frame.size.width, currentYelpUserProfileView.frame.size.height);
        currentYelpUserProfileView.tag = i+1;
        [self.scrllViewYelpChat addSubview:currentYelpUserProfileView];
    }
    [self.scrllViewYelpChat setContentSize:CGSizeMake([yelp.userProfileDataArr count] * 251 , self.scrllViewYelpChat.frame.size.height)];
    
    for (int i=0; i<[yelp.userProfileDataArr count]; i++)
    {
        yelpUserProfile = [yelp.userProfileDataArr objectAtIndex:i];
        YelpUserProfileView *currentYelpUserProfileView = (YelpUserProfileView *)[self.scrllViewYelpChat viewWithTag:i + 1];
        ((UILabel *)[currentYelpUserProfileView viewWithTag:2004]).text = [NSString stringWithFormat:@"%@",yelpUserProfile.review];
        ((UILabel *)[currentYelpUserProfileView viewWithTag:2003]).text = [NSString stringWithFormat:@"%@",yelpUserProfile.name];
     
        [((AsyncImageView *)[currentYelpUserProfileView viewWithTag:2001]) loadImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",yelpUserProfile.profile_url]]];
        
        [((AsyncImageView *)[currentYelpUserProfileView viewWithTag:2002]) loadImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",yelpUserProfile.rating_img]]];
        
        //((UILabel *)[currentYelpUserProfileView viewWithTag:2004]).layer.borderColor = [UIColor lightGrayColor].CGColor;
        //((UILabel *)[currentYelpUserProfileView viewWithTag:2004]).layer.borderWidth = 1.0;

    }
	self.scrllViewYelpChat.showsHorizontalScrollIndicator = NO;
    if ([yelp.userProfileDataArr count] == 0)
    {
        _yelpView.hidden = YES;
        _yelpBottomView.hidden = YES;
        _yelpContentView.hidden = YES;
    }
    else
    {
        _yelpView.frame = CGRectMake(_yelpView.frame.origin.x, tempHeight + socialViewgap, _yelpView.frame.size.width, _yelpView.frame.size.height);
        _yelpBottomView.frame = CGRectMake(_yelpBottomView.frame.origin.x, _yelpView.frame.origin.y + _yelpView.frame.size.height , _yelpBottomView.frame.size.width, _yelpBottomView.frame.size.height);
        _yelpContentView.frame = CGRectMake(_yelpContentView.frame.origin.x, _yelpView.frame.origin.y + _yelpView.frame.size.height, _yelpContentView.frame.size.width, _yelpContentView.frame.size.height);

        tempHeight += socialViewgap + _yelpView.frame.size.height + _yelpBottomView.frame.size.height;
        
        [bottomIconsNumber addObject:@"2"];
    }
}

-(void)loadTweetHandlerData:(Twitter *)twitter
{
    pageIndex = 0;

    self.scrllViewTweets.backgroundColor = [UIColor clearColor];
    
    TwitterHandlerdate *twitterHandlerdate = [[TwitterHandlerdate alloc] init];
    
    for (int i=1; i<[twitter.handlerdataArray count]; i++)
    {
        TweetHandlerView *currentTweethandlerView = (TweetHandlerView *)[self cloneView:[self.scrllViewTweets viewWithTag:1]];
        currentTweethandlerView.frame = CGRectMake(10 + i*251, currentTweethandlerView.frame.origin.y, currentTweethandlerView.frame.size.width , currentTweethandlerView.frame.size.height);
        currentTweethandlerView.tag = i+1;
        [self.scrllViewTweets addSubview:currentTweethandlerView];
    }
    
    [self.scrllViewTweets setContentSize:CGSizeMake([twitter.handlerdataArray count] * 251 + 20 , self.scrllViewTweets.frame.size.height)];
    
    for (int i=0; i<[twitter.handlerdataArray count]; i++)
    {
        twitterHandlerdate = [twitter.handlerdataArray objectAtIndex:i];
        TweetHandlerView *currentTweethandlerView = (TweetHandlerView *)[self.scrllViewTweets viewWithTag:i + 1];
        ((UILabel *)[currentTweethandlerView viewWithTag:1003]).text = [NSString stringWithFormat:@"%@",twitterHandlerdate.tweet];
        ((UILabel *)[currentTweethandlerView viewWithTag:1001]).text = [NSString stringWithFormat:@"%@",twitter.name];
        ((UILabel *)[currentTweethandlerView viewWithTag:1002]).text = [NSString stringWithFormat:@"@%@",twitter.handle];
        [((AsyncImageView *)[currentTweethandlerView viewWithTag:1000]) loadImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",twitterHandlerdate.profileUrl]]];
    }
    self.scrllViewTweets.clipsToBounds = NO;
	//self.scrllViewTweets.pagingEnabled = YES;
	self.scrllViewTweets.showsHorizontalScrollIndicator = NO;

    if ([twitter.handlerdataArray count] == 0)
        self.scrllViewTweets.hidden = YES;
    else
    {
        self.scrllViewTweets.frame = CGRectMake(self.scrllViewTweets.frame.origin.x, tempHeight - self.scrllViewTweets.frame.size.height, self.scrllViewTweets.frame.size.width, self.scrllViewTweets.frame.size.height);
    }
}

-(void)loadTweetHashTagsData:(Twitter *)twitter
{
    pageIndex = 0;
    
    self.scrllViewTweetHashtags.backgroundColor = [UIColor clearColor];
    
    TwitterHashTagsdate *twitterHashTagsdate = [[TwitterHashTagsdate alloc] init];
    
    for (int i=1; i<[twitter.hashtagsdataArray count]; i++)
    {
        TweetHashTagsView *currentTweetHashTagsView = (TweetHashTagsView *)[self cloneView:[self.scrllViewTweetHashtags viewWithTag:1]];
        currentTweetHashTagsView.frame = CGRectMake(10 + i*251, currentTweetHashTagsView.frame.origin.y, currentTweetHashTagsView.frame.size.width, currentTweetHashTagsView.frame.size.height);
        currentTweetHashTagsView.tag = i+1;
        [self.scrllViewTweetHashtags addSubview:currentTweetHashTagsView];
    }
    [self.scrllViewTweetHashtags setContentSize:CGSizeMake([twitter.hashtagsdataArray count] * 251 + 20 , self.scrllViewTweetHashtags.frame.size.height)];
    
    for (int i=0; i<[twitter.hashtagsdataArray count]; i++)
    {
        twitterHashTagsdate = [twitter.hashtagsdataArray objectAtIndex:i];
        
        TweetHashTagsView *currenttwitterHashTagsdate= (TweetHashTagsView *)[self.scrllViewTweetHashtags viewWithTag:i + 1];
        ((UILabel *)[currenttwitterHashTagsdate viewWithTag:3002]).text = [NSString stringWithFormat:@"%@",twitterHashTagsdate.tweet];
        ((UILabel *)[currenttwitterHashTagsdate viewWithTag:3001]).text = [NSString stringWithFormat:@"%@",twitterHashTagsdate.name];
       // ((UILabel *)[currentTweethandlerView viewWithTag:1002]).text = [NSString stringWithFormat:@"@%@",twitter.handle];
        [((AsyncImageView *)[currenttwitterHashTagsdate viewWithTag:3000]) loadImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",twitterHashTagsdate.profileUrl]]];
        
    }
	self.scrllViewTweetHashtags.showsHorizontalScrollIndicator = NO;
    if ([twitter.hashtagsdataArray count] == 0)
        _twitterHashTagsView.hidden = YES;
    else
    {
        _twitterHashTagsView.frame = CGRectMake(_twitterHashTagsView.frame.origin.x, tempHeight, _twitterHashTagsView.frame.size.width, _twitterHashTagsView.frame.size.height);
        tempHeight +=  _twitterHashTagsView.frame.size.height;
    }
}


- (id) cloneView:(UIView *)view
{
    NSData *archivedViewData = [NSKeyedArchiver archivedDataWithRootObject: view];
    id cloneView = [NSKeyedUnarchiver unarchiveObjectWithData:archivedViewData];
    return cloneView;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (selectedOption == 1)
    {
        self.topBandMessageView.hidden = YES;
        
        if (scrollView.contentOffset.y > 200)
        {
            self.topBandMessageView.hidden = NO;
            
            if (IS_IPHONE_5)
            {
                self.topBandMessageView.backgroundColor=[UIColor whiteColor];
            }
            else
            {
                self.topBandMessageView.backgroundColor=[UIColor whiteColor];
                
            }
        }
        if ([scrollView isEqual:self.detailScrollView])
        {
            //        CGFloat pageWidth = self.detailScrollView.frame.size.width; // you need to have a **iVar** with getter for scrollView
            //
            //        float fractionalPage = self.detailScrollView.contentOffset.x / pageWidth;
            //
            //        NSInteger page = lround(fractionalPage);
            //
            //        self.pagecontrol.currentPage = page; // you need to have a **iVar** with getter for pageControl
        }
        else
        {
            if (_scrllViewMain.contentOffset.x < _scrllViewMain.frame.size.width )
            {
                [_scrllViewMain scrollRectToVisible:CGRectMake(_scrllViewMain.contentOffset.x + 3 * _scrllViewMain.frame.size.width, 0, _scrllViewMain.frame.size.width, _scrllViewMain.frame.size.height) animated:NO];
            }
            else if ( _scrllViewMain.contentOffset.x > 4 *  _scrllViewMain.frame.size.width  )
            {
                [_scrllViewMain scrollRectToVisible:CGRectMake(_scrllViewMain.contentOffset.x - 3 * _scrllViewMain.frame.size.width, 0, _scrllViewMain.frame.size.width, _scrllViewMain.frame.size.height) animated:NO];
            }
        }
        
        [btnYelpicon setImage:[UIImage imageNamed:@"Icon-yelp-inActive.png"] forState:UIControlStateNormal];
        [btnInsticon setImage:[UIImage imageNamed:@"Icon-Instagram-inActive.png"] forState:UIControlStateNormal];
        [btnFBicon setImage:[UIImage imageNamed:@"Icon-FB-inactive.png"] forState:UIControlStateNormal];
        [btnFeqicon setImage:[UIImage imageNamed:@"Icon-4Square-inactive.png"] forState:UIControlStateNormal];
        [btnTwitticon setImage:[UIImage imageNamed:@"Icon-twitter-inactive.png"] forState:UIControlStateNormal];
        [btnWikiicon setImage:[UIImage imageNamed:@"Icon-wiki-inactive.png"] forState:UIControlStateNormal];
        
        CGPoint aPoint = CGPointMake(self.view.center.x,self.view.center.y);
        CGRect frame = [_facebookView convertRect:_facebookView.bounds toView:self.view];
        
        if (CGRectContainsPoint(frame, aPoint)){
            [btnFBicon setImage:[UIImage imageNamed:@"fb.png"] forState:UIControlStateNormal];}
        
        frame = [_instagramView convertRect:_instagramView.bounds toView:self.view];
        if (CGRectContainsPoint(frame, aPoint)){
            [btnInsticon setImage:[UIImage imageNamed:@"instagram.png"] forState:UIControlStateNormal];
        }
        frame = [_twitterView convertRect:_twitterView.bounds toView:self.view];
        if (CGRectContainsPoint(frame, aPoint)){
            [btnTwitticon setImage:[UIImage imageNamed:@"twitter_h.png"] forState:UIControlStateNormal];
        }
        frame = [_yelpBottomView convertRect:_yelpBottomView.bounds toView:self.view];
        if (CGRectContainsPoint(frame, aPoint)){
            [btnYelpicon setImage:[UIImage imageNamed:@"yelp.png"] forState:UIControlStateNormal];
        }
        frame = [_foursquareView convertRect:_foursquareView.bounds toView:self.view];
        if (CGRectContainsPoint(frame, aPoint)){
            [btnFeqicon setImage:[UIImage imageNamed:@"4square.png"] forState:UIControlStateNormal];}
        frame = [_wikiView convertRect:_wikiView.bounds toView:self.view];
        if (CGRectContainsPoint(frame, aPoint)){
            [btnWikiicon setImage:[UIImage imageNamed:@"wordpress.png"] forState:UIControlStateNormal];
        }
    }
}

-(void)openRemoteUrl:(NSString *)urlString
{
    BOOL result = [[urlString lowercaseString] hasPrefix:@"http://"];
    
    if (!result)
    {
        urlString = [NSString stringWithFormat:@"http://%@", urlString];
    }
    
    [MTPopupWindow showWindowWithHTMLFile:urlString insideView:self.view];
}

-(void)openDirectionUrl
{
    NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",
                     currentLocation.latitude, currentLocation.longitude,
                     destLocation.latitude, destLocation.longitude];
    
    [MTPopupWindow showWindowWithHTMLFile:url insideView:self.view];

}
-(NSString *)addingCommaToCounts:(NSString *)count
{
    NSNumberFormatter *currency = [[NSNumberFormatter alloc] init];
    [currency setNumberStyle:NSNumberFormatterCurrencyStyle];
    [currency setLocale:[NSLocale currentLocale]];
    NSString *countstring = [NSString stringWithFormat:@"%@", [currency stringFromNumber:[NSNumber numberWithInt:[count intValue]]]];
    countstring = [countstring stringByReplacingOccurrencesOfString:@"₹ " withString:@""];
    countstring = [countstring stringByReplacingOccurrencesOfString:@"$" withString:@""];
    countstring = [countstring stringByReplacingOccurrencesOfString:@".00" withString:@""];
    
   // NSLog(@"number = %@",countstring);
    return countstring;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)sendEmail
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
        [mailComposer setSubject:_lblTrendTittle.text];
        NSString *message;
        message = shareText;
        if (shareimage != nil)
        {
            NSData *exportData = UIImageJPEGRepresentation(shareimage ,1.0);
            [mailComposer addAttachmentData:exportData mimeType:@"image/jpeg" fileName:@"Picture.jpeg"];
        }
        
        [mailComposer setMessageBody:message isHTML:YES];
        mailComposer.mailComposeDelegate = self;
        [self presentViewController:mailComposer animated:YES completion:nil];
    }
}
#pragma mark MFMailComposeViewControllerDelegate

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result
                       error:(NSError *)error
{
    if (result == MFMailComposeResultSent) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Message"
                                                     message:@"Mail sent sucessfully!"
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark Twitter

- (void)loadView {
    [super loadView];
    
    [[FHSTwitterEngine sharedEngine]permanentlySetConsumerKey:@"Xg3ACDprWAH8loEPjMzRg" andSecret:@"9LwYDxw1iTc6D9ebHdrYCZrJP4lJhQv5uf4ueiPHvJ0"];
    [[FHSTwitterEngine sharedEngine]setDelegate:self];
    [[FHSTwitterEngine sharedEngine]loadAccessToken];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 5757)
    {
        NSString *titleAlert = [alertView buttonTitleAtIndex:1];
        NSLog(@"titleAlert===%@",titleAlert);
        

        if (buttonIndex==0)
        {
            NSLog(@"0");
            
        }
       if([titleAlert isEqualToString:@"Launch with image"])
        {
            NSLog(@"1");
            [self launchWhatsAppwithImage];
            
        }
        if (buttonIndex==2)
        {
            NSLog(@"2");
            [self launchWhatsAppWithMessage];
            
        }
    }
    
    else if (alertView.tag == 1000)
    {
        if (buttonIndex==0)
        {
            NSString *number = [trendDetail.phone_number stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSString *phoneNumber = [@"tel://" stringByAppendingString:number];
            
            NSLog(@"phonenumber====%@",phoneNumber);
            
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:phoneNumber]])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"ALERT" message:@"This function is only available on the iPhone"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            
        }
    }
    
    
    else if ([alertView.title isEqualToString:@"Tweet"]) {
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
    [self postTweet];
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

- (void)logout
{
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
    
//    shareimage =[UIImage imageNamed:@"slider-1.png"];
//    
//    UIImageWriteToSavedPhotosAlbum(shareimage, nil, nil, nil);
    
    NSString *strCheck=@"Placeley Tweets-"; // only allowing 140 char
    
    NSData *imageData = UIImagePNGRepresentation(shareimage);
    
    if (shareimage != nil)
    {
        id yayOrNay = [[FHSTwitterEngine sharedEngine] postTweet:strCheck withImageData:imageData];
        if (yayOrNay == nil) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Sucessfully posted to photos & wall!"
                                                         message:@"Check out your Twitter to see!"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
            [av show];
            [AppDelegate performSelector:@selector(activeIndicatorStopAnimating) withObject:nil];
        }
    }
    else
    {
        [[FHSTwitterEngine sharedEngine] postTweet:strCheck];
    }
}

#pragma mark Facebook Login Button

- (IBAction)loginFBButtonTapped:(id)sender
{
    [AppDelegate performSelector:@selector(activeIndicatorStartAnimating:) withObject:self.view afterDelay:0.2];
    self.view.userInteractionEnabled = NO;
    
    NSString *appId = @"408481352616594";
    NSString *permissions = @"publish_stream,email";
    //[_loginDialog logout];
    if (_loginDialog == nil) {
        self.loginDialog = [[FBFunLoginDialog alloc] initWithAppId:appId requestedPermissions:permissions delegate:self];
        self.loginDialogView = _loginDialog.view;
    }
    count = 0;
    
    [_loginDialog login];
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
    dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy hhmma"];
    
    NSMutableDictionary *responseJSON = [[request responseString] JSONValue];
    
    NSString *expirationdateString = [dateFormat stringFromDate:self.expiryDate];
    
    NSMutableDictionary *originalDictionary = [[NSMutableDictionary alloc] init];
    
    [originalDictionary setValue:@"Email is not working" forKey:@"email"];
    [originalDictionary setValue:[responseJSON objectForKey:@"id"] forKey:@"uid"];
    [originalDictionary setValue:self.accessToken forKey:@"token"];
    [originalDictionary setValue:expirationdateString forKey:@"expires_at"];
    [originalDictionary setValue:@"facebook" forKey:@"provider"];
    [originalDictionary setValue:[responseJSON objectForKey:@"name"] forKey:@"name"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    
    NSString *jsonString = [jsonWriter stringWithObject:originalDictionary];
    
    NSLog(@"jsonString = %@",jsonString);
    
    [[NSUserDefaults standardUserDefaults] setObject:jsonString forKey:@"Facebook"];
}

- (void)getFacebookPhotoFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    NSLog(@"Got Facebook Photo: %@", responseString);
    
    NSMutableDictionary *responseJSON = [responseString JSONValue];
    
    NSString *link = [responseJSON objectForKey:@"link"];
    if (link == nil) return;
    else
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Sucessfully posted to photos & wall!"
                                                     message:@"Check out your Facebook to see!"
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
        [AppDelegate performSelector:@selector(activeIndicatorStopAnimating) withObject:nil];
    }
    NSLog(@"Link to photo: %@", link);
}

- (void)postToWallFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    NSMutableDictionary *responseJSON = [responseString JSONValue];
    NSString *postId = [responseJSON objectForKey:@"id"];
    NSLog(@"Post id is: %@", postId);
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Sucessfully posted to wall!"
                                                 message:@"Check out your Facebook to see!"
                                                delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
	[av show];
    [AppDelegate performSelector:@selector(activeIndicatorStopAnimating) withObject:nil];
}

#pragma mark uploadPhoto

-(void)uploadText
{
    NSURL *url = [NSURL URLWithString:@"https://graph.facebook.com/me/feed"];
    ASIFormDataRequest *newRequest = [ASIFormDataRequest requestWithURL:url];
    [newRequest setPostValue:shareText forKey:@"message"];
    [newRequest setPostValue:_accessToken forKey:@"access_token"];
    [newRequest setDidFinishSelector:@selector(postToWallFinished:)];
    
    [newRequest setDelegate:self];
    [newRequest startAsynchronous];
}
-(void)uploadPhoto
{
   // UIImage* image = [UIImage imageNamed:@"unlike.png"];
    
    NSString *filePath;
    
    NSString  *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.png"];
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.jpg"];
    
    [UIImageJPEGRepresentation(shareimage, 1.0) writeToFile:jpgPath atomically:YES];
    [UIImagePNGRepresentation(shareimage) writeToFile:pngPath atomically:YES];
    
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *tst=@"/Test.jpg";
    
    filePath = [documentsDirectory stringByAppendingString:tst];
    
    NSString *list = _accessToken;
    NSArray *listItems = [list componentsSeparatedByString:@"&"];
    NSString *finalstr=[listItems objectAtIndex:0];
    _accessToken=finalstr;
    
    NSString *message = [NSString stringWithFormat:@"%@",shareText];
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
    [self dismissViewControllerAnimated:YES completion:nil];
    [self getFacebookProfile];
    if (selectedOption == 2)
    {
        [self uploadText];
    }
    else
    {
        [self uploadPhoto];
    }
    count = 0;
    if ([accessToken length] > 0)
    {
        [AppDelegate performSelector:@selector(activeIndicatorStopAnimating) withObject:nil];
        self.view.userInteractionEnabled = YES;
    }
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
    [_loginDialog logout];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    selectedTextField = textField;
    
    [self pushViewUpDown:CGPointMake(scrolViewMainActivity.frame.origin.x,selectedTextField.superview.superview.frame.origin.y + 20)];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self pushViewUpDown:CGPointMake(scrolViewMainActivity.frame.origin.x, selectedTextField.superview.superview.frame.origin.y - 10)];

    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)pushViewUpDown:(CGPoint)point
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [scrolViewMainActivity setContentOffset:point];
    [UIView commitAnimations];

}


#pragma mark ====== Instgram Large Image Methods===============


-(void)tapDetectedpOnInstgramimage:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"tapDetectedpOnInstgramimage");
    if([viewInstgramLargeImg isDescendantOfView:self.view])
    {
        NSLog(@"Filter is visible");
        [self viewPopDownInstgramImg];
        [viewInstgramLargeImg removeFromSuperview];
    }
    else
    {
        NSLog(@"Filter not visible");
        AsyncImageView *asyncImageView = (AsyncImageView *)[self cloneView:[gestureRecognizer view]];
        asyncImageView.frame = viewInstgramLargeImg.bounds;
        [viewInstgramLargeImg addSubview:asyncImageView];
        [viewInstgramLargeImg sendSubviewToBack:asyncImageView];
        [self.view addSubview:viewInstgramLargeImg];
        [self viewPopUpInstgramImg];
    }
}

-(IBAction)btnCloseInstgramimg_Clicked:(id)sender
{
      [self viewPopDownInstgramImg];
}

-(void)viewPopUpInstgramImg
{
    viewInstgramLargeImg.hidden=NO;
    
    viewInstgramLargeImg.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    self.view.alpha = 1.0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3/1.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
    viewInstgramLargeImg.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    if(IS_IPHONE_5)
        viewInstgramLargeImg.frame=CGRectMake(viewInstgramLargeImg.frame.origin.x, 120, viewInstgramLargeImg.frame.size.width, viewInstgramLargeImg.frame.size.height);
    else
        viewInstgramLargeImg.frame=CGRectMake(viewInstgramLargeImg.frame.origin.x, 120, viewInstgramLargeImg.frame.size.width, viewInstgramLargeImg.frame.size.height);
    [UIView commitAnimations];
}

-(void)viewPopDownInstgramImg
{
    viewInstgramLargeImg.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    self.view.alpha = 1.0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3/1.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStoppedPopDown)];
    viewInstgramLargeImg.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [UIView commitAnimations];
}
- (void)bounce1AnimationStoppedPopDown {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3/2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationStoppedPopDown)];
    viewInstgramLargeImg.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.0, 0.0);
    [UIView commitAnimations];
}

- (void)bounce2AnimationStoppedPopDown {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3/2];
    viewInstgramLargeImg.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
   viewInstgramLargeImg.hidden = TRUE;
    if([viewInstgramLargeImg isDescendantOfView:self.view])
    {
        for (id subview in [viewInstgramLargeImg subviews])
        {
            [subview removeFromSuperview];
        }
        [viewInstgramLargeImg removeFromSuperview];
    }
}

- (void)bounce1AnimationStopped {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3/2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
    viewInstgramLargeImg.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
    [UIView commitAnimations];
}

- (void)bounce2AnimationStopped {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3/2];
    viewInstgramLargeImg.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}

#pragma mark ========= Menu options==========================

-(IBAction)btnInfoPage_Clicked:(id)sender
{
    
    objinfoPageVC=[[infoPageVC alloc]initWithNibName:@"infoPageVC" bundle:nil];
    [self.navigationController pushViewController:objinfoPageVC animated:YES];
    
}


-(IBAction)btnMenuOptions_Clicked:(id)sender
{
    [self infoOpenAnimation];
    viewManuoptions.hidden=NO;
    
    
}

-(void)handleTapGestureCloseMenus:(UIGestureRecognizer*)sender
{
    [self infoCloseAnimation];
}



-(void)infoCloseAnimation
{
    if(IS_IPHONE_5)
    {
        [UIView animateWithDuration:0.2 delay:0
                            options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear
                         animations:^{
                             [viewManuoptions setFrame:CGRectMake(0, 568, 320, 568)];
                             [self.view bringSubviewToFront:viewManuoptions];
                         }
                         completion:NULL];
    }
    
    else
    {
        [UIView animateWithDuration:0.2 delay:0
                            options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear
                         animations:^{
                             [viewManuoptions setFrame:CGRectMake(0, 480, 320, 480)];
                             [self.view bringSubviewToFront:viewManuoptions];
                         }
                         completion:NULL];
    }
}




-(void)infoOpenAnimation
{
    if(IS_IPHONE_5)
    {
        [UIView animateWithDuration:0.2 delay:0
                            options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear
                         animations:^{
                             [viewManuoptions setFrame:CGRectMake(0, 0, 320, 568)];
                             [self.view bringSubviewToFront:viewManuoptions];
                         }
                         completion:NULL];
    }
    
    else
    {
        [UIView animateWithDuration:0.2 delay:0
                            options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear
                         animations:^{
                             [viewManuoptions setFrame:CGRectMake(0, 0, 320, 480)];
                             [self.view bringSubviewToFront:viewManuoptions];
                         }
                         completion:NULL];
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

@end

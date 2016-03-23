//
//  trendsDetailsViewController.h
//  Placeley
//
//  Created by APR on 12/17/13.
//  Copyright (c) 2013 APR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "trendsDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Aggregation.h"
#import "Facebook.h"
#import "Twitter.h"
#import "Instagram.h"
#import "Foursquare.h"
#import "TwitterHandlerdate.h"
#import "TwitterHashTagsdate.h"
#import "Wikipedia.h"
#import "YelpUserProfile.h"
#import "Yelp.h"
#import "TweetHashTagsView.h"
#import "TweetHandlerView.h"
#import "YelpUserProfileView.h"

#import "AsyncImageView.h"

#import "ShowDetail.h"


#import "InfinitePagingView.h"

#import "LocalTrendsViewController.h"

#import "FAFancyMenuView.h"

#import "HMSideMenu.h"

#import "FHSTwitterEngine.h"
#import "FBFunLoginDialog.h"
#import <MessageUI/MessageUI.h>

#import "ActivityFeedView.h"
#import "FollowingView.h"
#import "Followings.h"
#import "infoPageVC.h"


#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>

@class LocalTrendsViewController;

typedef enum
{
    kABAuthStatusNotDetermined = 0,
    kABAuthStatusRestricted,
    kABAuthStatusDenied,
    kABAuthStatusAuthorized,
    kABAuthStatusPending,
}AddressBookAuthStatus;


typedef void (^AddressbookRequestHandler)(ABAddressBookRef addressBookRef, BOOL available);


@interface trendsDetailsViewController : UIViewController<UIScrollViewDelegate,InfinitePagingViewDelegate,UIGestureRecognizerDelegate,FAFancyMenuViewDelegate,UIAlertViewDelegate,FHSTwitterEngineAccessTokenDelegate,UIWebViewDelegate,FBFunLoginDialogDelegate,MFMailComposeViewControllerDelegate,UITextFieldDelegate,UIDocumentInteractionControllerDelegate>
{
     AddressBookAuthStatus status;
    
    
    LocalTrendsViewController *objLocalTrendsViewController;
    
    
    NSString *placeId;
    
    NSString *placeName;
    
    NSMutableArray *allaggregationsArray;
    
    ShowDetail *trendDetail;
    
    int pageIndex;
    
    IBOutlet AsyncImageView *detailProfileImgView;

    IBOutlet AsyncImageView *detailLogoImgView;

    AsyncImageView *asyImgView;
    
    AsyncImageView *asyInstagramImgView;
    
    NSString *facebookUrl;
    NSString *yelpUrl;
    NSString *twitterUrl;
    NSString *instagramUrl;
    NSString *foursquareUrl;
    NSString *wikiUrl;
    
    int tempHeight;
    int socialViewgap;
    
    NSMutableArray *bottomIconsNumber;
    
    InfinitePagingView *pagingView;
    
    IBOutlet UIButton *twitterPageButton;
    //====================
    
    IBOutlet UIView *menuView;

    UITapGestureRecognizer *TapOn_InstrgarmImages;

    
    
    //====================
    
    UISwipeGestureRecognizer *SwipeFromTrendsDetailsVC;
    
    CLLocationCoordinate2D currentLocation;
    
    CLLocationCoordinate2D destLocation;
    
    BOOL isInitialLoad;
    
    BOOL shareIsVisible;
    
    NSMutableArray *shareOptionArray;
    
    NSMutableArray *selectedIndexPaths;
    
    UIWebView* mywebview;
    
    UIButton *_loginButton;
    FBFunLoginDialog *_loginDialog;
    UIView *_loginDialogView;
    UIWebView *_webView;
    NSString *_accessToken;
    NSDate *expiryDate;
    int count;
    NSDateFormatter *dateFormat;
    
    NSString *selectedTrend;
    
    //========================= Activity View Objects=================
    
    IBOutlet UIScrollView *scrolViewMainActivity;
    
    UITextField *selectedTextField;
    
    NSMutableArray *allactivityFeedsArray;

    //=========== FollowingView Objects===================
    IBOutlet UIScrollView *scrolViewMainFollowing;
    NSMutableArray *allFollowingsArray;

    IBOutlet UIView *trendDetailView;
    
    int selectedOption;
    
    UIImage* shareimage;
    
    NSString *shareText;
    
    NSString *shareLink;
    
    NSString *postType;
    
    UIImageView *imgNodata;
    
    IBOutlet UIView *viewManuoptions;
    IBOutlet UIButton *btnInfoPage;
    infoPageVC *objinfoPageVC;
}

-(void)performLikeInBackground;

@property int selectedOption;

@property (nonatomic , retain) IBOutlet UIView *trendDetailView,*viewInstgramLargeImg;

@property (nonatomic , retain) NSString *selectedTrend;

@property (retain) IBOutlet UIButton *loginButton;
@property (retain) FBFunLoginDialog *loginDialog;
@property (retain) IBOutlet UIView *loginDialogView;
@property (retain) IBOutlet UIWebView *webView;
@property (copy) NSString *accessToken;
@property (copy) NSDate *expiryDate;



@property (nonatomic, assign) BOOL menuIsVisible;
@property (nonatomic, strong) HMSideMenu *sideMenu;

@property (nonatomic , retain) IBOutlet UIView *fancyContainer;

@property (nonatomic, strong) FAFancyMenuView *menu;

@property CLLocationCoordinate2D currentLocation;

@property CLLocationCoordinate2D destLocation;

//===== Details page objects=====
@property(nonatomic,strong) NSString *placeId;

@property(nonatomic,strong) NSString *placeName;


@property(nonatomic,strong)IBOutlet AsyncImageView *detailProfileImgView;
@property(nonatomic,strong)IBOutlet AsyncImageView *detailLogoImgView;
@property(nonatomic,strong)IBOutlet UIScrollView *scrllViewMain;
@property(nonatomic,strong)IBOutlet UIScrollView *detailScrollView;
@property(nonatomic,strong)IBOutlet UIScrollView *scrllViewAddtionalimg;

@property(nonatomic,strong) IBOutlet UIView *viewFollowins;
@property(nonatomic,strong) IBOutlet UIView *viewActivity;
@property(nonatomic,strong) IBOutlet UIView *viewSocial;

@property(nonatomic,strong) IBOutlet UIImageView *imgTrendsMain;
@property(nonatomic,strong) IBOutlet AsyncImageView *imgLogo;
@property(nonatomic,strong) IBOutlet UIImageView *imgIcon;
@property(nonatomic,strong) IBOutlet UIImageView *imgTrendsAdditional;
@property(nonatomic,strong)IBOutlet UIImageView *imgOpenCloseTop,*imgOpenCloseTopBand;


@property(nonatomic,strong) IBOutlet UILabel *lblTrendTittle;
@property(nonatomic,strong) IBOutlet UILabel *lblTrendAddress;
@property(nonatomic,strong) IBOutlet UILabel *lblTrendFollower;
@property(nonatomic,strong) IBOutlet UILabel *lblTrendBuddies;
@property(nonatomic,strong) IBOutlet UILabel *lblTrendThumpsup;
@property(nonatomic,strong) IBOutlet UILabel *lblTrendSubTittle;
@property(nonatomic,strong) IBOutlet UILabel *lblTrendSubAddress;
@property(nonatomic,strong) IBOutlet UILabel *lblOpenBetween;

@property(nonatomic,strong) IBOutlet UILabel *lblAdditionalPreName;
@property(nonatomic,strong) IBOutlet UILabel *lblAdditionalAddress;

@property(nonatomic,strong) IBOutlet UIButton *btnFollowing;
@property(nonatomic,strong) IBOutlet UIButton *btnLike;
@property(nonatomic,strong) IBOutlet UIButton *btnShare;
@property(nonatomic,strong) IBOutlet UIButton *btnDeals;
@property(nonatomic,strong) IBOutlet UIButton *btnActivity;
@property(nonatomic,strong) IBOutlet UIButton *btnSocial;

@property(nonatomic,strong) IBOutlet UIButton *btnFBicon,*btnYelpicon,*btnInsticon;
@property(nonatomic,strong) IBOutlet UIButton *btnFeqicon,*btnTwitticon,*btnWikiicon;




@property(nonatomic,strong) IBOutlet UIView *instagramView;
@property(nonatomic,strong) IBOutlet UIView *yelpView;
@property(nonatomic,strong) IBOutlet UIView *yelpBottomView;
@property(nonatomic,strong) IBOutlet UIView *yelpContentView;
@property(nonatomic,strong) IBOutlet UIView *facebookView;
@property(nonatomic,strong) IBOutlet UIView *foursquareView;
@property(nonatomic,strong) IBOutlet UIView *twitterView;
@property(nonatomic,strong) IBOutlet UIView *twitterHashTagsView;
@property(nonatomic,strong) IBOutlet UIView *wikiView;
@property(nonatomic,strong) IBOutlet UIView *bottomSocialIconBar;

@property(nonatomic,strong) IBOutlet UIButton *twitterPageButton;

@property(nonatomic,strong) IBOutlet UIView *topBandView;
@property(nonatomic,strong) IBOutlet UIView *topBandMessageView;
@property(nonatomic,strong) IBOutlet UILabel *topBandPreName;
@property(nonatomic,strong) IBOutlet UILabel *topBandAddress;
@property(nonatomic,strong) IBOutlet AsyncImageView *topBandLogoImage;

@property(nonatomic,strong) IBOutlet UILabel *topActivityName;
@property(nonatomic,strong) IBOutlet UILabel *topDetailOf;

-(IBAction)btnDeals_Clicked:(id)sender;
-(IBAction)btnActivity_Clicked:(id)sender;
-(IBAction)btnSocial_Clicked:(id)sender;
-(IBAction)back_clicked:(id)sender;


//============Social page objects======Instgram=========

@property(nonatomic,strong)IBOutlet UIScrollView *scrllViewInstgram;

-(IBAction)btnInstgramPage_Clicked:(id)sender;


//======================Yelp===============
@property(nonatomic,strong)IBOutlet UILabel *lblYelpChat;
@property(nonatomic,strong)IBOutlet UILabel *lblYelpChatPersonName;
@property(nonatomic,strong)IBOutlet UILabel *lblYelpChatPersonAddress;

@property(nonatomic,strong)IBOutlet UIImageView *imgYelpIcon;
@property(nonatomic,strong)IBOutlet UIScrollView *scrllViewYelpChat;


-(IBAction)btnYelpPage_Clicked:(id)sender;

//====================Facebook====================

@property(nonatomic,strong)IBOutlet UILabel *lblFbTalkingabt;
@property(nonatomic,strong)IBOutlet UILabel *lblFbTotalLikes;
@property(nonatomic,strong)IBOutlet UILabel *lblFbVisited;
@property(nonatomic,strong)IBOutlet UILabel *lblFbTotalcheckins;

-(IBAction)btnFBPage_Clicked:(id)sender;

//====================Foursquare====================

@property(nonatomic,strong)IBOutlet UILabel *lblFqsPopularity;
@property(nonatomic,strong)IBOutlet UILabel *lblFqsHerenow;
@property(nonatomic,strong)IBOutlet UILabel *lblFqsTotalVisiters;
@property(nonatomic,strong)IBOutlet UILabel *lblFqsTotalcheckin;

-(IBAction)btnFqsPage_Clicked:(id)sender;

//==========================Twitter=============

@property(nonatomic,strong)IBOutlet UILabel *lblTweets;
@property(nonatomic,strong)IBOutlet UILabel *lblTwittFollowing;
@property(nonatomic,strong)IBOutlet UILabel *lblTwittFollowers;
@property(nonatomic,strong)IBOutlet UILabel *lblTweetsShopDetails;

@property(nonatomic,strong)IBOutlet UIView *viewTopBorder;
@property(nonatomic,strong)IBOutlet UIView *viewInstgramBorder;



@property(nonatomic,strong)IBOutlet UIButton *btnAtTweets;
@property(nonatomic,strong)IBOutlet UIButton *btnHashTweets;

@property(nonatomic,strong)IBOutlet TweetHandlerView *tweetHandlerView;
@property(nonatomic,strong)IBOutlet UIScrollView *scrllViewTweets;
@property(nonatomic,strong)IBOutlet UIScrollView *scrllViewTweetHashtags;
@property(nonatomic,strong)IBOutlet TweetHashTagsView *tweetHashTagsView;

-(IBAction)btnAtTwittesShopName_Clicked:(id)sender;
-(IBAction)btnHashTwittesShopName_Clicked:(id)sender;


-(IBAction)btnTwitterPage_Clicked:(id)sender;

//======================Wikipedia=================

@property(nonatomic,strong)IBOutlet UIWebView *webViewWikiContent;

-(IBAction)btnWikipediaPage_Clicked:(id)sender;

//===============================================


#pragma mark Social button actions

-(IBAction)Instgram_Clicked:(id)sender;
-(IBAction)Yelp_Clicked:(id)sender;
-(IBAction)Facebook_Clicked:(id)sender;
-(IBAction)Foursquare_Clicked:(id)sender;
-(IBAction)Twitter_Clicked:(id)sender;
-(IBAction)Wikipedia_Clicked:(id)sender;


-(IBAction)btnAtHashTagTweets:(id)sender;
-(IBAction)btnAtHandlerTweets:(id)sender;


#pragma mark Fetch date from server

-(void)fetchDetailDataFromServer;
-(void)fetchAggregationDataFromServer;
-(void)setActivityFeedAfterFetchingFromServer;



#pragma mark set date after fetching from server

-(void)setDataAfterFetchingFromServer;

-(IBAction)shareClicked:(id)sender;

-(void)sendEmail;

- (IBAction)loginFBButtonTapped:(id)sender;

-(void)uploadText;

-(void)uploadPhoto;

- (void)postTweet;

- (void)loginOAuth;

-(IBAction)btnShowAllCommentsClicked:(id)sender;

-(IBAction)btnPostCommentsClicked:(id)sender;

-(IBAction)btnFollowClicked:(UIButton *)sender;

-(IBAction)btnLikeClicked:(UIButton *)sender;

#pragma WatsApp==============================

@property(nonatomic,retain) UIDocumentInteractionController *documentationInteractionController;

- (void)launchWhatsAppWithMessage;

- (void)launchWhatsAppwithImage;

- (void) requestAddressBookWithCompletionHandler:(AddressbookRequestHandler)handler;
- (AddressBookAuthStatus) addressBookAuthLevel;

-(void)downloadImage:(NSString *)urlString;

-(IBAction)btnPlaceNameClickedInActivity:(UIButton *)sender;

@end



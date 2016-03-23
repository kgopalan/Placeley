//
//  LocalTrendsViewController.h
//  Test
//
//  Created by Rajesh on 18/12/13.
//  Copyright (c) 2013 Rajesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>

#import "LocalTrendscustomCell.h"
#import "AppDelegate.h"
#import "ServiceHelper.h"
#import "MenuViewController.h"

#import "TrendsData.h"

#import "MapViewController.h"
#import "FilterCell.h"

#import "InfinitePagingView.h"

#import "PlaceleyConstants.h"

#import "CategoryFilterViewController.h"
#import "CategoryFilterGlobalVC.h"
#import "FAFancyMenuView.h"
#import "infoPageVC.h"

@class ServiceHelper;
@class MenuViewController;
@class SPGooglePlacesAutocompleteQuery;
@class CategoryFilterGlobalVC;
@class MapViewController;


@interface LocalTrendsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,UISearchBarDelegate,UISearchDisplayDelegate,filterOptionDelegate,UIGestureRecognizerDelegate,FAFancyMenuViewDelegate,UITextFieldDelegate,filterOptionGlobalDelegate>
{
    NSMutableArray *arr_Trends;
    
    NSMutableArray *arr_FilterSearch;
    
    NSMutableArray *globalCategoryname;
    
    NSMutableArray *searchResultPlaces;
    
    SPGooglePlacesAutocompleteQuery *searchQuery;
    
    BOOL shouldBeginEditing;
    BOOL didFindLocation;

    
    CLLocationManager *locationManager;
    
    NSString *latitude,*longitude;

    
    
    NSString *strTableCheck;
    
    MapViewController *obj_MapVC;
    CategoryFilterViewController *objCategoryFilterViewController;
    CategoryFilterGlobalVC *objCategoryFilterGlobalVC;
    MenuViewController *objMenuViewController;
    
    

    
    
    IBOutlet UIView *menuView;
    
    IBOutlet UIView *filterOptionView;
    
    BOOL isFilterPopUpVisible;
    
    BOOL isSearching;
    
    
    IBOutlet UISearchBar *searchBar;
    
    NSString *strFilterName;
    NSString *strGlobalFilterName;
    NSString *strGlobalFilterCity;
    NSString *Alertmsg;

    
    ServiceHelper *downloads;
    
    NSMutableArray *urls;
    
    NSMutableArray *finalallTrends;
    
    UISearchDisplayController *searchDisplayController;

    //====================
    IBOutlet UIButton *btnInfoPage;
    infoPageVC *objinfoPageVC;
    
    IBOutlet UIView *viewManuoptions;
}

@property (nonatomic, strong) NSString *strSelectedVC;


@property BOOL didFindLocation;

@property (nonatomic , retain) IBOutlet UIView *fancyContainer;

@property (nonatomic, strong) FAFancyMenuView *menu;

@property (nonatomic , retain) NSString *latitude,*longitude;

@property(nonatomic,strong) IBOutlet UIView *menuView;

@property(nonatomic,strong) IBOutlet UIView *filterOptionView;

@property(nonatomic,strong) IBOutlet UIView *filterOptionViewGlobal;
@property(nonatomic,strong) IBOutlet UIImageView *imgViewBg;


@property(nonatomic,strong) IBOutlet UITableView *tbleViewLocalTrendsList ,*m_searchTableView;

@property(nonatomic,strong) IBOutlet UISearchBar *searchBar;


@property(nonatomic,strong) IBOutlet UILabel *lblFiltername,*lblTrendTitle;

@property(nonatomic,strong) IBOutlet UIButton *btnFilter,*btnMap,*btnLocal,*btnGlobal;

@property(nonatomic,retain) NSArray * arrLocalTrendFilter,*arrTrendsAddress,*arrTrendsicon;
@property(nonatomic,strong)IBOutlet UIButton *btnFilterClose;


//================Filter objects=====================

@property(nonatomic,strong)IBOutlet UITableView *tbleViewFilterLocal;
@property(nonatomic,strong) IBOutlet UITableView *tbleViewFilterGlobalCity,*tbleViewFilterGlobalCat;



-(void)showErrorAlert:(NSString *)message;

-(void)loadInfiniteScrollingDataForGlobal;

-(IBAction)nearMeBtnClicked:(id)sender;

@end

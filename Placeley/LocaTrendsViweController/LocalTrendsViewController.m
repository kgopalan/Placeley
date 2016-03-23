//
//  LocalTrendsViewController.m
//  Test
//
//  Created by Rajesh on 18/12/13.
//  Copyright (c) 2013 Rajesh. All rights reserved.
//

#import "LocalTrendsViewController.h"
#import "InfinitePagingView.h"
#import "SPGooglePlacesAutocomplete.h"
#import "SettingsViewController.h"




@interface LocalTrendsViewController ()

@end
@interface LocalTrendsViewController ()
{
    SettingsViewController *objsettingsViewController;
}
@end

@implementation LocalTrendsViewController
@synthesize tbleViewLocalTrendsList=_tbleViewLocalTrendsList;
@synthesize imgViewBg;


@synthesize arrTrendsAddress=_arrTrendsAddress;
@synthesize arrTrendsicon=_arrTrendsicon;
@synthesize arrLocalTrendFilter=_arrLocalTrendFilter;

@synthesize btnFilter,btnGlobal,btnLocal,btnMap;
@synthesize lblFiltername;
@synthesize searchBar=_searchBar;

@synthesize lblTrendTitle=_lblTrendTitle;

@synthesize menuView;
@synthesize filterOptionView;
@synthesize btnFilterClose;

@synthesize filterOptionViewGlobal=_filterOptionViewGlobal;
@synthesize latitude,longitude;
//========== FILTER===========

@synthesize tbleViewFilterGlobalCat,tbleViewFilterGlobalCity,tbleViewFilterLocal;

@synthesize m_searchTableView = _m_searchTableView;

@synthesize fancyContainer;
@synthesize didFindLocation;
@synthesize strSelectedVC;


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
    
/*
    UIView *transparentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    transparentView.backgroundColor = [UIColor blackColor];
    transparentView.alpha = 0.5;
    [fancyContainer addSubview:transparentView];

    
    NSArray *images = @[[UIImage imageNamed:@"menutrends.png"],[UIImage imageNamed:@"menuactivity.png"],[UIImage imageNamed:@"menufollowing.png"],[UIImage imageNamed:@"menusettings.png"]];
    
    

    self.menu = [[FAFancyMenuView alloc] init];
    self.menu.delegate = self;
    self.menu.buttonImages = images;
    [fancyContainer addSubview:self.menu];
   fancyContainer.hidden = YES;
    */
    
    //===========================================
    [self.view addSubview:viewManuoptions];
    if (IS_IPHONE_5)
    {
        btnInfoPage.frame=CGRectMake(257, 524, 30, 30);
        
        viewManuoptions.frame=CGRectMake(0, 568, 320, 568);
    }
    else
    {
        btnInfoPage.frame=CGRectMake(257, 440, 30, 30);
        
        viewManuoptions.frame=CGRectMake(0, 480, 320, 480);
    }
    
    UILongPressGestureRecognizer *longPressonView=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressonView:)];
    longPressonView.minimumPressDuration=1.0;
    [self.view addGestureRecognizer:longPressonView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureCloseMenus:)];
    [viewManuoptions addGestureRecognizer:tapGesture];
    
    btnInfoPage.layer.borderWidth = 1.f;
    btnInfoPage.layer.borderColor =[[UIColor whiteColor]CGColor];
    btnInfoPage.layer.cornerRadius = 12.0;
    
    //===========================================


    self.searchBar.tintColor = [UIColor blueColor];
    isSearching = NO;
    isFilterPopUpVisible = NO;
    self.filterOptionView.hidden = YES;
    self.filterOptionViewGlobal.hidden=YES;
    
    self.searchBar.hidden=YES;
   [self.searchBar setBackgroundImage:[UIImage imageNamed:@"searchBG.png"]];
    
    for (UIView *view in searchBar.subviews){
    if ([view isKindOfClass: [UITextField class]]) {
        UITextField *tf = (UITextField *)view;
            tf.delegate = self;
            break;
        }
    }

   [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];

    searchQuery = [[SPGooglePlacesAutocompleteQuery alloc] initWithApiKey:@"AIzaSyCt8IKg7esxwHHInbdcRmecVcZLPTy5a4o"];
    
    self.searchDisplayController.searchBar.placeholder = @"Search or Address";
    
    self.m_searchTableView.hidden = YES;
    
    
//    self.latitude = @"12.982672";
//    self.longitude = @"80.263380";

    NSLog(@"strLongitude View===%@",self.longitude);
    
    NSLog(@"strLatitude View ===%@",self.latitude);
    
    
    arr_Trends=[[NSMutableArray alloc]init];
    arr_FilterSearch=[[NSMutableArray alloc]init];
    
    strGlobalFilterName=@"all";
    strFilterName=@"all";

   self.tbleViewLocalTrendsList.hidden=YES;
    [btnLocal setImage:[UIImage imageNamed:@"local_blue.png"] forState:UIControlStateNormal];
    [btnGlobal setImage:[UIImage imageNamed:@"global_white.png"] forState:UIControlStateNormal];
    
    if (IS_IPHONE_5)
    {
        [self.tbleViewLocalTrendsList setFrame:CGRectMake(0, 106,320, 467)];
    }
    else
    {
        [self.tbleViewLocalTrendsList setFrame:CGRectMake(0, 106,320, 385)];
    }
    
    //[self getLocalTrendsData];
  
    strTableCheck=@"Local";
    [self startFindLocation];
    
    
    
    // for ios 7
    [self setNeedsStatusBarAppearanceUpdate];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        UIColor *searchBarColor = [UIColor blueColor];
        self.searchBar.backgroundColor = searchBarColor;
    }
    //====================
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)startFindLocation
{
    self.didFindLocation=NO;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

/*
- (void)fancyMenu:(FAFancyMenuView *)menu didSelectedButtonAtIndex:(NSUInteger)index{
    NSLog(@"Selected index====>%i",index);
    switch (index)
    {
        case 0:
            [self getLocalTrendsData];
            break;
        case 1:
        {
            trendsDetailsViewController *trendsDetailsVC_obj=[[trendsDetailsViewController alloc]initWithNibName:@"trendsDetailsViewController" bundle:nil];
            trendsDetailsVC_obj.selectedOption = 2;
            [self.navigationController pushViewController:trendsDetailsVC_obj animated:YES];
        }
            break;
        case 2:
        {
            trendsDetailsViewController *trendsDetailsVC_obj=[[trendsDetailsViewController alloc]initWithNibName:@"trendsDetailsViewController" bundle:nil];
            trendsDetailsVC_obj.selectedOption = 3;
            [self.navigationController pushViewController:trendsDetailsVC_obj animated:YES];
        }
            break;
        case 3:
           //[self nearMeTrendsList];
           // NSLog(@"nearMeTrendsList");
            
            [self puthToSettingsVC];
            NSLog(@"puthToSettingsVC");
            
            break;
        case 4:
            //[self puthToSettingsVC];
            //NSLog(@"puthToSettingsVC");

            break;

        default:
            break;
    }
    [self.menu hide];
}
*/


-(IBAction)btnTrends_Clicked:(id)sender
{
    viewManuoptions.hidden=YES;
    [self getLocalTrendsData];
    
    
}
-(IBAction)btnFollowing_Clicked:(id)sender
{
    viewManuoptions.hidden=YES;
    
    trendsDetailsViewController *trendsDetailsVC_obj=[[trendsDetailsViewController alloc]initWithNibName:@"trendsDetailsViewController" bundle:nil];
    trendsDetailsVC_obj.selectedOption = 3; // Following
    [self.navigationController pushViewController:trendsDetailsVC_obj animated:YES];
    
}

-(IBAction)btnActivity_Clicked:(id)sender
{
    viewManuoptions.hidden=YES;
    trendsDetailsViewController *trendsDetailsVC_obj=[[trendsDetailsViewController alloc]initWithNibName:@"trendsDetailsViewController" bundle:nil];
    trendsDetailsVC_obj.selectedOption = 2; // activity
    [self.navigationController pushViewController:trendsDetailsVC_obj animated:YES];
    
}

-(IBAction)btnSettings_Clicked:(id)sender
{
    viewManuoptions.hidden=YES;
    [self puthToSettingsVC];
}


-(void)puthToSettingsVC
{
   objsettingsViewController=[[SettingsViewController alloc]initWithNibName:@"SettingsViewController" bundle:nil];
   [self.navigationController pushViewController:objsettingsViewController animated:YES];
}

-(IBAction)btnBack_Clicked:(id)sender
{
    objMenuViewController=[[MenuViewController alloc]initWithNibName:@"MenuViewController" bundle:nil];
    [self.navigationController pushViewController:objMenuViewController animated:YES];

    
//    for (UIViewController *viewcontroller in [self.navigationController viewControllers])
//    {
//        if ([viewcontroller isKindOfClass:[MenuViewController class]])
//        {
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }
}



-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"selectedTrend====%@",strSelectedVC);
    if ([strSelectedVC isEqualToString:@"Trendings"])
    {
        [self getLocalTrendsData];
    }
    if ([strSelectedVC isEqualToString:@"NearMe"])
    {
        //[self nearMeTrendsList];
    }
    
}

-(IBAction)btnFilter_Clicked:(id)sender
{
    if ([strTableCheck isEqualToString:@"Local"] || [strTableCheck isEqualToString:@"NearMe"])
    {
        objCategoryFilterViewController=[[CategoryFilterViewController alloc]init];
        
        objCategoryFilterViewController.delegate = self;
        [self.view addSubview:objCategoryFilterViewController.view];
        [objCategoryFilterViewController FilterOpenViewAnimations];
        
    }
    if ([strTableCheck isEqualToString:@"Global"])
    {
        objCategoryFilterGlobalVC=[[CategoryFilterGlobalVC alloc]init];
        objCategoryFilterGlobalVC.delegate = self;
        [self.view addSubview:objCategoryFilterGlobalVC.view];
        [objCategoryFilterGlobalVC FilterOpenViewAnimations];
        [objCategoryFilterGlobalVC getGlobalCity];
        
    }
}

#pragma mark -- Local Filter option method start==========================================

- (void)filterOptionSelected:(NSString *)categoryName
{
    NSString *strReplacing=[categoryName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSString *strLower=[strReplacing lowercaseString];
    strFilterName=strLower;
    
    NSLog(@"strFilterName===%@",strFilterName);
}

-(void)getLocalFilterData
{
    self.tbleViewLocalTrendsList.hidden=YES;

    [AppDelegate performSelector:@selector(activeIndicatorStartAnimating:) withObject:self.view afterDelay:0.2];
    
    self.view.userInteractionEnabled = NO;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),  ^{
        
        NSArray *getLocalFilterList = [ServiceHelper getLocalFilterListWithLatLong:latitude Longitude:longitude LocalFilterName:strFilterName];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self loadLocalFilterData:getLocalFilterList];
        });
    });
}

- (void)loadLocalFilterData:(NSArray *)arr_localFilter
{
    [arr_Trends removeAllObjects];

    [arr_Trends addObjectsFromArray:arr_localFilter];

    if ([arr_Trends count] > 0)
        self.tbleViewLocalTrendsList.hidden=NO;
    else
        [self showErrorAlert:@"No data available"];
    
    [self.tbleViewLocalTrendsList reloadData];
    
    [AppDelegate performSelector:@selector(activeIndicatorStopAnimating) withObject:nil];
    
    self.view.userInteractionEnabled = YES;
}

-(void)FilterDone
{
    NSLog(@"FilterDone");
    
    if ([strTableCheck isEqualToString:@"Local"])
    {
        [self getLocalFilterData];
    }
    else
    {
        [self getNearFilterData];
    }
}


#pragma mark -- Filter option method end==========================================


#pragma mark -- Global Filter option method start==========================================

- (void)filterOptionSelectedCategory:(NSString *)GlobalcategoryName
{
    NSString *strReplacing=[GlobalcategoryName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSString *strLower=[strReplacing lowercaseString];
    strGlobalFilterName=strLower;
    NSLog(@"strGlobalFilterName = %@",strGlobalFilterName);
}
-(void)filterOptionSelectedCity:(NSString *)GlobalCityName
{
    NSString *strReplacing=[GlobalCityName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSString *strLower=[strReplacing lowercaseString];
    strGlobalFilterCity=strLower;
    
    NSLog(@"strGlobalFilterCity = %@",strGlobalFilterCity);
    
}
-(void)getGlobalTrendsDataFilter
{
    self.tbleViewLocalTrendsList.hidden=YES;

    [AppDelegate performSelector:@selector(activeIndicatorStartAnimating:) withObject:self.view afterDelay:0.2];
    
    self.view.userInteractionEnabled = NO;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),  ^{
        
        NSArray *globalTrendsList = [ServiceHelper getGlobalFilterList:strGlobalFilterName GlobalCity:strGlobalFilterCity];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self loadGlobalTrendsDataFilter:globalTrendsList];
        });
    });
}

- (void)loadGlobalTrendsDataFilter:(NSArray *)globaltrendFilter_Array
{
    [arr_Trends removeAllObjects];
    [arr_Trends addObjectsFromArray:globaltrendFilter_Array];
    if ([arr_Trends count] > 0)
        self.tbleViewLocalTrendsList.hidden=NO;
    else
        [self showErrorAlert:@"No data available"];
    
    [self.tbleViewLocalTrendsList reloadData];
    
    [AppDelegate performSelector:@selector(activeIndicatorStopAnimating) withObject:nil];
    
    self.view.userInteractionEnabled = YES;
}

-(void)filterDoneGlobal
{
    NSLog(@"globalFilterDone");
    [self getGlobalTrendsDataFilter];
    
    
}


#pragma mark --  Global Filter option method end==========================================



-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)getGlobalTrendsData
{
    BOOL checkConnection=[THIS checkReachability];
    
    if (checkConnection==YES)
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSData *arrayData = [userDefaults objectForKey:@"selectedPhotos"];
        NSLog(@"%@", [NSKeyedUnarchiver unarchiveObjectWithData:arrayData]);
        if ([NSKeyedUnarchiver unarchiveObjectWithData:arrayData] != nil)
        {
            [self loadGlobalTrendsData:[NSKeyedUnarchiver unarchiveObjectWithData:arrayData]];
        }
        else
        {
            NSLog(@"arr_Tresnds===>%d=====and Data====%@",[arr_Trends count],arr_Trends);
            
            self.tbleViewLocalTrendsList.hidden=YES;

            [AppDelegate performSelector:@selector(activeIndicatorStartAnimating:) withObject:self.view afterDelay:0.2];
          
            self.view.userInteractionEnabled = NO;
            
           // [self fetchglobalByMultipleQueries];

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),  ^{
                NSArray *globalTrendsList = [ServiceHelper getGlobalTrendsList];

                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([globalTrendsList count]>0)
                    {
                        [self loadGlobalTrendsData:globalTrendsList];
                    }
                });
            });
        }
    }
}



- (void)loadGlobalTrendsData:(NSArray *)globaltrend_Array
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:globaltrend_Array];
    [userDefaults setObject:arrayData forKey:@"selectedPhotos"];
    
    [arr_Trends removeAllObjects];
    [arr_Trends addObjectsFromArray:globaltrend_Array];
    if ([arr_Trends count] > 0)
        self.tbleViewLocalTrendsList.hidden=NO;
    else
        [self showErrorAlert:@"No data available"];
    
    [self.tbleViewLocalTrendsList reloadData];
    
    [AppDelegate performSelector:@selector(activeIndicatorStopAnimating) withObject:nil];
    
    self.view.userInteractionEnabled = YES;
}

-(IBAction)btnLocalTrends_Clicked:(id)sender
{
    shouldBeginEditing = NO;
    
    [btnLocal setImage:[UIImage imageNamed:@"local_blue.png"] forState:UIControlStateNormal];
    
    [btnGlobal setImage:[UIImage imageNamed:@"global_white.png"] forState:UIControlStateNormal];
    
    if (IS_IPHONE_5)
    {
        [self.tbleViewLocalTrendsList setFrame:CGRectMake(0, 106,320, 467)];
    }
    else
    {
        [self.tbleViewLocalTrendsList setFrame:CGRectMake(0, 106,320, 385)];
    }
    
    self.filterOptionView.hidden = YES;
    
    isFilterPopUpVisible = NO;

    strTableCheck=@"Local";
    
    [arr_Trends removeAllObjects];
    
    [_tbleViewLocalTrendsList reloadData];

  //  [self performSelector:@selector(fetchLocalByMultipleQueries) withObject:nil afterDelay:0.1];

     [self getLocalTrendsData];
}

-(IBAction)btnGlobalTrends_Clicked:(id)sender
{
    
    shouldBeginEditing = NO;
    
    [btnLocal setImage:[UIImage imageNamed:@"local_white.png"] forState:UIControlStateNormal];
    
    [btnGlobal setImage:[UIImage imageNamed:@"global_blue.png"] forState:UIControlStateNormal];
    
    if (IS_IPHONE_5)
    {
        [self.tbleViewLocalTrendsList setFrame:CGRectMake(0, 106,320, 467)];
    }
    else
    {
        [self.tbleViewLocalTrendsList setFrame:CGRectMake(0, 106,320, 385)];
    }

    [arr_Trends removeAllObjects];
    
    [_tbleViewLocalTrendsList reloadData];
    
   // [self performSelector:@selector(fetchglobalByMultipleQueries) withObject:nil afterDelay:0.1];

    self.filterOptionView.hidden = YES;
    
    isFilterPopUpVisible = NO;

    strTableCheck=@"Global";
    
    [self getGlobalTrendsData];
    
    //[self getGlobalTrendsDataFilter];

}

#pragma mark - Near Me Methods

-(IBAction)nearMeBtnClicked:(id)sender
{
    [self nearMeTrendsList];
}

-(void)nearMeTrendsList
{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    
//    NSData *arrayDataForLocal = [userDefaults objectForKey:@"selectedPhotosForNear"];
//    
//    NSLog(@"%@", [NSKeyedUnarchiver unarchiveObjectWithData:arrayDataForLocal]);
//    
//    if ([NSKeyedUnarchiver unarchiveObjectWithData:arrayDataForLocal] != nil)
//    {
//        [self loadNearMeTrendsData:[NSKeyedUnarchiver unarchiveObjectWithData:arrayDataForLocal]];
//    }
//    else
//    {
        strTableCheck=@"NearMe";
        
        self.tbleViewLocalTrendsList.hidden=YES;
        
        [AppDelegate performSelector:@selector(activeIndicatorStartAnimating:) withObject:self.view afterDelay:0.2];
        
        self.view.userInteractionEnabled = NO;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),  ^{
            
            NSArray *localTrendsList = [ServiceHelper getNearMeTrendListByLatandLong:self.latitude Longitude:self.longitude];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self loadNearMeTrendsData:localTrendsList];
            });
        });
    //}

}

-(void)getNearFilterData
{
    self.tbleViewLocalTrendsList.hidden=YES;

    [AppDelegate performSelector:@selector(activeIndicatorStartAnimating:) withObject:self.view afterDelay:0.2];
    
    self.view.userInteractionEnabled = NO;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),  ^{
        
        NSArray *getLocalFilterList = [ServiceHelper getLocalFilterListWithLatLong:latitude Longitude:longitude LocalFilterName:strFilterName];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self loadNearMeFilterData:getLocalFilterList];
        });
    });
}

- (void)loadNearMeTrendsData:(NSArray *)localtrend_Array
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSData *arrayDataForLocal = [NSKeyedArchiver archivedDataWithRootObject:localtrend_Array];
    
    [userDefaults setObject:arrayDataForLocal forKey:@"selectedPhotosForNear"];
    
    [arr_Trends removeAllObjects];
    
    [arr_Trends addObjectsFromArray:localtrend_Array];
    
    if ([arr_Trends count] > 0)
        self.tbleViewLocalTrendsList.hidden=NO;
    else
        [self showErrorAlert:@"No data available"];

    [self.tbleViewLocalTrendsList reloadData];
    
    [AppDelegate performSelector:@selector(activeIndicatorStopAnimating) withObject:nil];
    
    self.view.userInteractionEnabled = YES;
}

- (void)loadNearMeFilterData:(NSArray *)arr_localFilter
{
    [arr_Trends removeAllObjects];
    
    [arr_Trends addObjectsFromArray:arr_localFilter];
    
    if ([arr_Trends count] > 0)
        self.tbleViewLocalTrendsList.hidden=NO;
    else
        [self showErrorAlert:@"No data available"];
    
    [self.tbleViewLocalTrendsList reloadData];
    
    [AppDelegate performSelector:@selector(activeIndicatorStopAnimating) withObject:nil];
    
    self.view.userInteractionEnabled = YES;
}

-(IBAction)btnMap_Clicked:(id)sender
{
    obj_MapVC=[[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];

    obj_MapVC.locationDetailArray = [[NSMutableArray alloc] init];

    obj_MapVC.trendDataArray = [[NSMutableArray alloc] initWithArray:arr_Trends];
    
    obj_MapVC.selectedTrend = strTableCheck;
    
    for (int i = 0; i < [arr_Trends count]; i++)
    {
        TrendsData *globalTrendsObj=[arr_Trends objectAtIndex:i];
        
        NSLog(@"globalTrendsObj.locationLatLngGlobalList test====%@",globalTrendsObj.locationLatLngGlobalList);

        [obj_MapVC.locationDetailArray addObject:globalTrendsObj.locationLatLngGlobalList];
    }
    
    obj_MapVC.currentLocation= CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
    
    NSLog(@"obj_MapVC.locationDetailArray test====%@",obj_MapVC.locationDetailArray);

    [self.navigationController pushViewController:obj_MapVC animated:YES];
}


-(IBAction)btnSearch_Clicked:(id)sende
{
    self.lblTrendTitle.hidden=YES;
    
    self.searchBar.hidden=NO;
    
}

-(void)showViewWithAnimation:(CGRect)fromFrame toFrame:(CGRect)toFrame andHidden:(BOOL)hidden
{
    [self.filterOptionView setFrame:CGRectMake(fromFrame.origin.x, fromFrame.origin.y, fromFrame.size.width, fromFrame.size.height)];

    [UIView animateWithDuration:0.2 delay:0
                        options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.filterOptionView setFrame:CGRectMake(toFrame.origin.x, toFrame.origin.y, toFrame.size.width, toFrame.size.height)];
                     }
                     completion:^(BOOL finished){
                         if(hidden)
                             self.filterOptionView.hidden = hidden;
                     }];
}


#pragma mark - Tableview Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (shouldBeginEditing)
    {
        return [searchResultPlaces count];
    }
    else if (isSearching == NO)
    {
        return [arr_Trends count];
    }
    else if (isSearching == YES)
    {
        return [arr_FilterSearch count];
    }
   
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.tbleViewLocalTrendsList)
    {
        return 80;
    }
    else
    {
        return 32;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (shouldBeginEditing)
    {
        static NSString *cellIdentifier = @"SPGooglePlacesAutocompleteCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.font = [UIFont fontWithName:@"GillSans" size:16.0];
        
        id trendData = [self placeAtIndexPath:indexPath];
        
        if ([trendData isKindOfClass:[TrendsData class]])
        {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ @%@",((TrendsData *)trendData).formal_name,((TrendsData *)trendData).post_name];
        }
        else if ([trendData isKindOfClass:[SPGooglePlacesAutocompletePlace class]])
        {
            cell.textLabel.text = ((SPGooglePlacesAutocompletePlace *)trendData).name;
        }
        return cell;
    }
    else
    {
   
        LocalTrendscustomCell * cellTrends =(LocalTrendscustomCell *)[self.tbleViewLocalTrendsList dequeueReusableCellWithIdentifier:@"LocalTrendscustomCell"];
        
        if (cellTrends == nil)
        {
            cellTrends=[[[NSBundle mainBundle]loadNibNamed:@"LocalTrendscustomCell" owner:self options:nil]objectAtIndex:0];
            cellTrends.frame=CGRectMake(0, 0, 320, 80);
            
            UIView *selectionColor = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
            selectionColor.backgroundColor = [UIColor colorWithRed:(253/255.0) green:(195/255.0) blue:(156/255.0) alpha:1];
            cellTrends.selectedBackgroundView = selectionColor;
        }
        
        if (isSearching == NO)
        {
            TrendsData *TrendsObj=[arr_Trends objectAtIndex:indexPath.row];
            cellTrends.self.lblLocalTrendsTitle.text=[NSString stringWithFormat:@"%@",[TrendsObj formal_name]];
            cellTrends.self.lblLocalTrendsAddress.text=[NSString stringWithFormat:@"%@%@",@"@",[TrendsObj post_name]];
            NSString *imageUrl=[TrendsObj.logo_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"TrendsObj===%@",TrendsObj.likers_count);

            if (![imageUrl isEqualToString:@""])
            {
                NSURL *imagUrl = [NSURL URLWithString:imageUrl];
                cellTrends.asynImgView.layer.cornerRadius = 5.0;
                [cellTrends.asynImgView setBackgroundColor:[UIColor lightGrayColor]];
                cellTrends.asynImgView.layer.masksToBounds = YES;
                [cellTrends.asynImgView loadImageFromURL:imagUrl];
            }
            else
            {
                UIImageView *noImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 50)];
                [noImgView setImage:[UIImage imageNamed:@"pinBlue.png"]];
                noImgView.layer.cornerRadius = 5.0;
                noImgView.layer.masksToBounds = YES;
                [cellTrends.asynImgView  addSubview:noImgView];
            }
        }
         else if (isSearching == YES)
         {
             if ([arr_Trends count]>0)
             {
                 TrendsData *trendsFilterObj=[arr_FilterSearch objectAtIndex:indexPath.row];
                 
                 cellTrends.self.lblLocalTrendsTitle.text=[NSString stringWithFormat:@"%@",[trendsFilterObj formal_name]];
                 
                 cellTrends.self.lblLocalTrendsAddress.text=[NSString stringWithFormat:@"%@%@",@"@",[trendsFilterObj post_name]];
                 
                 NSLog(@"TrendsObj===%@",trendsFilterObj.likers_count);

                 NSString *imageUrl=[trendsFilterObj.logo_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                 if (![imageUrl isEqualToString:@""])
                 {
                     NSURL *imagUrl = [NSURL URLWithString:imageUrl];
                     //NSLog(@"imagUrl===%@",imagUrl);
                     cellTrends.asynImgView.layer.cornerRadius = 5.0;
                     [cellTrends.asynImgView setBackgroundColor:[UIColor lightGrayColor]];
                     cellTrends.asynImgView.layer.masksToBounds = YES;
                     [cellTrends.asynImgView loadImageFromURL:imagUrl];
                 }
                 else
                 {
                     UIImageView *noImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 50)];
                     [noImgView setImage:[UIImage imageNamed:@"pinBlue.png"]];
                     [cellTrends.asynImgView  addSubview:noImgView];
                     noImgView.layer.cornerRadius = 5.0;
                     noImgView.layer.masksToBounds = YES;

                 }
             }
         }
        return cellTrends;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (shouldBeginEditing)
    {
        id trendData = [self placeAtIndexPath:indexPath];
        
        if ([trendData isKindOfClass:[TrendsData class]])
        {
            TrendsData *TrendsObj=[arr_Trends objectAtIndex:indexPath.row];
            
            trendsDetailsViewController *trendsDetailsVC_obj=[[trendsDetailsViewController alloc]initWithNibName:@"trendsDetailsViewController" bundle:nil];
            
            trendsDetailsVC_obj.selectedOption = 1;

            trendsDetailsVC_obj.currentLocation= CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
            
            trendsDetailsVC_obj.destLocation= CLLocationCoordinate2DMake([[TrendsObj.locationLatLngGlobalList objectAtIndex:0] doubleValue], [[TrendsObj.locationLatLngGlobalList objectAtIndex:1] doubleValue]);
            
            trendsDetailsVC_obj.placeId = TrendsObj.id_trend;
            
            [self.navigationController pushViewController:trendsDetailsVC_obj animated:YES];
        }
        else if ([trendData isKindOfClass:[SPGooglePlacesAutocompletePlace class]])
        {
            NSMutableArray *currentGoogleAndReferenceIds = [[NSMutableArray alloc] init];

            [currentGoogleAndReferenceIds addObject:[self placeAtIndexPath:indexPath].identifier];
            
            [currentGoogleAndReferenceIds addObject:[self placeAtIndexPath:indexPath].reference];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),  ^{
                
                TrendsData *TrendsObj = (TrendsData *)[ServiceHelper createNewPlaceByGoogleandReferenceId:currentGoogleAndReferenceIds];
                
//                [self dismissSearchControllerWhileStayingActive];
//                
//                [self.searchDisplayController.searchResultsTableView deselectRowAtIndexPath:indexPath animated:NO];

              //  NSArray *getLocalFilterList = [ServiceHelper getLocalFilterListWithLatLong:latitude Longitude:longitude LocalFilterName:strFilterName];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                                        
                    trendsDetailsViewController *trendsDetailsVC_obj=[[trendsDetailsViewController alloc]initWithNibName:@"trendsDetailsViewController" bundle:nil];
                    
                    trendsDetailsVC_obj.selectedOption = 1;

                    trendsDetailsVC_obj.currentLocation= CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
                    trendsDetailsVC_obj.destLocation= CLLocationCoordinate2DMake([[TrendsObj.locationLatLngGlobalList objectAtIndex:0] doubleValue], [[TrendsObj.locationLatLngGlobalList objectAtIndex:1] doubleValue]);
                    
                    trendsDetailsVC_obj.placeId = TrendsObj.id_trend;
                    
                    [self.navigationController pushViewController:trendsDetailsVC_obj animated:YES];
                    
                    self.view.userInteractionEnabled = YES;
                });
            });

        }
    }
    else if (isSearching == NO)
    {
        TrendsData *TrendsObj=[arr_Trends objectAtIndex:indexPath.row];
        
        trendsDetailsViewController *trendsDetailsVC_obj=[[trendsDetailsViewController alloc]initWithNibName:@"trendsDetailsViewController" bundle:nil];
        
        trendsDetailsVC_obj.selectedOption = 1;

//        trendsDetailsVC_obj.currentLocation= CLLocationCoordinate2DMake(12.997822, 80.267556);
//        trendsDetailsVC_obj.destLocation= CLLocationCoordinate2DMake(13.061429, 80.248625);

        trendsDetailsVC_obj.currentLocation= CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
        trendsDetailsVC_obj.destLocation= CLLocationCoordinate2DMake([[TrendsObj.locationLatLngGlobalList objectAtIndex:0] doubleValue], [[TrendsObj.locationLatLngGlobalList objectAtIndex:1] doubleValue]);

        trendsDetailsVC_obj.placeId = TrendsObj.id_trend;
        
        [self.navigationController pushViewController:trendsDetailsVC_obj animated:YES];
    }
    else if (isSearching == YES)
    {
        TrendsData *trendsFilterObj=[arr_FilterSearch objectAtIndex:indexPath.row];
        
        trendsDetailsViewController *trendsDetailsVC_obj=[[trendsDetailsViewController alloc]initWithNibName:@"trendsDetailsViewController" bundle:nil];
        
        trendsDetailsVC_obj.selectedOption = 1;

        trendsDetailsVC_obj.currentLocation= CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
        trendsDetailsVC_obj.destLocation= CLLocationCoordinate2DMake([[trendsFilterObj.locationLatLngGlobalList objectAtIndex:0] doubleValue], [[trendsFilterObj.locationLatLngGlobalList objectAtIndex:1] doubleValue]);

        trendsDetailsVC_obj.placeId = trendsFilterObj.id_trend;

        NSLog(@"trendsDetailsVC_obj.placeId = %@",trendsDetailsVC_obj.placeId);

        NSLog(@"globalTrendsObj.id_trend = %@",trendsFilterObj.id_trend);
        
        [self.navigationController pushViewController:trendsDetailsVC_obj animated:YES];
    }
}

#pragma mark Filter Methods



-(IBAction)btn_Back_Clicked:(id)sender
{
   // [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark Map Current Location=========================


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
//    UIAlertView *errorAlert = [[UIAlertView alloc]
//                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    CLLocation *currentLocation = newLocation;
    
    if (!self.didFindLocation)
    {
        self.didFindLocation = YES;
        [locationManager stopUpdatingLocation];

       self.longitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        self.latitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        
//        self.latitude = @"12.982672";
//        self.longitude = @"80.263380";

        NSLog(@"strLongitude===%@",self.longitude);
        
        NSLog(@"strLatitude===%@",self.latitude);

      [self getLocalTrendsData];

       // [self performSelector:@selector(fetchLocalByMultipleQueries) withObject:nil afterDelay:0.1];

    }
    
   
}



- (void)getLocalTrendsData
{
//    BOOL checkConnection=[THIS checkReachability];
//    
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        
//        NSData *arrayDataForLocal = [userDefaults objectForKey:@"selectedPhotosForLocal"];
//        
//        NSLog(@"%@", [NSKeyedUnarchiver unarchiveObjectWithData:arrayDataForLocal]);
//        
//        if ([NSKeyedUnarchiver unarchiveObjectWithData:arrayDataForLocal] != nil)
//        {
//            [self loadLocalTrendsData:[NSKeyedUnarchiver unarchiveObjectWithData:arrayDataForLocal]];
//        }
//        else
//        {
            self.tbleViewLocalTrendsList.hidden=YES;
            
            NSLog(@"arr_Tresnds===>%d=====and Data====%@",[arr_Trends count],arr_Trends);
    
            [AppDelegate performSelector:@selector(activeIndicatorStartAnimating:) withObject:self.view afterDelay:0.2];
      
            self.view.userInteractionEnabled = NO;
        
           // [self fetchLocalByMultipleQueries];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),  ^{
            
            NSArray *localTrendsList = [ServiceHelper getLocalTrendListByLatandLong:[self checkForNull:self.latitude] Longitude:[self checkForNull:self.longitude]];

            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self loadLocalTrendsData:localTrendsList];
            });
        });
 
       // }
    
}

- (void)loadLocalTrendsData:(NSArray *)localtrend_Array
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSData *arrayDataForLocal = [NSKeyedArchiver archivedDataWithRootObject:localtrend_Array];
    
    [userDefaults setObject:arrayDataForLocal forKey:@"selectedPhotosForLocal"];
    
    [arr_Trends removeAllObjects];
    
    [arr_Trends addObjectsFromArray:localtrend_Array];
    
    if ([arr_Trends count] > 0)
        self.tbleViewLocalTrendsList.hidden=NO;
    else
        [self showErrorAlert:@"No data available"];

    [self.tbleViewLocalTrendsList reloadData];
    
    [AppDelegate performSelector:@selector(activeIndicatorStopAnimating) withObject:nil];
    
    self.view.userInteractionEnabled = YES;
}





//===================================================================

-(void)showErrorAlert:(NSString *)message
{
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Alert" message:message
                                                        delegate:self
                                               cancelButtonTitle:@"Ok."
                                               otherButtonTitles:nil];
    [errorAlert show];
    
}


-(NSMutableArray *)searchTrendsOnTable
{
    NSMutableArray *placeNameArray = [[NSMutableArray alloc] init];

    NSString *searchText=[[self searchBar] text];
    
    NSLog(@"searchText===%@",searchText);
    
    for (TrendsData *localtrends_obj in  arr_Trends )
    {
        NSLog(@"localtrends_obj.formal_name===%@",localtrends_obj.formal_name);

        NSRange range=[localtrends_obj.formal_name rangeOfString:searchText options:( NSCaseInsensitiveSearch)];
        NSRange range2=[localtrends_obj.post_name rangeOfString:searchText options:( NSCaseInsensitiveSearch)];
        NSRange range3=[localtrends_obj.city rangeOfString:searchText options:( NSCaseInsensitiveSearch)];
        if(range.location!=NSNotFound || range2.location!=NSNotFound ||range3.location!=NSNotFound )
        {
            [placeNameArray addObject:localtrends_obj];//[NSString stringWithFormat:@"%@ @%@",localtrends_obj.formal_name,localtrends_obj.post_name]];
        }
    }
    return placeNameArray;
}



#pragma mark - Search Bar Delegates

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    //isSearching = YES;
}



- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar1
{
   // [self searchTrendsOnTable];
    
    [searchBar1 resignFirstResponder];
    
}
-(void)searchBar:(UISearchBar *)searchBar1 textDidChange:(NSString *)searchText
{
    if (shouldBeginEditing)
    {
        if (![searchBar1 isFirstResponder]) {
            // User tapped the 'clear' button.
            shouldBeginEditing = NO;
            [self.searchDisplayController setActive:NO];
        }
    }
}


- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [self performSelector:@selector(searchBarCancelButtonClicked:) withObject:self.searchBar afterDelay: 0.1];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchbar
{
    shouldBeginEditing = NO;
    self.m_searchTableView.hidden = YES;

    [searchbar resignFirstResponder];
    searchbar.text=@"";
    [arr_FilterSearch removeAllObjects];
    [arr_FilterSearch addObject:arr_Trends];
    
    if ([arr_FilterSearch count] > 0)
        self.tbleViewLocalTrendsList.hidden=NO;
    else
        [self showErrorAlert:@"No data available"];

    [self.tbleViewLocalTrendsList reloadData];
    self.lblTrendTitle.hidden=NO;
    self.searchBar.hidden=YES;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchLocalByMultipleQueries
{
    finalallTrends = [[NSMutableArray alloc] init];
    
   /* urls = [NSMutableArray arrayWithObjects:
            @"http://zuppl.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=1&perPage=2",
            @"http://zuppl.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=2&perPage=2",
            @"http://zuppl.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=3&perPage=2",
            @"http://zuppl.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=4&perPage=2",
            @"http://zuppl.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=5&perPage=2",
            @"http://zuppl.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=6&perPage=2",
            @"http://zuppl.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=7&perPage=2",
            @"http://zuppl.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=8&perPage=2",
            @"http://zuppl.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=9&perPage=2",
            @"http://zuppl.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=10&perPage=2",
            @"http://zuppl.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=11&perPage=2",
            @"http://zuppl.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=12&perPage=2",
            @"http://zuppl.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=13&perPage=2",
            @"http://zuppl.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=14&perPage=2",
            @"http://zuppl.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=15&perPage=2",
            nil];
    */
    
//    NSLog(@" %@",[NSString stringWithFormat:@"https://placeley.com/trend/geolocation.json?lat=%@&long=%@&page=1&perPage=2",latitude,longitude]);
//    
//    urls = [NSMutableArray arrayWithObjects:
//            [NSString stringWithFormat:@"https://placeley.com/trend/geolocation.json?lat=%@&long=%@&page=1&perPage=2",latitude,longitude],
//            @"https://placeley.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=2&perPage=2",
//            @"https://placeley.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=3&perPage=2",
//            @"https://placeley.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=4&perPage=2",
//            @"https://placeley.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=5&perPage=2",
//            @"https://placeley.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=6&perPage=2",
//            @"https://placeley.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=7&perPage=2",
//            @"https://placeley.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=8&perPage=2",
//            @"https://placeley.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=9&perPage=2",
//            @"https://placeley.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=10&perPage=2",
//            @"https://placeley.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=11&perPage=2",
//            @"https://placeley.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=12&perPage=2",
//            @"https://placeley.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=13&perPage=2",
//            @"https://placeley.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=14&perPage=2",
//            @"https://placeley.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=15&perPage=2",
//            nil];

    urls = [NSMutableArray arrayWithObjects:
            @"https://placeley.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=1&perPage=2",
            @"https://placeley.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=2&perPage=2",
            @"https://placeley.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=3&perPage=2",
            @"https://placeley.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=4&perPage=2",
            @"https://placeley.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=5&perPage=2",
            @"https://placeley.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=6&perPage=2",
            @"https://placeley.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=7&perPage=2",
            @"https://placeley.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=8&perPage=2",
            @"https://placeley.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=9&perPage=2",
            @"https://placeley.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=10&perPage=2",
            @"https://placeley.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=11&perPage=2",
            @"https://placeley.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=12&perPage=2",
            @"https://placeley.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=13&perPage=2",
            @"https://placeley.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=14&perPage=2",
            @"https://placeley.com/trend/geolocation.json?lat=12.977540&long=77.599510&page=15&perPage=2",
            nil];

	downloads = [[ServiceHelper alloc] initWithUrls: urls];
	downloads.delegate = self;
}
- (void)fetchglobalByMultipleQueries
{
    finalallTrends = [[NSMutableArray alloc] init];
    
  /*  urls = [NSMutableArray arrayWithObjects:
            @"http://zuppl.com/trend/global.json?page=1&perPage=2",
            @"http://zuppl.com/trend/global.json?page=2&perPage=2",
            @"http://zuppl.com/trend/global.json?page=3&perPage=2",
            @"http://zuppl.com/trend/global.json?page=4&perPage=2",
            @"http://zuppl.com/trend/global.json?page=5&perPage=2",
            @"http://zuppl.com/trend/global.json?page=6&perPage=2",
            @"http://zuppl.com/trend/global.json?page=7&perPage=2",
            @"http://zuppl.com/trend/global.json?page=8&perPage=2",
            @"http://zuppl.com/trend/global.json?page=9&perPage=2",
            @"http://zuppl.com/trend/global.json?page=10&perPage=2",
            @"http://zuppl.com/trend/global.json?page=11&perPage=2",
            @"http://zuppl.com/trend/global.json?page=12&perPage=2",
            @"http://zuppl.com/trend/global.json?page=13&perPage=2",
            @"http://zuppl.com/trend/global.json?page=14&perPage=2",
            @"http://zuppl.com/trend/global.json?page=15&perPage=2",
            nil];
    
   */
    
    urls = [NSMutableArray arrayWithObjects:
            @"https://placeley.com/trend/global.json?page=1&perPage=1",
            @"https://placeley.com/trend/global.json?page=2&perPage=1",
            @"https://placeley.com/trend/global.json?page=3&perPage=1",
            @"https://placeley.com/trend/global.json?page=4&perPage=1",
            @"https://placeley.com/trend/global.json?page=5&perPage=1",
            @"https://placeley.com/trend/global.json?page=6&perPage=1",
            @"https://placeley.com/trend/global.json?page=7&perPage=1",
            @"https://placeley.com/trend/global.json?page=8&perPage=1",
            @"https://placeley.com/trend/global.json?page=9&perPage=1",
            @"https://placeley.com/trend/global.json?page=10&perPage=1",
            @"https://placeley.com/trend/global.json?page=11&perPage=1",
            @"https://placeley.com/trend/global.json?page=12&perPage=1",
            @"https://placeley.com/trend/global.json?page=13&perPage=1",
            @"https://placeley.com/trend/global.json?page=14&perPage=1",
            @"https://placeley.com/trend/global.json?page=15&perPage=1",
            @"https://placeley.com/trend/global.json?page=16&perPage=1",
            @"https://placeley.com/trend/global.json?page=17&perPage=1",
            @"https://placeley.com/trend/global.json?page=18&perPage=1",
            @"https://placeley.com/trend/global.json?page=19&perPage=1",
            @"https://placeley.com/trend/global.json?page=20&perPage=1",
            @"https://placeley.com/trend/global.json?page=21&perPage=1",
            @"https://placeley.com/trend/global.json?page=22&perPage=1",
            @"https://placeley.com/trend/global.json?page=23&perPage=1",
            @"https://placeley.com/trend/global.json?page=24&perPage=1",
            @"https://placeley.com/trend/global.json?page=25&perPage=1",
            @"https://placeley.com/trend/global.json?page=26&perPage=1",
            @"https://placeley.com/trend/global.json?page=27&perPage=1",
            @"https://placeley.com/trend/global.json?page=28&perPage=1",
            @"https://placeley.com/trend/global.json?page=29&perPage=1",
            @"https://placeley.com/trend/global.json?page=30&perPage=1",

            nil];
    
	downloads = [[ServiceHelper alloc] initWithUrls: urls];
	downloads.delegate = self;
}


- (void) didFinishDownload:(NSNumber*)idx {
	NSLog(@"%d download: %@", [idx intValue], [downloads dataAsStringAtIndex: [idx intValue]]);
    
    id theObject = nil;
	
	@try
	{
		NSString *jsonString = [downloads dataAsStringAtIndex: [idx intValue]];
		
		NSData *theJSONData = [NSData dataWithBytes:[jsonString UTF8String]
											 length:[jsonString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
		
		NSError *theError = nil;
		
		theObject = [[CJSONDeserializer deserializer] deserialize:theJSONData error:&theError];
	}
	@catch (NSException *exception)
	{
		theObject = nil;
	}
    
    [finalallTrends addObjectsFromArray:[self createTrendObject:theObject]];
    
    NSLog(@" download: %d", [finalallTrends count]);
    
    if ([strTableCheck isEqualToString:@"Local"])
    {
        [self loadLocalTrendsData:finalallTrends];
    }
    else
    {
        [self loadGlobalTrendsData:finalallTrends];
    }
}

- (void) didFinishAllDownload {
	NSLog(@"Finished all download!");
    
    // NSLog(@" download: %d", [finalallTrends count]);
    
}

- (NSMutableArray *)createTrendObject:(id)trendsLocal
{
    NSMutableArray *globalTrendsFilterArray = [[NSMutableArray alloc] init];
    
    id trendsGlobalList = [trendsLocal valueForKey:@"places"];
    
    if(trendsLocal != nil && [trendsLocal count] > 0)
    {
        id currentLocalTrends = nil;
        
        NSEnumerator *enumerator = [trendsGlobalList objectEnumerator];
        
        while (currentLocalTrends = [enumerator nextObject])
        {
            TrendsData *localTrendsData = [[TrendsData alloc]init];
            
            [localTrendsData setId_trend:[self checkForNull:[currentLocalTrends valueForKey:@"_id"]]];
         
            [localTrendsData setAddress:[self checkForNull:[currentLocalTrends valueForKey:@"address"]]];
          
            [localTrendsData setCity:[self checkForNull:[currentLocalTrends valueForKey:@"city"]]];
            
            [localTrendsData setCity_country:[ self checkForNull:[ currentLocalTrends valueForKey:@"city_country"]]];
          
            [localTrendsData setComputed_name:[self checkForNull:[ currentLocalTrends valueForKey:@"computed_name"]]];
            
            [localTrendsData setLikers_count: [NSString stringWithFormat:@"%@",[ currentLocalTrends valueForKey:@"likers_count"]]];

            [localTrendsData setCountry:[self checkForNull:[ currentLocalTrends valueForKey:@"country"]]];
        
            [localTrendsData setFollower_ids:[self checkForNull:[ currentLocalTrends valueForKey:@"follower_ids"]]]; // array
            
            [localTrendsData setFormal_address:[self checkForNull:[ currentLocalTrends valueForKey:@"formal_address"]]];
            
            [localTrendsData setFormal_name:[self checkForNull:[currentLocalTrends valueForKey:@"formal_name"]]];
            
            [localTrendsData setIdentifier:[self checkForNull:[ currentLocalTrends valueForKey:@"identifier"]]];
            
            [localTrendsData setLocation:[self checkForNull:[ currentLocalTrends valueForKey:@"location"]]]; // array
            
            [localTrendsData setName:[self checkForNull:[ currentLocalTrends valueForKey:@"name"]]];
            
            [localTrendsData setTimezone:[self checkForNull:[currentLocalTrends valueForKey:@"timezone"]]];
            
            [localTrendsData setOpen_now:[self checkForNull:[ currentLocalTrends valueForKey:@"open_now"]]];
            
            [localTrendsData setPost_name:[self checkForNull:[ currentLocalTrends valueForKey:@"post_name"]]];
            
            [localTrendsData setPre_name:[self checkForNull:[ currentLocalTrends valueForKey:@"pre_name"]]];
            
            [localTrendsData setFollowers_count:[self checkForNull:[currentLocalTrends valueForKey:@"followers_count"]]];
            
            [localTrendsData setRecommend_count:[self checkForNull:[currentLocalTrends valueForKey:@"recommend_count"]]];
            
            [localTrendsData setLogo_url:[self checkForNull:[ currentLocalTrends valueForKey:@"logo_url"]]];
            
            [localTrendsData setPhotos_url:[self checkForNull:[ currentLocalTrends valueForKey:@"photos_url"]]]; // array
          
            [localTrendsData setWebsite_url:[self checkForNull:[ currentLocalTrends valueForKey:@"website_url"]]];
            
            [localTrendsData setMy_network:[self checkForNull:[ currentLocalTrends valueForKey:@"my_network"]]];
            
            [localTrendsData setOpen_between:[self checkForNull:[currentLocalTrends valueForKey:@"open_between"]]];
            
            [localTrendsData setPhone_number:[self checkForNull:[currentLocalTrends valueForKey:@"phone_number"]]];
            
            [localTrendsData setUser_id:[self checkForNull:[currentLocalTrends valueForKey:@"user_id"]]];
            
            [localTrendsData setCategoryNameArray:[self checkForNull:[currentLocalTrends valueForKey:@"categories"]]];
            
            
             NSMutableDictionary *dict = [currentLocalTrends valueForKey:@"info"];
             NSMutableDictionary *locationdict = [dict valueForKey:@"geometry"];
             NSMutableDictionary *locationdetaildict = [locationdict valueForKey:@"location"];
             
             localTrendsData.locationLatLngGlobalList = [[NSMutableArray alloc] init];
             [localTrendsData.locationLatLngGlobalList addObject:[locationdetaildict valueForKey:@"lat"]];
             [localTrendsData.locationLatLngGlobalList addObject:[locationdetaildict valueForKey:@"lng"]];
             
            
            [globalTrendsFilterArray addObject:localTrendsData];
            
            NSLog(@"globalTrendsFilterArray====>%@",globalTrendsFilterArray);
            
        }
        
        NSLog(@"All Global filter response===> %@",globalTrendsFilterArray);
    }
    return globalTrendsFilterArray;
}

-(id)checkForNull:(id)value
{
    NSString *valueString = [NSString stringWithFormat:@"%@",value];
    
    id objectString = @"";
    
    if (![valueString isEqualToString:@"(null)"] && ![valueString isEqualToString:@"<null>"] && valueString.length != 0)
        return value;
    
    return objectString;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)dismissSearchControllerWhileStayingActive {
    // Animate out the table view.
    NSTimeInterval animationDuration = 0.3;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    self.searchDisplayController.searchResultsTableView.alpha = 0.0;
    [UIView commitAnimations];
    
    [self.searchDisplayController.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchDisplayController.searchBar resignFirstResponder];
    self.m_searchTableView.hidden = YES;
}

- (SPGooglePlacesAutocompletePlace *)placeAtIndexPath:(NSIndexPath *)indexPath {
    return searchResultPlaces[indexPath.row];
}


#pragma mark -
-(void)setCorrectFrames
{
    // Here we set the frame to avoid overlay
    CGRect searchDisplayerFrame = self.searchDisplayController.searchResultsTableView.superview.frame;
    searchDisplayerFrame.origin.y = CGRectGetMaxY(self.searchDisplayController.searchBar.frame);
    searchDisplayerFrame.size.height -= searchDisplayerFrame.origin.y;
    self.searchDisplayController.searchResultsTableView.superview.frame = searchDisplayerFrame;
}

-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    [self setCorrectFrames];
}

-(void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    [self setCorrectFrames];
}
#pragma mark UISearchDisplayDelegate

- (void)handleSearchForSearchString:(NSString *)searchString {
    searchQuery.location = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
    searchQuery.input = searchString;
    [searchQuery fetchPlaces:^(NSArray *places, NSError *error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not fetch Places"
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        } else {
            searchResultPlaces = [places mutableCopy];
            
            NSMutableArray *placeNameArray = [[NSMutableArray alloc] init];
            [placeNameArray addObjectsFromArray:[self searchTrendsOnTable]];

            for (int iCount = 0; iCount < [places count]; iCount ++)
            {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:iCount inSection:0];
                [placeNameArray addObject:[self placeAtIndexPath:indexPath]];
            }

            [searchResultPlaces removeAllObjects];
            [searchResultPlaces addObjectsFromArray:placeNameArray];

            [self.searchDisplayController.searchResultsTableView reloadData];
        }
    }];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self handleSearchForSearchString:searchString];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark -
#pragma mark UISearchBar Delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    if (shouldBeginEditing) {
        // Animate in the table view.
        NSTimeInterval animationDuration = 0.3;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        self.searchDisplayController.searchResultsTableView.alpha = 0.75;
        [UIView commitAnimations];
        
        [self.searchDisplayController.searchBar setShowsCancelButton:YES animated:YES];
        self.m_searchTableView.hidden = NO;
        self.m_searchTableView.backgroundColor = [UIColor whiteColor];
    }
    BOOL boolToReturn = shouldBeginEditing;
    shouldBeginEditing = YES;
    return boolToReturn;
}
#pragma mark ================  Menu Options=====================

-(IBAction)btnInfoPage_Clicked:(id)sender
{
    objinfoPageVC=[[infoPageVC alloc]initWithNibName:@"infoPageVC" bundle:nil];
    [self.navigationController pushViewController:objinfoPageVC animated:YES];
    
}

- (void)handleLongPressonView:(UILongPressGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        
    }
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        [self infoOpenAnimation];
        viewManuoptions.hidden=NO;
        
    }
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



#pragma mark ======== Null Checking===============

+(id)checkForNull:(id)value
{
    NSString *valueString = [NSString stringWithFormat:@"%@",value];
    
    id objectString = @"";
    
    if (![valueString isEqualToString:@"(null)"] && ![valueString isEqualToString:@"<null>"] && valueString.length != 0)
        return value;
    
    return objectString;
}

@end

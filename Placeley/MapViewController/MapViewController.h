//
//  ViewController.h
//  MapWithAnnptation
//
//  Created by kushal on 10/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MApKit/MapKit.h"
#import "CoreLocation/CoreLocation.h"
#import "MKMapView+ZoomLevel.h"
#import "AsyncImageView.h"
#import "TrendsData.h"
#import "LocalTrendsViewController.h"


@interface MapViewController : UIViewController<MKMapViewDelegate,UIGestureRecognizerDelegate>
{
    TrendsData *selectedTrendDetail;
    LocalTrendsViewController *objLocalTrendsVC;
    
    MKPolyline *  routeLine ;
    
    int deselectedIndex;
    
    NSMutableArray *locationDetailArray;
    
    BOOL btnboolAnimateHandle;
    
    UIView *viewMapContent;

    AsyncImageView *asyInstagramImgView;
    
    UILabel *shopAddress;
    
    UIButton *btnShopname;
    
    
    UILabel *lblMapSelectNo;
    
    UILabel *lblFollowNo,*lblBuddiesNo,*lblThupNo;
    
    UILabel *lblFollowTxt,*lblBuddiesTxt,*lblThumbTxt;
    
    UIButton *btnMapSelectNo,*btnMapPhone,*btnMapShow,*btnMapWeb;
    
    NSMutableArray *annotationViewArray;

    BOOL isAnnotationSelected;
    
    NSString *selectedTrend;
    
    UISwipeGestureRecognizer *SwipeFromMapVC;
}

@property CLLocationCoordinate2D currentLocation;

@property CLLocationCoordinate2D destLocation;

@property (nonatomic , retain) NSString *selectedTrend,*selectedTrendMap;

@property (nonatomic, retain) IBOutlet MKMapView *theMapView;

@property (nonatomic, retain) NSMutableArray *mapAnnotations;

@property (nonatomic , retain) NSMutableArray *locationDetailArray;

@property (nonatomic , retain) NSMutableArray *trendDataArray;

@property(nonatomic,strong) IBOutlet UIView *viewBottomMap;

@property(nonatomic,strong) IBOutlet UIButton *btnUpDown;

@property(nonatomic,strong)IBOutlet UIView *viewUpDown;

@property(nonatomic,strong)IBOutlet UIButton *btnLocalMap,*btnGlobalMap;

@property(nonatomic,strong)IBOutlet UIScrollView *scrlViewBottomMap;


#pragma mark =======View Annimation Up and Down=============
-(IBAction)btnAnimationHandle_Clicked:(id)sender;
-(void)OpenViewAnimations;
-(void)CloseViewAnimations;

@end

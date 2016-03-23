//
//  MenuViewController.h
//  Placeley
//
//  Created by APR on 12/23/13.
//  Copyright (c) 2013 APR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "LocalTrendsViewController.h"
#import "FollowingTrendViewController.h"

//#import "ComposeMsgVC.h"


@class LocalTrendsViewController;
@class trendsDetailsViewController;

@interface MenuViewController : UIViewController
{
    
    LocalTrendsViewController *localTrendVC_obj;
    FollowingTrendViewController *followingTrendsVC;

    trendsDetailsViewController *trendsDetailsVC_obj;
    
   // ComposeMsgVC *ComposeMsgVC_Obj;
    
    
    IBOutlet UIButton *btnActivity,*btnFollowing,*btnTrending,*btnSetting;
    
}

@property(nonatomic,strong)    IBOutlet UIButton *btnActivity,*btnFollowing,*btnTrending,*btnSetting,*btnMap,*btnAddPlace;

@property(nonatomic,strong) IBOutlet UILabel *lblTittle;



@end

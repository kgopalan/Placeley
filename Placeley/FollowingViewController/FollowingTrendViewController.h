//
//  LocalTrendsViewController.h
//  Test
//
//  Created by Rajesh on 18/12/13.
//  Copyright (c) 2013 Rajesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FollowTrendscustomCell.h"

@interface FollowingTrendViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

{
    NSInteger selectedIndex;

}

@property(nonatomic,strong) IBOutlet UITableView *tbleViewLocalTrendsList;

@property(nonatomic,retain) NSArray * arrTrendsTitle,*arrTrendsAddress,*arrTrendsicon;


@end

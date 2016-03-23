//
//  LocalTrendscustomCell.h
//  Test
//
//  Created by Rajesh on 18/12/13.
//  Copyright (c) 2013 Rajesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowTrendscustomCell : UITableViewCell

{
    
}
@property(nonatomic,strong)IBOutlet UIImageView *imgViewLocalTrends;
@property(nonatomic,strong)IBOutlet UILabel *lblLocalTrendsTitle;
@property(nonatomic,strong)IBOutlet UILabel *lblLocalTrendsAddress;

@property(nonatomic,strong)IBOutlet UIButton *btnPhone;
@property(nonatomic,strong)IBOutlet UIButton *btnMap;
@property(nonatomic,strong)IBOutlet UIButton *btnWeb;

@property(nonatomic,strong)IBOutlet UIButton *btnUnFollow;




@end


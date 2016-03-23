//
//  LocalTrendscustomCell.h
//  Test
//
//  Created by Rajesh on 18/12/13.
//  Copyright (c) 2013 Rajesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface LocalTrendscustomCell : UITableViewCell

{
    
}
@property(nonatomic,strong)IBOutlet UIImageView *imgViewLocalTrends;
@property(nonatomic,strong)IBOutlet UILabel *lblLocalTrendsTitle;
@property(nonatomic,strong)IBOutlet UILabel *lblLocalTrendsAddress;
@property(nonatomic,retain)IBOutlet AsyncImageView *asynImgView;




@end

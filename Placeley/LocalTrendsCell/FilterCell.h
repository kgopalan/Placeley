//
//  FilterCell.h
//  Placeley
//
//  Created by APR on 12/22/13.
//  Copyright (c) 2013 APR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterCell : UITableViewCell

{
    
}
@property(nonatomic,strong) IBOutlet UILabel *lblFiltername;
@property(nonatomic,retain)IBOutlet UIButton *btnCheckbox;
@property(nonatomic,strong) IBOutlet UIImageView *imgCellBackground;

@end

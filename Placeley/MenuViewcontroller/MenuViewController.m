//
//  MenuViewController.m
//  Placeley
//
//  Created by APR on 12/23/13.
//  Copyright (c) 2013 APR. All rights reserved.
//

#import "MenuViewController.h"
#import "SettingsViewController.h"
#import "trendsDetailsViewController.h"

@interface MenuViewController ()
{
    SettingsViewController *settingsViewController;
}
@end

@implementation MenuViewController

@synthesize btnActivity,btnFollowing,btnSetting,btnTrending,btnMap,btnAddPlace;

@synthesize lblTittle;


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
    btnTrending.layer.cornerRadius = 10;
    btnTrending.clipsToBounds = YES;
    
    [self setNeedsStatusBarAppearanceUpdate];

    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(UIStatusBarStyle)preferredStatusBarStyle

{
    return UIStatusBarStyleLightContent;
}

#pragma mark UIButton click events

-(IBAction)btnActivity_Clicked:(id)sender
{
    lblTittle.text=@"Activity";
    
    [self addZoomInAnimation:sender];
}


-(IBAction)btnFollowing_Clicked:(id)sender
{
    lblTittle.text=@"Following";
    
    [self addZoomInAnimation:sender];
}

-(IBAction)btnTrending_Clicked:(id)sender
{
    lblTittle.text=@"Trending";
    [self addZoomInAnimation:sender];
}

-(IBAction)btnSettings_Clicked:(id)sender
{
    lblTittle.text=@"Settings";
    [self addZoomInAnimation:sender];
    
}

-(IBAction)btnMap_Clicked:(id)sender
{
    lblTittle.text=@"Map";
    [self addZoomInAnimation:sender];
}

-(IBAction)btnAddPlace_Clicked:(id)sender
{
    lblTittle.text=@"AddPlace";
    [self addZoomInAnimation:sender];
    
    
//    ComposeMsgVC_Obj=[[ComposeMsgVC alloc]initWithNibName:@"ComposeMsgVC" bundle:nil];
//    [self.navigationController pushViewController:ComposeMsgVC_Obj animated:YES];
}

#pragma mark Move to next ViewController Methods

-(void)pushToNextViewController:(UIButton *)button
{
    switch (button.tag)
    {
        case 1:
            trendsDetailsVC_obj=[[trendsDetailsViewController alloc]initWithNibName:@"trendsDetailsViewController" bundle:nil];
            [self.navigationController pushViewController:trendsDetailsVC_obj animated:YES];

            break;
        case 2:
            followingTrendsVC=[[FollowingTrendViewController alloc]initWithNibName:@"FollowingTrendViewController" bundle:nil];
            [self.navigationController pushViewController:followingTrendsVC animated:YES];
            break;
        case 3:
            localTrendVC_obj=[[LocalTrendsViewController alloc]initWithNibName:@"LocalTrendsViewController" bundle:nil];
            [self.navigationController pushViewController:localTrendVC_obj animated:YES];
            break;
        case 4:
            break;
        case 5:
            settingsViewController=[[SettingsViewController alloc]initWithNibName:@"SettingsViewController" bundle:nil];
            [self.navigationController pushViewController:settingsViewController animated:YES];
            break;
        case 6:
            break;

        default:
            break;
    }
    [self performSelector:@selector(resetButtonTransition:) withObject:button afterDelay:0.1];
}

#pragma mark Animation Methods

- (void) addZoomInAnimation:(UIButton*)btn
{
    [UIView animateWithDuration:0.1f delay:0 options: UIViewAnimationOptionAllowUserInteraction  animations:^{
        
        btn.transform = CGAffineTransformMakeTranslation(-14, -14);
        
        btn.transform = CGAffineTransformScale(btn.transform,1.2f, 1.2f);
        
    }  completion:^(BOOL finished)
        {
            [self performSelector:@selector(pushToNextViewController:) withObject:btn afterDelay:0.1];
        }];

}

-(void)resetButtonTransition:(UIButton *)btn
{
    [UIView animateWithDuration:0.1f delay:0.1 options: UIViewAnimationOptionAllowUserInteraction  animations:^{
        
        btn.transform = CGAffineTransformMakeTranslation(0, 0);
        
        btn.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        
    }  completion:^(BOOL finished)
     {
     }];

}
- (IBAction)moveButtonUp:(UIButton *)btn
{
    [self performSelector:@selector(resetButtonTransition:) withObject:btn afterDelay:0.1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

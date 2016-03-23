//
//  trendsListViewController.m
//  Placeley
//
//  Created by APR on 12/17/13.
//  Copyright (c) 2013 APR. All rights reserved.
//

#import "trendsListViewController.h"

@interface trendsListViewController ()

@end

@implementation trendsListViewController

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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)btnOntrends_Clicked:(id)sender
{
    trendsDetailsVC_obj=[[trendsDetailsViewController alloc]initWithNibName:@"trendsDetailsViewController" bundle:nil];
    [self.navigationController pushViewController:trendsDetailsVC_obj animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

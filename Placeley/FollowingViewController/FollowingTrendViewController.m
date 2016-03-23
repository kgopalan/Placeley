//
//  LocalTrendsViewController.m
//  Test
//
//  Created by Rajesh on 18/12/13.
//  Copyright (c) 2013 Rajesh. All rights reserved.
//

#import "FollowingTrendViewController.h"

@interface FollowingTrendViewController ()

@end

@implementation FollowingTrendViewController
@synthesize tbleViewLocalTrendsList=_tbleViewLocalTrendsList;

@synthesize arrTrendsAddress=_arrTrendsAddress;
@synthesize arrTrendsicon=_arrTrendsicon;
@synthesize arrTrendsTitle=_arrTrendsTitle;

#define EXPANDCELL_HEIGHT 125

#define NORMALCELL_HEIGHT 52


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
    selectedIndex = -1;

    
    self.arrTrendsTitle =[[NSArray alloc]initWithObjects:@"iOS Development",@"Android Development",@"Blackberry Development",@"Windows Development",@"Symbain Development", nil];
    self.arrTrendsicon=[[NSArray alloc]initWithObjects:@"apple-logo.png",@"android_icon.png",@"blackberry_icon.png",@"windows_icon.png", @"symbian_icon.png",nil];
    [super viewDidLoad];
    self.arrTrendsAddress =[[NSArray alloc]initWithObjects:@"iOS arrTrendsAddress",@"arrTrendsAddress Development",@"Blackberry arrTrendsAddress",@"Windows arrTrendsAddress",@"Symbain arrTrendsAddress", nil];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - Tableview Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrTrendsTitle count];
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 52;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //If this is the selected index we need to return the height of the cell
    //in relation to the label height otherwise we just return the minimum label height with padding
    if(selectedIndex == indexPath.row)
    {
        //return [self getLabelHeightForIndex:indexPath.row] + COMMENT_LABEL_PADDING * 2;
        
        return EXPANDCELL_HEIGHT ;
        
    }
    else {
        //return COMMENT_LABEL_MIN_HEIGHT + COMMENT_LABEL_PADDING * 2;
        
        return NORMALCELL_HEIGHT ;
        
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FollowTrendscustomCell * cellTrends =(FollowTrendscustomCell *)[self.tbleViewLocalTrendsList dequeueReusableCellWithIdentifier:@"FollowTrendscustomCell"];
    
    if (cellTrends == nil)
    {
        cellTrends=[[[NSBundle mainBundle]loadNibNamed:@"FollowTrendscustomCell" owner:self options:nil]objectAtIndex:0];
        cellTrends.frame=CGRectMake(0, 0, 320, 52);
    }

    
    [cellTrends.btnPhone addTarget:self action:@selector(btnPhone_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    cellTrends.btnPhone.tag=indexPath.row;
    
    [cellTrends.btnMap addTarget:self action:@selector(btnMap_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    cellTrends.btnMap.tag=indexPath.row;
    
    [cellTrends.btnWeb addTarget:self action:@selector(btnWeb_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    cellTrends.btnWeb.tag=indexPath.row;
    
    [cellTrends.btnUnFollow addTarget:self action:@selector(btnUnFollow_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    cellTrends.btnUnFollow.tag=indexPath.row;
    
    
    cellTrends.self.imgViewLocalTrends.image=[UIImage imageNamed:[self.arrTrendsicon objectAtIndex:indexPath.row]];
    
    cellTrends.self.lblLocalTrendsTitle.text=[self.arrTrendsTitle objectAtIndex:indexPath.row];
    
    cellTrends.self.lblLocalTrendsAddress.text=[self.arrTrendsAddress objectAtIndex:indexPath.row];
    
    if(selectedIndex == indexPath.row)
    {
        cellTrends.frame=CGRectMake(0, 0, 320, EXPANDCELL_HEIGHT);
    }
    else
    
    {
        
        cellTrends.frame=CGRectMake(0, 0, 320, NORMALCELL_HEIGHT);
    }
    

    return cellTrends;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(selectedIndex == indexPath.row)
    {
        selectedIndex = -1;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        //UITableViewRowAnimationFade
        return;
    }
    
    
    if(selectedIndex >= 0)
    {
        NSIndexPath *previousPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        selectedIndex = indexPath.row;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:previousPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    
    
    selectedIndex = indexPath.row;
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];

}


-(IBAction)btnPhone_Clicked:(id)sender

{
    NSLog(@"btnPhone_Clicked");
    
}

-(IBAction)btnMap_Clicked:(id)sender

{
    NSLog(@"btnMap_Clicked");

}

-(IBAction)btnWeb_Clicked:(id)sender

{
    NSLog(@"btnWeb_Clicked");

}

-(IBAction)btnUnFollow_Clicked:(id)sender

{
    NSLog(@"btnUnFollow_Clicked");

    
}


//

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if([indexPath compare: _selectedCellIndexPath] == NSOrderedSame) {
//        return EXPANDED_CELL_HEIGHT;
//    }
//    else {
//        return NORMAL_CELL_HEIGHT;
//    }
//}



-(IBAction)btn_Back_Clicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

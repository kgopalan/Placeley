//
//  CategoryFilterViewController.m
//  Placeley
//
//  Created by APR on 1/25/14.
//  Copyright (c) 2014 APR. All rights reserved.
//

#import "CategoryFilterViewController.h"

@interface CategoryFilterViewController ()

@end

@implementation CategoryFilterViewController
@synthesize viewPopUpLocal;
@synthesize tbleFilter;
@synthesize btnFilterClose;
@synthesize btnDone;

@synthesize delegate;

@synthesize transparentView;

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
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    tbleFilter.separatorInset = UIEdgeInsetsZero;

    arrLocalFilterCatName = [[NSMutableArray alloc]initWithObjects:@"All",@"Bar",@"Cafe",@"Department store",@"Eelectronics store",@"Establishment",@"Food",@"Gym", @"Night club",@"Pharmacy",@"Restaurant",@"Parking",@"Stadium",@"Store",@"University",@"Point of interest",@"Locality",nil];
    
    [viewPopUpLocal addSubview:tbleFilter];
    
    self.view.backgroundColor = [UIColor clearColor];
    transparentView.backgroundColor = [UIColor blackColor];
    transparentView.alpha = 0.5;
    [self.view addSubview:viewPopUpLocal];
    if (IS_IPHONE_5)
    {
        viewPopUpLocal.frame=CGRectMake(0, 568, 320, 450);
    }
    else
    {
        viewPopUpLocal.frame=CGRectMake(0, 480, 320, 400);
    }
    selectedIndexPaths = [[NSMutableArray alloc] init];
    [super viewDidLoad];
    
    btnDone.layer.cornerRadius = 8.0;
    btnDone.layer.borderColor=[UIColor blueColor].CGColor;
    btnDone.layer.borderWidth=1.0f;
}


#pragma mark - ============== VIEW POP ANIMATIONS====================

-(IBAction)btn_FilterClose:(id)sender
{
    [self FilterCloseViewAnimations];
}

-(IBAction)btn_DoneClicked:(id)sender
{
    [delegate FilterDone];
    [self FilterCloseViewAnimations];
}



-(void)FilterCloseViewAnimations
{
    if(IS_IPHONE_5)
    {
        [UIView animateWithDuration:0.2 delay:0
                            options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear
                         animations:^{
                             [viewPopUpLocal setFrame:CGRectMake(0, 568, 320, 568)];
                         }
                         completion:^(BOOL finished){
                             if(finished)
                                 [self.view removeFromSuperview];
                         }];
    }
    
    else
    {
        [UIView animateWithDuration:0.2 delay:0
                            options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear
                         animations:^{
                             [viewPopUpLocal setFrame:CGRectMake(0, 480, 320, 380)];
                         }
                         completion:^(BOOL finished){
                             if(finished)
                                 [self.view removeFromSuperview];
                         }];
    }
}




-(void)FilterOpenViewAnimations
{
    if(IS_IPHONE_5)
    {
        [UIView animateWithDuration:0.2 delay:0
                            options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear
                         animations:^{
                             [viewPopUpLocal setFrame:CGRectMake(0, 110, 320, 450)];
                            viewPopUpLocal.hidden = FALSE;
                             [self.view bringSubviewToFront:viewPopUpLocal];
                         }
                         completion:NULL];
    }
    
    else
    {
        [UIView animateWithDuration:0.2 delay:0
                            options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear
                         animations:^{
                            [viewPopUpLocal setFrame:CGRectMake(0, 110, 320, 380)];
                             viewPopUpLocal.hidden = FALSE;
                             [self.view bringSubviewToFront:viewPopUpLocal];
                         }
                         completion:NULL];
    }
}


#pragma mark - Tableview Delegate Methods


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrLocalFilterCatName count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FilterCell * cellFilter =(FilterCell *)[tbleFilter dequeueReusableCellWithIdentifier:@"FilterCell"];
    if (cellFilter == nil)
    {
        cellFilter=[[[NSBundle mainBundle]loadNibNamed:@"FilterCell" owner:self options:nil]objectAtIndex:0];
        cellFilter.frame=CGRectMake(0, 0, 205, 40);
    }
    cellFilter.lblFiltername.text=[arrLocalFilterCatName objectAtIndex:indexPath.row];
    if ([selectedIndexPaths containsObject:indexPath])
        cellFilter.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cellFilter.accessoryType = UITableViewCellAccessoryNone;
    
    return cellFilter;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [delegate filterOptionSelected:[arrLocalFilterCatName objectAtIndex:indexPath.row]];
    
    [selectedIndexPaths removeAllObjects];
    [selectedIndexPaths addObject:indexPath];
//    if ([selectedIndexPaths containsObject:indexPath])
//        [selectedIndexPaths removeObject:indexPath];
//    else
//        [selectedIndexPaths addObject:indexPath];
    [tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

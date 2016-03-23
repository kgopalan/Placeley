//
//  CategoryFilterGlobalVC.m
//  Placeley
//
//  Created by APR on 1/25/14.
//  Copyright (c) 2014 APR. All rights reserved.
//

#import "CategoryFilterGlobalVC.h"
#import "AppDelegate.h"
#import "ServiceHelper.h"

@interface CategoryFilterGlobalVC ()

@end

@implementation CategoryFilterGlobalVC

@synthesize viewGlobalPop;
@synthesize tbleFilterGlobalCategory,tbleFilterGlobalCity;
@synthesize btnFilterClose;
@synthesize delegate;
@synthesize btnDone;


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
    tbleFilterGlobalCity.separatorInset = UIEdgeInsetsZero;
    tbleFilterGlobalCategory.separatorInset = UIEdgeInsetsZero;

    selectedCityIndexPaths = [[NSMutableArray alloc] init];
    selectedCategoryIndexPaths = [[NSMutableArray alloc] init];
    
    arrGlobalFiterCityName=[[NSMutableArray alloc]init];
    arrGlobalFilterCatName=[[NSMutableArray alloc]init];
    
    
    //arrGlobalFilterCatName=[[NSMutableArray alloc] initWithObjects:@"All",@"Amusement park",@"Art gallery", @"bakery", @"Beauty salon", @"Food",@"Hardware store", @"Hospital",@"Restaurant",nil];
    
    if (IS_IPHONE_5)
    {
        viewGlobalPop.frame=CGRectMake(0, 568, 320, 450);
    }
    else
    {
        viewGlobalPop.frame=CGRectMake(0, 480, 320, 360);
    }

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    btnDone.layer.cornerRadius = 8.0;
    btnDone.layer.borderColor=[UIColor blueColor].CGColor;
    btnDone.layer.borderWidth=1.0f;
}

-(void)getGlobalCity
{
    BOOL checkConnection=[THIS checkReachability];
    
    if (checkConnection==YES)
    {
        
        NSUserDefaults *userDefaultsCity = [NSUserDefaults standardUserDefaults];
        NSUserDefaults *userDefaultsCat = [NSUserDefaults standardUserDefaults];
        
        NSData *arrayDataGlobalCity = [userDefaultsCity objectForKey:@"GlobalCityList"];
        NSData *arrayDataGlobalCat = [userDefaultsCat objectForKey:@"GlobalCategories"];
        
        if ([NSKeyedUnarchiver unarchiveObjectWithData:arrayDataGlobalCity] != nil && [NSKeyedUnarchiver unarchiveObjectWithData:arrayDataGlobalCat] != nil)
        {
            [self loadGlobalCityName:[NSKeyedUnarchiver unarchiveObjectWithData:arrayDataGlobalCity ] andCategoryName:[NSKeyedUnarchiver unarchiveObjectWithData:arrayDataGlobalCat ]];
        }
        else
        {
            [AppDelegate performSelector:@selector(activeIndicatorStartAnimating:) withObject:self.view afterDelay:0.2];
            
            self.view.userInteractionEnabled = NO;
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),  ^{
                
                NSMutableDictionary *globalCityList = [ServiceHelper getGlobalCity];
                
                NSArray *globalSatesCityList;
                
                NSMutableArray *globalCountryKey = [globalCityList valueForKey:@"countries"];
                
                NSMutableDictionary *statesDictionary = (NSMutableDictionary *)[globalCountryKey objectAtIndex:0];
                
                globalSatesCityList = [statesDictionary objectForKey:@"United States"];
                
                NSMutableArray *globalCategoryKey = [globalCityList valueForKey:@"categories"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self loadGlobalCityName:globalSatesCityList andCategoryName:globalCategoryKey];
                    
                    [AppDelegate performSelector:@selector(activeIndicatorStopAnimating) withObject:nil];
                    
                    self.view.userInteractionEnabled = YES;
                });
            });
            
        }
    }
}

- (void)loadGlobalCityName:(NSArray *)globalCity_Array andCategoryName:(NSMutableArray *)globalCategoryKey
{
    
    NSUserDefaults *userDefaultsGlobalCity = [NSUserDefaults standardUserDefaults];
    NSData *arrayDataGlobalCity = [NSKeyedArchiver archivedDataWithRootObject:globalCity_Array];
    [userDefaultsGlobalCity setObject:arrayDataGlobalCity forKey:@"GlobalCityList"];
    
    NSUserDefaults *userDefaultsGlobalCat = [NSUserDefaults standardUserDefaults];
    NSData *arrayDataGlobalCat = [NSKeyedArchiver archivedDataWithRootObject:globalCategoryKey];
    [userDefaultsGlobalCat setObject:arrayDataGlobalCat forKey:@"GlobalCategories"];
    
    [arrGlobalFiterCityName removeAllObjects];
    
    [arrGlobalFiterCityName addObjectsFromArray:globalCity_Array];
    
    [tbleFilterGlobalCity reloadData];
    
    [arrGlobalFilterCatName removeAllObjects];
    
    [arrGlobalFilterCatName addObjectsFromArray:globalCategoryKey];
    
    [tbleFilterGlobalCategory reloadData];
    
}


-(void)getGlobalCityBasedonCategory
{
    
    
    [AppDelegate performSelector:@selector(activeIndicatorStartAnimating:) withObject:self.view afterDelay:0.2];
    
    self.view.userInteractionEnabled = NO;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),  ^{
        
        NSMutableDictionary *globalCityList = [ServiceHelper getGlobalCityBasedCategoryname:strGlobalCityNameSelect];
        
        NSArray *globalSatesCityList;
        
        NSMutableArray *globalCountryKey = [globalCityList valueForKey:@"countries"];
        
        NSMutableDictionary *statesDictionary = (NSMutableDictionary *)[globalCountryKey objectAtIndex:0];
        
        globalSatesCityList = [statesDictionary objectForKey:@"United States"];
        
        NSMutableArray *globalCategoryKey = [globalCityList valueForKey:@"categories"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self loadGlobalCityBasedOnCategoty:globalCategoryKey];
            
            [AppDelegate performSelector:@selector(activeIndicatorStopAnimating) withObject:nil];
            
            self.view.userInteractionEnabled = YES;
        });
    });
}

- (void)loadGlobalCityBasedOnCategoty:(NSMutableArray *)arr_globalCategoryName
{
    [arrGlobalFilterCatName removeAllObjects];
    
    [arrGlobalFilterCatName addObjectsFromArray:arr_globalCategoryName];
    
    [tbleFilterGlobalCategory reloadData];
}

#pragma mark - ============== VIEW POP ANIMATIONS====================

-(IBAction)btn_FilterClose:(id)sender
{
    [self FilterCloseViewAnimations];
}

-(IBAction)btn_FilterDone:(id)sender
{
    [delegate filterDoneGlobal];
    [self FilterCloseViewAnimations];
}

-(void)FilterCloseViewAnimations
{
    if(IS_IPHONE_5)
    {
        [UIView animateWithDuration:0.2 delay:0
                            options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear
                         animations:^{
                             [viewGlobalPop setFrame:CGRectMake(0, 568, 320, 568)];
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
                             [viewGlobalPop setFrame:CGRectMake(0, 480, 320, 400)];
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
                             [viewGlobalPop setFrame:CGRectMake(0, 110, 320, 450)];
                             [self.view bringSubviewToFront:viewGlobalPop];
                         }
                         completion:NULL];
    }
    
    else
    {
        [UIView animateWithDuration:0.2 delay:0
                            options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear
                         animations:^{
                             [viewGlobalPop setFrame:CGRectMake(0, 110, 320, 360)];
                             [self.view bringSubviewToFront:viewGlobalPop];
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
    if (tableView==tbleFilterGlobalCity)
    {
        return [arrGlobalFiterCityName count];
    }
    else
    {
        return [arrGlobalFilterCatName count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     FilterCell * cellFilter =(FilterCell *)[tbleFilterGlobalCity dequeueReusableCellWithIdentifier:@"FilterCell"];
    
    if (tableView==tbleFilterGlobalCity)
    {
        if (cellFilter == nil)
        {
            cellFilter=[[[NSBundle mainBundle]loadNibNamed:@"FilterCell" owner:self options:nil]objectAtIndex:0];
            cellFilter.frame=CGRectMake(0, 0, 205, 40);
        }
        cellFilter.lblFiltername.text=[[arrGlobalFiterCityName objectAtIndex:indexPath.row]stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        if ([selectedCityIndexPaths containsObject:indexPath])
            cellFilter.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            cellFilter.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (tableView==tbleFilterGlobalCategory )
    {
        if (cellFilter == nil)
        {
            cellFilter=[[[NSBundle mainBundle]loadNibNamed:@"FilterCell" owner:self options:nil]objectAtIndex:0];
            cellFilter.frame=CGRectMake(0, 0, 205, 40);
        }
        NSString *strCatNameFromServer=[[arrGlobalFilterCatName objectAtIndex:indexPath.row]stringByReplacingOccurrencesOfString:@"_" withString:@" "];;
        
       // NSString *strFinalCatName =[strCatNameFromServer uppercaseString];
       // cellFilter.lblFiltername.text=[arrGlobalFilterCatName objectAtIndex:indexPath.row];
       // cellFilter.lblFiltername.text=[[arrGlobalFilterCatName objectAtIndex:indexPath.row]stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        cellFilter.lblFiltername.text=strCatNameFromServer;
        
        if ([selectedCategoryIndexPaths containsObject:indexPath])
            cellFilter.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            cellFilter.accessoryType = UITableViewCellAccessoryNone;
    }
    return cellFilter;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tbleFilterGlobalCity)
    {
        [selectedCityIndexPaths removeAllObjects];
        [selectedCityIndexPaths addObject:indexPath];
        [tbleFilterGlobalCity reloadData];
        [delegate filterOptionSelectedCity:[arrGlobalFiterCityName objectAtIndex:indexPath.row]];
        NSString *strCitySelect=[arrGlobalFiterCityName objectAtIndex:indexPath.row];
        
        NSString *strReplacing=[strCitySelect stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        NSString *strLower=[strReplacing lowercaseString];
        strGlobalCityNameSelect=strLower;
        NSLog(@"strCitySelecet to send====%@",strGlobalCityNameSelect);
        
        [self getGlobalCityBasedonCategory];
        
        
    }
    if (tableView==tbleFilterGlobalCategory)
    {
        [selectedCategoryIndexPaths removeAllObjects];
        [selectedCategoryIndexPaths addObject:indexPath];
        [tbleFilterGlobalCategory reloadData];
        [delegate filterOptionSelectedCategory:[arrGlobalFilterCatName objectAtIndex:indexPath.row]];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

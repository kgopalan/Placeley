//
//  ViewController.m
//  MapWithAnnptation
//
//  Created by kushal on 10/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "SFAnnotation.h"        // annotation for the city of San Francisco
#import "trendsDetailsViewController.h"
#import "MTPopupWindow.h"

@implementation MapViewController
@synthesize theMapView;
@synthesize locationDetailArray;
@synthesize viewBottomMap=_viewBottomMap;
@synthesize btnUpDown=_btnUpDown;
@synthesize scrlViewBottomMap=_scrlViewBottomMap;
@synthesize viewUpDown=_viewUpDown;

@synthesize trendDataArray = _trendDataArray;

@synthesize selectedTrend;
@synthesize selectedTrendMap;


@synthesize btnLocalMap,btnGlobalMap;

@synthesize currentLocation;
@synthesize destLocation;

static NSString* const ANNOTATION_SELECTED_DESELECTED = @"mapAnnotationSelectedOrDeselected";

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

+ (CGFloat)annotationPadding;
{
    return 10.0f;
}

+ (CGFloat)calloutHeight;
{
    return 40.0f;
}

-(void)handleTapGesture:(UIGestureRecognizer*)sender
{
    for (int iCount = 1; iCount <= [annotationViewArray count]; iCount++)
    {
        MKAnnotationView *annotationView = [annotationViewArray objectAtIndex:iCount - 1];
        
        CGRect resizeRect;
        resizeRect.size = CGSizeMake(25, 40); //flagImage.size;
        CGSize maxSize = CGRectInset(self.view.bounds,
                                     [MapViewController annotationPadding],
                                     [MapViewController annotationPadding]).size;
        maxSize.height -= self.navigationController.navigationBar.frame.size.height + [MapViewController calloutHeight];
        if (resizeRect.size.width > maxSize.width)
            resizeRect.size = CGSizeMake(maxSize.width, resizeRect.size.height / resizeRect.size.width * maxSize.width);
        if (resizeRect.size.height > maxSize.height)
            resizeRect.size = CGSizeMake(resizeRect.size.width / resizeRect.size.height * maxSize.height, maxSize.height);
        
        resizeRect.origin = CGPointMake(0.0, 0.0);
        UIGraphicsBeginImageContext(resizeRect.size);
        [[UIImage imageNamed:@"pnRed.png"] drawInRect:resizeRect];
        
        resizeRect.origin = CGPointMake(0.0, 5.0);
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setAlignment:NSTextAlignmentCenter];
        NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
        [attributes setObject:[UIFont boldSystemFontOfSize:12] forKey:NSFontAttributeName];
        [attributes setObject:style forKey:NSParagraphStyleAttributeName];
        [attributes setObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
        
        [[NSString stringWithFormat:@"%d",iCount] drawInRect:resizeRect withAttributes:attributes];
        
        UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        annotationView.image=resizedImage;
    }

}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    annotationViewArray = [[NSMutableArray alloc] init];
    
    // for ios 7
    [self setNeedsStatusBarAppearanceUpdate];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [theMapView addGestureRecognizer:tapGesture];
    theMapView.delegate=self;

    NSLog(@"obj_MapVC.locationDetailArray test====%@",locationDetailArray);

    self.mapAnnotations = [[NSMutableArray alloc] init];
    
    SFAnnotation *pointAnnotation;
    
    NSArray *latlng;
    
    if ([locationDetailArray count] > 0)
    {
        latlng = [locationDetailArray objectAtIndex:0];
        
        destLocation= CLLocationCoordinate2DMake([[latlng objectAtIndex:0] doubleValue], [[latlng objectAtIndex:1] doubleValue]);
    }

    
    for (int iCount = 0; iCount < [locationDetailArray count]; iCount ++)
    {
        NSArray *latlng = [locationDetailArray objectAtIndex:iCount];
        
        pointAnnotation = [[SFAnnotation alloc] initWithLatitude:[[latlng objectAtIndex:0] doubleValue] andLongitude:[[latlng objectAtIndex:1] doubleValue] andmyIndex:1];
        pointAnnotation.title = @"h";
        [self.mapAnnotations addObject:pointAnnotation];

        if (iCount == 0)
        {
            CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake([[latlng objectAtIndex:0] doubleValue], [[latlng objectAtIndex:1] doubleValue]);
            if ([selectedTrend isEqualToString:@"Local"] || [selectedTrend isEqualToString:@"NearMe"])
            {
                [theMapView setCenterCoordinate:centerCoordinate zoomLevel:13 animated:YES];
                [btnLocalMap setImage:[UIImage imageNamed:@"local_blue.png"] forState:UIControlStateNormal];
                
                [btnGlobalMap setImage:[UIImage imageNamed:@"global_white.png"] forState:UIControlStateNormal];

            }
            else
            {
                [btnLocalMap setImage:[UIImage imageNamed:@"local_white.png"] forState:UIControlStateNormal];
                
                [btnGlobalMap setImage:[UIImage imageNamed:@"global_blue.png"] forState:UIControlStateNormal];
                
                [theMapView setCenterCoordinate:centerCoordinate zoomLevel:1 animated:YES];
            }

        }
    }
    
    [theMapView removeAnnotations:theMapView.annotations];  // remove any annotations that exist
    
    [theMapView addAnnotations:self.mapAnnotations];

    self.scrlViewBottomMap.pagingEnabled = YES;
    
    btnboolAnimateHandle=0;
    if (IS_IPHONE_5)
    {
        self.viewBottomMap.frame=CGRectMake(0, 560, 320,218);
         self.viewUpDown.frame=CGRectMake(0, 545, 320,28);
    }
    else
    {
        self.viewBottomMap.frame=CGRectMake(0, 485, 320,218);
        self.viewUpDown.frame=CGRectMake(0, 450, 320,28);
    }
    
   

    
    self.viewUpDown.backgroundColor = [UIColor clearColor];
    
    self.viewBottomMap.backgroundColor = [UIColor colorWithRed:168.0/255.0 green:166.0/255.0 blue:162.0/255.0 alpha:0.6];

    [self.viewUpDown addSubview: self.btnUpDown];
    
    
    SwipeFromMapVC =[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFormMapVC)];
    [SwipeFromMapVC setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:SwipeFromMapVC];
    
    [self LoadMapContentView];

    [self CloseViewAnimations];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)handleSwipeFormMapVC
{
    for (UIViewController *viewcontroller in [self.navigationController viewControllers])
    {
        if ([viewcontroller isKindOfClass:[LocalTrendsViewController class]])
        {
            [self.navigationController popToViewController:viewcontroller animated:YES];
        }
    }
}

-(IBAction)btnLocalTrendMap_Clicked:(id)sender
{
    for (UIViewController *viewcontroller in [self.navigationController viewControllers])
    {
        if ([viewcontroller isKindOfClass:[LocalTrendsViewController class]])
        {
            [self.navigationController popToViewController:viewcontroller animated:YES];
        }
    }
}

-(IBAction)btnGlobalTrendMap_Clicked:(id)sender
{
    for (UIViewController *viewcontroller in [self.navigationController viewControllers])
    {
        if ([viewcontroller isKindOfClass:[LocalTrendsViewController class]])
        {
            selectedTrend=@"Test";
            
            [self.navigationController popToViewController:viewcontroller animated:YES];
        }
    }
}

-(IBAction)btnBack_Clicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark =======View Annimation Up and Down=============


-(IBAction)btnAnimationHandle_Clicked:(id)sender
{
    self.viewBottomMap.hidden = FALSE;
    
    if (btnboolAnimateHandle==0)
    {
        btnboolAnimateHandle=1;
        
        [self OpenViewAnimations];
    }
    else if(btnboolAnimateHandle==1)
    {
        btnboolAnimateHandle=0;
        
        [self CloseViewAnimations];
    }
}


-(void)OpenViewAnimations
{
    if(IS_IPHONE_5)
    {
        [UIView animateWithDuration:0.5 delay:0
                            options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.viewUpDown.transform = CGAffineTransformMakeScale(1, -1);
                             [self.viewBottomMap setFrame:CGRectMake(0, 372, 320, 250)];
                             self.viewUpDown.frame=CGRectMake(0, 347, 320,28);
                             self.viewBottomMap.hidden = FALSE;
                             [self.view bringSubviewToFront:self.viewBottomMap];
                         }
                         completion:NULL];
    }
    
    else
    {
        [UIView animateWithDuration:0.5 delay:0
                            options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.viewUpDown.transform = CGAffineTransformMakeScale(1, -1);
                             [self.viewBottomMap setFrame:CGRectMake(0, 282, 320, 250)];
                             self.viewUpDown.frame=CGRectMake(0, 252, 320,28);
                             self.viewBottomMap.hidden = FALSE;
                             [self.view bringSubviewToFront:self.viewBottomMap];
                         }
                         completion:NULL];
    }
}

-(void)CloseViewAnimations
{
    if(IS_IPHONE_5)
    {
        [UIView animateWithDuration:0.5 delay:0
                            options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.viewUpDown.transform = CGAffineTransformMakeScale(1, 1);
                             self.viewUpDown.frame=CGRectMake(0, 545, 320,28);
                             [self.viewBottomMap setFrame:CGRectMake(0, 568, 320, 250)];
                             [self.view bringSubviewToFront:self.viewBottomMap];
                         }
                         completion:NULL];
    }
    else
    {
        [UIView animateWithDuration:0.5 delay:0
                            options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.viewUpDown.transform = CGAffineTransformMakeScale(1, 1);
                             self.viewUpDown.frame=CGRectMake(0, 450, 320,28);
                             [self.viewBottomMap setFrame:CGRectMake(0, 480, 320, 250)];
                             [self.view bringSubviewToFront:self.viewUpDown];

                         }
                         completion:NULL];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle

{
    return UIStatusBarStyleLightContent;
}



-(void)LoadMapContentView
{
    NSInteger intVXpos=20,intVYpos=0;
    //NSInteger intImgBgXpos=23,intImgBgYpos=0;
    
    NSInteger intlblNameXpos=20,intlblNameYpos=11;
    NSInteger intlblAddXpos=20,intlblAddYpos=35;
    
    NSInteger intbtnNoXpos=40,intbtnNoYpos=70;
    NSInteger intlblMapNoXpos=42,intlblMapNoYpos=72;
    
    NSInteger intbtnPhoneXpos=105,intbtnPhoneYpos=70;
    NSInteger intbtnMapXpos=170,intbtnMapYpos=70;
    NSInteger intbtnWebXpos=235,intbtnWebYpos=70;
    
  //  NSInteger intImgViewXpos=220,intImgViewYpos=5;

    
//    NSInteger intlblFnoXpos=38,intbtnlblFnoYpos=130;
//    NSInteger intlblBnoXpos=130,intbtnlblBnoYpos=130;
//    NSInteger intlblTnoXpos=205,intbtnlblTnoYpos=130;
//    
//    NSInteger intlblFtxtXpos=38,intbtnlblFtxtYpos=155;
//    NSInteger intlblBtxtXpos=130,intbtnlblBtxtYpos=155;
//    NSInteger intlblThtxtXpos=205,intbtnlblThtxtYpos=155;
    
    
    int count = [_trendDataArray count];
    
    for (int iCount=1; iCount<=count; iCount++)
    {
        TrendsData *trendDetail=[_trendDataArray objectAtIndex:iCount - 1];
        viewMapContent=[[UIView alloc]initWithFrame:CGRectMake(intVXpos, intVYpos, 280, 130)];
        viewMapContent.backgroundColor=[UIColor whiteColor];

        asyInstagramImgView = [[AsyncImageView alloc] initWithFrame:CGRectMake(intVXpos, intVYpos, 280, 162)];
        asyInstagramImgView.alpha=0.7;
        asyInstagramImgView.tag = iCount;

        if ([trendDetail.photos_url count] > 0)
        {
            [asyInstagramImgView loadImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[trendDetail.photos_url objectAtIndex:0] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
        }
        else
        {
            UIImageView *noImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
            [noImgView setImage:[UIImage imageNamed:@"pinBlue.png"]];
            noImgView.layer.cornerRadius = 5.0;
            noImgView.layer.masksToBounds = YES;
            [asyInstagramImgView  addSubview:noImgView];
        }
        UIImageView *blackTransparentImgView = [[UIImageView alloc] initWithFrame:asyInstagramImgView.frame];
        blackTransparentImgView.backgroundColor = [UIColor blackColor];
        blackTransparentImgView.alpha = 0.7;


        UIImageView *noImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
        [noImgView setImage:[UIImage imageNamed:@""]]; // NO Images 
        noImgView.layer.cornerRadius = 5.0;
        noImgView.layer.masksToBounds = YES;
        [asyInstagramImgView  addSubview:noImgView];

        UIImageView *imgOpenCloseTopBand= [[UIImageView alloc] initWithFrame:CGRectMake(intVXpos + 199, intVYpos, 81, 49)];
        
        NSString *strOpenClose=[NSString stringWithFormat:@"%@",trendDetail.open_now];
        if ([strOpenClose isEqualToString:@"open"])
            [ imgOpenCloseTopBand setImage:[UIImage imageNamed:@"open.png"]];
        else
            [ imgOpenCloseTopBand setImage:[UIImage imageNamed:@"closed.png"]];

        intVXpos=intVXpos+320;

        //        imgViewShopBg=[[UIImageView alloc]initWithFrame:CGRectMake(intImgBgXpos, intImgBgYpos, 260, 200)];
        //        imgViewShopBg.image=[UIImage imageNamed:@"trendicon.png"];
        //        intImgBgXpos=intImgBgXpos+300;
        
//        lblShopname = [[UILabel alloc] initWithFrame:CGRectMake(intlblNameXpos, intlblNameYpos, 280, 22)];
//        lblShopname.textColor=[UIColor whiteColor];
//        lblShopname.text = trendDetail.formal_name;
//        lblShopname.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
//        lblShopname.textAlignment = NSTextAlignmentCenter;
//        intlblNameXpos=intlblNameXpos+320;
        
        btnShopname = [UIButton buttonWithType:UIButtonTypeCustom];
        btnShopname.frame=CGRectMake(intlblNameXpos, intlblNameYpos, 280, 22);
        [btnShopname setTitle: trendDetail.formal_name forState:UIControlStateNormal];
        btnShopname.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
        [btnShopname setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
        btnShopname.tag=iCount;
        [btnShopname addTarget:self action:@selector(trendName_Clicked:) forControlEvents:UIControlEventTouchUpInside];
        intlblNameXpos=intlblNameXpos+320;


        
      
        shopAddress = [[UILabel alloc] initWithFrame:CGRectMake(intlblAddXpos, intlblAddYpos, 280, 22)];
        shopAddress.textColor=[UIColor whiteColor];
        shopAddress.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
        shopAddress.text = trendDetail.address;
        shopAddress.textAlignment = NSTextAlignmentCenter;
        intlblAddXpos=intlblAddXpos+320;
        
        btnMapSelectNo=[UIButton buttonWithType:UIButtonTypeCustom];
        btnMapSelectNo.frame = CGRectMake(intbtnNoXpos, intbtnNoYpos, 45, 45);
        [btnMapSelectNo setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [btnMapSelectNo setImage:[UIImage imageNamed:@"Icons-CircleMapCard.png"] forState:UIControlStateNormal];
        btnMapSelectNo.backgroundColor = [UIColor clearColor];
        [btnMapSelectNo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
        intbtnNoXpos=intbtnNoXpos+320;
        
        
        lblMapSelectNo = [[UILabel alloc] initWithFrame:CGRectMake(intlblMapNoXpos, intlblMapNoYpos, 40, 40)];
        lblMapSelectNo.backgroundColor = [UIColor clearColor];
        lblMapSelectNo.textColor=[UIColor blackColor];
        [lblMapSelectNo setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20.0]];
        lblMapSelectNo.numberOfLines=0;
        lblMapSelectNo.textAlignment = NSTextAlignmentCenter;
        lblMapSelectNo.text = [NSString stringWithFormat:@"%d",iCount];
        intlblMapNoXpos=intlblMapNoXpos+320;
        
        
        btnMapPhone=[UIButton buttonWithType:UIButtonTypeCustom];
        btnMapPhone.frame = CGRectMake(intbtnPhoneXpos, intbtnPhoneYpos, 45, 45);
        [btnMapPhone setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [btnMapPhone setImage:[UIImage imageNamed:@"Icon-PhoneMapCard.png"] forState:UIControlStateNormal];
        btnMapPhone.backgroundColor = [UIColor clearColor];
        [btnMapPhone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
        [btnMapPhone addTarget:self action:@selector(phone_Clicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *lblcall = [[UILabel alloc] initWithFrame:CGRectMake(intbtnPhoneXpos, intbtnPhoneYpos + btnMapPhone.frame.size.height, 45, 32)];
        lblcall.textColor=[UIColor whiteColor];
        [lblcall setFont:[UIFont fontWithName:@"Helvetica" size:13.0]];
        lblcall.textAlignment = NSTextAlignmentCenter;
        lblcall.text = @"Call";
       
        intbtnPhoneXpos=intbtnPhoneXpos+320;

        btnMapShow=[UIButton buttonWithType:UIButtonTypeCustom];
        btnMapShow.frame = CGRectMake(intbtnMapXpos, intbtnMapYpos, 45, 45);
        [btnMapShow setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [btnMapShow setImage:[UIImage imageNamed:@"Icons-MapCard.png"] forState:UIControlStateNormal];
        btnMapShow.backgroundColor = [UIColor clearColor];
        [btnMapShow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
        [btnMapShow addTarget:self action:@selector(map_Clicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *lblMap = [[UILabel alloc] initWithFrame:CGRectMake(intbtnMapXpos, intbtnMapYpos + btnMapShow.frame.size.height, 45, 32)];
        lblMap.textColor=[UIColor whiteColor];
        [lblMap setFont:[UIFont fontWithName:@"Helvetica" size:13.0]];
        lblMap.textAlignment = NSTextAlignmentCenter;
        lblMap.text = @"Map";
       
        intbtnMapXpos=intbtnMapXpos+320;

        btnMapWeb=[UIButton buttonWithType:UIButtonTypeCustom];
        btnMapWeb.frame = CGRectMake(intbtnWebXpos, intbtnWebYpos, 45, 45);
        [btnMapWeb setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [btnMapWeb setImage:[UIImage imageNamed:@"Icons-websiteMapCard.png"] forState:UIControlStateNormal];
        btnMapWeb.backgroundColor = [UIColor clearColor];
        [btnMapWeb setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
        [btnMapWeb addTarget:self action:@selector(web_Clicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *lblWeb = [[UILabel alloc] initWithFrame:CGRectMake(intbtnWebXpos, intbtnWebYpos + btnMapWeb.frame.size.height, 45, 32)];
        lblWeb.textColor=[UIColor whiteColor];
        [lblWeb setFont:[UIFont fontWithName:@"Helvetica" size:13.0]];
        lblWeb.textAlignment = NSTextAlignmentCenter;
        lblWeb.text = @"Web";
        intbtnWebXpos=intbtnWebXpos+320;

        
        
       // [cellTrends.asynImgView  addSubview:noImgView];
        
//        lblFollowNo = [[UILabel alloc] initWithFrame:CGRectMake(intlblFnoXpos, intbtnlblFnoYpos, 70, 32)];
//        lblFollowNo.backgroundColor = [UIColor clearColor];
//        lblFollowNo.textColor=[UIColor blackColor];
//        [lblFollowNo setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0]];
//        lblFollowNo.numberOfLines=0;
//        lblFollowNo.textAlignment = NSTextAlignmentCenter;
//        lblFollowNo.text = trendDetail.followers_count;
//        intlblFnoXpos=intlblFnoXpos+320;
//        
//        lblBuddiesNo = [[UILabel alloc] initWithFrame:CGRectMake(intlblBnoXpos, intbtnlblBnoYpos, 65, 32)];
//        lblBuddiesNo.backgroundColor = [UIColor clearColor];
//        lblBuddiesNo.textColor=[UIColor blackColor];
//        [lblBuddiesNo setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0]];
//        lblBuddiesNo.numberOfLines=0;
//        lblBuddiesNo.textAlignment = NSTextAlignmentCenter;
//        lblBuddiesNo.text = @"0"; // Need to check Service 
//        intlblBnoXpos=intlblBnoXpos+320;
//        
//        lblThupNo = [[UILabel alloc] initWithFrame:CGRectMake(intlblTnoXpos, intbtnlblTnoYpos, 65, 32)];
//        lblThupNo.backgroundColor = [UIColor clearColor];
//        lblThupNo.textColor=[UIColor blackColor];
//        [lblThupNo setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0]];
//        lblThupNo.numberOfLines=0;
//        lblThupNo.textAlignment = NSTextAlignmentCenter;
//        if ([trendDetail.likers_count isEqualToString:@"(null)"] || [trendDetail.likers_count isEqualToString:@""]) {
//            lblThupNo.text = trendDetail.likers_count;
//        }
//        else  lblThupNo.text = @"0";
//        intlblTnoXpos=intlblTnoXpos+320;
//        
//        lblFollowTxt = [[UILabel alloc] initWithFrame:CGRectMake(intlblFtxtXpos, intbtnlblFtxtYpos, 70, 32)];
//        lblFollowTxt.backgroundColor = [UIColor clearColor];
//        lblFollowTxt.textColor=[UIColor blackColor];
//        [lblFollowTxt setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
//        lblFollowTxt.textAlignment = NSTextAlignmentCenter;
//        lblFollowTxt.text = @"Followers";
//        intlblFtxtXpos=intlblFtxtXpos+320;
//        
//        lblBuddiesTxt = [[UILabel alloc] initWithFrame:CGRectMake(intlblBtxtXpos, intbtnlblBtxtYpos, 70, 32)];
//        lblBuddiesTxt.backgroundColor = [UIColor clearColor];
//        lblBuddiesTxt.textColor=[UIColor blackColor];
//        [lblBuddiesTxt setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
//        lblBuddiesTxt.textAlignment = NSTextAlignmentCenter;
//        lblBuddiesTxt.text = @"Buddies";
//        intlblBtxtXpos=intlblBtxtXpos+320;
//        
//        lblThumbTxt = [[UILabel alloc] initWithFrame:CGRectMake(intlblThtxtXpos, intbtnlblThtxtYpos, 80, 32)];
//        lblThumbTxt.backgroundColor = [UIColor clearColor];
//        lblThumbTxt.textColor=[UIColor blackColor];
//        [lblThumbTxt setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
//        lblThumbTxt.textAlignment = NSTextAlignmentCenter;
//        lblThumbTxt.text = @"Thumbs Up";
//        intlblThtxtXpos=intlblThtxtXpos+320;
        
        
        [self.scrlViewBottomMap  addSubview:viewMapContent];
        [self.scrlViewBottomMap addSubview:asyInstagramImgView];

        [self.scrlViewBottomMap  addSubview:blackTransparentImgView];

        [self.scrlViewBottomMap  addSubview:btnShopname];
        [self.scrlViewBottomMap  addSubview:shopAddress];
        [self.scrlViewBottomMap  addSubview:btnMapSelectNo];
        [self.scrlViewBottomMap  addSubview:btnMapPhone];
        [self.scrlViewBottomMap  addSubview:btnMapShow];
        [self.scrlViewBottomMap  addSubview:btnMapWeb];
        
        [self.scrlViewBottomMap  addSubview:lblcall];
        [self.scrlViewBottomMap  addSubview:lblMap];
        [self.scrlViewBottomMap  addSubview:lblWeb];

        [self.scrlViewBottomMap  addSubview:imgOpenCloseTopBand];

//        [self.scrlViewBottomMap  addSubview:lblFollowNo];
//        [self.scrlViewBottomMap  addSubview:lblBuddiesNo];
//        [self.scrlViewBottomMap  addSubview:lblThupNo];
//        
//        [self.scrlViewBottomMap  addSubview:lblFollowTxt];
//        [self.scrlViewBottomMap  addSubview:lblBuddiesTxt];
//        [self.scrlViewBottomMap  addSubview:lblThumbTxt];
        
        [self.scrlViewBottomMap addSubview: lblMapSelectNo];
    }
    [self.view addSubview:self.viewBottomMap];
    [self.view addSubview:self.viewUpDown];

    [self.scrlViewBottomMap setContentSize:CGSizeMake(intVXpos,200)];
}

/*
-(void)tapDetected:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"%d", [gestureRecognizer view].tag);
    NSArray *latlng = [locationDetailArray objectAtIndex:[gestureRecognizer view].tag - 1];
    
    NSLog(@"iCount = %f, %f",[[latlng objectAtIndex:0] doubleValue],[[latlng objectAtIndex:1] doubleValue]);
    
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake([[latlng objectAtIndex:0] doubleValue], [[latlng objectAtIndex:1] doubleValue]);
    
    [theMapView setCenterCoordinate:centerCoordinate zoomLevel:13 animated:YES];

    TrendsData *TrendsObj=[_trendDataArray objectAtIndex:[gestureRecognizer view].tag - 1];
    
    trendsDetailsViewController *trendsDetailsVC_obj=[[trendsDetailsViewController alloc]initWithNibName:@"trendsDetailsViewController" bundle:nil];
    
    trendsDetailsVC_obj.currentLocation= centerCoordinate;
    
    trendsDetailsVC_obj.destLocation= CLLocationCoordinate2DMake([[TrendsObj.locationLatLngGlobalList objectAtIndex:0] doubleValue], [[TrendsObj.locationLatLngGlobalList objectAtIndex:1] doubleValue]);
    
    trendsDetailsVC_obj.placeId = TrendsObj.id_trend;
    
    [self.navigationController pushViewController:trendsDetailsVC_obj animated:YES];
}
*/


#pragma mark --=============Button actions Methodds===========
-(IBAction)trendName_Clicked:(UIButton *)sender
{
    UIButton *btnNameTag=(UIButton *)sender;
    
    NSArray *latlng = [locationDetailArray objectAtIndex:btnNameTag.tag - 1];
    
    NSLog(@"iCount = %f, %f",[[latlng objectAtIndex:0] doubleValue],[[latlng objectAtIndex:1] doubleValue]);
    
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake([[latlng objectAtIndex:0] doubleValue], [[latlng objectAtIndex:1] doubleValue]);
    
    [theMapView setCenterCoordinate:centerCoordinate zoomLevel:13 animated:YES];
    
    TrendsData *TrendsObj=[_trendDataArray objectAtIndex:btnNameTag.tag - 1];
    
    trendsDetailsViewController *trendsDetailsVC_obj=[[trendsDetailsViewController alloc]initWithNibName:@"trendsDetailsViewController" bundle:nil];
    trendsDetailsVC_obj.selectedOption=1;
    
    trendsDetailsVC_obj.currentLocation= centerCoordinate;
    
    trendsDetailsVC_obj.destLocation= CLLocationCoordinate2DMake([[TrendsObj.locationLatLngGlobalList objectAtIndex:0] doubleValue], [[TrendsObj.locationLatLngGlobalList objectAtIndex:1] doubleValue]);
    
    trendsDetailsVC_obj.placeId = TrendsObj.id_trend;
    
    [self.navigationController pushViewController:trendsDetailsVC_obj animated:YES];

    
}
-(IBAction)phone_Clicked:(id)sender;
{
    NSString *number = [selectedTrendDetail.phone_number stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"number===%@",number);
    
    if ([number length]>0)
    {
        NSString *phoneNumber = [@"Call " stringByAppendingString:number];
        UIAlertView  *alertCall=[[UIAlertView alloc]initWithTitle:@"ALERT" message:phoneNumber  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        [alertCall show];

    }
    else
    {
        // no number
    }
}

-(IBAction)map_Clicked:(id)sender
{
    [self openDirectionUrl];
    
    NSLog(@"direcction url====%@",selectedTrendDetail.website_url);
}
-(IBAction)web_Clicked:(id)sender
{
    [self openRemoteUrl:selectedTrendDetail.website_url];
    
    NSLog(@"websiteBtnClicked url====%@",selectedTrendDetail.website_url);
}

-(void)openRemoteUrl:(NSString *)urlString
{
    BOOL result = [[urlString lowercaseString] hasPrefix:@"http://"];
    
    if (!result)
    {
        urlString = [NSString stringWithFormat:@"http://%@", urlString];
    }
    [MTPopupWindow showWindowWithHTMLFile:urlString insideView:self.view];
}

-(void)openDirectionUrl
{
    NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",
                     currentLocation.latitude, currentLocation.longitude,
                     destLocation.latitude, destLocation.longitude];
    
    [MTPopupWindow showWindowWithHTMLFile:url insideView:self.view];
}


#pragma mark UIScrollViewDelegate Method

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!isAnnotationSelected)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(selectObject:) object:scrollView];
        
        [self performSelector:@selector(selectObject:) withObject:scrollView afterDelay:0.3];
    }
}

-(void)selectObject:(UIScrollView *)scrollView
{
    int contentOffsetX = scrollView.contentOffset.x/320;
    
    selectedTrendDetail=[_trendDataArray objectAtIndex:contentOffsetX];

    contentOffsetX = contentOffsetX + 1;
    
    NSLog(@"scrollView = %d",contentOffsetX);
    
    for (int iCount = 1; iCount <= [annotationViewArray count]; iCount++)
    {
        MKAnnotationView *annotationView = [annotationViewArray objectAtIndex:iCount - 1];
            

        if (iCount == contentOffsetX) {
            
            NSArray *latlng = [locationDetailArray objectAtIndex:iCount - 1];
            
            NSLog(@"iCount = %f, %f",[[latlng objectAtIndex:0] doubleValue],[[latlng objectAtIndex:1] doubleValue]);

            destLocation= CLLocationCoordinate2DMake([[latlng objectAtIndex:0] doubleValue],[[latlng objectAtIndex:1] doubleValue]);

            CLLocationCoordinate2D newCenter = CLLocationCoordinate2DMake(annotationView.annotation.coordinate.latitude, annotationView.annotation.coordinate.longitude );

            [theMapView setCenterCoordinate:newCenter animated:YES];


            CGRect resizeRect;
            resizeRect.size = CGSizeMake(50, 50); //flagImage.size;
            CGSize maxSize = CGRectInset(self.view.bounds,
                                         [MapViewController annotationPadding],
                                         [MapViewController annotationPadding]).size;
            maxSize.height -= self.navigationController.navigationBar.frame.size.height + [MapViewController calloutHeight];
            if (resizeRect.size.width > maxSize.width)
                resizeRect.size = CGSizeMake(maxSize.width, resizeRect.size.height / resizeRect.size.width * maxSize.width);
            if (resizeRect.size.height > maxSize.height)
                resizeRect.size = CGSizeMake(resizeRect.size.width / resizeRect.size.height * maxSize.height, maxSize.height);
            
            resizeRect.origin = CGPointMake(0.0, 0.0);
            UIGraphicsBeginImageContext(resizeRect.size);
            if (iCount == contentOffsetX) {
                [[UIImage imageNamed:@"mapcircle.png"] drawInRect:CGRectMake(resizeRect.origin.x , resizeRect.origin.y , 50, 50)];
            }
            resizeRect.size = CGSizeMake(25, 40); //flagImage.size; pinBlue.png

            resizeRect.origin = CGPointMake(12.0, 10.0);
            [[UIImage imageNamed:@"pinBlue.png"] drawInRect:resizeRect];
            resizeRect.origin = CGPointMake(12.0, 15.0);
            NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            [style setAlignment:NSTextAlignmentCenter];
            NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
            [attributes setObject:[UIFont boldSystemFontOfSize:12] forKey:NSFontAttributeName];
            [attributes setObject:style forKey:NSParagraphStyleAttributeName];
            [attributes setObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
            
            [[NSString stringWithFormat:@"%d",iCount] drawInRect:resizeRect withAttributes:attributes];
            
            UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            annotationView.image=resizedImage;

        }
        else
        {
            CGRect resizeRect;
            resizeRect.size = CGSizeMake(25, 40); //flagImage.size;
            CGSize maxSize = CGRectInset(self.view.bounds,
                                         [MapViewController annotationPadding],
                                         [MapViewController annotationPadding]).size;
            maxSize.height -= self.navigationController.navigationBar.frame.size.height + [MapViewController calloutHeight];
            if (resizeRect.size.width > maxSize.width)
                resizeRect.size = CGSizeMake(maxSize.width, resizeRect.size.height / resizeRect.size.width * maxSize.width);
            if (resizeRect.size.height > maxSize.height)
                resizeRect.size = CGSizeMake(resizeRect.size.width / resizeRect.size.height * maxSize.height, maxSize.height);
            
            resizeRect.origin = CGPointMake(0.0, 0.0);
            UIGraphicsBeginImageContext(resizeRect.size);
            [[UIImage imageNamed:@"pnRed.png"] drawInRect:resizeRect];
            
            resizeRect.origin = CGPointMake(0.0, 5.0);
            NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            [style setAlignment:NSTextAlignmentCenter];
            NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
            [attributes setObject:[UIFont boldSystemFontOfSize:12] forKey:NSFontAttributeName];
            [attributes setObject:style forKey:NSParagraphStyleAttributeName];
            [attributes setObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
            
            [[NSString stringWithFormat:@"%d",iCount] drawInRect:resizeRect withAttributes:attributes];
            UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            annotationView.image = resizedImage;

        }
        
    }
    isAnnotationSelected = NO;
}

#pragma mark =======Map Annotation Part=============

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKOverlayView* overlayView = nil;
    MKPolylineView  * _routeLineView = [[MKPolylineView alloc] initWithPolyline:routeLine] ;
    _routeLineView.fillColor = [UIColor redColor];
    _routeLineView.strokeColor = [UIColor redColor];
    _routeLineView.lineWidth = 3;
    _routeLineView.lineCap = kCGLineCapRound;
    overlayView = _routeLineView;
    return overlayView;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{    
    static NSString *SFAnnotationIdentifier = @"SFAnnotationIdentifier";
    
	 if ([annotation isKindOfClass:[SFAnnotation class]])   // for City of San Francisco
    {
        MKAnnotationView *annotationView = [theMapView dequeueReusableAnnotationViewWithIdentifier:SFAnnotationIdentifier];
        
        if (!annotationView)
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:SFAnnotationIdentifier];
            annotationView.canShowCallout = NO;
        }
        
            int index = [theMapView.annotations indexOfObject:annotation];
            index = index + 1;
            NSLog(@"yourIndex = %d",(int)index);
            
        UIImage *flagImage = [UIImage imageNamed:@"pnRed.png"];//[NSString stringWithFormat:@"%d.png",(int)index%9]];
            
            // size the flag down to the appropriate size
            CGRect resizeRect;
            resizeRect.size = CGSizeMake(25, 40); //flagImage.size;
            CGSize maxSize = CGRectInset(self.view.bounds,
                                         [MapViewController annotationPadding],
                                         [MapViewController annotationPadding]).size;
            maxSize.height -= self.navigationController.navigationBar.frame.size.height + [MapViewController calloutHeight];
            if (resizeRect.size.width > maxSize.width)
                resizeRect.size = CGSizeMake(maxSize.width, resizeRect.size.height / resizeRect.size.width * maxSize.width);
            if (resizeRect.size.height > maxSize.height)
                resizeRect.size = CGSizeMake(resizeRect.size.width / resizeRect.size.height * maxSize.height, maxSize.height);
            
            resizeRect.origin = CGPointMake(0.0, 0.0);
            UIGraphicsBeginImageContext(resizeRect.size);
            [flagImage drawInRect:resizeRect];
        
            resizeRect.origin = CGPointMake(0.0, 5.0);
            NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            [style setAlignment:NSTextAlignmentCenter];
            NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
            [attributes setObject:[UIFont boldSystemFontOfSize:12] forKey:NSFontAttributeName];
            [attributes setObject:style forKey:NSParagraphStyleAttributeName];
            [attributes setObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];

            [[NSString stringWithFormat:@"%d",index] drawInRect:resizeRect withAttributes:attributes];
            UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            annotationView.image = resizedImage;
            annotationView.opaque = NO;
           UIImageView *sfIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]]; // Pop img check pnRed.png
            annotationView.leftCalloutAccessoryView = sfIconView;
            
            // offset the flag annotation so that the flag pole rests on the map coordinate
            annotationView.centerOffset = CGPointMake( annotationView.centerOffset.x + annotationView.image.size.width/2, annotationView.centerOffset.y - annotationView.image.size.height/2 );
        
            [annotationViewArray addObject:annotationView];
        
            return annotationView;

    }
    else
    {
        return nil;
    }
}
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
//	for (MKAnnotationView *anAnnotationView in views) {
//		[anAnnotationView setCanShowCallout:YES];
//		[anAnnotationView addObserver:self
//                           forKeyPath:@"selected"
//                              options:NSKeyValueObservingOptionNew
//						      context:(__bridge void *)(ANNOTATION_SELECTED_DESELECTED)];
//	}
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    NSString *action = (__bridge NSString *)context;
	if ([action isEqualToString:ANNOTATION_SELECTED_DESELECTED]) {
		BOOL annotationSelected = [[change valueForKey:@"new"] boolValue];
		if (annotationSelected) {
			NSLog(@"Annotation was selected, do whatever required");
            CGRect resizeRect;
            resizeRect.size = CGSizeMake(25, 40); //flagImage.size;
            CGSize maxSize = CGRectInset(self.view.bounds,
                                         [MapViewController annotationPadding],
                                         [MapViewController annotationPadding]).size;
            maxSize.height -= self.navigationController.navigationBar.frame.size.height + [MapViewController calloutHeight];
            if (resizeRect.size.width > maxSize.width)
                resizeRect.size = CGSizeMake(maxSize.width, resizeRect.size.height / resizeRect.size.width * maxSize.width);
            if (resizeRect.size.height > maxSize.height)
                resizeRect.size = CGSizeMake(resizeRect.size.width / resizeRect.size.height * maxSize.height, maxSize.height);
            
            resizeRect.origin = CGPointMake(0.0, 0.0);
            UIGraphicsBeginImageContext(resizeRect.size);
            
            resizeRect.origin = CGPointMake(0.0, 5.0);
            NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            [style setAlignment:NSTextAlignmentCenter];
            NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
            [attributes setObject:[UIFont boldSystemFontOfSize:12] forKey:NSFontAttributeName];
            [attributes setObject:style forKey:NSParagraphStyleAttributeName];
            [attributes setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
            [[NSString stringWithFormat:@"%d",deselectedIndex] drawInRect:resizeRect withAttributes:attributes];

            [[UIImage imageNamed:@"pinBlue.png"] drawInRect:resizeRect];
            UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();

            ((MKPinAnnotationView*) object).image=resizedImage;
		}else {
			NSLog(@"Annotation was deselected, do what you must");

		}
	}
}



- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
}

//- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
//    NSLog(@"%f",[mapView getZoomLevel]);
//    if([mapView getZoomLevel]<10) {
//        [mapView setCenterCoordinate:[mapView centerCoordinate] zoomLevel:10
//                            animated:NO];
//    }
//}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    int index = [theMapView.annotations indexOfObject:view.annotation];
    
    selectedTrendDetail=[_trendDataArray objectAtIndex:index];

    NSArray *latlng = [locationDetailArray objectAtIndex:index];

    destLocation = CLLocationCoordinate2DMake([[latlng objectAtIndex:0] doubleValue],[[latlng objectAtIndex:1] doubleValue]);

    index = index + 1;
    deselectedIndex = index;
    
    isAnnotationSelected = YES;
    
    NSLog(@"deselectedIndex = %d",deselectedIndex);
    
    CGRect resizeRect;
    resizeRect.size = CGSizeMake(50, 50); //flagImage.size;
    CGSize maxSize = CGRectInset(self.view.bounds,
                                 [MapViewController annotationPadding],
                                 [MapViewController annotationPadding]).size;
    maxSize.height -= self.navigationController.navigationBar.frame.size.height + [MapViewController calloutHeight];
    if (resizeRect.size.width > maxSize.width)
        resizeRect.size = CGSizeMake(maxSize.width, resizeRect.size.height / resizeRect.size.width * maxSize.width);
    if (resizeRect.size.height > maxSize.height)
        resizeRect.size = CGSizeMake(resizeRect.size.width / resizeRect.size.height * maxSize.height, maxSize.height);
    
    resizeRect.origin = CGPointMake(0.0, 0.0);
    UIGraphicsBeginImageContext(resizeRect.size);
    resizeRect.origin = CGPointMake(12.0, 10.0);
    resizeRect.size = CGSizeMake(25, 40); //flagImage.size;
    
    [[UIImage imageNamed:@"pinBlue.png"] drawInRect:resizeRect];
    
    resizeRect.origin = CGPointMake(12.0, 15.0);
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    [attributes setObject:[UIFont boldSystemFontOfSize:12] forKey:NSFontAttributeName];
    [attributes setObject:style forKey:NSParagraphStyleAttributeName];
    [attributes setObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    [[NSString stringWithFormat:@"%d",deselectedIndex] drawInRect:resizeRect withAttributes:attributes];

    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    view.image=resizedImage;
    
    [_scrlViewBottomMap setContentOffset:CGPointMake(_scrlViewBottomMap.contentOffset.x, _scrlViewBottomMap.contentOffset.y)];
    [self OpenViewAnimations];
    [UIView animateWithDuration:0.5 delay:0
                        options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear
                     animations:^{
                         isAnnotationSelected = NO;
                         [_scrlViewBottomMap setContentOffset:CGPointMake((deselectedIndex - 1) * 320, _scrlViewBottomMap.contentOffset.y)];
                     }
                     completion:nil];


}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    int index = [theMapView.annotations indexOfObject:view.annotation];
    index = index + 1;
    deselectedIndex = index;
    
    isAnnotationSelected = NO;
    
    CGRect resizeRect;
    resizeRect.size = CGSizeMake(25, 40); //flagImage.size;
    CGSize maxSize = CGRectInset(self.view.bounds,
                                 [MapViewController annotationPadding],
                                 [MapViewController annotationPadding]).size;
    maxSize.height -= self.navigationController.navigationBar.frame.size.height + [MapViewController calloutHeight];
    if (resizeRect.size.width > maxSize.width)
        resizeRect.size = CGSizeMake(maxSize.width, resizeRect.size.height / resizeRect.size.width * maxSize.width);
    if (resizeRect.size.height > maxSize.height)
        resizeRect.size = CGSizeMake(resizeRect.size.width / resizeRect.size.height * maxSize.height, maxSize.height);
    
    resizeRect.origin = CGPointMake(0, 0);
    UIGraphicsBeginImageContext(resizeRect.size);
    [[UIImage imageNamed:@"pnRed.png"] drawInRect:resizeRect];
    
    resizeRect.origin = CGPointMake(0.0, 5.0);
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    [attributes setObject:[UIFont boldSystemFontOfSize:12] forKey:NSFontAttributeName];
    [attributes setObject:style forKey:NSParagraphStyleAttributeName];
    [attributes setObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    [[NSString stringWithFormat:@"%d",deselectedIndex] drawInRect:resizeRect withAttributes:attributes];

    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    view.image=resizedImage;
}
- (void)viewDidUnload
{
    [self setTheMapView:nil];
    theMapView.delegate = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

+(id)checkForNull:(id)value
{
    NSString *valueString = [NSString stringWithFormat:@"%@",value];
    
    id objectString = @"";
    
    if (![valueString isEqualToString:@"(null)"] && ![valueString isEqualToString:@"<null>"] && valueString.length != 0)
        return value;
    
    return objectString;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
@end

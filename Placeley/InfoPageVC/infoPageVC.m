//
//  infoPageVC.m
//  Placeley
//
//  Created by Krishnan Ziggma on 3/1/14.
//  Copyright (c) 2014 APR. All rights reserved.
//

#import "infoPageVC.h"

@interface infoPageVC ()

@end

@implementation infoPageVC

@synthesize scrollView;
@synthesize pageControl;

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
    [self setNeedsStatusBarAppearanceUpdate];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    
    [self setupPageControl];
    
    if (IS_IPHONE_5)
    {
        self.pageControl.frame=CGRectMake(140, 524, 30, 30);
        viewBottom.frame=CGRectMake(0,518, 320, 52);
        
    }
    else
    {
        self.pageControl.frame=CGRectMake(140, 530, 30, 30);
        viewBottom.frame=CGRectMake(0,520, 320, 52);

    }
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    
}
- (void)setupPageControl
{
    arrImages=[[NSMutableArray alloc]initWithObjects:@"infotrendingmap1.png",@"infomapTrends3.png",@"infoSocialpage4.png",@"infoFollowing5.png",@"infoActivity6.png",@"infoThanks7.png",nil];
    
    for (int i = 0; i < [arrImages count]; i++)
    {

        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        
        imageView = [[UIImageView alloc] initWithFrame:frame];
       // imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.image = [UIImage imageNamed:[arrImages objectAtIndex:i]];
        
        [self.scrollView addSubview:imageView];
	}
    
   
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [arrImages count], scrollView.frame.size.height);

}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
      if(self.pageControl.currentPage==5)
      {
          btnNext.hidden=YES;
          
      }
    if(self.pageControl.currentPage<5)
    {
        btnNext.hidden=NO;
        
    }
    [self feedBackbtnCreare];
    
       // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}


-(void)feedBackbtnCreare
{
    if(self.pageControl.currentPage==5)
    {
        imageView.userInteractionEnabled=YES;
        self.scrollView.userInteractionEnabled=YES;
        UIButton *btnFeedBack = [UIButton buttonWithType:UIButtonTypeCustom];
        btnFeedBack.frame=CGRectMake(10, 280, 280, 30);
        [btnFeedBack addTarget:self action:@selector(btnFeedback_Clicked:) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:btnFeedBack];
    }

}

-(IBAction)btnFeedback_Clicked:(id)sender
{
    NSLog(@"btnFeedback_Clicked");
    
    [self sendMail];
    
}

-(void)sendMail
{
    if([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController* mailer = [[MFMailComposeViewController alloc] init];
        NSString* to = @"feedback@placeley.com";
        [mailer setToRecipients:[NSArray arrayWithObject:to]];
        [mailer setSubject:@"Feedback"];
        [mailer setMessageBody:@"" isHTML:NO];
        mailer.mailComposeDelegate = self;
        [self presentViewController:mailer animated:YES completion:nil];
        
    }
    else
    {
        NSLog(@"Can't send mail");
    }
}

#pragma mark MFMailComposeViewControllerDelegate

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result
                       error:(NSError *)error
{
    if (result == MFMailComposeResultSent) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Message"
                                                     message:@"Mail sent sucessfully!"
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)btnNext_Clicked:(id)sender
{
    [self feedBackbtnCreare];

        int page = self.pageControl.currentPage;
    page=page+1;

    if(page==5)
    {
        imageView.userInteractionEnabled=YES;
        self.scrollView.userInteractionEnabled=YES;
        UIButton *btnFeedBack = [UIButton buttonWithType:UIButtonTypeCustom];
        btnFeedBack.frame=CGRectMake(10, 280, 280, 30);
        [btnFeedBack addTarget:self action:@selector(btnFeedback_Clicked:) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:btnFeedBack];
        
    }
    [self.scrollView setContentOffset:CGPointMake(page*320, self.scrollView.frame.origin.y)];
    
    
    if (page==5)
    {
        btnNext.hidden=YES;
        
    }
    
    
}
-(IBAction)btnSkip_Clicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  ComposeMsgVC.m
//  Placeley
//
//  Created by APR on 1/15/14.
//  Copyright (c) 2014 APR. All rights reserved.
//

#import "ComposeMsgVC.h"
#import "AppDelegate.h"

@interface ComposeMsgVC ()
{
    AppDelegate *appDelegate;
}
@end

@implementation ComposeMsgVC

@synthesize viewMain,viewSubMenu,viewValidDate;

@synthesize txtViewMsg;

@synthesize txtFldToName;

@synthesize txtFldToAddress;

@synthesize scrollView;

@synthesize trendDetail;

@synthesize updateButton, dealButton, eventButton;

@synthesize lblValidForm,lblValidTo,btnFromDate,btnToDate;

@synthesize lineimageView;

@synthesize borderlineimageView;

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
    
    
    UIImageWriteToSavedPhotosAlbum([UIImage imageNamed:@"Instgram_icon.png"], nil, nil, nil);
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    selectedOption = 1;
    
    txtFldToName.text = @"Wildlife Conservation Network"; //trendDetail.pre_name;
    
    txtFldToAddress.text = @"25745 Bassett Lane, Los Altos Hills, CA, United States";// trendDetail.address;
    
    [updateButton setTitleColor:[UIColor colorWithRed:36/255.0 green:186.0/255.0 blue:248.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    updateButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    dealButton.titleLabel.font = [UIFont systemFontOfSize:15];
    eventButton.titleLabel.font = [UIFont systemFontOfSize:15];

    imagePicker =[[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    
    datePicker=[[UIDatePicker alloc]init];
    
    lblValidForm.hidden=YES;
    btnFromDate.hidden=YES;
    lblValidFromTxt.hidden=YES;
    lineimageView.hidden = YES;
    lblValidToTxt.hidden=YES;
    btnToDate.hidden = YES;
    lblValidTo.hidden = YES;
    
    borderlineimageView.frame=CGRectMake(102,borderlineimageView.frame.origin.y, borderlineimageView.frame.size.width,borderlineimageView.frame.size.height);

    txtViewMsg.text = @"Compose message here";
    txtViewMsg.textColor = [UIColor lightGrayColor];

    [[txtViewMsg layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[txtViewMsg layer] setBorderWidth:2];
    [[txtViewMsg layer] setCornerRadius:5];

    [[viewMain layer] setCornerRadius:5];

    // ios 7 Status bar
    
    [self setNeedsStatusBarAppearanceUpdate];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    // Do any additional setup after loading the view from its nib.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(IBAction)btn_Back_Clicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)btn_UpdateClicked:(id)sender
{
    // txtFldMsg.frame=CGRectMake(20,0,250, 50);
    selectedOption = 1;
    
    [updateButton setTitleColor:[UIColor colorWithRed:36/255.0 green:186.0/255.0 blue:248.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [dealButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [eventButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

   
    txtViewMsg.hidden=NO;
    lblValidForm.hidden=YES;
    btnFromDate.hidden=YES;
    lblValidFromTxt.hidden=YES;
    lineimageView.hidden = YES;
    lblValidToTxt.hidden=YES;
    btnToDate.hidden = YES;
    lblValidTo.hidden = YES;

    viewMain.frame=CGRectMake(8,viewMain.frame.origin.y, viewMain.frame.size.width,viewMain.frame.size.height);
    borderlineimageView.frame=CGRectMake(102,borderlineimageView.frame.origin.y, borderlineimageView.frame.size.width,borderlineimageView.frame.size.height);
    
    scrollView.hidden=NO;
    
    viewValidDate.hidden=NO;
    
    updateButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    dealButton.titleLabel.font = [UIFont systemFontOfSize:15];
    eventButton.titleLabel.font = [UIFont systemFontOfSize:15];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    txtViewMsg.frame=CGRectMake(txtViewMsg.frame.origin.x, 10,txtViewMsg.frame.size.width,197);
    [UIView commitAnimations];

}

-(IBAction)btn_dealClicked:(id)sender
{
    selectedOption = 2;

    [dealButton setTitleColor:[UIColor colorWithRed:36/255.0 green:186.0/255.0 blue:248.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [updateButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [eventButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

    dealButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    updateButton.titleLabel.font = [UIFont systemFontOfSize:15];
    eventButton.titleLabel.font = [UIFont systemFontOfSize:15];

    viewMain.frame=CGRectMake(viewMain.frame.origin.x,viewMain.frame.origin.y, viewMain.frame.size.width,viewMain.frame.size.height);
    borderlineimageView.frame=CGRectMake(169,borderlineimageView.frame.origin.y, borderlineimageView.frame.size.width,borderlineimageView.frame.size.height);

    lblValidForm.hidden=NO;
    btnFromDate.hidden=NO;
    lblValidFromTxt.hidden=NO;
    lineimageView.hidden = NO;
    lblValidToTxt.hidden=NO;
    btnToDate.hidden = NO;
    lblValidTo.hidden = NO;


    viewValidDate.hidden=NO;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    txtViewMsg.frame=CGRectMake(txtViewMsg.frame.origin.x, 115,txtViewMsg.frame.size.width,95);
    [UIView commitAnimations];

}

-(IBAction)btn_EventClicked:(id)sender
{
    selectedOption = 3;
    
    eventButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    dealButton.titleLabel.font = [UIFont systemFontOfSize:15];
    updateButton.titleLabel.font = [UIFont systemFontOfSize:15];

    [eventButton setTitleColor:[UIColor colorWithRed:36/255.0 green:186.0/255.0 blue:248.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [dealButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [updateButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

    viewMain.frame=CGRectMake(viewMain.frame.origin.x,viewMain.frame.origin.y, viewMain.frame.size.width,viewMain.frame.size.height);
    
    borderlineimageView.frame=CGRectMake(230,borderlineimageView.frame.origin.y, borderlineimageView.frame.size.width,borderlineimageView.frame.size.height);

    //txtFldMsg.frame=CGRectMake(16,110,250, 50);
    lblValidForm.hidden=NO;
    btnFromDate.hidden=NO;
    viewValidDate.hidden=NO;
    lblValidFromTxt.hidden=NO;
    lineimageView.hidden = NO;
    lblValidToTxt.hidden=NO;
    btnToDate.hidden = NO;
    lblValidTo.hidden = NO;

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    txtViewMsg.frame=CGRectMake(txtViewMsg.frame.origin.x, 115,txtViewMsg.frame.size.width,95);
    [UIView commitAnimations];

}

-(IBAction)btnValidFrom_Clicked:(id)sender
{
    [self openDatePicker];
    strPickerCheck=@"ValidFrom";
    
    
}

-(IBAction)btnValidTo_Clicked:(id)sender

{
    [self openDatePicker];
    strPickerCheck=@"ValidTo";

    
    
}
#pragma mark -
#pragma mark Instance Methods

-(void)openDatePicker
{
    [datePicker setFrame:CGRectMake(0, 40, 0, 0)];
    datePicker.datePickerMode = UIDatePickerModeDate;

    [self.view addSubview:datePicker];
    actionSheetPicker = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                              cancelButtonTitle:nil
                         destructiveButtonTitle:nil
                              otherButtonTitles:nil];
    actionSheetPicker.delegate=nil;
    [actionSheetPicker setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    [actionSheetPicker addSubview:datePicker];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    view.backgroundColor = [UIColor colorWithRed:19/255.0 green:125/255.0 blue:193/255.0 alpha:1.0];
    [actionSheetPicker addSubview:view];

    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [pickerToolbar setTranslucent:YES];
    //[pickerToolbar setBarStyle:UIBarStyleDefault];
    [pickerToolbar setBackgroundImage:[UIImage new]
                  forToolbarPosition:UIBarPositionAny
                          barMetrics:UIBarMetricsDefault];
    [pickerToolbar setShadowImage:[UIImage new]
              forToolbarPosition:UIToolbarPositionAny];

    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *cancelbtn = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(CancelClicked:)];
    [cancelbtn setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    [barItems addObject:cancelbtn];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems addObject:flexSpace];
    UIBarButtonItem *Done_btn=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DoneClicked:)];
    [Done_btn setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    [barItems addObject:Done_btn];
    [pickerToolbar setItems:barItems animated:YES];
    [actionSheetPicker addSubview:pickerToolbar];
    
    [actionSheetPicker showInView:[[UIApplication sharedApplication] keyWindow]];
    [actionSheetPicker setBounds:CGRectMake(0, 0, 320, 485)];
}

-(void)DoneClicked:(id)sender
{
    if ([strPickerCheck isEqualToString:@"ValidFrom"])
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy/MM/dd"];
        lblValidForm.text = [NSString stringWithFormat:@"%@",
                             [df stringFromDate:datePicker.date]];
        lblValidForm.textColor = [UIColor colorWithRed:36/255.0 green:186.0/255.0 blue:248.0/255.0 alpha:1.0];
        [actionSheetPicker dismissWithClickedButtonIndex:0 animated:YES];
    }
    
    if ([strPickerCheck isEqualToString:@"ValidTo"])
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy/MM/dd"];
        lblValidTo.text = [NSString stringWithFormat:@"%@",
                             [df stringFromDate:datePicker.date]];
        lblValidTo.textColor = [UIColor colorWithRed:36/255.0 green:186.0/255.0 blue:248.0/255.0 alpha:1.0];

        [actionSheetPicker dismissWithClickedButtonIndex:0 animated:YES];
    }
    
}

-(void)CancelClicked:(id)sender
{
    [actionSheetPicker dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)LabelChange:(id)sender
{
	
}
-(IBAction)btn_PostClicked:(id)sender
{
    if ((_imageView.image) && (![txtViewMsg.text isEqualToString:@""]))
    {
        NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/image.jpg"];
        UIImage *img = _imageView.image;// [UIImage imageNamed:@"icon.png"];
        
        
        // Write a UIImage to JPEG with minimum compression (best quality)
        [UIImageJPEGRepresentation(img, 0.5) writeToFile:jpgPath atomically:YES];
        
        NSString *photoPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/image.jpg"];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://zuppl.com/photos"]];
        //[request setPostValue:@"Hi uploading photo" forKey:@"data"];
        [request setFile:photoPath forKey:@"file"];
        [request setDidFinishSelector:@selector(sendToServerPhotosFinished:)];
        [request setDelegate:self];
        [request startSynchronous];

    }
    else if ((![txtViewMsg.text isEqualToString:@""]))
    {
        NSMutableDictionary *originalDictionary = [[NSMutableDictionary alloc] init];
        
        [originalDictionary setValue:@"user" forKey:@"posted_by"];
        if (selectedOption == 1)
            [originalDictionary setValue:@"update" forKey:@"post_type"];
        if (selectedOption == 2)
            [originalDictionary setValue:@"deal" forKey:@"post_type"];
        if (selectedOption == 3)
            [originalDictionary setValue:@"event" forKey:@"post_type"];

        [originalDictionary setValue:@"" forKey:@"starts_at"];
        [originalDictionary setValue:@"" forKey:@"ends_at"];
        [originalDictionary setValue:txtViewMsg.text forKey:@"body"];
        [originalDictionary setValue:@"0" forKey:@"share_on_facebook"];
        [originalDictionary setValue:@"0" forKey:@"share_on_twitter"];
        
        SBJsonWriter *jsonWriter = [SBJsonWriter new];
        
        NSString *jsonString = [jsonWriter stringWithObject:originalDictionary];
        
        [ServiceHelper postComment:jsonString andPlaceId:trendDetail.place_id andAuthToken:appDelegate.currentLoggedInUser.auth_token];
    }
    else
    {
        UIAlertView *alertCall=[[UIAlertView alloc]initWithTitle:@"ALERT" message:@"Oops..looks like you've missed out to enter the text!"  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        [alertCall show];
    }
}

- (void)sendToServerPhotosFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    
    NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]
                                                             options:0 error:NULL];
    
    NSMutableArray *responseIdArray = [[NSMutableArray alloc] init];
    
    for (int iCount = 0; iCount < [responseArray count]; iCount++) {
        NSMutableDictionary *responseDictionary = [[NSMutableDictionary alloc] initWithDictionary:[responseArray objectAtIndex:iCount]];
        [responseIdArray addObject:[responseDictionary objectForKey:@"id"]];
    }
    
   // [responseIdArray addObject:@"5310c0bc49c88af284000001"];
    
    NSLog(@"responseIdArray = %@",responseIdArray);
    
    NSMutableDictionary *originalDictionary = [[NSMutableDictionary alloc] init];
    
    [originalDictionary setValue:@"user" forKey:@"posted_by"];
    if (selectedOption == 1)
        [originalDictionary setValue:@"update" forKey:@"post_type"];
    if (selectedOption == 2)
        [originalDictionary setValue:@"deal" forKey:@"post_type"];
    if (selectedOption == 3)
        [originalDictionary setValue:@"event" forKey:@"post_type"];
    [originalDictionary setValue:@"" forKey:@"starts_at"];
    [originalDictionary setValue:@"" forKey:@"ends_at"];
    [originalDictionary setValue:txtViewMsg.text forKey:@"body"];
    [originalDictionary setValue:@"0" forKey:@"share_on_facebook"];
    [originalDictionary setValue:@"0" forKey:@"share_on_twitter"];
    [originalDictionary setValue:responseIdArray forKey:@"photo_ids"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    
    NSString *jsonString = [jsonWriter stringWithObject:originalDictionary];
    
   // [ServiceHelper postCommentToImage:jsonString andPlaceId:trendDetail.place_id andAuthToken:appDelegate.currentLoggedInUser.auth_token];
    
}


-(IBAction)btnCamera_Clicked:(id)sender
{
    UIAlertView *alertWatsApp = [[UIAlertView alloc]
                                 initWithTitle:@"Image Post"
                                 message:@""
                                 delegate:self
                                 cancelButtonTitle:@"Cancel"
                                 otherButtonTitles:@"Use Camera", @"Use Photo Library", nil];
    [alertWatsApp show];
    alertWatsApp.tag=5252;
    
}

- (void)useCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
        _newMedia = YES;
    }
}

- (void)useCameraRoll
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
        _newMedia = NO;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 5252)
    {
        if (buttonIndex==0)
        {
            NSLog(@"0");
            
        }
        if(buttonIndex==1)
        {
            NSLog(@"1");
            [self useCamera];
            
        }
        if (buttonIndex==2)
        {
            NSLog(@"2");

            [self useCameraRoll];
            
        }
    }
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        _imageView.image = image;
        if (_newMedia)
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Code here to support video if enabled
    }
}

-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}
#pragma mark - TextField Delegates



//- (void)textFieldDidBeginEditing:(UITextField *)textField;
//{
//    [self pushViewUpDown:230 andHeight:166];
//}
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
//{
//    return YES;
//}
//// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
//
//- (void)textFieldDidEndEditing:(UITextField *)textField;
//{
//    [self pushViewUpDown:439 andHeight:64];
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField;
//{
//    [textField resignFirstResponder];
//    return YES;
//}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (selectedOption == 1)
    {
        [self pushViewUpDown:230 andHeight:74];
    }
    else if (selectedOption == 2)
    {
        [self pushViewUpDown:-154 andHeight:74];
    }
    else if (selectedOption == 3)
    {
        [self pushViewUpDown:-154 andHeight:74];
    }
    txtViewMsg.text = @"";
    txtViewMsg.textColor = [UIColor blackColor];

}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (selectedOption == 1)
    {
        [self pushViewUpDown:439 andHeight:197];
    }
    else if (selectedOption == 2)
    {
        [self pushViewUpDown:64 andHeight:74];
    }
    else if (selectedOption == 3)
    {
        [self pushViewUpDown:64 andHeight:74];
    }

    if(txtViewMsg.text.length == 0){
        txtViewMsg.textColor = [UIColor lightGrayColor];
        txtViewMsg.text = @"Compose message here";
        [txtViewMsg resignFirstResponder];
    }
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(txtViewMsg.text.length == 0){
        txtViewMsg.textColor = [UIColor lightGrayColor];
        txtViewMsg.text = @"Compose message here";
        [txtViewMsg resignFirstResponder];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(void)pushViewUpDown:(int)y andHeight:(int)height
{
    if (selectedOption == 1)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3f];
        txtViewMsg.frame=CGRectMake(txtViewMsg.frame.origin.x, txtViewMsg.frame.origin.y,txtViewMsg.frame.size.width,height);
        viewSubMenu.frame=CGRectMake(viewSubMenu.frame.origin.x, y,viewSubMenu.frame.size.width,viewSubMenu.frame.size.height);
        [UIView commitAnimations];
    }
    else if (selectedOption == 2)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3f];
        viewMain.frame=CGRectMake(txtViewMsg.frame.origin.x, y,viewMain.frame.size.width,viewMain.frame.size.height);
        [UIView commitAnimations];
    }
    else if (selectedOption == 3)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3f];
        viewMain.frame=CGRectMake(txtViewMsg.frame.origin.x, y,viewMain.frame.size.width,viewMain.frame.size.height);
        [UIView commitAnimations];
    }

}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

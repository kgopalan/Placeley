//
//  ComposeMsgVC.h
//  Placeley
//
//  Created by APR on 1/15/14.
//  Copyright (c) 2014 APR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "ServiceHelper.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"


@class TPKeyboardAvoidingScrollView;

@interface ComposeMsgVC : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,
UINavigationControllerDelegate>
{
    UIImagePickerController *imagePicker;
    
    IBOutlet TPKeyboardAvoidingScrollView *scrollView;

    IBOutlet UIButton *btnFromDate, *btnToDate;
    
    IBOutlet UIButton *updateButton, *dealButton, *eventButton;

    IBOutlet UILabel *lblValidForm,*lblValidFromTxt, *lblValidTo,*lblValidToTxt;

    int selectedOption;
    
    NSString *strPickerCheck;
    
    ShowDetail *trendDetail;
    
    UIDatePicker *datePicker;
    
    UIActionSheet *actionSheetPicker;

}
@property BOOL newMedia;

@property (nonatomic , retain) ShowDetail *trendDetail;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property(nonatomic,strong)IBOutlet UIView *viewMain,*viewSubMenu,*viewValidDate;

@property(nonatomic,strong)IBOutlet UITextField *txtFldToName;

@property(nonatomic,strong)IBOutlet UITextField *txtFldToAddress;

@property(nonatomic,strong)IBOutlet UITextView *txtViewMsg;

@property (nonatomic, retain) IBOutlet TPKeyboardAvoidingScrollView *scrollView;

@property (nonatomic, strong) IBOutlet UIButton *btnFromDate, *btnToDate;

@property (nonatomic, strong) IBOutlet UILabel *lblValidForm, *lblValidTo;

@property (nonatomic, retain) IBOutlet UIButton *updateButton, *dealButton, *eventButton;

@property (strong, nonatomic) IBOutlet UIImageView *lineimageView;

@property (strong, nonatomic) IBOutlet UIImageView *borderlineimageView;


-(IBAction)btn_Back_Clicked:(id)sender;
- (void)useCamera;
- (void)useCameraRoll;


-(IBAction)btn_UpdateClicked:(id)sender;
-(IBAction)btn_dealClicked:(id)sender;
-(IBAction)btn_EventClicked:(id)sender;
-(IBAction)btn_PostClicked:(id)sender;

@end

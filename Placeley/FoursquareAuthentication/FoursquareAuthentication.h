//
//  FoursquareAuthentication.h
//  foursquaredemo
//
//  Created by Keith Elliott on 4/18/13.
//  Copyright (c) 2013 gittielabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface FoursquareAuthentication : UIViewController<UIWebViewDelegate>
{
    AppDelegate *appDelegate;
    UIButton *foursquareCancel;
}
@end

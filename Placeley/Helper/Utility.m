//
//  Utility.m
//  NYStateSnowmobiling
//
//  Created by Ed Elliott on 12/4/11.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+ (NSDate *)getDateFromJSONDate:(NSString *)jsonDate
{
	NSDate *date = nil;
	
	@try 
	{
		NSString *inputString = jsonDate;
		
        NSInteger milliseconds;
        
        if ([inputString length] != 0)
        {
            if ([inputString length] != 0)
            {
                milliseconds = [[inputString substringWithRange:NSMakeRange(16, 3)] intValue];
              
                date = [[NSDate dateWithTimeIntervalSince1970:
						 [[inputString substringWithRange:NSMakeRange(6, 10)] intValue]]
						dateByAddingTimeInterval:milliseconds / 1000];
            }
        }
		static NSDateFormatter *dateFormatter = nil;
		
		if (dateFormatter == nil) 
		{
			dateFormatter = [[NSDateFormatter alloc] init];
            
			[dateFormatter setDateStyle:NSDateFormatterShortStyle];
            
			[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
			
			NSString *fourDigitYearFormat = [[dateFormatter dateFormat]
											 stringByReplacingOccurrencesOfString:@"yy"
											 withString:@"yyyy"];
			
			[dateFormatter setDateFormat:fourDigitYearFormat];
		}
	}
	@catch (NSException *exception) 
	{
		date = nil;
	}
	@finally 
	{
		return date;
	}
}

void double2Ints(double f, int p, long long *i, long long *d)
{ 
	long long   li; 
	int   prec=1;
	
	for(int x=p;x>0;x--) 
	{
		prec*=10;
	};  // same as power(10,p)
	
	li = (long long) f;              // get integer part
	*d = (int) ((f-li)*prec);  // get decimal part
	*i = li;
}

+(NSDate *)convertToLocalTimeZone:(NSString *)myString
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *createDate = [formatter dateFromString:myString] ;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *pacificTime = [NSTimeZone timeZoneWithName:@"America/Los_Angeles"];
    
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    
    [dateComps setCalendar:gregorian];
    
    [dateFormatter setDateFormat:@"yyyy"];

    [dateComps setYear:[[dateFormatter stringFromDate:createDate] intValue]];
    
    [dateFormatter setDateFormat:@"MM"];

    [dateComps setMonth:[[dateFormatter stringFromDate:createDate] intValue]];

    [dateFormatter setDateFormat:@"dd"];

    [dateComps setDay:[[dateFormatter stringFromDate:createDate] intValue]];
    
    [dateComps setTimeZone:pacificTime];

    [dateFormatter setDateFormat:@"HH"];

    [dateComps setHour:[[dateFormatter stringFromDate:createDate] intValue]];

    [dateFormatter setDateFormat:@"mm"];

    [dateComps setMinute:[[dateFormatter stringFromDate:createDate] intValue]];

    [dateFormatter setDateFormat:@"ss"];

    [dateComps setSecond:[[dateFormatter stringFromDate:createDate] intValue]];
    
    NSDate *dateOfKeynote = [dateComps date];
    
    return dateOfKeynote;
}

+ (UIStoryboard *)getCurrentStoryBoardObject
{
    BOOL iPad = NO;

    UIStoryboard *mainStoryboard = nil;

#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
    if (iPad)
    {
        // iPad specific code here
        mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle: nil];
    }
    else
    {
        // iPhone/iPod specific code here
        mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle: nil];
    }
    return mainStoryboard;
}

+(NSString *)getCurrentDateasPSTString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"PST"]];
    
    NSString *timeStamp = [dateFormatter stringFromDate:[NSDate date]];
    
    return timeStamp;
}


@end

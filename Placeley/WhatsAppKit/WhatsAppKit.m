//
//  WhatsAppKit.m
//  WhatsAppKitDemo
//
//  Created by Fawkes Wei on 7/18/13.
//  Copyright (c) 2013 Fawkes Wei. All rights reserved.
//

#import "WhatsAppKit.h"
#import "NSString+WhatsAppKit.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#define kCONST_PREFIX @"whatsapp://"

@implementation WhatsAppKit

+ (BOOL)isWhatsAppInstalled {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:kCONST_PREFIX]];
}

+ (void)launchWhatsApp {
    [WhatsAppKit launchWhatsAppWithMessage:nil];
}

+ (void)launchWhatsAppWithMessage:(NSString *)message {
    
//    NSMutableArray *contactList=[[NSMutableArray alloc] init];
//    CFErrorRef err;
//    ABAddressBookRef m_addressbook = ABAddressBookCreateWithOptions(NULL, &err);
//    
//    if (!m_addressbook) {
//        NSLog(@"opening address book");
//    }
//    
//    ABRecordID selectedrecordID;
//    
//    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(m_addressbook);
//    CFIndex nPeople = ABAddressBookGetPersonCount(m_addressbook);
//    
//    for (int i=0;i < nPeople;i++) {
//        NSMutableDictionary *dOfPerson=[NSMutableDictionary dictionary];
//        
//        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople,i);
//        
//        ABRecordID recordID = ABRecordGetRecordID(ref);
//        NSLog(@"recordID = %d",recordID);
//
//        //For username and surname
//        ABMultiValueRef phones =(__bridge ABMultiValueRef)((__bridge NSString*)ABRecordCopyValue(ref, kABPersonPhoneProperty));
//        CFStringRef firstName;
//        firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
//        [dOfPerson setObject:[NSString stringWithFormat:@"%@", firstName] forKey:@"name"];
//        
//        if ([[NSString stringWithFormat:@"%@", firstName] isEqualToString:@"Poomalai"])
//        {
//            selectedrecordID = recordID;
//        }
////        //For Email ids
////        ABMutableMultiValueRef eMail  = ABRecordCopyValue(ref, kABPersonEmailProperty);
////        if(ABMultiValueGetCount(eMail) > 0) {
////            [dOfPerson setObject:(__bridge NSString *)ABMultiValueCopyValueAtIndex(eMail, 0) forKey:@"email"];
////            
////        }
////        
////        //For Phone number
////        NSString* mobileLabel;
////        for(CFIndex i = 0; i < ABMultiValueGetCount(phones); i++) {
////            mobileLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phones, i);
////            if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel])
////            {
////                [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:@"Phone"];
////            }
////            else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel])
////            {
////                [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:@"Phone"];
////                break ;
////            }
////            
////            [contactList addObject:dOfPerson];
////        }
//    }
//    NSLog(@"selectedrecordID is %d",selectedrecordID);
//
//    [WhatsAppKit launchWhatsAppWithAddressBookId:selectedrecordID-1 andMessage:message];
    
    [WhatsAppKit launchWhatsAppWithAddressBookId:-1 andMessage:message];

}

+ (void)launchWhatsAppWithAddressBookId:(int)addressBookId {
    [WhatsAppKit launchWhatsAppWithAddressBookId:addressBookId andMessage:nil];
}

+ (void)launchWhatsAppWithAddressBookId:(int)addressBookId andMessage:(NSString *)message {
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@send?", kCONST_PREFIX];
    
    if (addressBookId > 0) {
        [urlString appendFormat:@"abid=%d&", addressBookId];
    }
    
    if ([message length] != 0) {
        [urlString appendFormat:@"text=%@&", [message urlEncode]];
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

@end

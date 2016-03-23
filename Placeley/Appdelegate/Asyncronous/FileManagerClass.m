//
//  FileManagerClass.m
//  MWPhotoBrowser
//
//  Created by HB13 on 23/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FileManagerClass.h"
#import <CommonCrypto/CommonDigest.h>

@implementation FileManagerClass

+(NSString *)KeyGenerationForUrl:(NSString *)StringUrl
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *str_path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ImageCache"] ;
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:str_path])
	{
		[[NSFileManager defaultManager] createDirectoryAtPath:str_path
								  withIntermediateDirectories:YES
												   attributes:nil
														error:NULL];
	}
	
	const char *str = [StringUrl UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
	return filename;
}
+(BOOL)isCachedAlready:(NSString *)StringUrl
{
	if ([[NSFileManager defaultManager] fileExistsAtPath:[self getPath:StringUrl]])
	{
		return YES;
	}
	else {
		return NO;
	}
	return NO;
}
+(UIImage *)getCacheImage:(NSString *)stringUrl
{
	UIImage *img = [UIImage imageWithContentsOfFile:[self getPath:stringUrl]];
	return img;
}
+(BOOL)AddImagesToResourceFolder:(UIImage *)image withName:(NSString *)stingUrl
{
	if (![[NSFileManager defaultManager] fileExistsAtPath:[self getPath:stingUrl]])
	{
		NSData *dataObj = UIImagePNGRepresentation(image);
		[dataObj writeToFile:[self getPath:stingUrl] atomically:YES];
	}
	return YES;
}
+(NSString *)getPath:(NSString *)StringUrl
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *str_path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ImageCache"] ;
	str_path = [str_path stringByAppendingPathComponent:[[self KeyGenerationForUrl:StringUrl] stringByAppendingString:@".png"]];
	return str_path;
}
+(void)removeFileAtpath:(NSString *)StringUrl
{
	[[NSFileManager defaultManager] removeItemAtPath:[self getPath:StringUrl] error:nil];
}
@end

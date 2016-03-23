//
//  FileManagerClass.h
//  MWPhotoBrowser
//
//  Created by HB13 on 23/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FileManagerClass : NSObject {

}
+(NSString *)getPath:(NSString *)StringUrl;
+(UIImage *)getCacheImage:(NSString *)stringUrl;
+(NSString *)KeyGenerationForUrl:(NSString *)StringUrl; 
+(BOOL)isCachedAlready:(NSString *)StringUrl;
+(BOOL)AddImagesToResourceFolder:(UIImage *)image withName:(NSString *)stingUrl;
+(void)removeFileAtpath:(NSString *)StringUrl;
@end

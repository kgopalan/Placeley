//
//  AsyncImageView.m
//  YellowJacket
//
//  Created by Wayne Cochran on 7/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AsyncImageView.h"
#import "ImageCacheObject.h"
#import "ImageCache.h"
#import <QuartzCore/QuartzCore.h>
#import "FileManagerClass.h"
//
// Key's are URL strings.
// Value's are ImageCacheObject's
//
static ImageCache *imageCache = nil;

@implementation AsyncImageView

@synthesize imageView;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (void)dealloc {
    [connection cancel];
    [connection release];
    [data release];
    [super dealloc];
}
/*
-(void)loadImageFromimage:(UIImage *)image
{

    UIImageView *imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
    CALayer *l = [imageView layer];
    l.masksToBounds = YES;
    //l.cornerRadius = 10.0;
    l.borderWidth = 1.0;
    l.borderColor = [[UIColor whiteColor] CGColor];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.autoresizingMask =
    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:imageView];
    imageView.frame = self.bounds;
    
    [imageView setNeedsLayout];
    [self setNeedsLayout];
}
 */

-(void)loadImageFromURL:(NSURL*)url {
    if (connection != nil) {
        [connection cancel];
        [connection release];
        connection = nil;
    }
    if (data != nil) {
        [data release];
        data = nil;
    }
    
	UIActivityIndicatorView *actiVityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
	actiVityIndicator.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2); 
	[actiVityIndicator startAnimating];
	//[actiVityIndicator setHidesWhenStopped:YES];
	[self addSubview:actiVityIndicator];
//	[actiVityIndicator release];
    if (imageCache == nil) // lazily create image cache
        imageCache = [[ImageCache alloc] initWithMaxSize:4*1024*1024];  // 2 MB Image cache*/
    
    [urlString release];
    urlString = [[url absoluteString] copy];
    
    UIImage *cachedImage = [imageCache imageForKey:urlString];
    if (cachedImage != nil) {
        if ([[self subviews] count] > 0) {
            [[[self subviews] objectAtIndex:0] removeFromSuperview];
        }
        imageView = [[[UIImageView alloc] initWithImage:[imageCache imageForKey:urlString]] autorelease];
        imageView.backgroundColor=[UIColor clearColor];

        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.autoresizingMask = 
            UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:imageView];
        if (imageView.image==nil)
        {
            [imageView setImage:[UIImage imageNamed:@"1.png"]];
        }
        imageView.frame = self.bounds;
        [imageView setNeedsLayout]; // is this necessary if superview gets setNeedsLayout?
        [self setNeedsLayout];
		
        return;
	}
	
	else {
//		UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lite_bg.png"]] autorelease];
//        imageView.layer.cornerRadius=5.0;
//		CALayer *l = [imageView layer];
//		l.masksToBounds = YES;
//		//l.cornerRadius = 10.0;
//		l.borderWidth = 1.0;
//		l.borderColor = [[UIColor whiteColor] CGColor];
//		imageView.contentMode = UIViewContentModeScaleToFill;
//		imageView.autoresizingMask =
//		UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//		[self addSubview:imageView];
//		imageView.frame = self.bounds;
//
//		[imageView setNeedsLayout];
//		[self setNeedsLayout];
	}
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url 
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                         timeoutInterval:60.0];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection 
    didReceiveData:(NSData *)incrementalData {
    if (data==nil) {
        data = [[NSMutableData alloc] initWithCapacity:2048];
    }
    [data appendData:incrementalData];
}

+(UIImage *)getCacheImage:(NSString *)stringUrl
{
	UIImage *img = [UIImage imageWithContentsOfFile:[self getPath:stringUrl]];
	return img;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {
    [connection release];
    connection = nil;
    
    if ([[self subviews] count] > 0) {
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }
    if(data!=nil){
		UIImage *image = [UIImage imageWithData:data];

		[imageCache insertImage:image withSize:[data length] forKey:urlString];
		if([[NSUserDefaults standardUserDefaults] boolForKey:@"isCacheNeeded"])
			[FileManagerClass AddImagesToResourceFolder:image withName:urlString];
		UIImageView *imageView1 = [[UIImageView alloc] initWithImage:nil];
        imageView1.image=image;
        imageView1.backgroundColor=[UIColor clearColor];
        if (imageView1.image==nil)
        {
            imageView1.image=[UIImage imageNamed:@"1.png"];
        }
		imageView1.contentMode = UIViewContentModeScaleToFill;
		imageView1.autoresizingMask =
			UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

		[self addSubview:imageView1];

		imageView1.frame = self.bounds;
		[imageView1 setNeedsLayout]; // is this necessary if superview gets setNeedsLayout?
		[self setNeedsLayout];
		
	}else {
		UIImage *image = [UIImage imageNamed:@"1.png"];
		UIImageView *imageView1 = [[[UIImageView alloc]
								   initWithImage:image] autorelease];
		imageView1.contentMode = UIViewContentModeScaleToFill;
		imageView1.autoresizingMask =
		UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self addSubview:imageView1];
		imageView1.frame = self.bounds;
		[imageView1 setNeedsLayout]; // is this necessary if superview gets setNeedsLayout?
		[self setNeedsLayout];
	}
    [data release];
    data = nil;
}

/*
-(void)setCacheImage:(UIImage*)imageForAsyncImageView
{
	UIImageView *imageView = [[[UIImageView alloc] 
							   initWithImage:imageForAsyncImageView] autorelease];
	imageView.contentMode = UIViewContentModeScaleToFill;
	imageView.autoresizingMask = 
	UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self addSubview:imageView];
	imageView.frame = self.bounds;
	[imageView setNeedsLayout]; // is this necessary if superview gets setNeedsLayout?
	[self setNeedsLayout];
}
*/
/*
- (UIImage *)scaleAndRotateImage:(UIImage *)imgPic {
	
	int kMaxResolution = 640; // Or whatever	
    CGImageRef imgRef = imgPic.CGImage;	
    CGFloat width = CGImageGetWidth(imgRef);	
    CGFloat height = CGImageGetHeight(imgRef);	
    CGAffineTransform transform = CGAffineTransformIdentity;	
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {		
        CGFloat ratio = width/height;		
        if (ratio > 1) {			
            bounds.size.width = kMaxResolution;			
            bounds.size.height = roundf(bounds.size.width / ratio);			
        }		
        else {			
            bounds.size.height = kMaxResolution;			
            bounds.size.width = roundf(bounds.size.height * ratio);			
        }		
    }	
    CGFloat scaleRatio = bounds.size.width / width;	
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));	
    CGFloat boundHeight;	
    UIImageOrientation orient = imgPic.imageOrientation;	
    switch(orient) {			
        case UIImageOrientationUp: //EXIF = 1			
            transform = CGAffineTransformIdentity;			
            break;			
        case UIImageOrientationUpMirrored: //EXIF = 2			
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);			
            transform = CGAffineTransformScale(transform, -1.0, 1.0);			
            break;			
        case UIImageOrientationDown: //EXIF = 3			
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);			
            transform = CGAffineTransformRotate(transform, M_PI);			
            break;			
        case UIImageOrientationDownMirrored: //EXIF = 4			
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
			
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
			
            break;
			
        case UIImageOrientationLeftMirrored: //EXIF = 5
			
            boundHeight = bounds.size.height;
			
            bounds.size.height = bounds.size.width;
			
            bounds.size.width = boundHeight;
			
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
			
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
			
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			
            break;
			
        case UIImageOrientationLeft: //EXIF = 6
			
            boundHeight = bounds.size.height;
			
            bounds.size.height = bounds.size.width;
			
            bounds.size.width = boundHeight;
			
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
			
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			
            break;
			
        case UIImageOrientationRightMirrored: //EXIF = 7
			
            boundHeight = bounds.size.height;
			
            bounds.size.height = bounds.size.width;
			
            bounds.size.width = boundHeight;
			
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
			
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			
            break;
			
        case UIImageOrientationRight: //EXIF = 8
			
            boundHeight = bounds.size.height;
			
            bounds.size.height = bounds.size.width;
			
            bounds.size.width = boundHeight;
			
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
			
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			
            break;
			
        default:
			
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
			
    }
	
    UIGraphicsBeginImageContext(bounds.size);
	
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
		
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
		
        CGContextTranslateCTM(context, -height, 0);
		
    }
	
    else {
		
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
		
        CGContextTranslateCTM(context, 0, -height);
		
    }
	
    CGContextConcatCTM(context, transform);
	
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
	
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
	
    UIGraphicsEndImageContext();
	
    return imageCopy;
	
}
*/ 

@end

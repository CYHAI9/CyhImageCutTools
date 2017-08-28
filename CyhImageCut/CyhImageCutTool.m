//
//  CyhImageCutTool.m
//  CyhHImageCut
//
//  Created by 陈海哥 on 2017/8/23.
//  Copyright © 2017年 陈海哥. All rights reserved.
//

#import "CyhImageCutTool.h"

@implementation CyhImageCutTool

+ (void)AddImage:(UIImage *)oImage setImageCutFrame:(CGRect)cutFrame comple:(void (^)(UIImage *))CompleResult
{
    CompleResult([self DivisionImage_Rect:cutFrame OriginalImage:oImage]);
}


+ (UIImage *)DivisionImage_Rect:(CGRect)rect OriginalImage:(UIImage *)OriginalImage
{
    CGRect cropRect = rect;
    CGImageRef imgRef = CGImageCreateWithImageInRect(OriginalImage.CGImage, cropRect);
    
    CGFloat deviceScale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(cropRect.size, 0, deviceScale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, cropRect.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextDrawImage(context, CGRectMake(0, 0, cropRect.size.width, cropRect.size.height), imgRef);
    
    CGContextSetInterpolationQuality(context,kCGInterpolationHigh);
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRelease(imgRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end

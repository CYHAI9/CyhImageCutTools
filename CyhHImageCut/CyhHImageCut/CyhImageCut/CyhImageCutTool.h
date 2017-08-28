//
//  CyhImageCutTool.h
//  CyhHImageCut
//
//  Created by 陈海哥 on 2017/8/23.
//  Copyright © 2017年 陈海哥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CyhImageCutTool : NSObject

+ (void)AddImage:(UIImage *)oImage setImageCutFrame:(CGRect)cutFrame comple:(void(^)(UIImage * finishImage))CompleResult;

@end

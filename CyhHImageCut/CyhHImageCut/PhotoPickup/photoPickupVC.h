//
//  photoPickupVC.h
//  CyhHImageCut
//
//  Created by 陈海哥 on 2017/9/22.
//  Copyright © 2017年 陈海哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol photoPickupVCDelegate

- (void)photoPickImage:(UIImage *)photo;

@end

@interface photoPickupVC : UIViewController

@property (nonatomic , weak)id<photoPickupVCDelegate> photoPdelegate;

@end

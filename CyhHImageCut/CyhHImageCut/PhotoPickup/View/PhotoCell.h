//
//  PhotoCell.h
//  CyhHImageCut
//
//  Created by 陈海哥 on 2017/9/22.
//  Copyright © 2017年 陈海哥. All rights reserved.
//

// 对于约束参数可以省去"mas_"
#define MAS_SHORTHAND
// 对于默认的约束参数自动装箱
#define MAS_SHORTHAND_GLOBALS
//消除循环引用
#define Weak_selft(weakSelf) __weak __typeof(&*self)weakSelf = self

#import <UIKit/UIKit.h>

@interface PhotoCell : UICollectionViewCell

@property (nonatomic , strong)UIImage * photoImage;
@property (nonatomic , strong)UIImageView * photoImageview;

@end

@interface AlvumCell : UICollectionViewCell
@property (nonatomic , strong)UIImageView * photoImageview;
@property (nonatomic , strong)UILabel * alvumLabel;
@end

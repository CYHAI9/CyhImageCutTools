//
//  PhotoCell.m
//  CyhHImageCut
//
//  Created by 陈海哥 on 2017/9/22.
//  Copyright © 2017年 陈海哥. All rights reserved.
//

#import "PhotoCell.h"
@interface PhotoCell ()


@end

@implementation PhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        [self setupUI];
    }
    
    return self;
}


- (UIImageView *)photoImageview
{
    if (!_photoImageview) {
        _photoImageview = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    
    return _photoImageview;
    
}

- (void)setupUI
{
    [self.contentView addSubview:self.photoImageview];
    self.photoImageview.frame = self.contentView.frame;
    _photoImageview.contentMode = UIViewContentModeScaleAspectFill;
    _photoImageview.clipsToBounds = YES;
}

- (UIImage *)photoImage
{
    if (!_photoImage) {
    
        _photoImage = [UIImage imageNamed:@"03.png"];
    }
    
    return _photoImage;
}

@end

@implementation AlvumCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        [self setupUI];
    }
    
    return self;
}


- (UIImageView *)photoImageview
{
    if (!_photoImageview) {
        _photoImageview = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    
    return _photoImageview;
    
}

- (UILabel *)alvumLabel
{
    if (!_alvumLabel) {
        _alvumLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    return _alvumLabel;
}

- (void)setupUI
{
    [self.contentView addSubview:self.photoImageview];
    [self.contentView addSubview:self.alvumLabel];
    self.photoImageview.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.width);
    self.alvumLabel.frame = CGRectMake(0, 0, self.contentView.frame.size.width + 10, 30);
    _photoImageview.contentMode = UIViewContentModeTop|UIViewContentModeBottom|UIViewContentModeLeft|UIViewContentModeRight;
}

@end


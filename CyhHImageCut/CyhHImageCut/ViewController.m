//
//  ViewController.m
//  CyhHImageCut
//
//  Created by 陈海哥 on 2017/8/23.
//  Copyright © 2017年 陈海哥. All rights reserved.
//

#import "ViewController.h"
#import "CyhImageCutview.h"
#import "ViewController02.h"
#import "photoPickupVC.h"
@interface ViewController ()<photoPickupVCDelegate>

@property (nonatomic , strong)UIImage * cutimage;
@property (nonatomic , strong) CyhImageCutview * ImageCutview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(&*self) weakSelf = self;
    self.ImageCutview = [[CyhImageCutview alloc] init];
  UIView * view = [self.ImageCutview setView_cutViewWithImage:[UIImage imageNamed:@"01.jpg"] addSuperclassView:self.view PinScale:3.0 complet:^(UIImage *Cutimage) {
      
      weakSelf.cutimage = Cutimage;
      NSLog(@"新图片：%@",Cutimage);
      ViewController02 * vc02 = [ViewController02 new];
      vc02.newimage = Cutimage;
      [weakSelf.navigationController pushViewController:vc02 animated:YES];
    }];
    
    [self.view addSubview:view];
    
    
}
- (IBAction)pickImage:(id)sender {
    photoPickupVC * pvc = [photoPickupVC new];
    pvc.photoPdelegate = self;
    [self.navigationController pushViewController:pvc animated:YES];
    
}

- (void)photoPickImage:(UIImage *)photo
{
    self.ImageCutview.NewOimage = photo;
}

- (IBAction)ToVc2:(id)sender {
    
    [self.ImageCutview sureCutImage];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

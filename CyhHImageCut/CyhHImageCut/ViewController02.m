//
//  ViewController02.m
//  CyhHImageCut
//
//  Created by 陈海哥 on 2017/8/24.
//  Copyright © 2017年 陈海哥. All rights reserved.
//

#import "ViewController02.h"

@interface ViewController02 ()

@end

@implementation ViewController02

- (void)viewDidLoad {
    [super viewDidLoad];
  
    UIImageView * imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    [self.view addSubview:imageview];
    imageview.image = self.newimage;
    imageview.center = self.view.center;
}


- (void)dealloc
{
    NSLog(@"注销");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

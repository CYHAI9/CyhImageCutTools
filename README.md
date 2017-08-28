# CyhImageCutTools
pod 'CyhimageCutTool'

#import <CyhImageCutview.h>

添加裁剪视图

      UIView * view = [self.ImageCutview setView_cutViewWithImage:[UIImage imageNamed:@"SH02.png"] addSuperclassView:self.view 
      
      PinScale:2.0 complet:^(UIImage *Cutimage) {
       
       weakSelf.cutimage = Cutimage;
       
       NSLog(@"新图片：%@",Cutimage);
       
       ViewController02 * vc02 = [ViewController02 new];
        
        vc02.newimage = Cutimage;
       
       [weakSelf.navigationController pushViewController:vc02 animated:YES];
      
      }];
       
      
裁剪响应事件

     [self.ImageCutview sureCutImage];
       

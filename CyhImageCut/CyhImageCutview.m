//
//  CyhImageCutview.m
//  CyhHImageCut
//
//  Created by 陈海哥 on 2017/8/23.
//  Copyright © 2017年 陈海哥. All rights reserved.
//

#import "CyhImageCutview.h"
#import "CyhImageCutTool.h"

@interface CyhImageCutview ()<UIGestureRecognizerDelegate>

@property (nonatomic , strong)UIImageView * Bgimageview;
@property (nonatomic , strong)UIImage * Oimage;
@property (nonatomic , strong)UIImageView * Cutview;
@property (nonatomic , strong)UIView * maskView;
@property (nonatomic , assign)CGFloat imageScale;
@property (nonatomic, assign) CGFloat totalScale;
@property (nonatomic , strong)UIPinchGestureRecognizer * pinchGestureRecognizer;
@property (nonatomic , strong)UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic,assign) double translateX;
@property (nonatomic,assign) double translateY;

@property (nonatomic , assign)CGFloat imagePinScale;
@property (nonatomic , assign)CGFloat cutImageScale;
@property (nonatomic , assign)CGFloat cutX;
@property (nonatomic , assign)CGFloat cutY;

@property (nonatomic , copy)void(^cutCompletBL)(UIImage * newimage);

@end

@implementation CyhImageCutview
{
    CGFloat minX,minY,maxX,maxY,imgViewMaxX,imgViewMaxY;
}
- (UIImageView *)Bgimageview
{
    if (!_Bgimageview) {
        _Bgimageview = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _Bgimageview;
}

- (UIImageView *)Cutview
{
    if (!_Cutview) {
        _Cutview = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    
    return _Cutview;
}

- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectZero];
        _maskView.backgroundColor= [UIColor blackColor];
        _maskView.alpha= 0.7;
    }
    return _maskView;
}

BOOL isCan;
- (instancetype)setView_cutViewWithImage:(UIImage *)Oimage addSuperclassView:(UIView *)Spview complet:(void (^)(UIImage *))resultComplet
{
    
    CGFloat oimagescale = Oimage.size.width/Oimage.size.height;
    if (!Oimage) {
        oimagescale = 1.0;
#ifdef DEBUG
        NSLog(@"照片不存在");
#endif
    }
    self.Oimage = Oimage;
    self.backgroundColor = [UIColor blackColor];
    self.totalScale = 1.0;
    self.frame = Spview.frame;
    self.maskView.frame = Spview.frame;
    self.imageScale = oimagescale;
    self.Bgimageview.frame = CGRectMake(0, 0, Spview.frame.size.width,Spview.frame.size.width/oimagescale);
    self.Cutview.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
    self.Cutview.image = [UIImage imageNamed:@"mask.png"];
    [self addmaskView:self.maskView SetFrame:CGRectMake(0,self.frame.size.height/2.0 - self.frame.size.width/2.0, self.frame.size.width,self.frame.size.width)];
    
    self.Bgimageview.image = Oimage;
    self.Bgimageview.center = Spview.center;
    self.Cutview.center =  self.Bgimageview.center;
    self.pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    self.Bgimageview.userInteractionEnabled = YES;
    self.Cutview.userInteractionEnabled = YES;
    self.userInteractionEnabled = YES;
    [self.Cutview addGestureRecognizer:self.panGestureRecognizer];
    [self.Cutview addGestureRecognizer:self.pinchGestureRecognizer];
    self.pinchGestureRecognizer.delegate = self;
    [self addSubview:self.Bgimageview];
    [self addSubview:self.maskView];
    [self addSubview: self.Cutview];

    minX= CGRectGetMinX(self.Cutview.frame);
    minY= CGRectGetMinY(self.Cutview.frame);
    maxX= CGRectGetMaxX(self.Cutview.frame);
    maxY= CGRectGetMaxY(self.Cutview.frame);
    //=================
    self.imagePinScale = 1/(self.frame.size.width/Oimage.size.width);
    self.cutImageScale = self.imagePinScale;
    if (oimagescale >= 1.0) {
        self.cutX = self.Cutview.center.x - self.Bgimageview.frame.size.height/2.0;
        self.cutY = 0;
    }
    else
    {
        self.cutX = 0;
        self.cutY = minY - self.Bgimageview.frame.origin.y;
    }
    //================
    self.cutCompletBL = resultComplet;
    
    return self;
}

- (void)addmaskView:(UIView *)maskView SetFrame:(CGRect)cutframe
{
    //贝塞尔曲线 画一个带有圆角的矩形
    UIBezierPath *bpath = [UIBezierPath bezierPathWithRoundedRect:maskView.frame cornerRadius:0];
    
   [bpath appendPath: [[UIBezierPath bezierPathWithRoundedRect:cutframe cornerRadius:0] bezierPathByReversingPath]];
    
    //创建一个CAShapeLayer 图层
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bpath.CGPath;
    //添加图层蒙板
    maskView.layer.mask = shapeLayer;
}


- (void)handlePinch:(UIPinchGestureRecognizer*)pinchGesture
{
    UIView *view = self.Bgimageview;//
    if (pinchGesture.state == UIGestureRecognizerStateBegan || pinchGesture.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGesture.scale, pinchGesture.scale);
        self.cutImageScale = self.cutImageScale/pinchGesture.scale;
        
        if (_Bgimageview.frame.size.width <= _Cutview.frame.size.width ) {
            [UIView animateWithDuration:0.3 animations:^{
                /**
                 *  固定1倍
                 */
                view.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
            } completion:^(BOOL finished) {
                self.cutImageScale = self.imagePinScale / 1.0;
//                [self GestureRecognizer:self.Bgimageview];

            }];
            
        }
        if (_Bgimageview.frame.size.width > 2 * _Cutview.frame.size.width) {
            [UIView animateWithDuration:0.3 animations:^{
                /**
                 *  固定2倍
                 */
                view.transform = CGAffineTransformMake(2, 0, 0, 2, 0, 0);
            } completion:^(BOOL finished) {
                pinchGesture.scale = 2.0;
                self.cutImageScale = self.imagePinScale / 2.0;
//                [self GestureRecognizer:self.Bgimageview];
                
            }]; // 提交动画
            
        }
        
        pinchGesture.scale = 1;
        
    }
    
    if (pinchGesture.state == UIGestureRecognizerStateEnded|| pinchGesture.state == UIGestureRecognizerStateChanged) {
        
        [self GestureRecognizer:self.Bgimageview];

    }
    
}

- (void)panView:(UIPanGestureRecognizer *)recognizer
{
    static CGPoint prevLoc;
    UIView *view = self.Bgimageview;//
    CGPoint location = [recognizer locationInView:self];
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        prevLoc = location;
    }
    
    if ((recognizer.state == UIGestureRecognizerStateChanged) || (recognizer.state == UIGestureRecognizerStateEnded))
    {

        _translateX =  (location.x - prevLoc.x);
        _translateY =  (location.y - prevLoc.y);
        
        CGPoint center = view.center;
//        minX= CGRectGetMinX(self.Cutview.frame);
//        minY= CGRectGetMinY(self.Cutview.frame);
//        maxX= CGRectGetMaxX(self.Cutview.frame);
//        maxY= CGRectGetMaxY(self.Cutview.frame);
        
        center.x =center.x +_translateX;
        center.y = center.y +_translateY;
        
        imgViewMaxX= center.x + view.frame.size.width/2;
        imgViewMaxY= center.y+ view.frame.size.height/2;
        
        if(  (center.x - (view.frame.size.width/2.0) ) >= minX)
        {
            center.x = minX + (view.frame.size.width/2.0) ;
        }
        if( center.y - (view.frame.size.height/2) >= minY)
        {
            if ( view.frame.size.height >= self.Cutview.frame.size.height) {
                center.y = minY + (view.frame.size.height/2) ;

            }
            else{
            
                    center.y = self.Cutview.center.y;

                }
        }
        if(imgViewMaxX <= maxX)
        {
            center.x = maxX - (view.frame.size.width/2);
        }
        if(imgViewMaxY <= maxY)
        {
            if ( view.frame.size.height >= self.Cutview.frame.size.height) {
                center.y = maxY - (view.frame.size.height/2);

            }
            else{
                
                center.y = self.Cutview.center.y;

            }
        }
        
        view.center = center;
        [recognizer setTranslation:prevLoc inView:view];
        prevLoc = location;
        
        if ( view.frame.size.height <= self.Cutview.frame.size.height) {
            self.cutX = self.Cutview.frame.size.width/2.0 - self.Bgimageview.frame.size.height/2.0 - self.Bgimageview.frame.origin.x;
            self.cutY = 0;
            
        }else
        {
        self.cutX = - self.Bgimageview.frame.origin.x;
        self.cutY = minY - self.Bgimageview.frame.origin.y;
        }
        
    }
    
    
}

- (void)GestureRecognizer:(UIView *)view
{
    CGPoint location = [self.panGestureRecognizer locationInView:self];
    static CGPoint prevLoc;
    prevLoc = location;
    _translateX =  (location.x - prevLoc.x);
    _translateY =  (location.y - prevLoc.y);
    CGPoint center = view.center;
    
    center.x =center.x +_translateX;
    center.y = center.y +_translateY;
    
    imgViewMaxX= center.x + view.frame.size.width/2;
    imgViewMaxY= center.y+ view.frame.size.height/2;
    
    if(  (center.x - (view.frame.size.width/2.0) ) >= minX)
    {
        center.x = minX + (view.frame.size.width/2.0) ;
    }
    if( center.y - (view.frame.size.height/2) >= minY)
    {
        if ( view.frame.size.height >= self.Cutview.frame.size.height) {
            center.y = minY + (view.frame.size.height/2) ;
            
        }
        else{
            
            center.y = self.Cutview.center.y;
            
        }
    }
    if(imgViewMaxX <= maxX)
    {
        center.x = maxX - (view.frame.size.width/2);
    }
    if(imgViewMaxY <= maxY)
    {
        if ( view.frame.size.height >= self.Cutview.frame.size.height) {
            center.y = maxY - (view.frame.size.height/2);
            
        }
        else{
            
            center.y = self.Cutview.center.y;
            
        }
    }
    view.center = center;
    [self.panGestureRecognizer setTranslation:prevLoc inView:view];
    prevLoc = location;
    if (view.frame.size.height <= self.Cutview.frame.size.height) {
        self.cutX = self.Cutview.center.x - self.Bgimageview.frame.size.height/2.0 - self.Bgimageview.frame.origin.x;
        self.cutY = 0;
        
    }else
    {
        self.cutX = - self.Bgimageview.frame.origin.x;
        self.cutY = minY - self.Bgimageview.frame.origin.y;
    }
    
}

- (void)sureCutImage
{
    CGFloat cutWH;
    if (self.Bgimageview.frame.size.height <= self.Cutview.frame.size.height)
    {
        cutWH = self.Bgimageview.frame.size.height * self.cutImageScale;
    }
    else
    {
        cutWH = self.frame.size.width * self.cutImageScale;
    }
    
    [CyhImageCutTool AddImage:self.Oimage setImageCutFrame:CGRectMake(self.cutX*self.cutImageScale, self.cutY*self.cutImageScale, cutWH,cutWH) comple:^(UIImage *finishImage) {
        
        self.cutCompletBL(finishImage);
    }];

  
}


@end

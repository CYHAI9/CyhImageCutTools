//
//  photoPickupVC.m
//  CyhHImageCut
//
//  Created by 陈海哥 on 2017/9/22.
//  Copyright © 2017年 陈海哥. All rights reserved.
//

#import "photoPickupVC.h"
#import <Photos/Photos.h>
#import "PhotoCell.h"

@interface photoPickupVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic , strong)NSMutableDictionary * images;
@property (nonatomic , strong)NSMutableArray<PHAsset *> * ImageAsset;
@property (nonatomic , strong)UICollectionView * photoCollectionView;

@end

@implementation photoPickupVC

- (NSMutableDictionary *)images
{
    if (!_images) {
        _images = [NSMutableDictionary new];
    }
    return _images;
}

- (NSMutableArray<PHAsset *> *)ImageAsset
{
    if (!_ImageAsset) {
        _ImageAsset = [NSMutableArray new];
    }
    
    return _ImageAsset;
}

- (UICollectionView *)photoCollectionView
{
    if (!_photoCollectionView) {
        UICollectionViewFlowLayout * collectionLayout = [[UICollectionViewFlowLayout alloc] init];
//        collectionLayout.estimatedItemSize = CGSizeMake(44.0, 44.0);
        collectionLayout.itemSize = CGSizeMake(self.view.frame.size.width/3.5, self.view.frame.size.width/3.5);
        collectionLayout.minimumLineSpacing = 10;
        collectionLayout.minimumInteritemSpacing = 10;
        collectionLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        collectionLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _photoCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:collectionLayout];
        _photoCollectionView.delegate = self;
        _photoCollectionView.dataSource = self;
        [_photoCollectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"PhotoCell"];
    }
    
    return _photoCollectionView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self fetchImages];
}

- (void)setUpUI
{
    [self.view addSubview:self.photoCollectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.ImageAsset.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor orangeColor];
    __weak typeof(&*self) weakSelf = self;
    if ([self.images objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.photoImageview.image = [self.images objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        });
    }
    else{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [weakSelf requestImageFor_AssetIndex:indexPath.row size:CGSizeMake(100, 100) resizeMode:PHImageRequestOptionsResizeModeNone completion:^(UIImage * returnImage, NSUInteger key) {
//            cell.photoImage = returnImage;
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.photoImageview.image = [self.images objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            });
        }];

     });
    }
 
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    [self requestImageFor_AssetIndex:indexPath.row size:PHImageManagerMaximumSize resizeMode:PHImageRequestOptionsResizeModeNone completion:^(UIImage * returnImage , NSUInteger index) {
       
        [weakSelf.photoPdelegate photoPickImage:returnImage];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    
}

- (void)fetchImages {
    
    //获取相机胶卷所有图片
    PHFetchResult *assets = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
    //遍历
    for (PHAsset *asset in assets) {
        [self.ImageAsset addObject:asset];
        //取出图片
//        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//
//            [self.images addObject:result];
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.photoCollectionView reloadData];
//            });
//
//        }];
    }
}

#pragma mark - 获取asset对应的图片
- (void)requestImageFor_AssetIndex:(NSInteger)index size:(CGSize)size resizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void (^)(UIImage * , NSUInteger))completion
{
    @synchronized (self) {
    
        dispatch_async(dispatch_get_main_queue(), ^{
            PHAsset * asset = self.ImageAsset[index];
            PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
            /**
             resizeMode：对请求的图像怎样缩放。有三种选择：None，默认加载方式；Fast，尽快地提供接近或稍微大于要求的尺寸；Exact，精准提供要求的尺寸。
     deliveryMode：图像质量。有三种值：Opportunistic，在速度与质量中均衡；HighQualityFormat，不管花费多长时间，提供高质量图像；FastFormat，以最快速度提供好的质量。
     这个属性只有在 synchronous 为 true 时有效。
     */
    //    option.resizeMode = resizeMode;//控制照片尺寸
    option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;//控制照片质量
    //option.synchronous = YES;
    option.networkAccessAllowed = YES;
    //param：targetSize 即你想要的图片尺寸，若想要原尺寸则可输入PHImageManagerMaximumSize
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
         [self.images setObject:image forKey:[NSString stringWithFormat:@"%ld",(long)index]];
        completion(image , index);
  
    }];
            
        });
        
    }
}

@end

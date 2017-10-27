//
//  AlbumViewController.m
//  CyhHImageCut
//
//  Created by 陈海哥 on 2017/9/22.
//  Copyright © 2017年 陈海哥. All rights reserved.
//

#import "PhotoCell.h"
#import "AlbumViewController.h"
#import <Photos/Photos.h>


@interface AlbumViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic , strong)NSMutableArray<PHAsset *> * ImageAsset;
@property (nonatomic , strong)NSMutableArray<NSString *> * AlbumName;
@property (nonatomic , strong)UICollectionView * AlbumCollectionView;
@end

@implementation AlbumViewController

- (UICollectionView *)AlbumCollectionView
{
    if (!_AlbumCollectionView) {
        UICollectionViewFlowLayout * collectionLayout = [[UICollectionViewFlowLayout alloc] init];
        //        collectionLayout.estimatedItemSize = CGSizeMake(44.0, 44.0);
        collectionLayout.itemSize = CGSizeMake(self.view.frame.size.width/3.5, self.view.frame.size.width/3.5);
        collectionLayout.minimumLineSpacing = 10;
        collectionLayout.minimumInteritemSpacing = 10;
        collectionLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        collectionLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _AlbumCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:collectionLayout];
        _AlbumCollectionView.delegate = self;
        _AlbumCollectionView.dataSource = self;
        [_AlbumCollectionView registerClass:[AlvumCell class] forCellWithReuseIdentifier:@"AlvumCell"];
    }
    return _AlbumCollectionView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self getThumbnailImages];
}

- (void)setUpUI
{
    [self.view addSubview:self.AlbumCollectionView];
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
    AlvumCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AlvumCell" forIndexPath:indexPath];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)getThumbnailImages
{
    // 获得所有的自定义相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 遍历所有的自定义相簿
    for (PHAssetCollection *assetCollection in assetCollections) {
        
        [self enumerateAssetsInAssetCollection:assetCollection original:NO];
    }
    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    [self enumerateAssetsInAssetCollection:cameraRoll original:NO];
    
}

int i = 0;
- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original
{
    NSLog(@"相簿名:%@", assetCollection.localizedTitle);
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    
    // 获得某个相簿中的所有PHAsset对象PHFetchResult
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    
    [assets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       [self.ImageAsset addObject:obj];
    }];
    [self.AlbumCollectionView reloadData];
}

@end

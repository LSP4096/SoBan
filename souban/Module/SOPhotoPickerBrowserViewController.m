//
//  SOPhotoPickerBrowserViewController.m
//  souban
//
//  Created by 周国勇 on 11/11/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOPhotoPickerBrowserViewController.h"
#import "UIViewController+TopViewController.h"
#import "NSString+URL.h"
#import "SDWebImageManager.h"
#import "UIImage+Color.h"
#import <UIImageView+WebCache.h>


@interface SOPhotoPickerBrowserViewController () <MLPhotoBrowserViewControllerDataSource, MLPhotoBrowserViewControllerDelegate>

@property (strong, nonatomic) NSArray *medias;
@property (strong, nonatomic) UIImageView *fromImageView;
@property (nonatomic) NSInteger originCurrentIndex;

@end


@implementation SOPhotoPickerBrowserViewController

+ (instancetype)showWithMedias:(NSArray<NSString *> *)medias currentIndex:(NSInteger)currentIndex fromImageView:(UIImageView *)imageView
{
    if (medias.count == 0) {
        return nil;
    }

    SOPhotoPickerBrowserViewController *controller = [[SOPhotoPickerBrowserViewController alloc] initWithMedias:medias];
    controller.currentIndexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
    controller.fromImageView = imageView;
    controller.originCurrentIndex = currentIndex;
//    [controller showPickerVc:[UIViewController topViewController]];
    return controller;
}


- (instancetype)initWithMedias:(NSArray *)medias
{
    if (self = [super init]) {
        self.delegate = self;
        self.dataSource = self;
        _medias = medias;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MLPhotoBrowserViewControllerDataSource

- (NSInteger) numberOfSectionInPhotosInPhotoBrowser:(MLPhotoBrowserViewController *)photoBrowser {
    return 1;
}

- (NSInteger) photoBrowser:(MLPhotoBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section
{
    return self.medias.count;
}

- (MLPhotoBrowserPhoto *)photoBrowser:(MLPhotoBrowserViewController *)photoBrowser photoAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *media = self.medias[indexPath.row];
    
    // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
    MLPhotoBrowserPhoto *photo = [MLPhotoBrowserPhoto photoAnyImageObjWith:media.originURL];
    photo.toView = self.fromImageView;
    UIImage *image = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:media.originURL.absoluteString];
    if (image) {
        photo.thumbImage = image;
    } else {
        photo.thumbImage = indexPath.row == self.originCurrentIndex ? nil : [UIImage imageNamed:@"placeholder_aptmt"];
    }
    
    return photo;
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

#import "UIImagePickerController+Block.h"
#import <objc/runtime.h>

#pragma mark Class Definition

static const NSString *kFinishBlockKey = @"UIImagePickerControllerBlockKey";


@implementation UIImagePickerController (Block)

#pragma mark - Properties


#pragma mark - Public Methods

+ (UIImagePickerController *)imagePickerWithFinishBlock:(ImagePickerFinishBlock)finishBlock
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.finishBlock = finishBlock;
    //    imagePicker.allowsEditing = YES;
    return imagePicker;
}

- (void)setFinishBlock:(ImagePickerFinishBlock)finishBlock
{
    self.delegate = self;

    objc_setAssociatedObject(self, &kFinishBlockKey, finishBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (ImagePickerFinishBlock)finishBlock
{
    return objc_getAssociatedObject(self, &kFinishBlockKey);
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //    [self dismissViewControllerAnimated:YES completion:nil];
    ImagePickerFinishBlock block = self.finishBlock;
    if (block) {
        // 选取照片
        if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
            block(kWFImagePikcerFinishedTypeChoosen, [info valueForKey:UIImagePickerControllerOriginalImage]);
        }
        // 拍照
        else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            block(kWFImagePikcerFinishedTypeTakePhoto, [info valueForKey:UIImagePickerControllerOriginalImage]);
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    self.finishBlock(kWFImagePikcerFinishedTypeCanceled, nil);
}
//
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
//}
//
//-(UIViewController *)childViewControllerForStatusBarHidden
//{
//    return nil;
//}
//
//-(BOOL)prefersStatusBarHidden   // iOS8 definitely needs this one. checked.
//{
//    return YES;
//}

@end

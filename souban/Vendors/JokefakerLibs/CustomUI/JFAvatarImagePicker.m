#import "JFAvatarImagePicker.h"
#import "TOCropViewController.h"


#pragma mark Constants


#pragma mark - Class Extension


@interface JFAvatarImagePicker () <UIActionSheetDelegate, TOCropViewControllerDelegate, TOCropViewControllerDelegate>

@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (copy, nonatomic) ImagePickerFinishBlock finishBlock;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (weak, nonatomic) UIViewController *targetViewController;

@end


#pragma mark - Class Variables

static JFAvatarImagePicker *_avatarPicker = nil;

#pragma mark - Class Definition


@implementation JFAvatarImagePicker


#pragma mark - Properties

- (UIActionSheet *)actionSheet
{
    if (!_actionSheet) {
        _actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:@"拍照", @"从相册中选取", nil];
    }
    return _actionSheet;
}

#pragma mark - Constructors

- (id)init
{
    // Abort if base initializer fails.
    if ((self = [super init]) == nil) {
        return nil;
    }

    // Initialize instance variables.

    // Return initialized instance.
    return self;
}


#pragma mark - Public Methods

- (void)showInViewController:(UIViewController *)viewController finishBlock:(ImagePickerFinishBlock)finishBolck
{
    self.finishBlock = finishBolck;
    self.targetViewController = viewController;
    [self.actionSheet showInView:viewController.view];
}

+ (void)showInViewController:(UIViewController *)viewController finishBlock:(ImagePickerFinishBlock)finishBolck
{
    if (!_avatarPicker) {
        _avatarPicker = [JFAvatarImagePicker new];
    }
    [_avatarPicker showInViewController:viewController finishBlock:finishBolck];
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 取消选择
    if (buttonIndex == 2) {
        self.finishBlock(kWFImagePikcerFinishedTypeCanceled, nil);
        return;
    }

    __weak __typeof(&*self) weakSelf = self;
    self.imagePickerController = [UIImagePickerController imagePickerWithFinishBlock:^(WFImagePikcerFinishedType finishType, UIImage *image) {
        if (finishType == kWFImagePikcerFinishedTypeCanceled) {
            [weakSelf.targetViewController dismissViewControllerAnimated:YES completion:nil];
            weakSelf.finishBlock(kWFImagePikcerFinishedTypeCanceled, nil);
        } else {
            [weakSelf.imagePickerController dismissViewControllerAnimated:NO completion:^{
                TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:image];
                cropController.delegate = weakSelf;
                [weakSelf.targetViewController presentViewController:cropController animated:YES completion:nil];
            }];
        }
    }];

    // 选择照片
    UIImagePickerControllerSourceType sourceType = 0;
    if (buttonIndex == 1) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    // 拍照
    else if (buttonIndex == 0) {
        sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        self.imagePickerController.sourceType = sourceType;
    }
    [self.targetViewController presentViewController:self.imagePickerController animated:YES completion:nil];
}

#pragma mark - CropViewController

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    [self.targetViewController dismissViewControllerAnimated:YES completion:nil];
    self.finishBlock(kWFImagePikcerFinishedTypeCropped, image);
}


@end

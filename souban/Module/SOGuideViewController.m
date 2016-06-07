//
//  SOGuideViewController.m
//  souban
//
//  Created by 周国勇 on 11/6/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOGuideViewController.h"
#import "UIView+Layout.h"


@interface SOGuideViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end


@implementation SOGuideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    NSString *widthString = width == 414 ? @(width * 3).stringValue : @(width * 2).stringValue;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    NSString *heightString = width == 414 ? @(height * 3).stringValue : @(height * 2).stringValue;
    NSString *name = [NSString stringWithFormat:@"%@*%@", widthString, heightString];

    for (NSInteger i = 0; i < 5; i++) {
        NSString *temp = [name stringByAppendingString:[NSString stringWithFormat:@"_%@", @(i + 1).stringValue]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:temp]];
        imageView.frame = CGRectMake(i * width, 0, width, height);
        if (i == 4) {
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lastImageViewTapped:)];
            [imageView addGestureRecognizer:gesture];
        }
        [self.scrollView addSubview:imageView];
    }
    self.scrollView.contentSize = CGSizeMake(width * 5, height);
}

- (void)lastImageViewTapped:(UITapGestureRecognizer *)gesture
{
    [UIView animateWithDuration:0.8 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger page = (scrollView.contentOffset.x + scrollView.width / 2) / self.view.width;
    if (page == 0) {
        page = 0;
    }
    if (page >= self.pageControl.numberOfPages) {
        page = self.pageControl.numberOfPages - 1;
    }
    [self.pageControl setCurrentPage:page];
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

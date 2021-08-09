//
//  TZAlbumsSwitcher.m
//  TZImagePickerController
//
//  Created by Gaoyang on 2021/8/6.
//

#import "TZAlbumsSwitcher.h"
#import "UIImage+MyBundle.h"

@interface TZAlbumsSwitcher ()
/// titleLabel
@property (nonatomic, readwrite, strong) UILabel *titleLabel;
/// 导航栏相册展开指示器
@property (nonatomic, readwrite, strong) UIImageView *indicatorImageView;
@property (nonatomic, readwrite, assign) TZAlbumsSwitcherStatus status;

@end

@implementation TZAlbumsSwitcher


+ (instancetype)albumsSwitcher {
    
    TZAlbumsSwitcher *switcher = [[self alloc] initWithArrangedSubviews:@[]];
    switcher.spacing = 8;
    if (@available(iOS 9.0, *)) {
        switcher.alignment = UIStackViewAlignmentCenter;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:switcher action:@selector(didClick)];
    [switcher addGestureRecognizer:tap];
    
    UILabel *label = [[UILabel alloc] init];
    [switcher addArrangedSubview:label];
    switcher.titleLabel = label;
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = UIColor.whiteColor;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200].active = YES;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage tz_imageNamedFromMyBundle:@"switcher-indicator"]];
    [switcher addArrangedSubview:imageView];
    switcher.indicatorImageView = imageView;
    imageView.transform = CGAffineTransformIdentity;
    return switcher;
}

- (void)didClick {
    [self toggleStatusAnimated: YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(albumsSwitcher:didChangeTo:)]) {
        [self.delegate albumsSwitcher:self didChangeTo:self.status];
    }
}

- (void)toggleStatusAnimated:(BOOL)animated {
    self.status = self.status == TZAlbumsSwitcherStatusDown ? TZAlbumsSwitcherStatusUp : TZAlbumsSwitcherStatusDown;
    CGAffineTransform t = _indicatorImageView.transform;
    t = CGAffineTransformRotate(t, M_PI);
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.indicatorImageView.transform = t;
        }];
    } else {
        [UIView setAnimationsEnabled:NO]; {
            self.indicatorImageView.transform = t;
        } [UIView setAnimationsEnabled:YES];
    }
}

- (void)updateAlbumName:(NSString *)albumName {
    self.titleLabel.text = albumName;
}

@end

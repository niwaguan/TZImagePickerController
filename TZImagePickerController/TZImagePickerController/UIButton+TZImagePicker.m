//
//  UIButton+TZImagePicker.m
//  TZImagePickerController
//
//  Created by Gaoyang on 2021/8/8.
//  Copyright © 2021 谭真. All rights reserved.
//

#import "UIButton+TZImagePicker.h"
#import "NSBundle+TZImagePicker.h"
#import "UIColor+TZImagePicker.h"
#import "UIImage+MyBundle.h"

@implementation UIButton (TZImagePicker)


+ (instancetype)doneButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    button.contentEdgeInsets = UIEdgeInsetsMake(2, 12, 2, 12);
    [button setTitle:[NSBundle tz_localizedStringForKey:@"Done"] forState:UIControlStateNormal];
    [button setTitleColor:UIColor.themeHighlightForegroundColor forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage tz_imageNamedFromMyBundle:@"picker-overview-bg"] forState:UIControlStateNormal];
    return button;
}

@end

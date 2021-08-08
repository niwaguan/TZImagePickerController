//
//  UIColor+TZImagePicker.m
//  TZImagePickerController
//
//  Created by Gaoyang on 2021/8/8.
//  Copyright © 2021 谭真. All rights reserved.
//

#import "UIColor+TZImagePicker.h"

#define ColorWithRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define ColorWithRGB(r, g, b) ColorWithRGBA(r, g, b, 1.0)

@implementation UIColor (TZImagePicker)

TZColorImplementation(themeHighlightColor, ColorWithRGB(0, 255, 223), ColorWithRGB(0, 255, 223))

TZColorImplementation(themeHighlightForegroundColor, ColorWithRGB(14, 24, 33), ColorWithRGB(14, 24, 33))

TZColorImplementation(navigationBarBackgroundColor, ColorWithRGB(10, 17, 23), ColorWithRGB(10, 17, 23))

TZColorImplementation(navigationBarTextColor, UIColor.whiteColor, UIColor.whiteColor)

TZColorImplementation(viewControllerBackgroundColor, ColorWithRGB(10, 17, 23), ColorWithRGB(10, 17, 23))

TZColorImplementation(titleColor, UIColor.whiteColor, UIColor.whiteColor)

TZColorImplementation(subTitleColor, [UIColor.whiteColor colorWithAlphaComponent:0.5], [UIColor.whiteColor colorWithAlphaComponent:0.5])

TZColorImplementation(popupBackgroundColor, ColorWithRGB(24, 29, 34), ColorWithRGB(24, 29, 34))


@end

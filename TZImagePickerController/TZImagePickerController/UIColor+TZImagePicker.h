//
//  UIColor+TZImagePicker.h
//  TZImagePickerController
//
//  Created by Gaoyang on 2021/8/8.
//  Copyright © 2021 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 声明颜色属性, 传入参数为属性名称，可使用 UIColor.Name 访问
#define TZColorProperty(Name) @property (class, nonatomic, readonly, strong) UIColor *Name

/// 实现一个使用 TZColorProperty 声明的属性。参数分别为：属性名，浅色模式颜色、深色模式及默认颜色
#define TZColorImplementation(Property, LightColor, DarkAndDefaultColor) + (UIColor *)Property {\
if (@available(iOS 13.0, *)) {\
    return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {\
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {\
            return LightColor;\
        }\
        return DarkAndDefaultColor;\
    }];\
}\
return DarkAndDefaultColor;\
}

@interface UIColor (TZImagePicker)

/// 主题高亮
TZColorProperty(themeHighlightColor);
/// 主题前进色
TZColorProperty(themeHighlightForegroundColor);
/// 导航栏背景色
TZColorProperty(navigationBarBackgroundColor);
/// 导航栏字体颜色
TZColorProperty(navigationBarTextColor);
/// view controller 背景色
TZColorProperty(viewControllerBackgroundColor);
/// 标题颜色
TZColorProperty(titleColor);
/// 副标题颜色
TZColorProperty(subTitleColor);
/// 浮层背景颜色
TZColorProperty(popupBackgroundColor);

@end

NS_ASSUME_NONNULL_END

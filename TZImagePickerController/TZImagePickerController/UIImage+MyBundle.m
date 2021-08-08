//
//  UIImage+MyBundle.m
//  TZImagePickerController
//
//  Created by Gaoyang on 2021/8/6.
//

#import "UIImage+MyBundle.h"
#import "NSBundle+TZImagePicker.h"

@implementation UIImage (MyBundle)

+ (UIImage *)tz_imageNamedFromMyBundle:(NSString *)name {
    NSBundle *imageBundle = [NSBundle tz_imagePickerBundle];
    name = [name stringByAppendingString:@"@2x"];
    NSString *imagePath = [imageBundle pathForResource:name ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    if (!image) {
        // 兼容业务方自己设置图片的方式
        name = [name stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
        image = [UIImage imageNamed:name];
    }
    return image;
}

@end

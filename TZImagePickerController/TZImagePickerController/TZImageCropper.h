//
//  TZImageCropper.h
//  TZImagePickerController
//
//  Created by Gaoyang on 2021/8/9.
//  Copyright © 2021 谭真. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class UIImage;
typedef void(^TZImageCropperCancelledCallback)(void);
typedef void(^TZImageCropperFinishedCallback)(UIImage *image);

@protocol TZImageCropper <NSObject>

@property (nonatomic, readwrite, copy) TZImageCropperCancelledCallback cropCancelledCallback;
/// 裁剪后回调
@property (nonatomic, readwrite, copy) TZImageCropperFinishedCallback cropFinishedCallback;

@end

NS_ASSUME_NONNULL_END

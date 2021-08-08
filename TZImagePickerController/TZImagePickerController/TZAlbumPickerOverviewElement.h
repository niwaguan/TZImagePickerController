//
//  TZAlbumPickerOverviewElement.h
//  TZImagePickerController
//
//  Created by Gaoyang on 2021/8/6.
//  Copyright © 2021 谭真. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class UIImage;
@class PHAsset;

@protocol TZAlbumPickerOverviewElement <NSObject>

@optional

@property (nonatomic, readonly, strong) UIImage *coverImage;
@property (nonatomic, readonly, strong) PHAsset *asset;


@end

NS_ASSUME_NONNULL_END

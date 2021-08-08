//
//  TZAlbumPickerOverview.h
//  TZImagePickerController
//
//  Created by Gaoyang on 2021/8/6.
//

#import <UIKit/UIKit.h>
#import "TZAlbumPickerOverviewElement.h"
NS_ASSUME_NONNULL_BEGIN

@class TZAlbumPickerOverview;

@protocol TZAlbumPickerOverviewDelegate <NSObject>

@optional

- (void)albumPickerOverview:(TZAlbumPickerOverview *)view requireDeleteAtIndex:(NSInteger)index;
- (void)albumPickerOverviewConfirmed:(TZAlbumPickerOverview *)view;

@end

@interface TZAlbumPickerOverview : UIView

/// delelgate
@property (nonatomic, readwrite, weak) id<TZAlbumPickerOverviewDelegate> delegate;

/// 选中多少张的提示label
@property (nonatomic, readonly, strong) UILabel *numbersHintLabel;
/// 确认按钮
@property (nonatomic, readonly, strong) UIButton *confirmButton;
/// 图片列表
@property (nonatomic, readonly, strong) UICollectionView *collectionView;

/// elements
@property (nonatomic, readwrite, strong) NSArray<id<TZAlbumPickerOverviewElement>> *elements;
/// 允许的最大数量。默认9
@property (nonatomic, readwrite, assign) NSInteger maxElements;

@end
NS_ASSUME_NONNULL_END

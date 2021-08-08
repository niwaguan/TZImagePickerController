//
//  TZAlbumsSwitcher.h
//  TZImagePickerController
//
//  Created by Gaoyang on 2021/8/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TZAlbumsSwitcher;

typedef NS_ENUM(NSInteger, TZAlbumsSwitcherStatus) {
    TZAlbumsSwitcherStatusDown,
    TZAlbumsSwitcherStatusUp
};

@protocol TZAlbumsSwitcherDelegate <NSObject>

- (void)albumsSwitcher:(TZAlbumsSwitcher *)switcher didChangeTo:(TZAlbumsSwitcherStatus)status;

@end

@interface TZAlbumsSwitcher : UIStackView

/// delegeate
@property (nonatomic, readwrite, weak) id<TZAlbumsSwitcherDelegate> delegate;
/// status
@property (nonatomic, readonly, assign) TZAlbumsSwitcherStatus status;

+ (instancetype)albumsSwitcher;

- (void)updateAlbumName:(NSString *)albumName;
- (void)toggleStatusAnimated:(BOOL)animated;


@end

NS_ASSUME_NONNULL_END

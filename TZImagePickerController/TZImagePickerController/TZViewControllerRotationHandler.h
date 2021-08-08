//
//  TZViewControllerRotationHandler.h
//  TZImagePickerController
//
//  Created by Gaoyang on 2021/8/8.
//  Copyright © 2021 谭真. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIApplication.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TZViewControllerRotationHandler <NSObject>

@optional

@property(nonatomic, readonly) BOOL shouldAutorotate;
@property(nonatomic, readonly) UIInterfaceOrientationMask supportedInterfaceOrientations;
@property(nonatomic, readonly) UIInterfaceOrientation preferredInterfaceOrientationForPresentation;
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator;

@optional


@end

NS_ASSUME_NONNULL_END

//
//  TZAlbumPickerOverview.m
//  TZImagePickerController
//
//  Created by Gaoyang on 2021/8/6.
//

#import "TZAlbumPickerOverview.h"
#import "TZImageManager.h"
#import "UIView+TZLayout.h"
#import "UIColor+TZImagePicker.h"
#import "UIImage+MyBundle.h"
#import "UIButton+TZImagePicker.h"

@class TZAlbumPickerOverviewCell;

@protocol TZAlbumPickerOverviewCellDelegate <NSObject>

@optional

- (void)albumPickerOverviewCellRequireDelete:(TZAlbumPickerOverviewCell *)cell;

@end


@interface TZAlbumPickerOverviewCell: UICollectionViewCell
/// delegate
@property (nonatomic, readwrite, weak) id<TZAlbumPickerOverviewCellDelegate> delegate;
/// imageView
@property (nonatomic, readwrite, strong) UIImageView *imageView;
/// 删除按钮
@property (nonatomic, readwrite, strong) UIButton *deleteButton;

/// element
@property (nonatomic, readwrite, strong) id<TZAlbumPickerOverviewElement> element;
/// requestid
@property (nonatomic, readwrite, assign) int32_t assetRequestId;

@end

@interface TZAlbumPickerOverview () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TZAlbumPickerOverviewCellDelegate>

/// 选中多少张的提示label
@property (nonatomic, readwrite, strong) UILabel *numbersHintLabel;
/// 确认按钮
@property (nonatomic, readwrite, strong) UIButton *confirmButton;
/// 顶部操作栏
@property (nonatomic, readwrite, strong) UIView *topMenuView;

/// 图片列表
@property (nonatomic, readwrite, strong) UICollectionView *collectionView;

/// 整个视图的mask
@property (nonatomic, readwrite, strong) CAShapeLayer *maskLayer;

@end

@implementation TZAlbumPickerOverview

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _maxElements = 9;
        
        self.backgroundColor = UIColor.popupBackgroundColor;
        _topMenuView = ({
            UIView *view = [[UIView alloc] init];
            [self addSubview:view];
            view;
        });
        
        _numbersHintLabel = ({
            UILabel *label = [[UILabel alloc] init];
            [_topMenuView addSubview:label];
            label;
        });
        
        _confirmButton = ({
            UIButton *button = [UIButton doneButton];
            [self addSubview:button];
            [button addTarget:self action:@selector(didClickConfirmButton) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
        
        _collectionView = ({
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.sectionInset = UIEdgeInsetsMake(0, 16, 12, 16);
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            layout.minimumLineSpacing = 12;
            UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
            [view registerClass:TZAlbumPickerOverviewCell.class forCellWithReuseIdentifier:@"TZAlbumPickerOverviewCell"];
            view.backgroundColor = UIColor.popupBackgroundColor;
            view.dataSource = self;
            view.delegate = self;
            [self addSubview:view];
            view;
        });
        _maskLayer = [[CAShapeLayer alloc] init];
        self.layer.mask = _maskLayer;
        [self updateNumbersLabelContent];
        
    }
    return self;
}

- (void)safeAreaInsetsDidChange {
    [super safeAreaInsetsDidChange];
    [self setNeedsUpdateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        safeAreaInsets = self.safeAreaInsets;
    }
    UIEdgeInsets insets = UIEdgeInsetsMake(safeAreaInsets.top, 16, safeAreaInsets.bottom, 16);
    _topMenuView.frame = CGRectMake(insets.left, 0, self.tz_width - insets.left - insets.right, 56);
    
    CGSize size = [_confirmButton sizeThatFits:self.bounds.size];
    _confirmButton.frame = CGRectMake(_topMenuView.tz_width - size.width + _topMenuView.tz_left, (_topMenuView.tz_height - size.height) / 2, size.width, size.height);
    
    size = [_numbersHintLabel sizeThatFits:self.bounds.size];
    _numbersHintLabel.frame = CGRectMake(0, (_topMenuView.tz_height - size.height) / 2, size.width, size.height);
    
    _collectionView.frame = CGRectMake(0, _topMenuView.tz_height, self.tz_width, self.tz_height - insets.bottom - _topMenuView.tz_height);
    
    // 更新layout itemSize
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    size = self.collectionView.bounds.size;
    CGFloat height = floor(size.height - layout.sectionInset.top - layout.sectionInset.bottom);
    CGSize itemSize = CGSizeMake(height, height);
    layout.itemSize = itemSize;
    
    // 更新mask
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(12, 12)];
    _maskLayer.frame = self.bounds;
    _maskLayer.path = path.CGPath;
}

- (void)updateNumbersLabelContent {
    NSString *count = [NSString stringWithFormat:@"%zd", self.elements.count];
    NSString *full = [NSString stringWithFormat:@"已选 %@/%zd 张", count, self.maxElements];
    NSMutableAttributedString *string = [[NSAttributedString alloc] initWithString:full attributes:@{
        NSFontAttributeName: [UIFont systemFontOfSize:14],
        NSForegroundColorAttributeName: [UIColor whiteColor]
    }].mutableCopy;
    [string addAttributes:@{ NSForegroundColorAttributeName: UIColor.themeHighlightColor } range:[full rangeOfString:count]];
    self.numbersHintLabel.attributedText = string;
    [self.numbersHintLabel sizeToFit];
}

- (void)updateCollectionView {
    [self.collectionView reloadData];
    if (self.elements.count > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.elements.count - 1 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

- (void)didClickConfirmButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(albumPickerOverviewConfirmed:)]) {
        [self.delegate albumPickerOverviewConfirmed:self];
    }
}

#pragma mark -

- (void)albumPickerOverviewCellRequireDelete:(TZAlbumPickerOverviewCell *)cell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(albumPickerOverview:requireDeleteAtIndex:)]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        [self.delegate albumPickerOverview:self requireDeleteAtIndex:indexPath.item];
    }
}

#pragma mark -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elements.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZAlbumPickerOverviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZAlbumPickerOverviewCell" forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(TZAlbumPickerOverviewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    id<TZAlbumPickerOverviewElement> element = self.elements[indexPath.item];
    cell.element = element;
    cell.delegate = self;
}

#pragma mark -

- (void)setElements:(NSArray<id<TZAlbumPickerOverviewElement>> *)elements {
    if (_elements == elements) {
        return;
    }
    if (elements.count > self.maxElements) {
        NSMutableArray *temps = [@[] mutableCopy];
        for (NSInteger i = 0; i < self.maxElements; ++i) {
            [temps addObject:elements[i]];
        }
        elements = temps;
    }
    _elements = [elements copy];
    [self updateCollectionView];
    [self updateNumbersLabelContent];
}

@end


@implementation TZAlbumPickerOverviewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = UIColor.viewControllerBackgroundColor;
        _imageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            [self.contentView addSubview:imageView];
            imageView.frame = self.contentView.bounds;
            imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            imageView.userInteractionEnabled = NO;
            imageView.clipsToBounds = YES;
            imageView.layer.cornerRadius = 4;
            imageView.layer.masksToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView;
        });
        
        _deleteButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 15, 0);
            button.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
            [button setImage:[UIImage imageNamed:@"gray-tr-bl-close"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(didClickDelete) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            button;
        });
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = [self.deleteButton sizeThatFits:self.bounds.size];
    CGSize max = self.bounds.size;
    self.deleteButton.frame = CGRectMake(max.width - size.width, 0, size.width, size.height);
}

- (void)didClickDelete {
    if (self.delegate && [self.delegate respondsToSelector:@selector(albumPickerOverviewCellRequireDelete:)]) {
        [self.delegate albumPickerOverviewCellRequireDelete:self];
    }
}

- (void)setElement:(id<TZAlbumPickerOverviewElement>)element {
    if (_element == element) {
        return;
    }
    _element = element;
    [self updateImage];
}

- (void)updateImage {
    if (self.assetRequestId) {
        [[PHImageManager defaultManager] cancelImageRequest:self.assetRequestId];
    }
    if (self.element.coverImage) {
        self.imageView.image = self.element.coverImage;
    } else if (self.element.asset) {
        NSString *identifier = self.element.asset.localIdentifier;
        self.assetRequestId = [[TZImageManager manager] getPhotoWithAsset:self.element.asset photoWidth:200 completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
            if ([identifier isEqualToString:self.element.asset.localIdentifier]) {
                self.imageView.image = photo;
            }
        } progressHandler:nil networkAccessAllowed:NO];
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    if (self.assetRequestId) {
        [[PHImageManager defaultManager] cancelImageRequest:self.assetRequestId];
    }
}

@end

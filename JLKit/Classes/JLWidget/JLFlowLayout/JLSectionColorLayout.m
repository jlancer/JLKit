//
//  JLSectionColorLayout.m
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "JLSectionColorLayout.h"
#import "UIView+Addition_JL.h"

#define kDecorationReuseIdentifier @"kUICollectionSectionColorIdentifier"

@interface UICollectionSectionColorLayoutAttributes : UICollectionViewLayoutAttributes

@property (nonatomic, strong) UIColor *sectionBgColor;

@end

@implementation UICollectionSectionColorLayoutAttributes

@end

@interface UICollectionSectionColorReusableView : UICollectionReusableView

@end

@implementation UICollectionSectionColorReusableView

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    if ([layoutAttributes isKindOfClass:[UICollectionSectionColorLayoutAttributes class]]) {
        self.backgroundColor = [(UICollectionSectionColorLayoutAttributes *)layoutAttributes sectionBgColor];
        [self jl_cornerRadius:16];
    }
}
@end

@interface JLSectionColorLayout  ()

@property (nonatomic, strong) UIColor *sectonColor;
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *decorationViewAttrs;

@end

@implementation JLSectionColorLayout

- (void)prepareLayout{
    [super prepareLayout];
    
    NSInteger sections = [self.collectionView numberOfSections];
    id<UICollectionSectionColorLayout> delegate = self.collectionView.delegate;
    if ([delegate respondsToSelector:@selector(collectionView:layout:colorForSectionAtIndex:)]) {
    }else{
        return ;
    }
    
    //1.初始化
    [self registerClass:[UICollectionSectionColorReusableView class] forDecorationViewOfKind:kDecorationReuseIdentifier];
    
    [self.decorationViewAttrs removeAllObjects];
    
    for (NSInteger section =0; section < sections; section++) {
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        if (numberOfItems > 0) {
            UICollectionViewLayoutAttributes *firstAttr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
            UICollectionViewLayoutAttributes *lastAttr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:(numberOfItems - 1) inSection:section]];
            
            UIEdgeInsets sectionInset = self.sectionInset;
            if ([delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
                UIEdgeInsets inset = [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
                if (!UIEdgeInsetsEqualToEdgeInsets(inset, sectionInset)) {
                    sectionInset = inset;
                }
            }
            
            
            CGRect sectionFrame = CGRectUnion(firstAttr.frame, lastAttr.frame);
            sectionFrame.origin.x -= sectionInset.left;
            sectionFrame.origin.y -= sectionInset.top;
            if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                sectionFrame.size.width += sectionInset.left + sectionInset.right;
                sectionFrame.size.height = self.collectionView.frame.size.height;
            }else{
                sectionFrame.origin.x = 32;
                sectionFrame.size.width = self.collectionView.frame.size.width - 32 * 2;
                sectionFrame.size.height += sectionInset.top + sectionInset.bottom;
            }
            
            //2. 定义
            UICollectionSectionColorLayoutAttributes *attr = [UICollectionSectionColorLayoutAttributes layoutAttributesForDecorationViewOfKind:kDecorationReuseIdentifier withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
            attr.frame = sectionFrame;
            attr.zIndex = -1;
            attr.sectionBgColor = [delegate collectionView:self.collectionView layout:self colorForSectionAtIndex:section];
            [self.decorationViewAttrs addObject:attr];
        }else{
            continue ;
        }
    }
    
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSMutableArray * attrs = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    for (UICollectionViewLayoutAttributes *attr in self.decorationViewAttrs) {
        if (CGRectIntersectsRect(rect, attr.frame)) {
            [attrs addObject:attr];
        }
    }
    return [attrs copy];
}

- (NSMutableArray<UICollectionViewLayoutAttributes *> *)decorationViewAttrs{
    if (!_decorationViewAttrs) {
        _decorationViewAttrs = [NSMutableArray array];
    }
    return _decorationViewAttrs;
}

@end


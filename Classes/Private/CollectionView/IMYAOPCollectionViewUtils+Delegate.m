//
//  IMYAOPFeedsViewUtils+UITableViewDelegate.m
//  IMYAOPFeedsView
//
//  Created by ljh on 16/4/15.
//  Copyright © 2016年 IMY. All rights reserved.
//

#import "IMYAOPCollectionViewUtils+Delegate.h"
#import "IMYAOPCollectionViewUtils+Private.h"

#define kAOPRealIndexPathCode                                           \
    NSIndexPath *realIndexPath = [self realIndexPathByTable:indexPath]; \
    id<IMYAOPCollectionViewDelegate> delegate = nil;                    \
    if (realIndexPath) {                                                \
        delegate = (id)self.origDelegate;                               \
        indexPath = realIndexPath;                                      \
    } else {                                                            \
        delegate = self.delegate;                                       \
    }

#define kAOPRealSectionCode                                    \
    NSInteger realSection = [self realSectionByTable:section]; \
    id<IMYAOPCollectionViewDelegate> delegate = nil;           \
    if (realSection >= 0) {                                    \
        delegate = (id)self.origDelegate;                      \
        section = realSection;                                 \
    } else {                                                   \
        delegate = self.delegate;                              \
    }

#define kAOPUICallingSaved \
    self.isUICalling -= 1;

#define kAOPUICallingResotre \
    self.isUICalling += 1;

@implementation IMYAOPCollectionViewUtils (UITableViewDelegate)

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    BOOL canHighlight = YES;
    if ([delegate respondsToSelector:@selector(collectionView:shouldHighlightItemAtIndexPath:)]) {
        canHighlight = [delegate collectionView:collectionView shouldHighlightItemAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
    return canHighlight;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    if ([delegate respondsToSelector:@selector(collectionView:didHighlightItemAtIndexPath:)]) {
        [delegate collectionView:collectionView didHighlightItemAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    if ([delegate respondsToSelector:@selector(collectionView:didUnhighlightItemAtIndexPath:)]) {
        [delegate collectionView:collectionView didUnhighlightItemAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    BOOL canSelected = YES;
    if ([delegate respondsToSelector:@selector(collectionView:shouldSelectItemAtIndexPath:)]) {
        canSelected = [delegate collectionView:collectionView shouldSelectItemAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
    return canSelected;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    BOOL canSelected = YES;
    if ([delegate respondsToSelector:@selector(collectionView:shouldDeselectItemAtIndexPath:)]) {
        canSelected = [delegate collectionView:collectionView shouldDeselectItemAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
    return canSelected;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    if ([delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
        [delegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    if ([delegate respondsToSelector:@selector(collectionView:didDeselectItemAtIndexPath:)]) {
        [delegate collectionView:collectionView didDeselectItemAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    if ([delegate respondsToSelector:@selector(collectionView:willDisplayCell:forItemAtIndexPath:)]) {
        [delegate collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    if ([delegate respondsToSelector:@selector(collectionView:willDisplaySupplementaryView:forElementKind:atIndexPath:)]) {
        [delegate collectionView:collectionView willDisplaySupplementaryView:view forElementKind:elementKind atIndexPath:indexPath];
    }
    kAOPUICallingResotre;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    if ([delegate respondsToSelector:@selector(collectionView:didEndDisplayingCell:forItemAtIndexPath:)]) {
        [delegate collectionView:collectionView didEndDisplayingCell:cell forItemAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    if ([delegate respondsToSelector:@selector(collectionView:didEndDisplayingSupplementaryView:forElementOfKind:atIndexPath:)]) {
        [delegate collectionView:collectionView didEndDisplayingSupplementaryView:view forElementOfKind:elementKind atIndexPath:indexPath];
    }
    kAOPUICallingResotre;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    BOOL canShowMenu = YES;
    if ([delegate respondsToSelector:@selector(collectionView:shouldShowMenuForItemAtIndexPath:)]) {
        canShowMenu = [delegate collectionView:collectionView shouldShowMenuForItemAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
    return canShowMenu;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    BOOL canPerform = YES;
    if ([delegate respondsToSelector:@selector(collectionView:canPerformAction:forItemAtIndexPath:withSender:)]) {
        canPerform = [delegate collectionView:collectionView canPerformAction:action forItemAtIndexPath:indexPath withSender:sender];
    }
    kAOPUICallingResotre;
    return canPerform;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    if ([delegate respondsToSelector:@selector(collectionView:performAction:forItemAtIndexPath:withSender:)]) {
        [delegate collectionView:collectionView performAction:action forItemAtIndexPath:indexPath withSender:sender];
    }
    kAOPUICallingResotre;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canFocusItemAtIndexPath:(NSIndexPath *)indexPath {
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    BOOL canFocus = YES;
    if ([delegate respondsToSelector:@selector(collectionView:canFocusItemAtIndexPath:)]) {
        canFocus = [delegate collectionView:collectionView canFocusItemAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
    return canFocus;
}

- (NSIndexPath *)collectionView:(UICollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath {
    kAOPUICallingSaved;
    NSIndexPath *source = [self realIndexPathByTable:originalIndexPath];
    NSIndexPath *destin = [self realIndexPathByTable:proposedIndexPath];
    NSIndexPath *resultIndex = nil;
    if ([self.origDelegate respondsToSelector:@selector(collectionView:targetIndexPathForMoveFromItemAtIndexPath:toProposedIndexPath:)]) {
        resultIndex = [self.origDelegate collectionView:collectionView targetIndexPathForMoveFromItemAtIndexPath:source toProposedIndexPath:destin];
    }
    kAOPUICallingResotre;
    return resultIndex;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSpringLoadItemAtIndexPath:(NSIndexPath *)indexPath withContext:(id<UISpringLoadedInteractionContext>)context {
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    BOOL shouldSpringLoad = YES;
    if ([delegate respondsToSelector:@selector(collectionView:shouldSpringLoadItemAtIndexPath:withContext:)]) {
        shouldSpringLoad = [delegate collectionView:collectionView shouldSpringLoadItemAtIndexPath:indexPath withContext:context];
    }
    kAOPUICallingResotre;
    return shouldSpringLoad;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(CHTCollectionViewWaterfallLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    CGSize size = CGSizeZero;
    if ([delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        size = [delegate collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
    return size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(CHTCollectionViewWaterfallLayout *)collectionViewLayout columnCountForSection:(NSInteger)section {
    kAOPUICallingSaved;
    NSInteger realSection = [self realSectionByTable:section];
    NSInteger columnCount = collectionViewLayout.columnCount;
    id delegate = nil;
    if (realSection >= 0) {
        section = realSection;
        delegate = self.origDelegate;
    } else {
        delegate = self.delegate;
    }
    if ([delegate respondsToSelector:@selector(collectionView:layout:columnCountForSection:)]) {
        columnCount = [delegate collectionView:collectionView layout:collectionViewLayout columnCountForSection:section];
    }
    kAOPUICallingResotre;
    return columnCount;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(CHTCollectionViewWaterfallLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section {
    kAOPUICallingSaved;
    NSInteger realSection = [self realSectionByTable:section];
    CGFloat height = collectionViewLayout.headerHeight;
    id delegate = nil;
    if (realSection >= 0) {
        section = realSection;
        delegate = self.origDelegate;
    } else {
        delegate = self.delegate;
    }
    if ([delegate respondsToSelector:@selector(collectionView:layout:heightForHeaderInSection:)]) {
        height = [delegate collectionView:collectionView layout:collectionViewLayout heightForHeaderInSection:section];
    }
    kAOPUICallingResotre;
    return height;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(CHTCollectionViewWaterfallLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section {
    kAOPUICallingSaved;
    NSInteger realSection = [self realSectionByTable:section];
    CGFloat height = collectionViewLayout.footerHeight;
    id delegate = nil;
    if (realSection >= 0) {
        section = realSection;
        delegate = self.origDelegate;
    } else {
        delegate = self.delegate;
    }
    if ([delegate respondsToSelector:@selector(collectionView:layout:heightForFooterInSection:)]) {
        height = [delegate collectionView:collectionView layout:collectionViewLayout heightForFooterInSection:section];
    }
    kAOPUICallingResotre;
    return height;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(CHTCollectionViewWaterfallLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    kAOPUICallingSaved;
    NSInteger realSection = [self realSectionByTable:section];
    UIEdgeInsets edgeInsets = collectionViewLayout.sectionInset;
    id delegate = nil;
    if (realSection >= 0) {
        section = realSection;
        delegate = self.origDelegate;
    } else {
        delegate = self.delegate;
    }
    if ([delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        edgeInsets = [delegate collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:section];
    }
    kAOPUICallingResotre;
    return edgeInsets;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(CHTCollectionViewWaterfallLayout *)collectionViewLayout insetForHeaderInSection:(NSInteger)section {
    kAOPUICallingSaved;
    NSInteger realSection = [self realSectionByTable:section];
    UIEdgeInsets edgeInsets = collectionViewLayout.headerInset;
    id delegate = nil;
    if (realSection >= 0) {
        section = realSection;
        delegate = self.origDelegate;
    } else {
        delegate = self.delegate;
    }
    if ([delegate respondsToSelector:@selector(collectionView:layout:insetForHeaderInSection:)]) {
        edgeInsets = [delegate collectionView:collectionView layout:collectionViewLayout insetForHeaderInSection:section];
    }
    kAOPUICallingResotre;
    return edgeInsets;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(CHTCollectionViewWaterfallLayout *)collectionViewLayout insetForFooterInSection:(NSInteger)section {
    kAOPUICallingSaved;
    NSInteger realSection = [self realSectionByTable:section];
    UIEdgeInsets edgeInsets = collectionViewLayout.footerInset;
    id delegate = nil;
    if (realSection >= 0) {
        section = realSection;
        delegate = self.origDelegate;
    } else {
        delegate = self.delegate;
    }
    if ([delegate respondsToSelector:@selector(collectionView:layout:insetForFooterInSection:)]) {
        edgeInsets = [delegate collectionView:collectionView layout:collectionViewLayout insetForFooterInSection:section];
    }
    kAOPUICallingResotre;
    return edgeInsets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(CHTCollectionViewWaterfallLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    kAOPUICallingSaved;
    NSInteger realSection = [self realSectionByTable:section];
    CGFloat spacing = collectionViewLayout.minimumInteritemSpacing;
    id delegate = nil;
    if (realSection >= 0) {
        section = realSection;
        delegate = self.origDelegate;
    } else {
        delegate = self.delegate;
    }
    if ([delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        spacing = [delegate collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:section];
    }
    kAOPUICallingResotre;
    return spacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(CHTCollectionViewWaterfallLayout *)collectionViewLayout minimumColumnSpacingForSectionAtIndex:(NSInteger)section {
    kAOPUICallingSaved;
    NSInteger realSection = [self realSectionByTable:section];
    CGFloat spacing = collectionViewLayout.minimumColumnSpacing;
    id delegate = nil;
    if (realSection >= 0) {
        section = realSection;
        delegate = self.origDelegate;
    } else {
        delegate = self.delegate;
    }
    if ([delegate respondsToSelector:@selector(collectionView:layout:minimumColumnSpacingForSectionAtIndex:)]) {
        spacing = [delegate collectionView:collectionView layout:collectionViewLayout minimumColumnSpacingForSectionAtIndex:section];
    }
    kAOPUICallingResotre;
    return spacing;
}

@end

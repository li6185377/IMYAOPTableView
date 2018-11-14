//
//  IMYAOPCollectionViewUtils+Delegate.m
//  IMYAOPFeedsView
//
//  Created by ljh on 16/5/20.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import "IMYAOPCollectionViewUtils+Delegate.h"
#import "IMYAOPCollectionViewUtils+Private.h"

#define kAOPUserIndexPathCode                                           \
    NSIndexPath *userIndexPath = [self userIndexPathByFeeds:indexPath]; \
    id<IMYAOPCollectionViewDelegate> delegate = nil;                    \
    if (userIndexPath) {                                                \
        delegate = (id)self.origDelegate;                               \
        indexPath = userIndexPath;                                      \
    } else {                                                            \
        delegate = self.delegate;                                       \
        isInjectAction = YES;                                           \
    }                                                                   \
    if (isInjectAction) {                                               \
        self.isUICalling += 1;                                          \
    }


#define kAOPUserSectionCode                                    \
    NSInteger userSection = [self userSectionByFeeds:section]; \
    id<IMYAOPCollectionViewDelegate> delegate = nil;           \
    if (userSection >= 0) {                                    \
        delegate = (id)self.origDelegate;                      \
        section = userSection;                                 \
    } else {                                                   \
        delegate = self.delegate;                              \
        isInjectAction = YES;                                  \
    }                                                          \
    if (isInjectAction) {                                      \
        self.isUICalling += 1;                                 \
    }


#define kAOPUICallingSaved          \
    BOOL isInjectAction = NO;       \
    self.isUICalling -= 1;

#define kAOPUICallingResotre        \
    if (isInjectAction) {           \
        self.isUICalling -= 1;      \
    }                               \
    self.isUICalling += 1;

@implementation IMYAOPCollectionViewUtils (UITableViewDelegate)

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    kAOPUICallingSaved;
    kAOPUserIndexPathCode;
    BOOL canHighlight = YES;
    if ([delegate respondsToSelector:@selector(collectionView:shouldHighlightItemAtIndexPath:)]) {
        canHighlight = [delegate collectionView:collectionView shouldHighlightItemAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
    return canHighlight;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    kAOPUICallingSaved;
    kAOPUserIndexPathCode;
    if ([delegate respondsToSelector:@selector(collectionView:didHighlightItemAtIndexPath:)]) {
        [delegate collectionView:collectionView didHighlightItemAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    kAOPUICallingSaved;
    kAOPUserIndexPathCode;
    if ([delegate respondsToSelector:@selector(collectionView:didUnhighlightItemAtIndexPath:)]) {
        [delegate collectionView:collectionView didUnhighlightItemAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    kAOPUICallingSaved;
    kAOPUserIndexPathCode;
    BOOL canSelected = YES;
    if ([delegate respondsToSelector:@selector(collectionView:shouldSelectItemAtIndexPath:)]) {
        canSelected = [delegate collectionView:collectionView shouldSelectItemAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
    return canSelected;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    kAOPUICallingSaved;
    kAOPUserIndexPathCode;
    BOOL canSelected = YES;
    if ([delegate respondsToSelector:@selector(collectionView:shouldDeselectItemAtIndexPath:)]) {
        canSelected = [delegate collectionView:collectionView shouldDeselectItemAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
    return canSelected;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    kAOPUICallingSaved;
    kAOPUserIndexPathCode;
    if ([delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
        [delegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    kAOPUICallingSaved;
    kAOPUserIndexPathCode;
    if ([delegate respondsToSelector:@selector(collectionView:didDeselectItemAtIndexPath:)]) {
        [delegate collectionView:collectionView didDeselectItemAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    kAOPUICallingSaved;
    ///回调给ad manager 虚拟广告位的上报
    if ([self.delegate respondsToSelector:@selector(aopCollectionUtils:willDisplayCell:forItemAtIndexPath:)]) {
        [self.delegate aopCollectionUtils:self willDisplayCell:cell forItemAtIndexPath:indexPath];
    }
    kAOPUserIndexPathCode;
    if ([delegate respondsToSelector:@selector(collectionView:willDisplayCell:forItemAtIndexPath:)]) {
        [delegate collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    kAOPUICallingSaved;
    kAOPUserIndexPathCode;
    if ([delegate respondsToSelector:@selector(collectionView:willDisplaySupplementaryView:forElementKind:atIndexPath:)]) {
        [delegate collectionView:collectionView willDisplaySupplementaryView:view forElementKind:elementKind atIndexPath:indexPath];
    }
    kAOPUICallingResotre;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    kAOPUICallingSaved;
    ///回调给ad manager 虚拟广告位的上报
    if ([self.delegate respondsToSelector:@selector(aopCollectionUtils:didEndDisplayingCell:forItemAtIndexPath:)]) {
        [self.delegate aopCollectionUtils:self didEndDisplayingCell:cell forItemAtIndexPath:indexPath];
    }
    kAOPUserIndexPathCode;
    if ([delegate respondsToSelector:@selector(collectionView:didEndDisplayingCell:forItemAtIndexPath:)]) {
        [delegate collectionView:collectionView didEndDisplayingCell:cell forItemAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    kAOPUICallingSaved;
    kAOPUserIndexPathCode;
    if ([delegate respondsToSelector:@selector(collectionView:didEndDisplayingSupplementaryView:forElementOfKind:atIndexPath:)]) {
        [delegate collectionView:collectionView didEndDisplayingSupplementaryView:view forElementOfKind:elementKind atIndexPath:indexPath];
    }
    kAOPUICallingResotre;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    kAOPUICallingSaved;
    kAOPUserIndexPathCode;
    BOOL canShowMenu = YES;
    if ([delegate respondsToSelector:@selector(collectionView:shouldShowMenuForItemAtIndexPath:)]) {
        canShowMenu = [delegate collectionView:collectionView shouldShowMenuForItemAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
    return canShowMenu;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    kAOPUICallingSaved;
    kAOPUserIndexPathCode;
    BOOL canPerform = YES;
    if ([delegate respondsToSelector:@selector(collectionView:canPerformAction:forItemAtIndexPath:withSender:)]) {
        canPerform = [delegate collectionView:collectionView canPerformAction:action forItemAtIndexPath:indexPath withSender:sender];
    }
    kAOPUICallingResotre;
    return canPerform;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    kAOPUICallingSaved;
    kAOPUserIndexPathCode;
    if ([delegate respondsToSelector:@selector(collectionView:performAction:forItemAtIndexPath:withSender:)]) {
        [delegate collectionView:collectionView performAction:action forItemAtIndexPath:indexPath withSender:sender];
    }
    kAOPUICallingResotre;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canFocusItemAtIndexPath:(NSIndexPath *)indexPath {
    kAOPUICallingSaved;
    kAOPUserIndexPathCode;
    BOOL canFocus = YES;
    if ([delegate respondsToSelector:@selector(collectionView:canFocusItemAtIndexPath:)]) {
        canFocus = [delegate collectionView:collectionView canFocusItemAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
    return canFocus;
}

- (NSIndexPath *)collectionView:(UICollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath {
    kAOPUICallingSaved;
    NSIndexPath *source = [self userIndexPathByFeeds:originalIndexPath];
    NSIndexPath *destin = [self userIndexPathByFeeds:proposedIndexPath];
    NSIndexPath *resultIndex = nil;
    if ([self.origDelegate respondsToSelector:@selector(collectionView:targetIndexPathForMoveFromItemAtIndexPath:toProposedIndexPath:)]) {
        resultIndex = [self.origDelegate collectionView:collectionView targetIndexPathForMoveFromItemAtIndexPath:source toProposedIndexPath:destin];
    }
    kAOPUICallingResotre;
    return resultIndex;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSpringLoadItemAtIndexPath:(NSIndexPath *)indexPath withContext:(id<UISpringLoadedInteractionContext>)context {
    kAOPUICallingSaved;
    kAOPUserIndexPathCode;
    BOOL shouldSpringLoad = YES;
    if ([delegate respondsToSelector:@selector(collectionView:shouldSpringLoadItemAtIndexPath:withContext:)]) {
        shouldSpringLoad = [delegate collectionView:collectionView shouldSpringLoadItemAtIndexPath:indexPath withContext:context];
    }
    kAOPUICallingResotre;
    return shouldSpringLoad;
}

#pragma mark - common layout delegate

// water layout and flow layout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    kAOPUICallingSaved;
    kAOPUserIndexPathCode;
    CGSize size = CGSizeZero;
    if ([collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        size = ((UICollectionViewFlowLayout *)collectionViewLayout).itemSize;
    }
    if ([delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        size = [delegate collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    kAOPUICallingSaved;
    NSInteger userSection = [self userSectionByFeeds:section];
    UIEdgeInsets edgeInsets = ((UICollectionViewFlowLayout *)collectionViewLayout).sectionInset;
    id delegate = nil;
    if (userSection >= 0) {
        section = userSection;
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

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    kAOPUICallingSaved;
    NSInteger userSection = [self userSectionByFeeds:section];
    CGFloat spacing = ((UICollectionViewFlowLayout *)collectionViewLayout).minimumInteritemSpacing;
    id delegate = nil;
    if (userSection >= 0) {
        section = userSection;
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

#pragma mark - flow layout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    kAOPUICallingSaved;
    NSInteger userSection = [self userSectionByFeeds:section];
    CGFloat spacing = collectionViewLayout.minimumLineSpacing;
    id delegate = nil;
    if (userSection >= 0) {
        section = userSection;
        delegate = self.origDelegate;
    } else {
        delegate = self.delegate;
    }
    if ([delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        spacing = [delegate collectionView:collectionView layout:collectionViewLayout minimumLineSpacingForSectionAtIndex:section];
    }
    kAOPUICallingResotre;
    return spacing;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    kAOPUICallingSaved;
    NSInteger userSection = [self userSectionByFeeds:section];
    CGSize size = collectionViewLayout.headerReferenceSize;
    id delegate = nil;
    if (userSection >= 0) {
        section = userSection;
        delegate = self.origDelegate;
    } else {
        delegate = self.delegate;
    }
    if ([delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
        size = [delegate collectionView:collectionView layout:collectionViewLayout referenceSizeForHeaderInSection:section];
    }
    kAOPUICallingResotre;
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    kAOPUICallingSaved;
    NSInteger userSection = [self userSectionByFeeds:section];
    CGSize size = collectionViewLayout.headerReferenceSize;
    id delegate = nil;
    if (userSection >= 0) {
        section = userSection;
        delegate = self.origDelegate;
    } else {
        delegate = self.delegate;
    }
    if ([delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
        size = [delegate collectionView:collectionView layout:collectionViewLayout referenceSizeForFooterInSection:section];
    }
    kAOPUICallingResotre;
    return size;
}

#pragma mark - water layout
#if _has_chtwaterfall_layout_

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(CHTCollectionViewWaterfallLayout *)collectionViewLayout columnCountForSection:(NSInteger)section {
    kAOPUICallingSaved;
    NSInteger userSection = [self userSectionByFeeds:section];
    NSInteger columnCount = collectionViewLayout.columnCount;
    id delegate = nil;
    if (userSection >= 0) {
        section = userSection;
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
    NSInteger userSection = [self userSectionByFeeds:section];
    CGFloat height = collectionViewLayout.headerHeight;
    id delegate = nil;
    if (userSection >= 0) {
        section = userSection;
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
    NSInteger userSection = [self userSectionByFeeds:section];
    CGFloat height = collectionViewLayout.footerHeight;
    id delegate = nil;
    if (userSection >= 0) {
        section = userSection;
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

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(CHTCollectionViewWaterfallLayout *)collectionViewLayout insetForHeaderInSection:(NSInteger)section {
    kAOPUICallingSaved;
    NSInteger userSection = [self userSectionByFeeds:section];
    UIEdgeInsets edgeInsets = collectionViewLayout.headerInset;
    id delegate = nil;
    if (userSection >= 0) {
        section = userSection;
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
    NSInteger userSection = [self userSectionByFeeds:section];
    UIEdgeInsets edgeInsets = collectionViewLayout.footerInset;
    id delegate = nil;
    if (userSection >= 0) {
        section = userSection;
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

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(CHTCollectionViewWaterfallLayout *)collectionViewLayout minimumColumnSpacingForSectionAtIndex:(NSInteger)section {
    kAOPUICallingSaved;
    NSInteger userSection = [self userSectionByFeeds:section];
    CGFloat spacing = collectionViewLayout.minimumColumnSpacing;
    id delegate = nil;
    if (userSection >= 0) {
        section = userSection;
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

#endif

@end

//
//  UICollectionView+IMYAOPCollectionView.m
//  IMYAOPFeedsView
//
//  Created by ljh on 16/5/20.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import "IMYAOPCollectionView.h"
#import "IMYAOPCollectionViewUtils+Private.h"
#import "UICollectionView+IMYAOPCollectionView.h"
#import <objc/message.h>
#import <objc/runtime.h>

#define AopDefineObjcSuper struct objc_super objcSuper = {                                                           \
                               .super_class = aop_utils.origViewClass ?: [UICollectionView class], .receiver = self, \
};

#define AopDefineVars                                      \
    IMYAOPCollectionViewUtils *aop_utils = self.aop_utils; \
    AopDefineObjcSuper;                                    \
    if (aop_utils.isUICalling > 0) {                       \
        aop_utils = nil;                                   \
    }

#define AopCallSuper(selector) ((void (*)(void *, SEL))(void *)objc_msgSendSuper)(&objcSuper, selector);
#define AopCallSuperResult(selector) ((id(*)(void *, SEL))(void *)objc_msgSendSuper)(&objcSuper, selector);

#define AopCallSuper_1(selector, var0) ((void (*)(void *, SEL, id))(void *)objc_msgSendSuper)(&objcSuper, selector, var0);
#define AopCallSuperResult_1(selector, var0) ((id(*)(void *, SEL, id))(void *)objc_msgSendSuper)(&objcSuper, selector, var0);

#define AopCallSuper_2(selector, var0, var1) ((void (*)(void *, SEL, id, id))(void *)objc_msgSendSuper)(&objcSuper, selector, var0, var1);
#define AopCallSuperResult_2(selector, var0, var1) ((id(*)(void *, SEL, id, id))(void *)objc_msgSendSuper)(&objcSuper, selector, var0, var1);

#define AopCallSuper_3(selector, var0, var1, var2) ((void (*)(void *, SEL, id, id, id))(void *)objc_msgSendSuper)(&objcSuper, selector, var0, var1, var2);
#define AopCallSuperResult_3(selector, var0, var1, var2) ((id(*)(void *, SEL, id, id, id))(void *)objc_msgSendSuper)(&objcSuper, selector, var0, var1, var2);

//@implementation UIView (IMYADCollectionUtils)
//
//@end

@implementation UICollectionView (IMYAOPCollectionUtils)

+ (Class)imy_aopClass {
    return [_IMYAOPCollectionView class];
}

@end

@implementation _IMYAOPCollectionView

// 纯手动敲打
- (Class)aop_class {
    IMYAOPCollectionViewUtils *aop_utils = self.aop_utils;
    if (aop_utils) {
        return aop_utils.origViewClass;
    } else {
        return [super class];
    }
}

- (void)aop_setDelegate:(id<UICollectionViewDelegate>)delegate {
    IMYAOPCollectionViewUtils *aop_utils = self.aop_utils;
    if (aop_utils) {
        if (aop_utils.origDelegate != delegate) {
            AopDefineObjcSuper;
            AopCallSuper_1(@selector(setDelegate:), delegate);
            aop_utils.origDelegate = delegate;
        }
    } else {
        [super setDelegate:delegate];
    }
}

- (id<UICollectionViewDelegate>)aop_delegate {
    AopDefineVars;
    if (aop_utils) {
        return aop_utils.origDelegate;
    } else {
        return AopCallSuperResult(@selector(delegate));
    }
}

- (void)aop_setDataSource:(id<UICollectionViewDataSource>)dataSource {
    IMYAOPCollectionViewUtils *aop_utils = self.aop_utils;
    if (aop_utils) {
        if (aop_utils.origDataSource != dataSource) {
            AopDefineObjcSuper;
            AopCallSuper_1(@selector(setDataSource:), dataSource);
            aop_utils.origDataSource = dataSource;
        }
    } else {
        [super setDataSource:dataSource];
    }
}

- (id<UICollectionViewDataSource>)aop_dataSource {
    AopDefineVars;
    if (aop_utils) {
        return aop_utils.origDataSource;
    } else {
        return AopCallSuperResult(@selector(dataSource));
    }
}

// UI Calling

- (void)aop_bringSubviewToFront:(UIView *)view {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    AopCallSuper_1(@selector(bringSubviewToFront:), view);
    aop_utils.isUICalling -= 1;
}

- (void)aop_sendSubviewToBack:(UIView *)view {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    AopCallSuper_1(@selector(sendSubviewToBack:), view);
    aop_utils.isUICalling -= 1;
}

- (void)aop_willMoveToWindow:(UIWindow *)newWindow {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    AopCallSuper_1(@selector(willMoveToWindow:), newWindow);
    aop_utils.isUICalling -= 1;
}

- (void)aop_willMoveToSuperview:(UIView *)newSuperview {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    AopCallSuper_1(@selector(willMoveToSuperview:), newSuperview);
    aop_utils.isUICalling -= 1;
}

- (void)aop_didMoveToWindow {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    AopCallSuper(@selector(didMoveToWindow));
    aop_utils.isUICalling -= 1;
}

- (void)aop_didMoveToSuperview {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    AopCallSuper(@selector(didMoveToSuperview));
    aop_utils.isUICalling -= 1;
}

- (void)aop_reloadData {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    AopCallSuper(@selector(reloadData));
    aop_utils.isUICalling -= 1;
}

- (void)aop_layoutSubviews {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    AopCallSuper(@selector(layoutSubviews));
    aop_utils.isUICalling -= 1;
}

- (void)aop_setBounds:(CGRect)bounds {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    ((void (*)(void *, SEL, CGRect))(void *)objc_msgSendSuper)(&objcSuper, @selector(setBounds:), bounds);
    aop_utils.isUICalling -= 1;
}

- (void)aop_touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    AopCallSuper_2(@selector(touchesBegan:withEvent:), touches, event);
    aop_utils.isUICalling -= 1;
}

- (void)aop_touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    AopCallSuper_2(@selector(touchesMoved:withEvent:), touches, event);
    aop_utils.isUICalling -= 1;
}

- (void)aop_touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    AopCallSuper_2(@selector(touchesEnded:withEvent:), touches, event);
    aop_utils.isUICalling -= 1;
}

- (void)aop_touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    AopCallSuper_2(@selector(touchesCancelled:withEvent:), touches, event);
    aop_utils.isUICalling -= 1;
}

- (void)aop_touchesEstimatedPropertiesUpdated:(NSSet *)touches {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    AopCallSuper_1(@selector(touchesEstimatedPropertiesUpdated:), touches);
    aop_utils.isUICalling -= 1;
}

- (BOOL)aop_touchesShouldBegin:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    BOOL should = ((BOOL(*)(void *, SEL, id, id, id))(void *)objc_msgSendSuper)(&objcSuper, @selector(touchesShouldBegin:withEvent:inContentView:), touches, event, view);
    aop_utils.isUICalling -= 1;
    return should;
}

- (BOOL)aop_touchesShouldCancelInContentView:(UIView *)view {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    BOOL should = ((BOOL(*)(void *, SEL, id))(void *)objc_msgSendSuper)(&objcSuper, @selector(touchesShouldCancelInContentView:), view);
    aop_utils.isUICalling -= 1;
    return should;
}

- (BOOL)aop_gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    BOOL should = ((BOOL(*)(void *, SEL, id))(void *)objc_msgSendSuper)(&objcSuper, @selector(gestureRecognizerShouldBegin:), gestureRecognizer);
    aop_utils.isUICalling -= 1;
    return should;
}

//add real reload function

- (void)aop_refreshDataSource {
    IMYAOPCollectionViewUtils *aop_utils = self.aop_utils;
    IMYAOPCollectionViewUtils *uiAopUtils = nil;
    if (aop_utils.isUICalling <= 0) {
        uiAopUtils = aop_utils;
    }
    uiAopUtils.isUICalling += 1;
    [super setDataSource:nil];
    [super setDataSource:(id)aop_utils];
    uiAopUtils.isUICalling -= 1;
}

- (void)aop_refreshDelegate {
    IMYAOPCollectionViewUtils *aop_utils = self.aop_utils;
    IMYAOPCollectionViewUtils *uiAopUtils = nil;
    if (aop_utils.isUICalling <= 0) {
        uiAopUtils = aop_utils;
    }
    uiAopUtils.isUICalling += 1;
    [super setDelegate:nil];
    [super setDelegate:(id)aop_utils];
    uiAopUtils.isUICalling -= 1;
}

- (NSArray<UICollectionViewCell *> *)aop_containVisibleCells:(const IMYAOPType)containType {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    NSArray<UICollectionViewCell *> *visibleCells = AopCallSuperResult(@selector(visibleCells));
    NSMutableArray *filteredArray = [NSMutableArray array];
    ///全部返回
    if (containType == IMYAOPTypeAll) {
        [filteredArray addObjectsFromArray:visibleCells];
    } else {
        for (UICollectionViewCell *cell in visibleCells) {
            NSIndexPath *indexPath = AopCallSuperResult_1(@selector(indexPathForCell:), cell);
            if (aop_utils) {
                indexPath = [aop_utils userIndexPathByFeeds:indexPath];
            }
            if (containType == IMYAOPTypeInsert) {
                ///只返回插入的cell
                if (indexPath == nil) {
                    [filteredArray addObject:cell];
                }
            } else {
                ///只返回原有的cell
                if (indexPath != nil) {
                    [filteredArray addObject:cell];
                }
            }
        }
    }
    aop_utils.isUICalling -= 1;
    return filteredArray;
}

- (NSArray<UICollectionReusableView *> *)aop_containVisibleSupplementaryViews:(const IMYAOPType)containType
                                                                       ofKind:(NSString *)elementKind {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    NSArray<UICollectionReusableView *> *visibleCells = AopCallSuperResult_1(@selector(visibleSupplementaryViewsOfKind:), elementKind);
    NSMutableArray *filteredArray = [NSMutableArray array];
    ///全部返回
    if (containType == IMYAOPTypeAll) {
        [filteredArray addObjectsFromArray:visibleCells];
    } else {
        for (UICollectionReusableView *cell in visibleCells) {
            CGPoint point = CGPointMake((NSInteger)(cell.frame.origin.x + cell.frame.size.width / 2.0), (NSInteger)(cell.frame.origin.y + cell.frame.size.height / 2.0));
            NSIndexPath *indexPath = ((id(*)(void *, SEL, CGPoint))(void *)objc_msgSendSuper)(&objcSuper, @selector(indexPathForItemAtPoint:), point);
            if (aop_utils) {
                indexPath = [aop_utils userIndexPathByFeeds:indexPath];
            }
            if (containType == IMYAOPTypeInsert) {
                ///只返回插入的cell
                if (indexPath == nil) {
                    [filteredArray addObject:cell];
                }
            } else {
                ///只返回原有的cell
                if (indexPath != nil) {
                    [filteredArray addObject:cell];
                }
            }
        }
    }
    aop_utils.isUICalling -= 1;
    return filteredArray;
}

// Info

#pragma mark - Appearance

- (UICollectionViewCell *)aop_dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    AopDefineVars;
    if (aop_utils) {
        indexPath = [aop_utils feedsIndexPathByUser:indexPath];
    }
    aop_utils.isUICalling += 1;
    UICollectionViewCell *dequeueCell = AopCallSuperResult_2(@selector(dequeueReusableCellWithReuseIdentifier:forIndexPath:), identifier, indexPath);
    aop_utils.isUICalling -= 1;
    return dequeueCell;
}

- (UICollectionReusableView *)aop_dequeueReusableSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    AopDefineVars;
    if (aop_utils) {
        indexPath = [aop_utils feedsIndexPathByUser:indexPath];
    }
    aop_utils.isUICalling += 1;
    UICollectionReusableView *reusableView = AopCallSuperResult_3(@selector(dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:),
                                                                  elementKind, identifier, indexPath);
    aop_utils.isUICalling -= 1;
    return reusableView;
}

- (NSArray<NSIndexPath *> *)aop_indexPathsForSelectedItems {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    NSArray<NSIndexPath *> *array = AopCallSuperResult(@selector(indexPathsForSelectedItems));
    if (aop_utils) {
        array = [aop_utils userIndexPathsByFeedsIndexPaths:array];
    }
    aop_utils.isUICalling -= 1;
    return array;
}

- (NSArray<NSIndexPath *> *)aop_indexPathsForVisibleItems {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    NSArray<NSIndexPath *> *array = AopCallSuperResult(@selector(indexPathsForVisibleItems));
    if (aop_utils) {
        array = [aop_utils userIndexPathsByFeedsIndexPaths:array];
    }
    aop_utils.isUICalling -= 1;
    return array;
}

- (void)aop_selectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition {
    AopDefineVars;
    if (aop_utils) {
        indexPath = [aop_utils feedsIndexPathByUser:indexPath];
    }
    aop_utils.isUICalling += 1;
    ((void (*)(void *, SEL, id, BOOL, UICollectionViewScrollPosition))(void *)objc_msgSendSuper)(&objcSuper, @selector(selectItemAtIndexPath:animated:scrollPosition:), indexPath, animated, scrollPosition);
    aop_utils.isUICalling -= 1;
}

- (void)aop_deselectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
    AopDefineVars;
    if (aop_utils) {
        indexPath = [aop_utils feedsIndexPathByUser:indexPath];
    }
    aop_utils.isUICalling += 1;
    ((void (*)(void *, SEL, id, BOOL))(void *)objc_msgSendSuper)(&objcSuper, @selector(deselectItemAtIndexPath:animated:), indexPath, animated);
    aop_utils.isUICalling -= 1;
}


- (void)aop_setCollectionViewLayout:(UICollectionViewLayout *)layout animated:(BOOL)animated {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    ((void (*)(void *, SEL, id, BOOL))(void *)objc_msgSendSuper)(&objcSuper, @selector(setCollectionViewLayout:animated:), layout, animated);
    aop_utils.isUICalling -= 1;
}

- (void)aop_setCollectionViewLayout:(UICollectionViewLayout *)layout animated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    ((void (*)(void *, SEL, id, BOOL, void (^)(BOOL)))(void *)objc_msgSendSuper)(&objcSuper, @selector(setCollectionViewLayout:animated:completion:), layout, animated, completion);
    aop_utils.isUICalling -= 1;
}

- (UICollectionViewTransitionLayout *)aop_startInteractiveTransitionToCollectionViewLayout:(UICollectionViewLayout *)layout completion:(UICollectionViewLayoutInteractiveTransitionCompletion)completion {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    UICollectionViewTransitionLayout *transitionLayout = ((id(*)(void *, SEL, id, UICollectionViewLayoutInteractiveTransitionCompletion))(void *)objc_msgSendSuper)(&objcSuper, @selector(startInteractiveTransitionToCollectionViewLayout:completion:), layout, completion);
    aop_utils.isUICalling -= 1;
    return transitionLayout;
}

- (void)aop_finishInteractiveTransition {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    AopCallSuper(@selector(finishInteractiveTransition));
    aop_utils.isUICalling -= 1;
}

- (void)aop_cancelInteractiveTransition {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    AopCallSuper(@selector(cancelInteractiveTransition));
    aop_utils.isUICalling -= 1;
}

- (NSInteger)aop_numberOfSections {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    NSInteger number = ((NSInteger(*)(void *, SEL))(void *)objc_msgSendSuper)(&objcSuper, @selector(numberOfSections));
    aop_utils.isUICalling -= 1;
    if (aop_utils) {
        number = [aop_utils userSectionByFeeds:number];
    }
    return number;
}

- (NSInteger)aop_numberOfItemsInSection:(NSInteger)section {
    AopDefineVars;
    if (aop_utils) {
        section = [aop_utils feedsSectionByUser:section];
    }
    aop_utils.isUICalling += 1;
    NSInteger number = ((NSInteger(*)(void *, SEL, NSInteger))(void *)objc_msgSendSuper)(&objcSuper, @selector(numberOfItemsInSection:), section);
    aop_utils.isUICalling -= 1;
    if (aop_utils && number > 0) {
        number = [aop_utils userIndexPathByFeeds:[NSIndexPath indexPathForRow:number inSection:section]].row;
    }
    return number;
}

- (UICollectionViewLayoutAttributes *)aop_layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    AopDefineVars;
    if (aop_utils) {
        indexPath = [aop_utils feedsIndexPathByUser:indexPath];
    }
    aop_utils.isUICalling += 1;
    UICollectionViewLayoutAttributes *attributes = AopCallSuperResult_1(@selector(layoutAttributesForItemAtIndexPath:), indexPath);
    aop_utils.isUICalling -= 1;
    return attributes;
}

- (UICollectionViewLayoutAttributes *)aop_layoutAttributesForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    AopDefineVars;
    if (aop_utils) {
        indexPath = [aop_utils feedsIndexPathByUser:indexPath];
    }
    aop_utils.isUICalling += 1;
    UICollectionViewLayoutAttributes *attributes = AopCallSuperResult_2(@selector(layoutAttributesForSupplementaryElementOfKind:atIndexPath:),
                                                                        kind, indexPath);
    aop_utils.isUICalling -= 1;
    return attributes;
}

- (NSIndexPath *)aop_indexPathForItemAtPoint:(CGPoint)point {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    NSIndexPath *indexPath = ((id(*)(void *, SEL, CGPoint))(void *)objc_msgSendSuper)(&objcSuper, @selector(indexPathForItemAtPoint:), point);
    aop_utils.isUICalling -= 1;
    if (aop_utils) {
        indexPath = [aop_utils userIndexPathByFeeds:indexPath];
    }
    return indexPath;
}

- (NSIndexPath *)aop_indexPathForCell:(UICollectionViewCell *)cell {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    NSIndexPath *indexPath = AopCallSuperResult_1(@selector(indexPathForCell:), cell);
    aop_utils.isUICalling -= 1;
    if (aop_utils) {
        indexPath = [aop_utils userIndexPathByFeeds:indexPath] ?: indexPath;
    }
    return indexPath;
}

- (UICollectionViewCell *)aop_cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AopDefineVars;
    if (aop_utils) {
        indexPath = [aop_utils feedsIndexPathByUser:indexPath];
    }
    aop_utils.isUICalling += 1;
    UICollectionViewCell *cell = AopCallSuperResult_1(@selector(cellForItemAtIndexPath:), indexPath);
    aop_utils.isUICalling -= 1;
    return cell;
}

- (NSArray<UICollectionViewCell *> *)aop_visibleCells {
    return [self aop_containVisibleCells:IMYAOPTypeRaw];
}

- (UICollectionReusableView *)aop_supplementaryViewForElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    AopDefineVars;
    if (aop_utils) {
        indexPath = [aop_utils feedsIndexPathByUser:indexPath];
    }
    aop_utils.isUICalling += 1;
    UICollectionReusableView *reusableView = AopCallSuperResult_2(@selector(supplementaryViewForElementKind:atIndexPath:),
                                                                  elementKind, indexPath);
    aop_utils.isUICalling -= 1;
    return reusableView;
}

- (NSArray<UICollectionReusableView *> *)aop_visibleSupplementaryViewsOfKind:(NSString *)elementKind {
    return [self aop_containVisibleSupplementaryViews:IMYAOPTypeRaw ofKind:elementKind];
}

- (NSArray<NSIndexPath *> *)aop_indexPathsForVisibleSupplementaryElementsOfKind:(NSString *)elementKind {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    NSArray<NSIndexPath *> *array = AopCallSuperResult_1(@selector(indexPathsForVisibleSupplementaryElementsOfKind:), elementKind);
    if (aop_utils) {
        array = [aop_utils userIndexPathsByFeedsIndexPaths:array];
    }
    aop_utils.isUICalling -= 1;
    return array;
}

// Interacting with the collection view.

- (void)aop_scrollToItemAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated {
    AopDefineVars;
    if (aop_utils) {
        indexPath = [aop_utils feedsIndexPathByUser:indexPath];
    }
    aop_utils.isUICalling += 1;
    ((void (*)(void *, SEL, id, UICollectionViewScrollPosition, BOOL))(void *)objc_msgSendSuper)(&objcSuper, @selector(scrollToItemAtIndexPath:atScrollPosition:animated:), indexPath, scrollPosition, animated);
    aop_utils.isUICalling -= 1;
}

// These methods allow dynamic modification of the current set of items in the collection view
- (void)aop_insertSections:(NSIndexSet *)sections {
    AopDefineVars;
    if (aop_utils) {
        sections = [aop_utils feedsSectionsByUserSet:sections];
    }
    aop_utils.isUICalling += 1;
    AopCallSuper_1(@selector(insertSections:), sections);
    aop_utils.isUICalling -= 1;
}

- (void)aop_deleteSections:(NSIndexSet *)sections {
    AopDefineVars;
    if (aop_utils) {
        sections = [aop_utils feedsSectionsByUserSet:sections];
    }
    aop_utils.isUICalling += 1;
    AopCallSuper_1(@selector(deleteSections:), sections);
    aop_utils.isUICalling -= 1;
}

- (void)aop_reloadSections:(NSIndexSet *)sections {
    AopDefineVars;
    if (aop_utils) {
        sections = [aop_utils feedsSectionsByUserSet:sections];
    }
    aop_utils.isUICalling += 1;
    AopCallSuper_1(@selector(reloadSections:), sections);
    aop_utils.isUICalling -= 1;
}

- (void)aop_moveSection:(NSInteger)section toSection:(NSInteger)newSection {
    AopDefineVars;
    if (aop_utils) {
        section = [aop_utils feedsSectionByUser:section];
        newSection = [aop_utils feedsSectionByUser:newSection];
    }
    aop_utils.isUICalling += 1;
    ((void (*)(void *, SEL, NSInteger, NSInteger))(void *)objc_msgSendSuper)(&objcSuper, @selector(moveSection:toSection:), section, newSection);
    aop_utils.isUICalling -= 1;
}


- (void)aop_insertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    AopDefineVars;
    if (aop_utils) {
        indexPaths = [aop_utils feedsIndexPathsByUserIndexPaths:indexPaths];
    }
    aop_utils.isUICalling += 1;
    AopCallSuper_1(@selector(insertItemsAtIndexPaths:), indexPaths);
    aop_utils.isUICalling -= 1;
}

- (void)aop_deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    AopDefineVars;
    if (aop_utils) {
        indexPaths = [aop_utils feedsIndexPathsByUserIndexPaths:indexPaths];
    }
    aop_utils.isUICalling += 1;
    AopCallSuper_1(@selector(deleteItemsAtIndexPaths:), indexPaths);
    aop_utils.isUICalling -= 1;
}

- (void)aop_reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    AopDefineVars;
    if (aop_utils) {
        indexPaths = [aop_utils feedsIndexPathsByUserIndexPaths:indexPaths];
    }
    aop_utils.isUICalling += 1;
    AopCallSuper_1(@selector(reloadItemsAtIndexPaths:), indexPaths);
    aop_utils.isUICalling -= 1;
}

- (void)aop_moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath {
    AopDefineVars;
    if (aop_utils) {
        indexPath = [aop_utils feedsIndexPathByUser:indexPath];
        newIndexPath = [aop_utils feedsIndexPathByUser:newIndexPath];
    }
    aop_utils.isUICalling += 1;
    AopCallSuper_2(@selector(moveItemAtIndexPath:toIndexPath:), indexPath, newIndexPath);
    aop_utils.isUICalling -= 1;
}

// allows multiple insert/delete/reload/move calls to be animated simultaneously. Nestable.
- (void)aop_performBatchUpdates:(void(NS_NOESCAPE ^)(void))updates completion:(void (^)(BOOL finished))completion {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    ((void (*)(void *, SEL, void(NS_NOESCAPE ^)(void), void (^)(BOOL)))(void *)objc_msgSendSuper)(&objcSuper, @selector(performBatchUpdates:completion:), updates, completion);
    aop_utils.isUICalling -= 1;
}

// Support for reordering
- (BOOL)aop_beginInteractiveMovementForItemAtIndexPath:(NSIndexPath *)indexPath {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    BOOL result = ((BOOL(*)(void *, SEL, NSIndexPath *))(void *)objc_msgSendSuper)(&objcSuper, @selector(beginInteractiveMovementForItemAtIndexPath:), indexPath);
    aop_utils.isUICalling -= 1;
    return result;
}

- (void)aop_updateInteractiveMovementTargetPosition:(CGPoint)targetPosition {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    ((void (*)(void *, SEL, CGPoint))(void *)objc_msgSendSuper)(&objcSuper, @selector(updateInteractiveMovementTargetPosition:), targetPosition);
    aop_utils.isUICalling -= 1;
}

- (void)aop_endInteractiveMovement {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    AopCallSuper(@selector(endInteractiveMovement));
    aop_utils.isUICalling -= 1;
}

- (void)aop_cancelInteractiveMovement {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    AopCallSuper(@selector(cancelInteractiveMovement));
    aop_utils.isUICalling -= 1;
}

@end

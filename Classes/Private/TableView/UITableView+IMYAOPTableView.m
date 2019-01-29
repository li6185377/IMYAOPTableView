//
//  UITableView+IMYAOPTableView.m
//  IMYAOPFeedsView
//
//  Created by ljh on 16/5/20.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import "IMYAOPTableView.h"
#import "IMYAOPTableViewUtils+Private.h"
#import "UITableView+IMYAOPTableView.h"
#import <objc/message.h>
#import <objc/runtime.h>

extern BOOL imyaop_swizzleMethod(Class clazz, SEL origSel_, SEL altSel_);

#define AopDefineObjcSuper struct objc_super objcSuper = {                                                      \
                               .super_class = aop_utils.origViewClass ?: [UITableView class], .receiver = self, \
};

#define AopDefineVars                                 \
    IMYAOPGlobalUICalling = NO;                       \
    IMYAOPTableViewUtils *aop_utils = self.aop_utils; \
    AopDefineObjcSuper;                               \
    if (aop_utils.isUICalling > 0) {                  \
        aop_utils = nil;                              \
    }                                                 \

#define AopCallSuper(selector) ((void (*)(void *, SEL))(void *)objc_msgSendSuper)(&objcSuper, selector);
#define AopCallSuperResult(selector) ((id(*)(void *, SEL))(void *)objc_msgSendSuper)(&objcSuper, selector);

#define AopCallSuper_1(selector, var0) ((void (*)(void *, SEL, id))(void *)objc_msgSendSuper)(&objcSuper, selector, var0);
#define AopCallSuperResult_1(selector, var0) ((id(*)(void *, SEL, id))(void *)objc_msgSendSuper)(&objcSuper, selector, var0);

#define AopCallSuper_2(selector, var0, var1) ((void (*)(void *, SEL, id, id))(void *)objc_msgSendSuper)(&objcSuper, selector, var0, var1);
#define AopCallSuperResult_2(selector, var0, var1) ((id(*)(void *, SEL, id, id))(void *)objc_msgSendSuper)(&objcSuper, selector, var0, var1);

@implementation UIView (IMYAOPTableUtils)

- (BOOL)imyaop_gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    NSString *className = NSStringFromClass(self.class);
    if (![className hasSuffix:@"TableViewWrapperView"]) {
        return [self imyaop_gestureRecognizerShouldBegin:gestureRecognizer];
    }
    UITableView *tableView = (id)self.superview;
    while (tableView && ![tableView isKindOfClass:[UITableView class]]) {
        tableView = (id)tableView.superview;
    }
    IMYAOPTableViewUtils *aop_utils = nil;
    if (tableView.aop_installed) {
        aop_utils = tableView.aop_utils;
        if (aop_utils.isUICalling > 0) {
            aop_utils = nil;
        }
    }
    aop_utils.isUICalling += 1;
    BOOL shouldBegin = [self imyaop_gestureRecognizerShouldBegin:gestureRecognizer];
    aop_utils.isUICalling -= 1;
    return shouldBegin;
}

@end

static BOOL IMYAOPGlobalUICalling = NO;

@implementation UITableView (IMYAOPTableUtils)

+ (Class)imy_aopClass {
    return [_IMYAOPTableView class];
}

@end

@implementation _IMYAOPTableView

+ (void)aop_setupConfigs {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imyaop_swizzleMethod([UIView class], @selector(gestureRecognizerShouldBegin:), @selector(imyaop_gestureRecognizerShouldBegin:));
    });
}

- (void)aop_setDelegate:(id<UITableViewDelegate>)delegate {
    IMYAOPTableViewUtils *aop_utils = self.aop_utils;
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

- (BOOL)aop_allowsSelection {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    BOOL allowsSelection = ((BOOL(*)(void *, SEL))(void *)objc_msgSendSuper)(&objcSuper, @selector(allowsSelection));
    aop_utils.isUICalling -= 1;
    IMYAOPGlobalUICalling = YES;
    return allowsSelection;
}

- (id<UITableViewDelegate>)aop_delegate {
    if (IMYAOPGlobalUICalling && self.aop_utils.isUICalling == 0) {
        AopDefineVars;
        return AopCallSuperResult(@selector(delegate));
    }
    AopDefineVars;
    if (aop_utils) {
        return aop_utils.origDelegate;
    } else {
        return AopCallSuperResult(@selector(delegate));
    }
}

- (void)aop_setDataSource:(id<UITableViewDataSource>)dataSource {
    IMYAOPTableViewUtils *aop_utils = self.aop_utils;
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

- (id<UITableViewDataSource>)aop_dataSource {
    AopDefineVars;
    if (aop_utils) {
        return aop_utils.origDataSource;
    } else {
        return AopCallSuperResult(@selector(dataSource));
    }
}

- (Class)aop_class {
    IMYAOPTableViewUtils *aop_utils = self.aop_utils;
    if (aop_utils) {
        return aop_utils.origViewClass;
    } else {
        return [super class];
    }
}

/// UI Calling

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

- (void)aop_touchesEstimatedPropertiesUpdated:(NSSet *)touches {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    AopCallSuper_1(@selector(touchesEstimatedPropertiesUpdated:), touches);
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

- (BOOL)aop_touchesShouldCancelInContentView:(UIView *)view {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    BOOL should = ((BOOL(*)(void *, SEL, id))(void *)objc_msgSendSuper)(&objcSuper, @selector(touchesShouldCancelInContentView:), view);
    aop_utils.isUICalling -= 1;
    return should;
}

- (BOOL)aop_touchesShouldBegin:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    BOOL should = ((BOOL(*)(void *, SEL, id, id, id))(void *)objc_msgSendSuper)(&objcSuper, @selector(touchesShouldBegin:withEvent:inContentView:), touches, event, view);
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

- (void)aop_layoutSubviews {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    AopCallSuper(@selector(layoutSubviews));
    aop_utils.isUICalling -= 1;
}

- (void)aop_reloadData {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    AopCallSuper(@selector(reloadData));
    aop_utils.isUICalling -= 1;
}

- (void)aop_refreshDelegate {
    IMYAOPTableViewUtils *aop_utils = self.aop_utils;
    IMYAOPTableViewUtils *uiAopUtils = nil;
    if (aop_utils.isUICalling <= 0) {
        uiAopUtils = aop_utils;
    }
    uiAopUtils.isUICalling += 1;
    [super setDelegate:nil];
    [super setDelegate:(id)aop_utils];
    uiAopUtils.isUICalling -= 1;
}

- (void)aop_refreshDataSource {
    IMYAOPTableViewUtils *aop_utils = self.aop_utils;
    IMYAOPTableViewUtils *uiAopUtils = nil;
    if (aop_utils.isUICalling <= 0) {
        uiAopUtils = aop_utils;
    }
    uiAopUtils.isUICalling += 1;
    [super setDataSource:nil];
    [super setDataSource:(id)aop_utils];
    uiAopUtils.isUICalling -= 1;
}

- (void)aop_reloadSectionIndexTitles {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    AopCallSuper(@selector(reloadSectionIndexTitles));
    aop_utils.isUICalling -= 1;
}

- (void)aop_beginUpdates {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    AopCallSuper(@selector(beginUpdates));
    aop_utils.isUICalling -= 1;
}

- (void)aop_endUpdates {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    AopCallSuper(@selector(endUpdates));
    aop_utils.isUICalling -= 1;
}

- (void)aop_setBounds:(CGRect)bounds {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    ((void (*)(void *, SEL, CGRect))(void *)objc_msgSendSuper)(&objcSuper, @selector(setBounds:), bounds);
    aop_utils.isUICalling -= 1;
}

// Info
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

- (NSInteger)aop_numberOfRowsInSection:(NSInteger)section {
    AopDefineVars;
    if (aop_utils) {
        section = [aop_utils feedsSectionByUser:section];
    }
    aop_utils.isUICalling += 1;
    NSInteger number = ((NSInteger(*)(void *, SEL, NSInteger))(void *)objc_msgSendSuper)(&objcSuper, @selector(numberOfRowsInSection:), section);
    aop_utils.isUICalling -= 1;
    if (aop_utils && number > 0) {
        number = [aop_utils userIndexPathByFeeds:[NSIndexPath indexPathForRow:number inSection:section]].row;
    }
    return number;
}

- (CGRect)aop_rectForSection:(NSInteger)section {
    AopDefineVars;
    if (aop_utils) {
        section = [aop_utils feedsSectionByUser:section];
    }
    aop_utils.isUICalling += 1;
    CGRect (*actionBlock)(void *, SEL, NSInteger);
#if !defined(__arm64__)
    actionBlock = (void *)objc_msgSendSuper_stret;
#else
    actionBlock = (void *)objc_msgSendSuper;
#endif
    CGRect rect = actionBlock(&objcSuper, @selector(rectForSection:), section);
    aop_utils.isUICalling -= 1;
    return rect;
}

- (CGRect)aop_rectForHeaderInSection:(NSInteger)section {
    AopDefineVars;
    if (aop_utils) {
        section = [aop_utils feedsSectionByUser:section];
    }
    aop_utils.isUICalling += 1;
    CGRect (*actionBlock)(void *, SEL, NSInteger);
#if !defined(__arm64__)
    actionBlock = (void *)objc_msgSendSuper_stret;
#else
    actionBlock = (void *)objc_msgSendSuper;
#endif
    CGRect rect = actionBlock(&objcSuper, @selector(rectForHeaderInSection:), section);
    aop_utils.isUICalling -= 1;
    return rect;
}

- (CGRect)aop_rectForFooterInSection:(NSInteger)section {
    AopDefineVars;
    if (aop_utils) {
        section = [aop_utils feedsSectionByUser:section];
    }
    aop_utils.isUICalling += 1;
    CGRect (*actionBlock)(void *, SEL, NSInteger);
#if !defined(__arm64__)
    actionBlock = (void *)objc_msgSendSuper_stret;
#else
    actionBlock = (void *)objc_msgSendSuper;
#endif
    CGRect rect = actionBlock(&objcSuper, @selector(rectForFooterInSection:), section);
    aop_utils.isUICalling -= 1;
    return rect;
}

- (CGRect)aop_rectForRowAtIndexPath:(NSIndexPath *)indexPath {
    AopDefineVars;
    if (aop_utils) {
        indexPath = [aop_utils feedsIndexPathByUser:indexPath];
    }
    aop_utils.isUICalling += 1;
    CGRect (*actionBlock)(void *, SEL, id);
#if !defined(__arm64__)
    actionBlock = (void *)objc_msgSendSuper_stret;
#else
    actionBlock = (void *)objc_msgSendSuper;
#endif
    CGRect rect = actionBlock(&objcSuper, @selector(rectForRowAtIndexPath:), indexPath);
    aop_utils.isUICalling -= 1;
    return rect;
}

- (NSIndexPath *)aop_indexPathForRowAtPoint:(CGPoint)point {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    NSIndexPath *indexPath = ((id(*)(void *, SEL, CGPoint))(void *)objc_msgSendSuper)(&objcSuper, @selector(indexPathForRowAtPoint:), point);
    aop_utils.isUICalling -= 1;
    if (aop_utils) {
        indexPath = [aop_utils userIndexPathByFeeds:indexPath];
    }
    return indexPath;
}

- (NSIndexPath *)aop_indexPathForCell:(UITableViewCell *)cell {
    BOOL isGlobalUICalling = IMYAOPGlobalUICalling;
    AopDefineVars;
    if (isGlobalUICalling) {
        aop_utils = nil;
        IMYAOPGlobalUICalling = YES;
    }
    aop_utils.isUICalling += 1;
    NSIndexPath *indexPath = AopCallSuperResult_1(@selector(indexPathForCell:), cell);
    aop_utils.isUICalling -= 1;
    if (aop_utils) {
        indexPath = [aop_utils userIndexPathByFeeds:indexPath] ?: indexPath;
    }
    return indexPath;
}

- (NSArray<NSIndexPath *> *)aop_indexPathsForRowsInRect:(CGRect)rect {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    NSArray<NSIndexPath *> *indexPaths = ((id(*)(void *, SEL, CGRect))(void *)objc_msgSendSuper)(&objcSuper, @selector(indexPathsForRowsInRect:), rect);
    ;
    aop_utils.isUICalling -= 1;
    if (aop_utils) {
        indexPaths = [aop_utils userIndexPathsByFeedsIndexPaths:indexPaths];
    }
    return indexPaths;
}

- (UITableViewCell *)aop_cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AopDefineVars;
    if (aop_utils) {
        indexPath = [aop_utils feedsIndexPathByUser:indexPath];
    }
    aop_utils.isUICalling += 1;
    UITableViewCell *cell = AopCallSuperResult_1(@selector(cellForRowAtIndexPath:), indexPath);
    aop_utils.isUICalling -= 1;
    return cell;
}

- (NSArray<UITableViewCell *> *)aop_containVisibleCells:(const IMYAOPType)containType {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    NSArray<UITableViewCell *> *visibleCells = AopCallSuperResult(@selector(visibleCells));
    NSMutableArray *filteredArray = [NSMutableArray array];
    ///全部返回
    if (containType == IMYAOPTypeAll) {
        [filteredArray addObjectsFromArray:visibleCells];
    } else {
        for (UITableViewCell *cell in visibleCells) {
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

- (NSArray<UITableViewCell *> *)aop_visibleCells {
    return [self aop_containVisibleCells:0];
}

- (NSArray<NSIndexPath *> *)aop_indexPathsForVisibleRows {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    NSArray<NSIndexPath *> *array = AopCallSuperResult(@selector(indexPathsForVisibleRows));
    if (aop_utils) {
        array = [aop_utils userIndexPathsByFeedsIndexPaths:array];
    }
    aop_utils.isUICalling -= 1;
    return array;
}

- (UITableViewHeaderFooterView *)aop_headerViewForSection:(NSInteger)section {
    AopDefineVars;
    if (aop_utils) {
        section = [aop_utils feedsSectionByUser:section];
    }
    aop_utils.isUICalling += 1;
    UITableViewHeaderFooterView *headerView = ((id(*)(void *, SEL, NSInteger))(void *)objc_msgSendSuper)(&objcSuper, @selector(headerViewForSection:), section);
    aop_utils.isUICalling -= 1;
    return headerView;
}

- (UITableViewHeaderFooterView *)aop_footerViewForSection:(NSInteger)section {
    AopDefineVars;
    if (aop_utils) {
        section = [aop_utils feedsSectionByUser:section];
    }
    aop_utils.isUICalling += 1;
    UITableViewHeaderFooterView *footerView = ((id(*)(void *, SEL, NSInteger))(void *)objc_msgSendSuper)(&objcSuper, @selector(footerViewForSection:), section);
    aop_utils.isUICalling -= 1;
    return footerView;
}

- (void)aop_scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated {
    AopDefineVars;
    if (aop_utils) {
        indexPath = [aop_utils feedsIndexPathByUser:indexPath];
    }
    aop_utils.isUICalling += 1;
    ((void (*)(void *, SEL, id, UITableViewScrollPosition, BOOL))(void *)objc_msgSendSuper)(&objcSuper, @selector(scrollToRowAtIndexPath:atScrollPosition:animated:), indexPath, scrollPosition, animated);
    aop_utils.isUICalling -= 1;
}

// Row insertion/deletion/reloading.
- (void)aop_insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    AopDefineVars;
    if (aop_utils) {
        sections = [aop_utils feedsSectionsByUserSet:sections];
    }
    aop_utils.isUICalling += 1;
    ((void (*)(void *, SEL, id, UITableViewRowAnimation))(void *)objc_msgSendSuper)(&objcSuper, @selector(insertSections:withRowAnimation:), sections, animation);
    aop_utils.isUICalling -= 1;
}

- (void)aop_deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    AopDefineVars;
    if (aop_utils) {
        sections = [aop_utils feedsSectionsByUserSet:sections];
    }
    aop_utils.isUICalling += 1;
    ((void (*)(void *, SEL, id, UITableViewRowAnimation))(void *)objc_msgSendSuper)(&objcSuper, @selector(deleteSections:withRowAnimation:), sections, animation);
    aop_utils.isUICalling -= 1;
}

- (void)aop_reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    AopDefineVars;
    if (aop_utils) {
        sections = [aop_utils feedsSectionsByUserSet:sections];
    }
    aop_utils.isUICalling += 1;
    ((void (*)(void *, SEL, id, UITableViewRowAnimation))(void *)objc_msgSendSuper)(&objcSuper, @selector(reloadSections:withRowAnimation:), sections, animation);
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

- (void)aop_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    AopDefineVars;
    if (aop_utils) {
        indexPaths = [aop_utils feedsIndexPathsByUserIndexPaths:indexPaths];
    }
    aop_utils.isUICalling += 1;
    ((void (*)(void *, SEL, id, UITableViewRowAnimation))(void *)objc_msgSendSuper)(&objcSuper, @selector(insertRowsAtIndexPaths:withRowAnimation:), indexPaths, animation);
    aop_utils.isUICalling -= 1;
}

- (void)aop_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    AopDefineVars;
    if (aop_utils) {
        indexPaths = [aop_utils feedsIndexPathsByUserIndexPaths:indexPaths];
    }
    aop_utils.isUICalling += 1;
    ((void (*)(void *, SEL, id, UITableViewRowAnimation))(void *)objc_msgSendSuper)(&objcSuper, @selector(deleteRowsAtIndexPaths:withRowAnimation:), indexPaths, animation);
    aop_utils.isUICalling -= 1;
}

- (void)aop_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    AopDefineVars;
    if (aop_utils) {
        indexPaths = [aop_utils feedsIndexPathsByUserIndexPaths:indexPaths];
    }
    aop_utils.isUICalling += 1;
    ((void (*)(void *, SEL, id, UITableViewRowAnimation))(void *)objc_msgSendSuper)(&objcSuper, @selector(reloadRowsAtIndexPaths:withRowAnimation:), indexPaths, animation);
    aop_utils.isUICalling -= 1;
}

- (void)aop_moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath {
    AopDefineVars;
    if (aop_utils) {
        indexPath = [aop_utils feedsIndexPathByUser:indexPath];
        newIndexPath = [aop_utils feedsIndexPathByUser:newIndexPath];
    }
    aop_utils.isUICalling += 1;
    AopCallSuper_2(@selector(moveRowAtIndexPath:toIndexPath:), indexPath, newIndexPath);
    aop_utils.isUICalling -= 1;
}

// Selection
- (NSIndexPath *)aop_indexPathForSelectedRow {
    BOOL isGlobalUICalling = IMYAOPGlobalUICalling;
    AopDefineVars;
    if (isGlobalUICalling) {
        aop_utils = nil;
        IMYAOPGlobalUICalling = YES;
    }
    aop_utils.isUICalling += 1;
    NSIndexPath *indexPath = AopCallSuperResult(@selector(indexPathForSelectedRow));
    aop_utils.isUICalling -= 1;
    if (aop_utils) {
        indexPath = [aop_utils userIndexPathByFeeds:indexPath];
    }
    return indexPath;
}

- (NSArray<NSIndexPath *> *)aop_indexPathsForSelectedRows {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    NSArray<NSIndexPath *> *indexPaths = AopCallSuperResult(@selector(indexPathsForSelectedRows));
    aop_utils.isUICalling -= 1;
    if (aop_utils) {
        indexPaths = [aop_utils userIndexPathsByFeedsIndexPaths:indexPaths];
    }
    return indexPaths;
}

- (void)aop_selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition {
    AopDefineVars;
    if (aop_utils) {
        indexPath = [aop_utils feedsIndexPathByUser:indexPath];
    }
    aop_utils.isUICalling += 1;
    ((void (*)(void *, SEL, id, BOOL, UITableViewScrollPosition))(void *)objc_msgSendSuper)(&objcSuper, @selector(reloadRowsAtIndexPaths:withRowAnimation:), indexPath, animated, scrollPosition);
    aop_utils.isUICalling -= 1;
}

- (void)aop_deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    ((void (*)(void *, SEL, id, BOOL))(void *)objc_msgSendSuper)(&objcSuper, @selector(deselectRowAtIndexPath:animated:), indexPath, animated);
    if (aop_utils) {
        indexPath = [aop_utils feedsIndexPathByUser:indexPath];
        ((void (*)(void *, SEL, id, BOOL))(void *)objc_msgSendSuper)(&objcSuper, @selector(deselectRowAtIndexPath:animated:), indexPath, animated);
    }
    aop_utils.isUICalling -= 1;
}

// Appearance
- (UITableViewCell *)aop_dequeueReusableCellWithIdentifier:(NSString *)identifier {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    UITableViewCell *dequeueCell = AopCallSuperResult_1(@selector(dequeueReusableCellWithIdentifier:), identifier);
    aop_utils.isUICalling -= 1;
    return dequeueCell;
}

- (UITableViewHeaderFooterView *)aop_dequeueReusableHeaderFooterViewWithIdentifier:(NSString *)identifier {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    UITableViewHeaderFooterView *reuseView = AopCallSuperResult_1(@selector(dequeueReusableHeaderFooterViewWithIdentifier:), identifier);
    aop_utils.isUICalling -= 1;
    return reuseView;
}

- (UITableViewCell *)aop_dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    AopDefineVars;
    if (aop_utils) {
        indexPath = [aop_utils feedsIndexPathByUser:indexPath];
    }
    aop_utils.isUICalling += 1;
    UITableViewCell *dequeueCell = AopCallSuperResult_2(@selector(dequeueReusableCellWithIdentifier:forIndexPath:), identifier, indexPath);
    aop_utils.isUICalling -= 1;
    return dequeueCell;
}

@end

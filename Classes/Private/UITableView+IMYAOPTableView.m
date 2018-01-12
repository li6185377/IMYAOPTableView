//
//  UITableView+IMYADTableUtils.m
//  IMYAdvertisementDemo
//
//  Created by ljh on 16/4/16.
//  Copyright © 2016年 IMY. All rights reserved.
//

#import "IMYAOPTableView.h"
#import "IMYAOPTableViewUtils+Private.h"
#import "UITableView+IMYAOPTableView.h"
#import <objc/message.h>
#import <objc/runtime.h>

static BOOL imyaop_swizzleMethod(Class clazz, SEL origSel_, SEL altSel_) {
    if (!clazz) {
        return NO;
    }
    Method origMethod = class_getInstanceMethod(clazz, origSel_);
    if (!origMethod) {
        return NO;
    }
    Method altMethod = class_getInstanceMethod(clazz, altSel_);
    if (!altMethod) {
        return NO;
    }

    class_addMethod(clazz,
                    origSel_,
                    class_getMethodImplementation(clazz, origSel_),
                    method_getTypeEncoding(origMethod));
    class_addMethod(clazz,
                    altSel_,
                    class_getMethodImplementation(clazz, altSel_),
                    method_getTypeEncoding(altMethod));

    method_exchangeImplementations(class_getInstanceMethod(clazz, origSel_), class_getInstanceMethod(clazz, altSel_));

    return YES;
}

#define AopDefineObjcSuper struct objc_super objcSuper = {                                                       \
                               .super_class = aop_utils.tableViewClass ?: [UITableView class], .receiver = self, \
};

#define AopDefineVars                                 \
    IMYAOPTableViewUtils *aop_utils = self.aop_utils; \
    AopDefineObjcSuper;                               \
    if (aop_utils.isUICalling > 0) {                  \
        aop_utils = nil;                              \
    }

#define AopCallSuper(selector) ((void (*)(void *, SEL))(void *)objc_msgSendSuper)(&objcSuper, selector);
#define AopCallSuperResult(selector) ((id(*)(void *, SEL))(void *)objc_msgSendSuper)(&objcSuper, selector);

#define AopCallSuper_1(selector, var0) ((void (*)(void *, SEL, id))(void *)objc_msgSendSuper)(&objcSuper, selector, var0);
#define AopCallSuperResult_1(selector, var0) ((id(*)(void *, SEL, id))(void *)objc_msgSendSuper)(&objcSuper, selector, var0);

#define AopCallSuper_2(selector, var0, var1) ((void (*)(void *, SEL, id, id))(void *)objc_msgSendSuper)(&objcSuper, selector, var0, var1);
#define AopCallSuperResult_2(selector, var0, var1) ((id(*)(void *, SEL, id, id))(void *)objc_msgSendSuper)(&objcSuper, selector, var0, var1);

@implementation UIView (IMYADTableUtils)

- (BOOL)imyaop_gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
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

@implementation UITableView (IMYADTableUtils)

+ (SEL)aop_userSelectRowAtPendingSelectionIndexPathSEL {
    static SEL sel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sel = NSSelectorFromString([NSString stringWithFormat:@"%@%@", @"_userSelectRowAtPending", @"SelectionIndexPath:"]);
    });
    return sel;
}

+ (SEL)aop_updateRowDataSEL {
    static SEL sel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sel = NSSelectorFromString([NSString stringWithFormat:@"%@%@", @"_updateRow", @"Data"]);
    });
    return sel;
}

+ (SEL)aop_rebuildGeometrySEL {
    static SEL sel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sel = NSSelectorFromString([NSString stringWithFormat:@"%@%@", @"_rebuild", @"Geometry"]);
    });
    return sel;
}

+ (SEL)aop_updateContentSizeSEL {
    static SEL sel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sel = NSSelectorFromString([NSString stringWithFormat:@"%@%@", @"_updateContent", @"Size"]);
    });
    return sel;
}

+ (SEL)aop_updateAnimationDidStopSEL {
    static SEL sel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sel = NSSelectorFromString([NSString stringWithFormat:@"%@%@", @"_updateAnimationDidStop:", @"finished:context:"]);
    });
    return sel;
}

+ (Class)imy_aopClass {
    return [_IMYAOPTableView class];
}

@end

@implementation _IMYAOPTableView

+ (void)aop_setupConfigs {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imyaop_swizzleMethod(NSClassFromString(@"UITableViewWrapperView"), @selector(gestureRecognizerShouldBegin:), @selector(imyaop_gestureRecognizerShouldBegin:));
    });
}

- (void)aop_setDelegate:(id<UITableViewDelegate>)delegate {
    IMYAOPTableViewUtils *aop_utils = self.aop_utils;
    if (aop_utils) {
        if (aop_utils.tableDelegate != delegate) {
            AopDefineObjcSuper;
            AopCallSuper_1(@selector(setDelegate:), delegate);
            aop_utils.tableDelegate = delegate;
        }
    } else {
        [super setDelegate:delegate];
    }
}

- (id<UITableViewDelegate>)aop_delegate {
    AopDefineVars;
    if (aop_utils) {
        return aop_utils.tableDelegate;
    } else {
        return AopCallSuperResult(@selector(delegate));
    }
}

- (void)aop_setDataSource:(id<UITableViewDataSource>)dataSource {
    IMYAOPTableViewUtils *aop_utils = self.aop_utils;
    if (aop_utils) {
        if (aop_utils.tableDataSource != dataSource) {
            AopDefineObjcSuper;
            AopCallSuper_1(@selector(setDataSource:), dataSource);
            aop_utils.tableDataSource = dataSource;
        }
    } else {
        [super setDataSource:dataSource];
    }
}

- (id<UITableViewDataSource>)aop_dataSource {
    AopDefineVars;
    if (aop_utils) {
        return aop_utils.tableDataSource;
    } else {
        return AopCallSuperResult(@selector(dataSource));
    }
}

- (Class)aop_class {
    IMYAOPTableViewUtils *aop_utils = self.aop_utils;
    if (aop_utils) {
        return aop_utils.tableViewClass;
    } else {
        return [super class];
    }
}

///AOP
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

- (void)aop__userSelectRowAtPendingSelectionIndexPath:(NSIndexPath *)indexPath {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    AopCallSuper_1([UITableView aop_userSelectRowAtPendingSelectionIndexPathSEL], indexPath);
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

- (void)aop__rebuildGeometry {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    AopCallSuper([UITableView aop_rebuildGeometrySEL]);
    aop_utils.isUICalling -= 1;
}

- (void)aop__updateRowData {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    AopCallSuper([UITableView aop_updateRowDataSEL]);
    aop_utils.isUICalling -= 1;
}

- (void)aop__updateContentSize {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    AopCallSuper([UITableView aop_updateContentSizeSEL]);
    aop_utils.isUICalling -= 1;
}

- (void)aop__updateAnimationDidStop:(id)arg1 finished:(id)arg2 context:(id)arg3 {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    ((void (*)(void *, SEL, id, id, id))(void *)objc_msgSendSuper)(&objcSuper, [UITableView aop_updateAnimationDidStopSEL], arg1, arg2, arg3);
    aop_utils.isUICalling -= 1;
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
        number = [aop_utils realSectionByTable:number];
    }
    return number;
}

- (NSInteger)aop_numberOfRowsInSection:(NSInteger)section {
    AopDefineVars;
    if (aop_utils) {
        section = [aop_utils tableSectionByReal:section];
    }
    aop_utils.isUICalling += 1;
    NSInteger number = ((NSInteger(*)(void *, SEL, NSInteger))(void *)objc_msgSendSuper)(&objcSuper, @selector(numberOfRowsInSection:), section);
    aop_utils.isUICalling -= 1;
    if (aop_utils && number > 0) {
        number = [aop_utils realIndexPathByTable:[NSIndexPath indexPathForRow:number inSection:section]].row;
    }
    return number;
}

- (CGRect)aop_rectForSection:(NSInteger)section {
    AopDefineVars;
    if (aop_utils) {
        section = [aop_utils tableSectionByReal:section];
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
        section = [aop_utils tableSectionByReal:section];
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
        section = [aop_utils tableSectionByReal:section];
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
        indexPath = [aop_utils tableIndexPathByReal:indexPath];
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
        indexPath = [aop_utils realIndexPathByTable:indexPath];
    }
    return indexPath;
}

- (NSIndexPath *)aop_indexPathForCell:(UITableViewCell *)cell {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    NSIndexPath *indexPath = AopCallSuperResult_1(@selector(indexPathForCell:), cell);
    aop_utils.isUICalling -= 1;
    if (aop_utils) {
        indexPath = [aop_utils realIndexPathByTable:indexPath] ?: indexPath;
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
        indexPaths = [aop_utils realIndexPathsByTableIndexPaths:indexPaths];
    }
    return indexPaths;
}

- (UITableViewCell *)aop_cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AopDefineVars;
    if (aop_utils) {
        indexPath = [aop_utils tableIndexPathByReal:indexPath];
    }
    aop_utils.isUICalling += 1;
    UITableViewCell *cell = AopCallSuperResult_1(@selector(cellForRowAtIndexPath:), indexPath);
    aop_utils.isUICalling -= 1;
    return cell;
}

- (NSArray *)aop_containVisibleCells:(const IMYAOPType)containType {
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
                indexPath = [aop_utils realIndexPathByTable:indexPath];
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
        array = [aop_utils realIndexPathsByTableIndexPaths:array];
    }
    aop_utils.isUICalling -= 1;
    return array;
}

- (UITableViewHeaderFooterView *)aop_headerViewForSection:(NSInteger)section {
    AopDefineVars;
    if (aop_utils) {
        section = [aop_utils tableSectionByReal:section];
    }
    aop_utils.isUICalling += 1;
    UITableViewHeaderFooterView *headerView = ((id(*)(void *, SEL, NSInteger))(void *)objc_msgSendSuper)(&objcSuper, @selector(headerViewForSection:), section);
    aop_utils.isUICalling -= 1;
    return headerView;
}

- (UITableViewHeaderFooterView *)aop_footerViewForSection:(NSInteger)section {
    AopDefineVars;
    if (aop_utils) {
        section = [aop_utils tableSectionByReal:section];
    }
    aop_utils.isUICalling += 1;
    UITableViewHeaderFooterView *footerView = ((id(*)(void *, SEL, NSInteger))(void *)objc_msgSendSuper)(&objcSuper, @selector(footerViewForSection:), section);
    aop_utils.isUICalling -= 1;
    return footerView;
}

- (void)aop_scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated {
    AopDefineVars;
    if (aop_utils) {
        indexPath = [aop_utils tableIndexPathByReal:indexPath];
    }
    aop_utils.isUICalling += 1;
    ((void (*)(void *, SEL, id, UITableViewScrollPosition, BOOL))(void *)objc_msgSendSuper)(&objcSuper, @selector(scrollToRowAtIndexPath:atScrollPosition:animated:), indexPath, scrollPosition, animated);
    aop_utils.isUICalling -= 1;
}

// Row insertion/deletion/reloading.
- (void)aop_insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    AopDefineVars;
    if (aop_utils) {
        sections = [aop_utils tableSectionsByRealSet:sections];
    }
    aop_utils.isUICalling += 1;
    ((void (*)(void *, SEL, id, UITableViewRowAnimation))(void *)objc_msgSendSuper)(&objcSuper, @selector(insertSections:withRowAnimation:), sections, animation);
    aop_utils.isUICalling -= 1;
}

- (void)aop_deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    AopDefineVars;
    if (aop_utils) {
        sections = [aop_utils tableSectionsByRealSet:sections];
    }
    aop_utils.isUICalling += 1;
    ((void (*)(void *, SEL, id, UITableViewRowAnimation))(void *)objc_msgSendSuper)(&objcSuper, @selector(deleteSections:withRowAnimation:), sections, animation);
    aop_utils.isUICalling -= 1;
}

- (void)aop_reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    AopDefineVars;
    if (aop_utils) {
        sections = [aop_utils tableSectionsByRealSet:sections];
    }
    aop_utils.isUICalling += 1;
    ((void (*)(void *, SEL, id, UITableViewRowAnimation))(void *)objc_msgSendSuper)(&objcSuper, @selector(reloadSections:withRowAnimation:), sections, animation);
    aop_utils.isUICalling -= 1;
}

- (void)aop_moveSection:(NSInteger)section toSection:(NSInteger)newSection {
    AopDefineVars;
    if (aop_utils) {
        section = [aop_utils tableSectionByReal:section];
        newSection = [aop_utils tableSectionByReal:newSection];
    }
    aop_utils.isUICalling += 1;
    ((void (*)(void *, SEL, NSInteger, NSInteger))(void *)objc_msgSendSuper)(&objcSuper, @selector(moveSection:toSection:), section, newSection);
    aop_utils.isUICalling -= 1;
}

- (void)aop_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    AopDefineVars;
    if (aop_utils) {
        indexPaths = [aop_utils tableIndexPathsByRealIndexPaths:indexPaths];
    }
    aop_utils.isUICalling += 1;
    ((void (*)(void *, SEL, id, UITableViewRowAnimation))(void *)objc_msgSendSuper)(&objcSuper, @selector(insertRowsAtIndexPaths:withRowAnimation:), indexPaths, animation);
    aop_utils.isUICalling -= 1;
}

- (void)aop_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    AopDefineVars;
    if (aop_utils) {
        indexPaths = [aop_utils tableIndexPathsByRealIndexPaths:indexPaths];
    }
    aop_utils.isUICalling += 1;
    ((void (*)(void *, SEL, id, UITableViewRowAnimation))(void *)objc_msgSendSuper)(&objcSuper, @selector(deleteRowsAtIndexPaths:withRowAnimation:), indexPaths, animation);
    aop_utils.isUICalling -= 1;
}

- (void)aop_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    AopDefineVars;
    if (aop_utils) {
        indexPaths = [aop_utils tableIndexPathsByRealIndexPaths:indexPaths];
    }
    aop_utils.isUICalling += 1;
    ((void (*)(void *, SEL, id, UITableViewRowAnimation))(void *)objc_msgSendSuper)(&objcSuper, @selector(reloadRowsAtIndexPaths:withRowAnimation:), indexPaths, animation);
    aop_utils.isUICalling -= 1;
}

- (void)aop_moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath {
    AopDefineVars;
    if (aop_utils) {
        indexPath = [aop_utils tableIndexPathByReal:indexPath];
        newIndexPath = [aop_utils tableIndexPathByReal:newIndexPath];
    }
    aop_utils.isUICalling += 1;
    AopCallSuper_2(@selector(moveRowAtIndexPath:toIndexPath:), indexPath, newIndexPath);
    aop_utils.isUICalling -= 1;
}

// Selection
- (NSIndexPath *)aop_indexPathForSelectedRow {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    NSIndexPath *indexPath = AopCallSuperResult(@selector(indexPathForSelectedRow));
    aop_utils.isUICalling -= 1;
    if (aop_utils) {
        indexPath = [aop_utils realIndexPathByTable:indexPath];
    }
    return indexPath;
}

- (NSArray<NSIndexPath *> *)aop_indexPathsForSelectedRows {
    AopDefineVars;
    aop_utils.isUICalling += 1;
    NSArray<NSIndexPath *> *indexPaths = AopCallSuperResult(@selector(indexPathsForSelectedRows));
    aop_utils.isUICalling -= 1;
    if (aop_utils) {
        indexPaths = [aop_utils realIndexPathsByTableIndexPaths:indexPaths];
    }
    return indexPaths;
}

- (void)aop_selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition {
    AopDefineVars;
    if (aop_utils) {
        indexPath = [aop_utils tableIndexPathByReal:indexPath];
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
        indexPath = [aop_utils tableIndexPathByReal:indexPath];
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
        indexPath = [aop_utils tableIndexPathByReal:indexPath];
    }
    aop_utils.isUICalling += 1;
    UITableViewCell *dequeueCell = AopCallSuperResult_2(@selector(dequeueReusableCellWithIdentifier:forIndexPath:), identifier, indexPath);
    aop_utils.isUICalling -= 1;
    return dequeueCell;
}

@end

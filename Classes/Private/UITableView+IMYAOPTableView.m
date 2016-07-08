//
//  UITableView+IMYADTableUtils.m
//  IMYAdvertisementDemo
//
//  Created by ljh on 16/4/16.
//  Copyright © 2016年 IMY. All rights reserved.
//

#import <objc/message.h>
#import <objc/runtime.h>
#import "IMYAOPTableView.h"
#import "IMYAOPTableViewUtils+Private.h"
#import "UITableView+IMYAOPTableView.h"

@protocol _AOPAsyncBlockProtocol <NSObject>
///可取消的 异步调用block
+ (void)imy_asyncBlock:(void (^)(void))block onQueue:(dispatch_queue_t)queue afterSecond:(double)second forKey:(NSString*)key;
///取消队列中的block
+ (void)imy_cancelBlockForKey:(NSString*)key;
///是否存在这个异步block
+ (BOOL)imy_hasAsyncBlockForKey:(NSString*)key;
@end

@implementation NSObject (IMYADTableUtils)
+ (BOOL)imyaop_swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_ error:(NSError**)error_
{
    Method origMethod = class_getInstanceMethod(self, origSel_);
    if (!origMethod) {
        return NO;
    }
    Method altMethod = class_getInstanceMethod(self, altSel_);
    if (!altMethod) {
        return NO;
    }
    
    class_addMethod(self,
                    origSel_,
                    class_getMethodImplementation(self, origSel_),
                    method_getTypeEncoding(origMethod));
    class_addMethod(self,
                    altSel_,
                    class_getMethodImplementation(self, altSel_),
                    method_getTypeEncoding(altMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, origSel_), class_getInstanceMethod(self, altSel_));
    
    return YES;
}
@end

@implementation UIView (IMYADTableUtils)
+ (void)load
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSClassFromString(@"UITableViewWrapperView") imyaop_swizzleMethod:@selector(gestureRecognizerShouldBegin:) withMethod:@selector(imyaop_gestureRecognizerShouldBegin:) error:nil];
    });
}
- (BOOL)imyaop_gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    UITableView* tableView = (id)self.superview;
    while (tableView && ![tableView isKindOfClass:[UITableView class]]) {
        tableView = (id)tableView.superview;
    }
    IMYAOPTableViewUtils* aop_utils = nil;
    if(tableView.aop_installed) {
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
+ (SEL)aop_userSelectRowAtPendingSelectionIndexPathSEL
{
    static SEL sel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sel = NSSelectorFromString([NSString stringWithFormat:@"%@%@", @"_userSelectRowAtPending", @"SelectionIndexPath:"]);
    });
    return sel;
}
+ (SEL)aop_updateRowDataSEL
{
    static SEL sel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sel = NSSelectorFromString([NSString stringWithFormat:@"%@%@", @"_updateRow", @"Data"]);
    });
    return sel;
}
+ (SEL)aop_rebuildGeometrySEL
{
    static SEL sel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sel = NSSelectorFromString([NSString stringWithFormat:@"%@%@", @"_rebuild", @"Geometry"]);
    });
    return sel;
}
+ (SEL)aop_updateContentSizeSEL
{
    static SEL sel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sel = NSSelectorFromString([NSString stringWithFormat:@"%@%@", @"_updateContent", @"Size"]);
    });
    return sel;
}
+ (SEL)aop_updateAnimationDidStopSEL
{
    static SEL sel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sel = NSSelectorFromString([NSString stringWithFormat:@"%@%@", @"_updateAnimationDidStop:", @"finished:context:"]);
    });
    return sel;
}
- (IMYAOPTableViewUtils*)aop_uiCallingUtils
{
    IMYAOPTableViewUtils* aop_utils = self.aop_utils;
    if (aop_utils.isUICalling > 0) {
        return nil;
    }
    return aop_utils;
}
+ (Class)imy_aopClass
{
    return [_IMYAOPTableView class];
}
@end

@implementation _IMYAOPTableView
- (void)aop_setDelegate:(id<UITableViewDelegate>)delegate
{
    IMYAOPTableViewUtils* aop_utils = self.aop_utils;
    if (aop_utils) {
        aop_utils.tableDelegate = delegate;
    }
    else {
        [super setDelegate:delegate];
    }
}
- (id<UITableViewDelegate>)aop_delegate
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    if (aop_utils) {
        return aop_utils.tableDelegate;
    }
    else {
        return [super delegate];
    }
}
- (void)aop_setDataSource:(id<UITableViewDataSource>)dataSource
{
    IMYAOPTableViewUtils* aop_utils = self.aop_utils;
    if (aop_utils) {
        aop_utils.tableDataSource = dataSource;
    }
    else {
        [super setDataSource:dataSource];
    }
}
- (id<UITableViewDataSource>)aop_dataSource
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    if (aop_utils) {
        return aop_utils.tableDataSource;
    }
    else {
        return [super dataSource];
    }
}
- (Class)aop_class
{
    IMYAOPTableViewUtils* aop_utils = self.aop_utils;
    if (aop_utils) {
        return aop_utils.tableViewClass;
    }
    else {
        return [super class];
    }
}
///AOP
- (void)aop_touchesBegan:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    aop_utils.isUICalling += 1;
    [super touchesBegan:touches withEvent:event];
    aop_utils.isUICalling -= 1;
}
- (void)aop_touchesMoved:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    aop_utils.isUICalling += 1;
    [super touchesMoved:touches withEvent:event];
    aop_utils.isUICalling -= 1;
}
- (void)aop_touchesEstimatedPropertiesUpdated:(NSSet*)touches
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    aop_utils.isUICalling += 1;
    [super touchesEstimatedPropertiesUpdated:touches];
    aop_utils.isUICalling -= 1;
}
- (void)aop__userSelectRowAtPendingSelectionIndexPath:(NSIndexPath*)indexPath
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    aop_utils.isUICalling += 1;
    struct objc_super objcSuper;
    objcSuper.receiver = self;
    objcSuper.super_class = self.aop_utils.tableViewClass;
    ((void (*)(void*, SEL, NSIndexPath*))(void*)objc_msgSendSuper)(&objcSuper, [UITableView aop_userSelectRowAtPendingSelectionIndexPathSEL], indexPath);
    aop_utils.isUICalling -= 1;
}
- (void)aop_touchesEnded:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    aop_utils.isUICalling += 1;
    [super touchesEnded:touches withEvent:event];
    aop_utils.isUICalling -= 1;
}
- (void)aop_touchesCancelled:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    aop_utils.isUICalling += 1;
    [super touchesCancelled:touches withEvent:event];
    aop_utils.isUICalling -= 1;
}
- (BOOL)aop_touchesShouldCancelInContentView:(UIView*)view
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    aop_utils.isUICalling += 1;
    BOOL should = [super touchesShouldCancelInContentView:view];
    aop_utils.isUICalling -= 1;
    return should;
}
- (BOOL)aop_touchesShouldBegin:(NSSet<UITouch*>*)touches withEvent:(nullable UIEvent*)event inContentView:(UIView*)view
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    aop_utils.isUICalling += 1;
    BOOL should = [super touchesShouldBegin:touches withEvent:event inContentView:view];
    aop_utils.isUICalling -= 1;
    return should;
}
- (BOOL)aop_gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    aop_utils.isUICalling += 1;
    BOOL should = [super gestureRecognizerShouldBegin:gestureRecognizer];
    aop_utils.isUICalling -= 1;
    return should;
}
- (void)aop__rebuildGeometry
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    aop_utils.isUICalling += 1;
    struct objc_super objcSuper;
    objcSuper.receiver = self;
    objcSuper.super_class = self.aop_utils.tableViewClass;
    ((void (*)(void*, SEL))(void*)objc_msgSendSuper)(&objcSuper, [UITableView aop_rebuildGeometrySEL]);
    aop_utils.isUICalling -= 1;
}
- (void)aop__updateRowData
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    aop_utils.isUICalling += 1;
    struct objc_super objcSuper;
    objcSuper.receiver = self;
    objcSuper.super_class = self.aop_utils.tableViewClass;
    ((void (*)(void*, SEL))(void*)objc_msgSendSuper)(&objcSuper, [UITableView aop_updateRowDataSEL]);
    aop_utils.isUICalling -= 1;
}
- (void)aop__updateContentSize
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    aop_utils.isUICalling += 1;
    struct objc_super objcSuper;
    objcSuper.receiver = self;
    objcSuper.super_class = self.aop_utils.tableViewClass;
    ((void (*)(void*, SEL))(void*)objc_msgSendSuper)(&objcSuper, [UITableView aop_updateContentSizeSEL]);
    aop_utils.isUICalling -= 1;
}
- (void)aop__updateAnimationDidStop:(id)arg1 finished:(id)arg2 context:(id)arg3
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    aop_utils.isUICalling += 1;
    struct objc_super objcSuper;
    objcSuper.receiver = self;
    objcSuper.super_class = self.aop_utils.tableViewClass;
    ((void (*)(void*, SEL, id, id, id))(void*)objc_msgSendSuper)(&objcSuper, [UITableView aop_updateAnimationDidStopSEL], arg1, arg2, arg3);
    aop_utils.isUICalling -= 1;
}
- (void)aop_layoutSubviews
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    aop_utils.isUICalling += 1;
    [super layoutSubviews];
    aop_utils.isUICalling -= 1;
}
- (void)aop_reloadData
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    aop_utils.isUICalling += 1;
    [super reloadData];
    aop_utils.isUICalling -= 1;
}
- (void)aop_refreshDelegate
{
    IMYAOPTableViewUtils* aop_utils = self.aop_utils;
    IMYAOPTableViewUtils* uiAopUtils = nil;
    if (aop_utils.isUICalling <= 0) {
        uiAopUtils = aop_utils;
    }
    uiAopUtils.isUICalling += 1;
    [super setDelegate:nil];
    [super setDelegate:(id)aop_utils];
    uiAopUtils.isUICalling -= 1;
}
- (void)aop_refreshDataSource
{
    IMYAOPTableViewUtils* aop_utils = self.aop_utils;
    IMYAOPTableViewUtils* uiAopUtils = nil;
    if (aop_utils.isUICalling <= 0) {
        uiAopUtils = aop_utils;
    }
    uiAopUtils.isUICalling += 1;
    [super setDataSource:nil];
    [super setDataSource:(id)aop_utils];
    uiAopUtils.isUICalling -= 1;
}
- (void)aop_reloadSectionIndexTitles
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    aop_utils.isUICalling += 1;
    [super reloadSectionIndexTitles];
    aop_utils.isUICalling -= 1;
}
- (void)aop_beginUpdates
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    aop_utils.isUICalling += 1;
    [super beginUpdates];
    aop_utils.isUICalling -= 1;
}
- (void)aop_endUpdates
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    aop_utils.isUICalling += 1;
    [super endUpdates];
    aop_utils.isUICalling -= 1;
}
- (void)aop_setBounds:(CGRect)bounds
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    aop_utils.isUICalling += 1;
    [super setBounds:bounds];
    aop_utils.isUICalling -= 1;
}
// Info
- (NSInteger)aop_numberOfSections
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    aop_utils.isUICalling += 1;
    NSInteger number = [super numberOfSections];
    aop_utils.isUICalling -= 1;
    if (aop_utils) {
        number = [aop_utils realSectionByTable:number];
    }
    return number;
}
- (NSInteger)aop_numberOfRowsInSection:(NSInteger)section
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    if (aop_utils) {
        section = [aop_utils tableSectionByReal:section];
    }
    aop_utils.isUICalling += 1;
    NSInteger number = [super numberOfRowsInSection:section];
    aop_utils.isUICalling -= 1;
    if (aop_utils && number > 0) {
        number = [aop_utils realIndexPathByTable:[NSIndexPath indexPathForRow:number inSection:section]].row;
    }
    return number;
}

- (CGRect)aop_rectForSection:(NSInteger)section
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    if (aop_utils) {
        section = [aop_utils tableSectionByReal:section];
    }
    aop_utils.isUICalling += 1;
    CGRect rect = [super rectForSection:section];
    aop_utils.isUICalling -= 1;
    return rect;
}
- (CGRect)aop_rectForHeaderInSection:(NSInteger)section
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    if (aop_utils) {
        section = [aop_utils tableSectionByReal:section];
    }
    aop_utils.isUICalling += 1;
    CGRect rect = [super rectForHeaderInSection:section];
    aop_utils.isUICalling -= 1;
    return rect;
}
- (CGRect)aop_rectForFooterInSection:(NSInteger)section
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    if (aop_utils) {
        section = [aop_utils tableSectionByReal:section];
    }
    aop_utils.isUICalling += 1;
    CGRect rect = [super rectForFooterInSection:section];
    aop_utils.isUICalling -= 1;
    return rect;
}
- (CGRect)aop_rectForRowAtIndexPath:(NSIndexPath*)indexPath
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    if (aop_utils) {
        indexPath = [aop_utils tableIndexPathByReal:indexPath];
    }
    aop_utils.isUICalling += 1;
    CGRect rect = [super rectForRowAtIndexPath:indexPath];
    aop_utils.isUICalling -= 1;
    return rect;
}
- (nullable NSIndexPath*)aop_indexPathForRowAtPoint:(CGPoint)point
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    aop_utils.isUICalling += 1;
    NSIndexPath* indexPath = [super indexPathForRowAtPoint:point];
    aop_utils.isUICalling -= 1;
    if (aop_utils) {
        indexPath = [aop_utils realIndexPathByTable:indexPath];
    }
    return indexPath;
}
- (nullable NSIndexPath*)aop_indexPathForCell:(UITableViewCell*)cell
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    aop_utils.isUICalling += 1;
    NSIndexPath* indexPath = [super indexPathForCell:cell];
    aop_utils.isUICalling -= 1;
    if (aop_utils) {
        indexPath = [aop_utils realIndexPathByTable:indexPath] ?: indexPath;
    }
    return indexPath;
}
- (nullable NSArray<NSIndexPath*>*)aop_indexPathsForRowsInRect:(CGRect)rect
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    aop_utils.isUICalling += 1;
    NSArray<NSIndexPath*>* indexPaths = [super indexPathsForRowsInRect:rect];
    aop_utils.isUICalling -= 1;
    if (aop_utils) {
        indexPaths = [aop_utils realIndexPathsByTableIndexPaths:indexPaths];
    }
    return indexPaths;
}
- (nullable __kindof UITableViewCell*)aop_cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    if (aop_utils) {
        indexPath = [aop_utils tableIndexPathByReal:indexPath];
    }
    aop_utils.isUICalling += 1;
    UITableViewCell* cell = [super cellForRowAtIndexPath:indexPath];
    aop_utils.isUICalling -= 1;
    return cell;
}
- (NSArray *)aop_containVisibleCells:(IMYAOPType)containType
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    aop_utils.isUICalling += 1;
    NSArray<UITableViewCell*>* visibleCells = [super visibleCells];
    visibleCells = [visibleCells filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UITableViewCell* cell, NSDictionary<NSString *,id>* bindings) {
        if (containType == IMYAOPTypeAll) {
            ///全部返回
            return YES;
        }
        NSIndexPath* indexPath = [super indexPathForCell:cell];
        if (aop_utils) {
            indexPath = [aop_utils realIndexPathByTable:indexPath];
        }
        if (containType == IMYAOPTypeInsert) {
            ///只返回插入的cell
            return (indexPath == nil);
        }
        else {
            ///只返回原有的cell
            return (indexPath != nil);
        }
    }]];
    aop_utils.isUICalling -= 1;
    return visibleCells;
}
- (NSArray<UITableViewCell*>*)aop_visibleCells
{
    return [self aop_containVisibleCells:0];
}
- (NSArray<NSIndexPath*>*)aop_indexPathsForVisibleRows
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    aop_utils.isUICalling += 1;
    NSArray<NSIndexPath*>* array = [super indexPathsForVisibleRows];
    if (aop_utils) {
        array = [aop_utils realIndexPathsByTableIndexPaths:array];
    }
    aop_utils.isUICalling -= 1;
    return array;
}
- (nullable UITableViewHeaderFooterView*)aop_headerViewForSection:(NSInteger)section
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    if (aop_utils) {
        section = [aop_utils tableSectionByReal:section];
    }
    aop_utils.isUICalling += 1;
    UITableViewHeaderFooterView* headerView = [super headerViewForSection:section];
    aop_utils.isUICalling -= 1;
    return headerView;
}
- (nullable UITableViewHeaderFooterView*)aop_footerViewForSection:(NSInteger)section
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    if (aop_utils) {
        section = [aop_utils tableSectionByReal:section];
    }
    aop_utils.isUICalling += 1;
    UITableViewHeaderFooterView* footerView = [super footerViewForSection:section];
    aop_utils.isUICalling -= 1;
    return footerView;
}

- (void)aop_scrollToRowAtIndexPath:(NSIndexPath*)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    if (aop_utils) {
        indexPath = [aop_utils tableIndexPathByReal:indexPath];
    }
    aop_utils.isUICalling += 1;
    [super scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
    aop_utils.isUICalling -= 1;
}

// Row insertion/deletion/reloading.
- (void)aop_insertSections:(NSIndexSet*)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    if (aop_utils) {
        sections = [aop_utils tableSectionsByRealSet:sections];
    }
    aop_utils.isUICalling += 1;
    [super insertSections:sections withRowAnimation:animation];
    aop_utils.isUICalling -= 1;
}
- (void)aop_deleteSections:(NSIndexSet*)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    if (aop_utils) {
        sections = [aop_utils tableSectionsByRealSet:sections];
    }
    aop_utils.isUICalling += 1;
    [super deleteSections:sections withRowAnimation:animation];
    aop_utils.isUICalling -= 1;
}
- (void)aop_reloadSections:(NSIndexSet*)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    if (aop_utils) {
        sections = [aop_utils tableSectionsByRealSet:sections];
    }
    aop_utils.isUICalling += 1;
    [super reloadSections:sections withRowAnimation:animation];
    aop_utils.isUICalling -= 1;
}
- (void)aop_moveSection:(NSInteger)section toSection:(NSInteger)newSection
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    if (aop_utils) {
        section = [aop_utils tableSectionByReal:section];
        newSection = [aop_utils tableSectionByReal:newSection];
    }
    aop_utils.isUICalling += 1;
    [super moveSection:section toSection:newSection];
    aop_utils.isUICalling -= 1;
}
- (void)aop_insertRowsAtIndexPaths:(NSArray<NSIndexPath*>*)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    if (aop_utils) {
        indexPaths = [aop_utils tableIndexPathsByRealIndexPaths:indexPaths];
    }
    aop_utils.isUICalling += 1;
    [super insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    aop_utils.isUICalling -= 1;
}
- (void)aop_deleteRowsAtIndexPaths:(NSArray<NSIndexPath*>*)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    if (aop_utils) {
        indexPaths = [aop_utils tableIndexPathsByRealIndexPaths:indexPaths];
    }
    aop_utils.isUICalling += 1;
    [super deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    aop_utils.isUICalling -= 1;
}
- (void)aop_reloadRowsAtIndexPaths:(NSArray<NSIndexPath*>*)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    if (aop_utils) {
        indexPaths = [aop_utils tableIndexPathsByRealIndexPaths:indexPaths];
    }
    aop_utils.isUICalling += 1;
    [super reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    aop_utils.isUICalling -= 1;
}
- (void)aop_moveRowAtIndexPath:(NSIndexPath*)indexPath toIndexPath:(NSIndexPath*)newIndexPath
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    if (aop_utils) {
        indexPath = [aop_utils tableIndexPathByReal:indexPath];
        newIndexPath = [aop_utils tableIndexPathByReal:newIndexPath];
    }
    aop_utils.isUICalling += 1;
    [super moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
    aop_utils.isUICalling -= 1;
}

// Selection
- (NSIndexPath*)aop_indexPathForSelectedRow
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    aop_utils.isUICalling += 1;
    NSIndexPath* indexPath = [super indexPathForSelectedRow];
    aop_utils.isUICalling -= 1;
    if (aop_utils) {
        indexPath = [aop_utils realIndexPathByTable:indexPath];
    }
    return indexPath;
}
- (NSArray<NSIndexPath*>*)aop_indexPathsForSelectedRows
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    aop_utils.isUICalling += 1;
    NSArray<NSIndexPath*>* indexPaths = [super indexPathsForSelectedRows];
    aop_utils.isUICalling -= 1;
    if (aop_utils) {
        indexPaths = [aop_utils realIndexPathsByTableIndexPaths:indexPaths];
    }
    return indexPaths;
}
- (void)aop_selectRowAtIndexPath:(nullable NSIndexPath*)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    if (aop_utils) {
        indexPath = [aop_utils tableIndexPathByReal:indexPath];
    }
    aop_utils.isUICalling += 1;
    [super selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
    aop_utils.isUICalling -= 1;
}
- (void)aop_deselectRowAtIndexPath:(NSIndexPath*)indexPath animated:(BOOL)animated
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    aop_utils.isUICalling += 1;
    [super deselectRowAtIndexPath:indexPath animated:animated];
    if (aop_utils) {
        indexPath = [aop_utils tableIndexPathByReal:indexPath];
        [super deselectRowAtIndexPath:indexPath animated:animated];
    }
    aop_utils.isUICalling -= 1;
}

// Appearance
- (UITableViewCell*)aop_dequeueReusableCellWithIdentifier:(NSString*)identifier
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    aop_utils.isUICalling += 1;
    UITableViewCell* dequeueCell = [super dequeueReusableCellWithIdentifier:identifier];
    aop_utils.isUICalling -= 1;
    return dequeueCell;
}
- (UITableViewHeaderFooterView*)aop_dequeueReusableHeaderFooterViewWithIdentifier:(NSString*)identifier
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    aop_utils.isUICalling += 1;
    UITableViewHeaderFooterView* reuseView = [super dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    aop_utils.isUICalling -= 1;
    return reuseView;
}
- (UITableViewCell*)aop_dequeueReusableCellWithIdentifier:(NSString*)identifier forIndexPath:(NSIndexPath*)indexPath
{
    IMYAOPTableViewUtils* aop_utils = [self aop_uiCallingUtils];
    if (aop_utils) {
        indexPath = [aop_utils tableIndexPathByReal:indexPath];
    }
    aop_utils.isUICalling += 1;
    UITableViewCell* dequeueCell = [super dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    aop_utils.isUICalling -= 1;
    return dequeueCell;
}
@end

//
//  IMYAOPTableViewUtils.m
//  IMYAOPFeedsView
//
//  Created by ljh on 16/5/20.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import "IMYAOPTableViewUtils.h"
#import "IMYAOPBaseUtils+Private.h"
#import "IMYAOPTableViewUtils+DataSource.h"
#import "IMYAOPTableViewUtils+Delegate.h"
#import "IMYAOPTableViewUtils+Private.h"
#import "UITableView+IMYAOPTableView.h"

@interface IMYAOPTableViewUtils ()

@property (nullable, nonatomic, weak) id<UITableViewDelegate> origDelegate;
@property (nullable, nonatomic, weak) id<UITableViewDataSource> origDataSource;

@property (nullable, nonatomic, weak) UITableView *tableView;

+ (instancetype)aopUtilsWithTableView:(UITableView *)tableView;
- (void)injectTableView;

@end

@implementation IMYAOPTableViewUtils

+ (instancetype)aopUtilsWithTableView:(UITableView *)tableView {
    IMYAOPTableViewUtils *aopUtils = [self newInstance];
    [aopUtils setTableView:tableView];
    return aopUtils;
}

- (void)setOrigDelegate:(id<UITableViewDelegate>)origDelegate {
    if (_origDelegate != origDelegate) {
        _origDelegate = origDelegate;
        id tableView = self.tableView;
        [tableView aop_refreshDelegate];
    }
}

- (void)setOrigDataSource:(id<UITableViewDataSource>)origDataSource {
    if (_origDataSource != origDataSource) {
        _origDataSource = origDataSource;
        id tableView = self.tableView;
        [tableView aop_refreshDataSource];
    }
}

- (void)setDelegate:(id<IMYAOPTableViewDelegate>)delegate {
    if (_delegate != delegate) {
        _delegate = delegate;
        id tableView = self.tableView;
        [tableView aop_refreshDelegate];
    }
}

- (void)setDataSource:(id<IMYAOPTableViewDataSource>)dataSource {
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        id tableView = self.tableView;
        [tableView aop_refreshDataSource];
    }
}

- (void)injectTableView {
    UITableView *tableView = self.tableView;

    _origDataSource = tableView.dataSource;
    _origDelegate = tableView.delegate;

    [self injectFeedsView:tableView];
}

#pragma mark - install aop method

- (Class)implAopViewClass {
    return [UITableView imy_aopClass];
}

- (Class)msgSendSuperClass {
    return [UITableView class];
}

- (void)setupAopClass:(Class)aopClass {
    ///纯手动敲打
    [self addOverriteMethod:@selector(class) aopClass:aopClass];
    [self addOverriteMethod:@selector(setDelegate:) aopClass:aopClass];
    [self addOverriteMethod:@selector(setDataSource:) aopClass:aopClass];
    [self addOverriteMethod:@selector(delegate) aopClass:aopClass];
    [self addOverriteMethod:@selector(dataSource) aopClass:aopClass];
    [self addOverriteMethod:@selector(allowsSelection) aopClass:aopClass];
    
    ///UI Calling
    [self addOverriteMethod:@selector(reloadData) aopClass:aopClass];
    [self addOverriteMethod:@selector(layoutSubviews) aopClass:aopClass];
    [self addOverriteMethod:@selector(setBounds:) aopClass:aopClass];
    [self addOverriteMethod:@selector(bringSubviewToFront:) aopClass:aopClass];
    [self addOverriteMethod:@selector(sendSubviewToBack:) aopClass:aopClass];
    [self addOverriteMethod:@selector(willMoveToSuperview:) aopClass:aopClass];
    [self addOverriteMethod:@selector(willMoveToWindow:) aopClass:aopClass];
    [self addOverriteMethod:@selector(didMoveToWindow) aopClass:aopClass];
    [self addOverriteMethod:@selector(didMoveToSuperview) aopClass:aopClass];
    [self addOverriteMethod:@selector(beginUpdates) aopClass:aopClass];
    [self addOverriteMethod:@selector(endUpdates) aopClass:aopClass];
    [self addOverriteMethod:@selector(reloadSectionIndexTitles) aopClass:aopClass];
    [self addOverriteMethod:@selector(touchesBegan:withEvent:) aopClass:aopClass];
    [self addOverriteMethod:@selector(touchesMoved:withEvent:) aopClass:aopClass];
    [self addOverriteMethod:@selector(touchesEnded:withEvent:) aopClass:aopClass];
    [self addOverriteMethod:@selector(touchesCancelled:withEvent:) aopClass:aopClass];
    [self addOverriteMethod:@selector(touchesEstimatedPropertiesUpdated:) aopClass:aopClass];
    [self addOverriteMethod:@selector(touchesShouldBegin:withEvent:inContentView:) aopClass:aopClass];
    [self addOverriteMethod:@selector(touchesShouldCancelInContentView:) aopClass:aopClass];
    [self addOverriteMethod:@selector(dequeueReusableHeaderFooterViewWithIdentifier:) aopClass:aopClass];
    [self addOverriteMethod:@selector(dequeueReusableCellWithIdentifier:) aopClass:aopClass];
    [self addOverriteMethod:@selector(gestureRecognizerShouldBegin:) aopClass:aopClass];
    ///add real reload function
    [self addOverriteMethod:@selector(aop_refreshDataSource) aopClass:aopClass];
    [self addOverriteMethod:@selector(aop_refreshDelegate) aopClass:aopClass];
    [self addOverriteMethod:@selector(aop_containVisibleCells:) aopClass:aopClass];

    // Info
    [self addOverriteMethod:@selector(numberOfSections) aopClass:aopClass];
    [self addOverriteMethod:@selector(numberOfRowsInSection:) aopClass:aopClass];
    [self addOverriteMethod:@selector(rectForSection:) aopClass:aopClass];
    [self addOverriteMethod:@selector(rectForHeaderInSection:) aopClass:aopClass];
    [self addOverriteMethod:@selector(rectForFooterInSection:) aopClass:aopClass];
    [self addOverriteMethod:@selector(rectForRowAtIndexPath:) aopClass:aopClass];
    [self addOverriteMethod:@selector(indexPathForRowAtPoint:) aopClass:aopClass];
    [self addOverriteMethod:@selector(indexPathForCell:) aopClass:aopClass];
    [self addOverriteMethod:@selector(indexPathsForRowsInRect:) aopClass:aopClass];
    [self addOverriteMethod:@selector(cellForRowAtIndexPath:) aopClass:aopClass];
    [self addOverriteMethod:@selector(visibleCells) aopClass:aopClass];
    [self addOverriteMethod:@selector(indexPathsForVisibleRows) aopClass:aopClass];
    [self addOverriteMethod:@selector(headerViewForSection:) aopClass:aopClass];
    [self addOverriteMethod:@selector(footerViewForSection:) aopClass:aopClass];
    [self addOverriteMethod:@selector(scrollToRowAtIndexPath:atScrollPosition:animated:) aopClass:aopClass];

    // Row insertion/deletion/reloading.
    [self addOverriteMethod:@selector(insertSections:withRowAnimation:) aopClass:aopClass];
    [self addOverriteMethod:@selector(deleteSections:withRowAnimation:) aopClass:aopClass];
    [self addOverriteMethod:@selector(reloadSections:withRowAnimation:) aopClass:aopClass];
    [self addOverriteMethod:@selector(moveSection:toSection:) aopClass:aopClass];
    [self addOverriteMethod:@selector(insertRowsAtIndexPaths:withRowAnimation:) aopClass:aopClass];
    [self addOverriteMethod:@selector(deleteRowsAtIndexPaths:withRowAnimation:) aopClass:aopClass];
    [self addOverriteMethod:@selector(reloadRowsAtIndexPaths:withRowAnimation:) aopClass:aopClass];
    [self addOverriteMethod:@selector(moveRowAtIndexPath:toIndexPath:) aopClass:aopClass];

    // Selection
    [self addOverriteMethod:@selector(indexPathForSelectedRow) aopClass:aopClass];
    [self addOverriteMethod:@selector(indexPathsForSelectedRows) aopClass:aopClass];
    [self addOverriteMethod:@selector(selectRowAtIndexPath:animated:scrollPosition:) aopClass:aopClass];
    [self addOverriteMethod:@selector(deselectRowAtIndexPath:animated:) aopClass:aopClass];

    // Appearance
    [self addOverriteMethod:@selector(dequeueReusableCellWithIdentifier:forIndexPath:) aopClass:aopClass];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    BOOL responds = NO;
    responds = ([self.origDelegate respondsToSelector:aSelector] || [self.origDataSource respondsToSelector:aSelector]);
    if (!responds) {
        responds = ([self.delegate respondsToSelector:aSelector] || [self.dataSource respondsToSelector:aSelector]);
    }
    if (!responds) {
        responds = (aSelector == @selector(tableView:willDisplayCell:forRowAtIndexPath:) ||
                    aSelector == @selector(tableView:didEndDisplayingCell:forRowAtIndexPath:));
    }
    return responds;
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    BOOL conforms = NO;
    conforms = ([self.origDelegate conformsToProtocol:aProtocol] || [self.origDataSource conformsToProtocol:aProtocol]);
    if (!conforms) {
        conforms = ([self.delegate conformsToProtocol:aProtocol] || [self.delegate conformsToProtocol:aProtocol]);
    }
    return conforms;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if ([self.origDelegate respondsToSelector:aSelector]) {
        return [(id)self.origDelegate methodSignatureForSelector:aSelector];
    } else if ([self.origDataSource respondsToSelector:aSelector]) {
        return [(id)self.origDataSource methodSignatureForSelector:aSelector];
    } else if ([self.delegate respondsToSelector:aSelector]) {
        return [(id)self.delegate methodSignatureForSelector:aSelector];
    } else if ([self.dataSource respondsToSelector:aSelector]) {
        return [(id)self.dataSource methodSignatureForSelector:aSelector];
    }
    return [super methodSignatureForSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return nil;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    if ([self.origDelegate respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:self.origDelegate];
    } else if ([self.origDataSource respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:self.origDataSource];
    }
    
    if ([self.delegate respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:self.delegate];
    } else if ([self.dataSource respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:self.dataSource];
    }
    
    if ([super respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:self];
    }
}

- (void)dealloc {
    IMYLog(@"dealloc aop table utils");
}

@end

#import <objc/runtime.h>

static const void *kIMYAOPTableUtilsKey = &kIMYAOPTableUtilsKey;

@implementation UITableView (AOPTableViewUtils)

- (IMYAOPTableViewUtils *)aop_utils {
    IMYAOPTableViewUtils *aopUtils = objc_getAssociatedObject(self, kIMYAOPTableUtilsKey);
    if (!aopUtils) {
        @synchronized(self) {
            aopUtils = objc_getAssociatedObject(self, kIMYAOPTableUtilsKey);
            if (!aopUtils) {
                ///初始化部分配置
                [_IMYAOPTableView aop_setupConfigs];
                ///获取aop utils
                aopUtils = [IMYAOPTableViewUtils aopUtilsWithTableView:self];
                objc_setAssociatedObject(self, kIMYAOPTableUtilsKey, aopUtils, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [aopUtils injectTableView];
            }
        }
    }
    return aopUtils;
}

- (BOOL)aop_installed {
    IMYAOPTableViewUtils *aopUtils = objc_getAssociatedObject(self, kIMYAOPTableUtilsKey);
    if (aopUtils) {
        return YES;
    }
    return NO;
}

@end


@implementation IMYAOPTableViewUtils (IndexPathDeprecated)
- (nullable NSIndexPath *)realIndexPathByTable:(NSIndexPath *)tableIndexPath {
    return [self userIndexPathByFeeds:tableIndexPath];
}
- (nullable NSIndexPath *)tableIndexPathByReal:(NSIndexPath *)realIndexPath {
    return [self feedsIndexPathByUser:realIndexPath];
}
- (NSInteger)realSectionByTable:(NSInteger)tableSection {
    return [self userSectionByFeeds:tableSection];
}
- (NSInteger)tableSectionByReal:(NSInteger)realSection {
    return [self feedsSectionByUser:realSection];
}
- (NSArray<NSIndexPath *> *)realIndexPathsByTableIndexPaths:(NSArray<NSIndexPath *> *)tableIndexPaths {
    return [self userIndexPathsByFeedsIndexPaths:tableIndexPaths];
}
- (NSArray<NSIndexPath *> *)tableIndexPathsByRealIndexPaths:(NSArray<NSIndexPath *> *)realIndexPaths {
    return [self feedsIndexPathsByUserIndexPaths:realIndexPaths];
}
- (NSIndexSet *)realSectionsByTableSet:(NSIndexSet *)tableSet {
    return [self userSectionsByFeedsSet:tableSet];
}
- (NSIndexSet *)tableSectionsByRealSet:(NSIndexSet *)realSet {
    return [self feedsSectionsByUserSet:realSet];
}
@end

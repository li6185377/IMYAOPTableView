//
//  IMYAOPTableViewUtils.m
//  IMYAdvertisementDemo
//
//  Created by ljh on 16/4/15.
//  Copyright © 2016年 IMY. All rights reserved.
//

#import "IMYAOPTableViewUtils.h"
#import <objc/message.h>
#import <objc/runtime.h>

#import "IMYAOPTableViewUtils+DataSource.h"
#import "IMYAOPTableViewUtils+Delegate.h"
#import "IMYAOPTableViewUtils+Private.h"
#import "UITableView+IMYAOPTableView.h"

static NSString* const kAOPTableViewPrefix = @"kIMYAOP_";
static Class kIMYTVAOPClass;

@interface IMYAOPTableViewUtils ()

@property (nonatomic, weak) id<UITableViewDelegate> tableDelegate;
@property (nonatomic, weak) id<UITableViewDataSource> tableDataSource;

@property (nonatomic, weak) UITableView* tableView;

@property (nonatomic, strong) NSMutableIndexSet* sections;
@property (nonatomic, strong) NSMutableDictionary* sectionMap;

///tableView Class
@property (nonatomic, assign) Class tableViewClass;
///是否由UI 进行调用
@property (nonatomic, assign) NSInteger isUICalling;

+ (instancetype)aopUtilsWithTableView:(UITableView*)tableView;
- (void)injectTableView;

@end

@implementation IMYAOPTableViewUtils
+ (instancetype)aopUtilsWithTableView:(UITableView*)tableView
{
    IMYAOPTableViewUtils* aopUtils = [super new];
    [aopUtils setTableView:tableView];
    return aopUtils;
}
- (void)setTableDelegate:(id<UITableViewDelegate>)tableDelegate
{
    if (_tableDelegate != tableDelegate) {
        _tableDelegate = tableDelegate;
        id tableView = self.tableView;
        [tableView aop_refreshDelegate];
    }
}
- (void)setTableDataSource:(id<UITableViewDataSource>)tableDataSource
{
    if (_tableDataSource != tableDataSource) {
        _tableDataSource = tableDataSource;
        id tableView = self.tableView;
        [tableView aop_refreshDataSource];
    }
}
- (void)setDelegate:(id<IMYAOPTableViewDelegate>)delegate
{
    if (_delegate != delegate) {
        _delegate = delegate;
        id tableView = self.tableView;
        [tableView aop_refreshDelegate];
    }
}
- (void)setDataSource:(id<IMYAOPTableViewDataSource>)dataSource
{
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        id tableView = self.tableView;
        [tableView aop_refreshDataSource];
    }
}
- (void)injectTableView
{
    UITableView* tableView = self.tableView;

    _tableDataSource = tableView.dataSource;
    _tableDelegate = tableView.delegate;

    tableView.delegate = self;
    tableView.dataSource = self;

    self.tableViewClass = [tableView class];
    Class aopClass = [self makeSubclassWithClass:self.tableViewClass];
    if (![self.tableViewClass isSubclassOfClass:aopClass]) {
        [self bindingTableView:tableView aopClass:aopClass];
    }
}
- (void)bindingTableView:(UITableView*)tableView aopClass:(Class)aopClass
{
    id observationInfo = [tableView observationInfo];
    NSArray* observances = [observationInfo valueForKey:@"_observances"];
    ///移除旧的KVO
    for (id observance in observances) {
        NSString* keyPath = [observance valueForKeyPath:@"_property._keyPath"];
        id observer = [observance valueForKey:@"_observer"];
        if (keyPath && observer) {
            [tableView removeObserver:observer forKeyPath:keyPath];
        }
    }
    object_setClass(tableView, aopClass);
    ///添加新的KVO
    for (id observance in observances) {
        NSString* keyPath = [observance valueForKeyPath:@"_property._keyPath"];
        id observer = [observance valueForKey:@"_observer"];
        if (observer && keyPath) {
            NSKeyValueObservingOptions options = [[observance valueForKey:@"_options"] unsignedIntegerValue];
            if (options == 0) {
                options = (NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew);
            }
            [tableView addObserver:observer forKeyPath:keyPath options:options context:nil];
        }
    }
}
- (void)insertWithSections:(NSArray<IMYAOPTableViewInsertBody*>*)insertSections
{
    NSArray<IMYAOPTableViewInsertBody*>* array = [insertSections sortedArrayUsingComparator:^NSComparisonResult(IMYAOPTableViewInsertBody* _Nonnull obj1, IMYAOPTableViewInsertBody* _Nonnull obj2) {
        if (obj1.section > obj2.section) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];

    NSMutableIndexSet* insertArray = [NSMutableIndexSet indexSet];
    [array enumerateObjectsUsingBlock:^(IMYAOPTableViewInsertBody* _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
        NSInteger section = obj.section;
        while (1) {
            BOOL hasEqual = NO;
            if ([insertArray containsIndex:section]) {
                section++;
                hasEqual = YES;
                break;
            }
            if (hasEqual == NO) {
                break;
            }
        }
        [insertArray addIndex:section];
        obj.resultSection = section;
    }];
    self.sections = insertArray;
}
- (void)insertWithIndexPaths:(NSArray<IMYAOPTableViewInsertBody*>*)indexPaths
{
    NSArray<IMYAOPTableViewInsertBody*>* array = [indexPaths sortedArrayUsingComparator:^NSComparisonResult(IMYAOPTableViewInsertBody* _Nonnull obj1, IMYAOPTableViewInsertBody* _Nonnull obj2) {
        return [obj1.indexPath compare:obj2.indexPath];
    }];

    NSMutableDictionary* insertMap = [NSMutableDictionary dictionary];

    [array enumerateObjectsUsingBlock:^(IMYAOPTableViewInsertBody* _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
        NSInteger section = obj.indexPath.section;
        NSInteger row = obj.indexPath.row;
        NSMutableArray* rowArray = insertMap[@(section)];
        if (!rowArray) {
            rowArray = [NSMutableArray array];
            [insertMap setObject:rowArray forKey:@(section)];
        }
        while (1) {
            BOOL hasEqual = NO;
            for (NSIndexPath* inserted in rowArray) {
                if (inserted.row == row) {
                    row++;
                    hasEqual = YES;
                    break;
                }
            }
            if (hasEqual == NO) {
                break;
            }
        }
        NSIndexPath* insertPath = [NSIndexPath indexPathForRow:row inSection:section];
        [rowArray addObject:insertPath];
        obj.resultIndexPath = insertPath;
    }];
    self.sectionMap = insertMap;
}
#pragma mark- install aop method
- (Class)makeSubclassWithClass:(Class)origClass
{
    NSString* className = NSStringFromClass(origClass);
    NSString* aopClassName = [kAOPTableViewPrefix stringByAppendingString:className];
    Class aopClass = NSClassFromString(aopClassName);

    if (aopClass) {
        return aopClass;
    }
    aopClass = objc_allocateClassPair(origClass, aopClassName.UTF8String, 0);

    [self setupAopClass:aopClass];

    objc_registerClassPair(aopClass);
    return aopClass;
}
- (void)setupAopClass:(Class)aopClass
{
    kIMYTVAOPClass = [UITableView imy_aopClass];
    ///纯手动敲打
    [self addOverriteMethod:@selector(class) aopClass:aopClass];
    [self addOverriteMethod:@selector(setDelegate:) aopClass:aopClass];
    [self addOverriteMethod:@selector(setDataSource:) aopClass:aopClass];
    [self addOverriteMethod:@selector(delegate) aopClass:aopClass];
    [self addOverriteMethod:@selector(dataSource) aopClass:aopClass];

    ///UI Calling
    [self addOverriteMethod:@selector(reloadData) aopClass:aopClass];
    [self addOverriteMethod:@selector(layoutSubviews) aopClass:aopClass];
    [self addOverriteMethod:@selector(setBounds:) aopClass:aopClass];
    [self addOverriteMethod:[UITableView aop_updateRowDataSEL] aopClass:aopClass];
    [self addOverriteMethod:[UITableView aop_updateContentSizeSEL] aopClass:aopClass];
    [self addOverriteMethod:[UITableView aop_rebuildGeometrySEL] aopClass:aopClass];
    [self addOverriteMethod:[UITableView aop_updateAnimationDidStopSEL] aopClass:aopClass];
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
    [self addOverriteMethod:[UITableView aop_userSelectRowAtPendingSelectionIndexPathSEL] aopClass:aopClass];
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
- (void)addOverriteMethod:(SEL)seletor aopClass:(Class)aopClass
{
    NSString* seletorString = NSStringFromSelector(seletor);
    NSString* aopSeletorString = [NSString stringWithFormat:@"aop_%@", seletorString];
    SEL aopMethod = NSSelectorFromString(aopSeletorString);
    [self addOverriteMethod:seletor toMethod:aopMethod class:aopClass];
}
- (void)addOverriteMethod:(SEL)seletor toMethod:(SEL)toSeletor class:(Class)clazz {
    Method method = class_getInstanceMethod(kIMYTVAOPClass, toSeletor);
    if (method == NULL) {
        method = class_getInstanceMethod(kIMYTVAOPClass, seletor);
    }
    const char* types = method_getTypeEncoding(method);
    IMP imp = method_getImplementation(method);
    class_addMethod(clazz, seletor, imp, types);
}
- (BOOL)respondsToSelector:(SEL)aSelector
{
    BOOL responds = NO;
    responds = ([self.tableDelegate respondsToSelector:aSelector] || [self.tableDataSource respondsToSelector:aSelector]);
    if (!responds) {
        responds = ([self.delegate respondsToSelector:aSelector] || [self.dataSource respondsToSelector:aSelector]);
    }
    return responds;
}
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if ([self.tableDelegate respondsToSelector:aSelector]) {
        return self.tableDelegate;
    }
    else if ([self.tableDataSource respondsToSelector:aSelector]) {
        return self.tableDataSource;
    }
    return nil;
}
- (void)forwardInvocation:(NSInvocation*)invocation
{
    if (self.tableDelegate || self.tableDataSource) {
        NSAssert(NO, @"未实现该方法");
    }
}
- (void)dealloc
{
    NSLog(@"dealloc aop table utils");
}
@end

@implementation IMYAOPTableViewUtils (IndexPath)
- (NSIndexPath*)realIndexPathByTable:(NSIndexPath*)tableIndexPath
{
    if (tableIndexPath == nil) {
        return nil;
    }
    NSInteger section = tableIndexPath.section;
    NSInteger row = tableIndexPath.row;

    NSMutableArray<NSIndexPath*>* array = self.sectionMap[@(section)];
    NSInteger cutCount = 0;
    for (NSIndexPath* obj in array) {
        if (obj.row == row) {
            cutCount = -1;
            break;
        }
        if (obj.row < row) {
            cutCount++;
        }
        else {
            break;
        }
    }
    if (cutCount < 0) {
        return nil;
    }
    ///如果该位置不是广告， 则转为逻辑index
    section = [self realSectionByTable:section];
    NSIndexPath* realIndexPath = [NSIndexPath indexPathForRow:row - cutCount inSection:section];
    return realIndexPath;
}
- (NSIndexPath*)tableIndexPathByReal:(NSIndexPath*)realIndexPath
{
    if (realIndexPath == nil) {
        return nil;
    }
    NSInteger section = realIndexPath.section;
    NSInteger row = realIndexPath.row;

    ///转为table section
    section = [self tableSectionByReal:section];

    NSMutableArray<NSIndexPath*>* array = self.sectionMap[@(section)];
    for (NSIndexPath* obj in array) {
        if (obj.row <= row) {
            row += 1;
        }
        else {
            break;
        }
    }
    NSIndexPath* tableIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    return tableIndexPath;
}
- (NSArray<NSIndexPath*>*)realIndexPathsByTableIndexPaths:(NSArray<NSIndexPath*>*)tableIndexPaths
{
    NSMutableArray* toArray = [NSMutableArray array];
    [tableIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath* _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
        NSIndexPath* realIndexPath = [self realIndexPathByTable:obj];
        if (realIndexPath) {
            [toArray addObject:realIndexPath];
        }
    }];
    return toArray;
}
- (NSArray<NSIndexPath*>*)tableIndexPathsByRealIndexPaths:(NSArray<NSIndexPath*>*)realIndexPaths
{
    NSMutableArray* toArray = [NSMutableArray array];
    [realIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath* _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
        NSIndexPath* tableIndexPath = [self tableIndexPathByReal:obj];
        if (tableIndexPath) {
            [toArray addObject:tableIndexPath];
        }
    }];
    return toArray;
}
- (NSInteger)tableSectionByReal:(NSInteger)realSection
{
    __block NSInteger section = realSection;
    [self.sections enumerateIndexesUsingBlock:^(NSUInteger insertSection, BOOL* _Nonnull stop) {
        if (insertSection <= section) {
            section += 1;
        }
        else {
            *stop = YES;
        }
    }];
    return section;
}
- (NSInteger)realSectionByTable:(NSInteger)tableSection
{
    __block NSInteger cutCount = 0;
    [self.sections enumerateIndexesUsingBlock:^(NSUInteger insertSection, BOOL* _Nonnull stop) {
        if (insertSection == tableSection) {
            cutCount = -1;
            *stop = YES;
        }
        if (insertSection < tableSection) {
            cutCount += 1;
        }
    }];
    if (cutCount >= 0) {
        NSInteger realCount = tableSection - cutCount;
        return realCount;
    }
    return -1;
}
- (NSIndexSet*)tableSectionsByRealSet:(NSIndexSet*)realSet
{
    NSMutableIndexSet* sections = [NSMutableIndexSet indexSet];
    [realSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL* _Nonnull stop) {
        NSInteger section = [self tableSectionByReal:idx];
        if (section >= 0) {
            [sections addIndex:section];
        }
    }];
    return sections;
}
- (NSIndexSet*)realSectionsByTableSet:(NSIndexSet*)tableSet
{
    NSMutableIndexSet* sections = [NSMutableIndexSet indexSet];
    [tableSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL* _Nonnull stop) {
        NSInteger section = [self realSectionByTable:idx];
        if (section >= 0) {
            [sections addIndex:section];
        }
    }];
    return sections;
}
@end

static const void* kIMYAOPTableUtilsKey = &kIMYAOPTableUtilsKey;
@implementation UITableView (AOPTableViewUtils)
- (IMYAOPTableViewUtils*)aop_utils
{
    IMYAOPTableViewUtils* aopUtils = objc_getAssociatedObject(self, kIMYAOPTableUtilsKey);
    if (!aopUtils) {
        @synchronized (self) {
            aopUtils = objc_getAssociatedObject(self, kIMYAOPTableUtilsKey);
            if (!aopUtils) {
                aopUtils = [IMYAOPTableViewUtils aopUtilsWithTableView:self];
                objc_setAssociatedObject(self, kIMYAOPTableUtilsKey, aopUtils, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [aopUtils injectTableView];
            }
        }
    }
    return aopUtils;
}
- (BOOL)aop_installed
{
    IMYAOPTableViewUtils* aopUtils = objc_getAssociatedObject(self, kIMYAOPTableUtilsKey);
    if (aopUtils) {
        return YES;
    }
    return NO;
}
@end

@implementation IMYAOPTableViewUtils (Deprecated_Nonfunctional)
- (void)setCombineReloadData:(BOOL)combineReloadData
{
}
- (BOOL)combineReloadData
{
    return NO;
}
@end
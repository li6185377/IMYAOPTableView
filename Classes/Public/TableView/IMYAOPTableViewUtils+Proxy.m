//
//  IMYAOPTableViewUtils+Proxy.m
//  IMYAOPFeedsView
//
//  Created by ljh on 16/5/20.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import "IMYAOPCallProxy.h"
#import "IMYAOPTableViewUtils+Private.h"
#import "IMYAOPTableViewUtils+Proxy.h"
#import "UITableView+IMYAOPTableView.h"
#import <objc/runtime.h>

@implementation IMYAOPTableViewUtils (InsertedProxy)

- (NSArray<UITableViewCell *> *)visibleInsertCells {
    return [self visibleCellsWithType:IMYAOPTypeInsert];
}

- (NSArray<UITableViewCell *> *)visibleCellsWithType:(IMYAOPType)type {
    return [(id)self.tableView aop_containVisibleCells:type];
}

@end

static const void *kIMYAOPProxyRawTableViewKey = &kIMYAOPProxyRawTableViewKey;
@implementation IMYAOPTableViewUtils (TableViewProxy)

- (UITableView *)proxyRawTableView {
    id tableView = objc_getAssociatedObject(self, kIMYAOPProxyRawTableViewKey);
    if (!tableView) {
        tableView = [IMYAOPCallProxy callWithSuperClass:self.origViewClass object:self.tableView aopUtils:self];
        objc_setAssociatedObject(self, kIMYAOPProxyRawTableViewKey, tableView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return tableView;
}

- (CGRect)rectForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.proxyRawTableView rectForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.proxyRawTableView cellForRowAtIndexPath:indexPath];
}

- (NSIndexPath *)indexPathForCell:(UITableViewCell *)cell {
    return [self.proxyRawTableView indexPathForCell:cell];
}

@end

@implementation IMYAOPTableViewUtils (Models)

- (NSArray<IMYAOPTableViewRawModel *> *)allModels {
    NSMutableArray *results = [NSMutableArray array];
    UITableView *tableView = self.proxyRawTableView;
    NSUInteger numberOfSections = [tableView numberOfSections];
    for (NSInteger section = 0; section < numberOfSections; section++) {
        NSUInteger numberOfRows = [tableView numberOfRowsInSection:section];
        for (NSInteger row = 0; row < numberOfRows; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            id model = [self modelForRowAtIndexPath:indexPath];
            IMYAOPTableViewRawModel *rawModel = [IMYAOPTableViewRawModel rawWithModel:model indexPath:indexPath];
            [results addObject:rawModel];
        }
    }
    return results;
}

- (id)modelForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *userIndexPath = [self userIndexPathByFeeds:indexPath];
    id<UITableViewDataSource, IMYAOPTableViewGetModelProtocol> dataSource = nil;
    if (userIndexPath) {
        dataSource = (id)self.origDataSource;
        indexPath = userIndexPath;
    } else {
        dataSource = (id)self.dataSource;
    }
    id model = nil;
    if ([dataSource respondsToSelector:@selector(tableView:modelForRowAtIndexPath:)]) {
        model = [dataSource tableView:self.tableView modelForRowAtIndexPath:indexPath];
    }
    return model;
}

@end

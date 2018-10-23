//
//  IMYAOPCollectionViewUtils+Proxy.m
//  IMYAOPFeedsView
//
//  Created by ljh on 16/5/20.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import "IMYAOPCallProxy.h"
#import "IMYAOPCollectionViewUtils+Private.h"
#import "IMYAOPCollectionViewUtils+Proxy.h"
#import "UICollectionView+IMYAOPCollectionView.h"
#import <objc/runtime.h>

@implementation IMYAOPCollectionViewUtils (InsertedProxy)

- (NSArray<UICollectionViewCell *> *)visibleInsertCells {
    return [self visibleCellsWithType:IMYAOPTypeInsert];
}

- (NSArray<UICollectionViewCell *> *)visibleCellsWithType:(IMYAOPType)type {
    return [(id)self.collectionView aop_containVisibleCells:type];
}

@end

static const void *kIMYAOPProxyRawCollectionViewKey = &kIMYAOPProxyRawCollectionViewKey;
@implementation IMYAOPCollectionViewUtils (TableViewProxy)

- (UICollectionView *)proxyRawCollectionView {
    id aopCall = objc_getAssociatedObject(self, kIMYAOPProxyRawCollectionViewKey);
    if (!aopCall) {
        aopCall = [IMYAOPCallProxy callWithSuperClass:self.origViewClass object:self.collectionView aopUtils:self];
        objc_setAssociatedObject(self, kIMYAOPProxyRawCollectionViewKey, aopCall, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return aopCall;
}

- (UICollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.proxyRawCollectionView cellForItemAtIndexPath:indexPath];
}

- (NSIndexPath *)indexPathForCell:(UICollectionViewCell *)cell {
    return [self.proxyRawCollectionView indexPathForCell:cell];
}

@end

@implementation IMYAOPCollectionViewUtils (Models)

- (NSArray<IMYAOPCollectionViewRawModel *> *)allModels {
    NSMutableArray *results = [NSMutableArray array];
    UICollectionView *collectionView = [self proxyRawCollectionView];
    NSUInteger numberOfSections = [collectionView numberOfSections];
    for (NSInteger section = 0; section < numberOfSections; section++) {
        NSUInteger numberOfRows = [collectionView numberOfItemsInSection:section];
        for (NSInteger row = 0; row < numberOfRows; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            id model = [self modelForRowAtIndexPath:indexPath];
            IMYAOPCollectionViewRawModel *rawModel = [IMYAOPCollectionViewRawModel rawWithModel:model indexPath:indexPath];
            [results addObject:rawModel];
        }
    }
    return results;
}

- (id)modelForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *userIndexPath = [self userIndexPathByFeeds:indexPath];
    id<UITableViewDataSource, IMYAOPCollectionViewGetModelProtocol> dataSource = nil;
    if (userIndexPath) {
        dataSource = (id)self.origDataSource;
        indexPath = userIndexPath;
    } else {
        dataSource = (id)self.dataSource;
    }
    id model = nil;
    if ([dataSource respondsToSelector:@selector(collectionView:modelForItemAtIndexPath:)]) {
        model = [dataSource collectionView:self.collectionView modelForItemAtIndexPath:indexPath];
    }
    return model;
}

@end

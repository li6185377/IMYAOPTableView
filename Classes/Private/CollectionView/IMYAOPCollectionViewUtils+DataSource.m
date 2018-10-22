//
//  IMYAOPFeedsViewUtils+UITableViewDataSource.m
//  IMYAOPFeedsView
//
//  Created by ljh on 16/4/15.
//  Copyright © 2016年 IMY. All rights reserved.
//

#import "IMYAOPCollectionViewUtils+DataSource.h"
#import "IMYAOPCollectionViewUtils+Private.h"

#define kAOPRealIndexPathCode                                           \
    NSIndexPath *realIndexPath = [self realIndexPathByTable:indexPath]; \
    id<IMYAOPCollectionViewDataSource> dataSource = nil;                \
    if (realIndexPath) {                                                \
        dataSource = (id)self.origDataSource;                           \
        indexPath = realIndexPath;                                      \
    } else {                                                            \
        dataSource = self.dataSource;                                   \
    }

#define kAOPRealSectionCode                                    \
    NSInteger realSection = [self realSectionByTable:section]; \
    id<IMYAOPCollectionViewDataSource> dataSource = nil;       \
    if (realSection >= 0) {                                    \
        dataSource = (id)self.origDataSource;                  \
        section = realSection;                                 \
    } else {                                                   \
        dataSource = self.dataSource;                          \
    }

#define kAOPUICallingSaved \
    self.isUICalling -= 1;

#define kAOPUICallingResotre \
    self.isUICalling += 1;

@implementation IMYAOPCollectionViewUtils (UICollectionViewDataSource)

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    kAOPUICallingSaved;
    NSInteger numberOfSection = 1;
    if ([self.origDataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        numberOfSection = [self.origDataSource numberOfSectionsInCollectionView:collectionView];
    }
    ///初始化回调
    [self.dataSource aopCollectionUtils:self numberOfSections:numberOfSection];

    ///总number section
    if (numberOfSection > 0) {
        numberOfSection = [self tableSectionByReal:numberOfSection];
    }
    kAOPUICallingResotre;
    return numberOfSection;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    kAOPUICallingSaved;
    NSInteger realSection = [self realSectionByTable:section];
    NSInteger rowCount = 0;
    if (realSection >= 0) {
        section = realSection;
        rowCount = [self.origDataSource collectionView:collectionView numberOfItemsInSection:section];

        NSIndexPath *tableIndexPath = [self tableIndexPathByReal:[NSIndexPath indexPathForRow:rowCount inSection:section]];
        rowCount = tableIndexPath.row;
    } else {
        NSMutableArray<NSIndexPath *> *array = self.sectionMap[@(section)];
        for (NSIndexPath *obj in array) {
            if (obj.row <= rowCount) {
                rowCount += 1;
            } else {
                break;
            }
        }
    }
    kAOPUICallingResotre;
    return rowCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    UICollectionViewCell *cell = nil;
    if ([dataSource respondsToSelector:@selector(collectionView:cellForItemAtIndexPath:)]) {
        cell = [dataSource collectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
    if (![cell isKindOfClass:[UICollectionViewCell class]]) {
        cell = [UICollectionViewCell new];
        if (dataSource) {
            NSAssert(NO, @"Cell is Nil");
        }
    }
    kAOPUICallingResotre;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    UICollectionReusableView *reusableView = nil;
    if ([dataSource respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)]) {
        reusableView = [dataSource collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
    }
    if (![reusableView isKindOfClass:[UICollectionReusableView class]]) {
        reusableView = [UICollectionReusableView new];
        if (dataSource) {
            NSAssert(NO, @"Cell is Nil");
        }
    }
    kAOPUICallingResotre;
    return reusableView;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    BOOL canMove = NO;
    if ([dataSource respondsToSelector:@selector(collectionView:canMoveItemAtIndexPath:)]) {
        canMove = [dataSource collectionView:collectionView canMoveItemAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
    return canMove;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    kAOPUICallingSaved;
    NSIndexPath *source = [self realIndexPathByTable:sourceIndexPath];
    NSIndexPath *destin = [self realIndexPathByTable:destinationIndexPath];
    if ([self.origDataSource respondsToSelector:@selector(collectionView:moveItemAtIndexPath:toIndexPath:)]) {
        [self.origDataSource collectionView:collectionView moveItemAtIndexPath:source toIndexPath:destin];
    }
    kAOPUICallingResotre;
}

- (NSArray<NSString *> *)indexTitlesForCollectionView:(UICollectionView *)collectionView {
    NSAssert(NO, @"NO Impl");
    return nil;
}

- (NSIndexPath *)collectionView:(UICollectionView *)collectionView indexPathForIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSAssert(NO, @"NO Impl");
    return nil;
}

@end

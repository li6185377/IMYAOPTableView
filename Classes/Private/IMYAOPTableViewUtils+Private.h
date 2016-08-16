//
//  IMYAOPTableViewUtils+Private.h
//  IMYAdvertisementDemo
//
//  Created by ljh on 16/4/16.
//  Copyright © 2016年 IMY. All rights reserved.
//

#import "IMYAOPTableViewUtils.h"

NS_ASSUME_NONNULL_BEGIN

@protocol IADTableViewUtilsPrivate

@property (nullable, nonatomic, weak) id<UITableViewDelegate> tableDelegate;
@property (nullable, nonatomic, weak) id<UITableViewDataSource> tableDataSource;

@property (nullable, nonatomic, strong) NSMutableIndexSet *sections;
@property (nullable, nonatomic, strong) NSMutableDictionary *sectionMap;

@property (nullable, nonatomic, strong) Class tableViewClass;

///是否由UI 进行调用
@property (nonatomic, assign) NSInteger isUICalling;

@end

@interface IMYAOPTableViewUtils (Private) <IADTableViewUtilsPrivate>

@end

NS_ASSUME_NONNULL_END

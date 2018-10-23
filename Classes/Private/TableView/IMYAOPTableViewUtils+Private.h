//
//  IMYAOPTableViewUtils+Private.h
//  IMYAOPFeedsView
//
//  Created by ljh on 16/5/20.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import "IMYAOPBaseUtils+Private.h"
#import "IMYAOPTableViewUtils.h"

NS_ASSUME_NONNULL_BEGIN

@protocol IAOPTableViewUtilsPrivate <IAOPBaseUtilsPrivate>

@property (nullable, nonatomic, weak) id<UITableViewDelegate> origDelegate;
@property (nullable, nonatomic, weak) id<UITableViewDataSource> origDataSource;

@property (nullable, nonatomic, weak) UITableView *tableView;

@end

@interface IMYAOPTableViewUtils (Private) <IAOPTableViewUtilsPrivate>

@end

NS_ASSUME_NONNULL_END

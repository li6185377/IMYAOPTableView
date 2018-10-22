//
//  IMYAOPFeedsView.h
//  IMYAOPFeedsView
//
//  Created by ljh on 16/5/30.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMYAOPTableViewUtils+Proxy.h"
#import "IMYAOPTableViewUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (IMYAOPTableViewUtils)

///创建并获取：AOPTableUtils
@property (nonatomic, readonly, strong) IMYAOPTableViewUtils *aop_utils;

///是否注入了：AOPTableUtils
@property (nonatomic, readonly, assign) BOOL aop_installed;

@end

NS_ASSUME_NONNULL_END

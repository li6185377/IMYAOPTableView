//
//  IMYAOPTableView.h
//  AOPTableView
//
//  Created by ljh on 16/5/30.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMYAOPTableViewUtils.h"
#import "IMYAOPTableViewUtils+Proxy.h"

@interface UITableView (IMYAOPTableViewUtils)
///创建并获取：AOPTableUtils
@property (nonatomic, readonly) IMYAOPTableViewUtils* aop_utils;
///是否注入了：AOPTableUtils
@property (nonatomic, readonly) BOOL aop_installed;
@end

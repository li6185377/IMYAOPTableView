//
//  IMYAOPTableViewUtilsDelegate.h
//  IMYAOPFeedsView
//
//  Created by ljh on 16/5/20.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class IMYAOPTableViewInsertBody, IMYAOPTableViewUtils;

@protocol IMYAOPTableViewDelegate <UITableViewDelegate>
@optional

- (void)aopTableUtils:(IMYAOPTableViewUtils *)tableUtils willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)aopTableUtils:(IMYAOPTableViewUtils *)tableUtils didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

///实现了这个方法 将不会再走原有的 获取 height 的方法  帖子列表置顶广告使用
- (CGFloat)aopTableUtils:(IMYAOPTableViewUtils *)tableUtils heightForHeaderInSection:(NSInteger)section;

@end

@protocol IMYAOPTableViewDataSource <UITableViewDataSource>

@required
//可以获取真实的 sectionNumber 并在这边进行一些AOP的数据初始化
- (void)aopTableUtils:(IMYAOPTableViewUtils *)tableUtils numberOfSection:(NSInteger)sectionNumber;
@end

NS_ASSUME_NONNULL_END

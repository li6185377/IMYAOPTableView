//
//  UITableView+IMYAOPTableView.h
//  IMYAOPFeedsView
//
//  Created by ljh on 16/5/20.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import "IMYAOPTableViewUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (IMYAOPTableOperation)

+ (SEL)aop_userSelectRowAtPendingSelectionIndexPathSEL;
+ (SEL)aop_updateRowDataSEL;
+ (SEL)aop_rebuildGeometrySEL;
+ (SEL)aop_updateContentSizeSEL;
+ (SEL)aop_updateAnimationDidStopSEL;

+ (Class)imy_aopClass;

@end


@interface _IMYAOPTableView : UITableView

+ (void)aop_setupConfigs;
- (void)aop_refreshDelegate;
- (void)aop_refreshDataSource;
///获取显示中的cell containType => 0：原生cell   1：插入的cell   2：全部cell
- (NSArray *)aop_containVisibleCells:(IMYAOPType)containType;

@end

NS_ASSUME_NONNULL_END

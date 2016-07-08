//
//  UITableView+IMYADTableUtils.h
//  IMYAdvertisementDemo
//
//  Created by ljh on 16/4/16.
//  Copyright © 2016年 IMY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMYAOPTableViewUtils.h"

@interface UITableView (IMYAOPTableOperation)
+ (SEL)aop_userSelectRowAtPendingSelectionIndexPathSEL;
+ (SEL)aop_updateRowDataSEL;
+ (SEL)aop_rebuildGeometrySEL;
+ (SEL)aop_updateContentSizeSEL;
+ (SEL)aop_updateAnimationDidStopSEL;

+ (Class)imy_aopClass;
@end


@interface _IMYAOPTableView : UITableView
- (void)aop_refreshDelegate;
- (void)aop_refreshDataSource;
///获取显示中的cell containType => 0：原生cell   1：插入的cell   2：全部cell
- (NSArray*)aop_containVisibleCells:(IMYAOPType)containType;
@end
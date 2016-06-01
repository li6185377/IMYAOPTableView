//
//  UITableView+IMYADTableUtils.h
//  IMYAdvertisementDemo
//
//  Created by ljh on 16/4/16.
//  Copyright © 2016年 IMY. All rights reserved.
//

#import "IMYAOPTableViewUtils.h"
#import <UIKit/UIKit.h>

@protocol IMYAOPTableViewPrivate
@optional
- (void)_userSelectRowAtPendingSelectionIndexPath:(NSIndexPath*)indexPath;
- (void)_updateRowData;
- (void)_rebuildGeometry;
- (void)_updateContentSize;
@end

@interface UITableView (IMYAOPTableOperation) <IMYAOPTableViewPrivate>
+ (Class)imy_aopClass;
@end


@interface _IMYAOPTableView : UITableView
- (void)aop_realReloadData;
- (void)aop_refreshDelegate;
- (void)aop_refreshDataSource;
@end
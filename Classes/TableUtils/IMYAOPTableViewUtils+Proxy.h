//
//  IMYAOPTableViewUtils+Proxy.h
//  Pods
//
//  Created by ljh on 16/6/22.
//
//

#import "IMYAOPTableViewUtils.h"

@interface IMYAOPTableViewUtils (InsertedProxy)
///获取插入集合内，显示中的cell
@property (nonatomic, readonly) NSArray<__kindof UITableViewCell*>* visibleInsertCells;
///获取显示中的cell
- (NSArray<__kindof UITableViewCell*>*)visibleCellsWithType:(IMYAOPType)type;
@end

///对TableView执行原始数据的操作, 不进行AOP的处理
@interface IMYAOPTableViewUtils (TableViewProxy)

- (CGRect)rectForRowAtIndexPath:(NSIndexPath*)indexPath;

- (NSIndexPath*)indexPathForCell:(UITableViewCell*)cell;

- (__kindof UITableViewCell*)cellForRowAtIndexPath:(NSIndexPath*)indexPath;

///more... 可直接使用这个tableView进行方法调用,不经过AOP处理
- (UITableView*)proxyRawTableView;

@end

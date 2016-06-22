//
//  IMYAOPTableViewUtils+Proxy.m
//  Pods
//
//  Created by ljh on 16/6/22.
//
//

#import "IMYAOPTableViewUtils+Proxy.h"
#import "IMYAOPTableViewUtils+Private.h"
#import "UITableView+IMYAOPTableView.h"
#import <objc/runtime.h>

@interface _IMYAOPCallProxy : NSProxy
@property (nonatomic, weak) id target;
@property (nonatomic, strong) Class invokeClass;
+ (id)callWithSuperClass:(Class)superClass object:(id)obj;
@end

@implementation IMYAOPTableViewUtils (InsertedProxy)
- (NSArray<UITableViewCell*>*)visibleInsertCells
{
    return [self visibleCellsWithType:IMYAOPTypeInsert];
}
- (NSArray<UITableViewCell*>*)visibleCellsWithType:(IMYAOPType)type
{
    return [(id)self.tableView aop_containVisibleCells:type];
}
@end

static const void* kIMYAOPProxyRawTableViewKey = &kIMYAOPProxyRawTableViewKey;
@implementation IMYAOPTableViewUtils (TableViewProxy)
- (UITableView*)proxyRawTableView
{
    id tableView = objc_getAssociatedObject(self, kIMYAOPProxyRawTableViewKey);
    if (!tableView) {
        tableView = [_IMYAOPCallProxy callWithSuperClass:self.tableViewClass object:self.tableView];
        objc_setAssociatedObject(self, kIMYAOPProxyRawTableViewKey, tableView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return tableView;
}
- (CGRect)rectForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return [[self proxyRawTableView] rectForRowAtIndexPath:indexPath];
}
- (UITableViewCell*)cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return [[self proxyRawTableView] cellForRowAtIndexPath:indexPath];
}
- (NSIndexPath*)indexPathForCell:(UITableViewCell*)cell
{
    return [[self proxyRawTableView] indexPathForCell:cell];
}
@end

@implementation _IMYAOPCallProxy
- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector
{
    return [self.target methodSignatureForSelector:selector];
}
- (void)forwardInvocation:(NSInvocation*)invocation
{
    if (self.target == nil) {
        return;
    }
    Class invokeClass = self.invokeClass;

    NSString* selectorName = NSStringFromSelector(invocation.selector);
    NSString* superSelectorName = [NSString stringWithFormat:@"IMYSuper_%@_%@", NSStringFromClass(invokeClass), selectorName];
    SEL superSelector = NSSelectorFromString(superSelectorName);

    if ([invokeClass instancesRespondToSelector:superSelector] == NO) {
        Method superMethod = class_getInstanceMethod(invokeClass, invocation.selector);
        if (superMethod == NULL) {
            NSLog(@"class:%@ undefine funcation: %@ ", NSStringFromClass(invokeClass), selectorName);
            return;
        }
        IMP superIMP = method_getImplementation(superMethod);
        class_addMethod(invokeClass, superSelector, superIMP, method_getTypeEncoding(superMethod));
    }

    invocation.selector = superSelector;
    [invocation invokeWithTarget:self.target];
}
- (NSString*)description
{
    return [self.target description];
}
- (NSString*)debugDescription
{
    return [self.target debugDescription];
}
- (Class)superclass
{
    return [self.target superclass];
}
- (Class)class
{
    return [self.target class];
}
+ (id)callSuper:(id)obj
{
    Class clazz = object_getClass(obj);
    NSString* className = NSStringFromClass(clazz);
    if ([className hasPrefix:@"NSKVONotifying_"]) {
        clazz = class_getSuperclass(clazz);
    }
    Class superclass = class_getSuperclass(clazz);
    return [self callWithSuperClass:superclass object:obj];
}
+ (id)callWithSuperClass:(Class)superClass object:(id)obj
{
    if (object_getClass(obj) == superClass || superClass == nil || [obj isKindOfClass:superClass] == NO) {
        return obj;
    }

    _IMYAOPCallProxy* proxy = [_IMYAOPCallProxy alloc];
    proxy.target = obj;
    proxy.invokeClass = superClass;
    return (id)proxy;
}
@end

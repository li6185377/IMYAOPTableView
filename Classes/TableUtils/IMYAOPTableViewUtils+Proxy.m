//
//  IMYAOPTableViewUtils+Proxy.m
//  Pods
//
//  Created by ljh on 16/6/22.
//
//

#import "IMYAOPTableViewUtils+Private.h"
#import "IMYAOPTableViewUtils+Proxy.h"
#import "UITableView+IMYAOPTableView.h"
#import <objc/runtime.h>

@interface _IMYAOPCallProxy : NSProxy

@property (nonatomic, weak) id target;
@property (nonatomic, strong) Class invokeClass;

+ (id)callWithSuperClass:(Class)superClass object:(id)obj;

@end

@implementation IMYAOPTableViewUtils (InsertedProxy)

- (NSArray<UITableViewCell *> *)visibleInsertCells {
    return [self visibleCellsWithType:IMYAOPTypeInsert];
}

- (NSArray<UITableViewCell *> *)visibleCellsWithType:(IMYAOPType)type {
    return [(id)self.tableView aop_containVisibleCells:type];
}

@end

static const void *kIMYAOPProxyRawTableViewKey = &kIMYAOPProxyRawTableViewKey;
@implementation IMYAOPTableViewUtils (TableViewProxy)

- (UITableView *)proxyRawTableView {
    id tableView = objc_getAssociatedObject(self, kIMYAOPProxyRawTableViewKey);
    if (!tableView) {
        tableView = [_IMYAOPCallProxy callWithSuperClass:self.tableViewClass object:self.tableView];
        objc_setAssociatedObject(self, kIMYAOPProxyRawTableViewKey, tableView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return tableView;
}

- (CGRect)rectForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[self proxyRawTableView] rectForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[self proxyRawTableView] cellForRowAtIndexPath:indexPath];
}

- (NSIndexPath *)indexPathForCell:(UITableViewCell *)cell {
    return [[self proxyRawTableView] indexPathForCell:cell];
}

@end

@implementation IMYAOPTableViewUtils (Models)

- (NSArray<IMYAOPTableViewRawModel *> *)allModels {
    NSMutableArray *results = [NSMutableArray array];
    UITableView *tableView = [self proxyRawTableView];
    NSUInteger numberOfSections = [tableView numberOfSections];
    for (NSInteger section = 0; section < numberOfSections; section++) {
        NSUInteger numberOfRows = [tableView numberOfRowsInSection:section];
        for (NSInteger row = 0; row < numberOfRows; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            id model = [self modelForRowAtIndexPath:indexPath];
            IMYAOPTableViewRawModel *rawModel = [IMYAOPTableViewRawModel rawWithModel:model indexPath:indexPath];
            [results addObject:rawModel];
        }
    }
    return results;
}

- (id)modelForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *realIndexPath = [self realIndexPathByTable:indexPath];
    id<UITableViewDataSource, IMYAOPTableViewGetModelProtocol> dataSource = nil;
    if (realIndexPath) {
        dataSource = (id)self.tableDataSource;
        indexPath = realIndexPath;
    } else {
        dataSource = (id)self.dataSource;
    }
    id model = nil;
    if ([dataSource respondsToSelector:@selector(tableView:modelForRowAtIndexPath:)]) {
        model = [dataSource tableView:self.tableView modelForRowAtIndexPath:indexPath];
    }
    return model;
}

@end


@implementation _IMYAOPCallProxy

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    id target = self.target;
    if (target) {
        return [target methodSignatureForSelector:selector];
    }
    return nil;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    id target = self.target;
    if (!target) {
        ///设置返回值为nil
        [invocation setReturnValue:&target];
        return;
    }

    Class invokeClass = self.invokeClass;
    NSString *selectorName = NSStringFromSelector(invocation.selector);
    NSString *superSelectorName = [NSString stringWithFormat:@"IMYSuper_%@_%@", NSStringFromClass(invokeClass), selectorName];
    SEL superSelector = NSSelectorFromString(superSelectorName);

    if ([invokeClass instancesRespondToSelector:superSelector] == NO) {
        Method superMethod = class_getInstanceMethod(invokeClass, invocation.selector);
        if (superMethod == NULL) {
            IMYLog(@"class:%@ undefine funcation: %@ ", NSStringFromClass(invokeClass), selectorName);
            return;
        }
        IMP superIMP = method_getImplementation(superMethod);
        class_addMethod(invokeClass, superSelector, superIMP, method_getTypeEncoding(superMethod));
    }
    invocation.selector = superSelector;
    [invocation invokeWithTarget:target];
}

- (Class)superclass {
    id target = self.target;
    if (target) {
        return [target superclass];
    }
    return NULL;
}

- (Class) class {
    id target = self.target;
    if (target) {
        return [target class];
    }
    return NULL;
}

    - (BOOL)respondsToSelector : (SEL)aSelector {
    id target = self.target;
    if (target) {
        return [target respondsToSelector:aSelector];
    }
    return NO;
}

- (BOOL)isKindOfClass:(Class)aClass {
    id target = self.target;
    if (target) {
        return [target isKindOfClass:aClass];
    }
    return NO;
}

- (BOOL)isMemberOfClass:(Class)aClass {
    id target = self.target;
    if (target) {
        return [target isMemberOfClass:aClass];
    }
    return NO;
}

- (NSString *)description {
    id target = self.target;
    if (target) {
        return [target description];
    }
    return @"";
}

- (NSString *)debugDescription {
    id target = self.target;
    if (target) {
        return [target debugDescription];
    }
    return @"";
}

+ (id)callSuper:(id)obj {
    Class clazz = object_getClass(obj);
    NSString *className = NSStringFromClass(clazz);
    if ([className hasPrefix:@"NSKVONotifying_"]) {
        clazz = class_getSuperclass(clazz);
    }
    Class superclass = class_getSuperclass(clazz);
    return [self callWithSuperClass:superclass object:obj];
}

+ (id)callWithSuperClass:(Class)superClass object:(id)obj {
    if (object_getClass(obj) == superClass || superClass == nil || [obj isKindOfClass:superClass] == NO) {
        return obj;
    }

    _IMYAOPCallProxy *proxy = [_IMYAOPCallProxy alloc];
    proxy.target = obj;
    proxy.invokeClass = superClass;
    return (id)proxy;
}

@end

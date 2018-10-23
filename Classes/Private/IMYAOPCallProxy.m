//
//  IMYAOPCallProxy.m
//  IMYAOPFeedsView
//
//  Created by ljh on 16/5/20.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import "IMYAOPCallProxy.h"
#import "IMYAOPBaseUtils+Private.h"
#import <objc/runtime.h>

@implementation IMYAOPCallProxy

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    id strongObj = self.target;
    if (strongObj) {
        return [strongObj methodSignatureForSelector:sel];
    }
    return [NSMethodSignature signatureWithObjCTypes:"@@:"];
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
    self.aop_utils.isUICalling += 1;
    [invocation invokeWithTarget:target];
    self.aop_utils.isUICalling -= 1;
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

+ (id)callWithSuperClass:(Class)superClass object:(id)obj aopUtils:(IMYAOPBaseUtils *)aopUtils {
    if (object_getClass(obj) == superClass || superClass == nil || [obj isKindOfClass:superClass] == NO) {
        return obj;
    }
    IMYAOPCallProxy *proxy = [IMYAOPCallProxy alloc];
    proxy.target = obj;
    proxy.invokeClass = superClass;
    proxy.aop_utils = aopUtils;
    return (id)proxy;
}

@end

BOOL imyaop_swizzleMethod(Class clazz, SEL origSel_, SEL altSel_) {
    if (!clazz) {
        return NO;
    }
    Method origMethod = class_getInstanceMethod(clazz, origSel_);
    if (!origMethod) {
        return NO;
    }
    Method altMethod = class_getInstanceMethod(clazz, altSel_);
    if (!altMethod) {
        return NO;
    }

    class_addMethod(clazz,
                    origSel_,
                    class_getMethodImplementation(clazz, origSel_),
                    method_getTypeEncoding(origMethod));
    class_addMethod(clazz,
                    altSel_,
                    class_getMethodImplementation(clazz, altSel_),
                    method_getTypeEncoding(altMethod));

    method_exchangeImplementations(class_getInstanceMethod(clazz, origSel_), class_getInstanceMethod(clazz, altSel_));

    return YES;
}

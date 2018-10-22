//
//  IMYAOPCallProxy.h
//  CHTCollectionViewWaterfallLayout
//
//  Created by ljh on 2018/10/22.
//

#import "IMYAOPBaseUtils.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMYAOPCallProxy : NSProxy

@property (nonatomic, weak) id target;
@property (nonatomic, weak) IMYAOPBaseUtils *aop_utils;
@property (nonatomic, strong) Class invokeClass;

+ (id)callWithSuperClass:(Class)superClass object:(id)obj aopUtils:(IMYAOPBaseUtils *)aopUtils;

@end

NS_ASSUME_NONNULL_END

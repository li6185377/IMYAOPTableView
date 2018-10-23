//
//  IMYAOPCallProxy.h
//  IMYAOPFeedsView
//
//  Created by ljh on 16/5/20.
//  Copyright © 2016年 ljh. All rights reserved.
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

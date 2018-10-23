//
//  IMYAOPBaseUtils+Private.h
//  IMYAOPFeedsView
//
//  Created by ljh on 16/5/20.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import "IMYAOPBaseUtils.h"

NS_ASSUME_NONNULL_BEGIN

@protocol IAOPBaseUtilsPrivate <NSObject>

@property (nullable, nonatomic, strong) NSMutableIndexSet *sections;
@property (nullable, nonatomic, strong) NSMutableDictionary *sectionMap;

///orig Feeds View Class
@property (nullable, nonatomic, strong) Class origViewClass;
///是否由UI 进行调用
@property (nonatomic, assign) NSInteger isUICalling;

@end

@interface IMYAOPBaseUtils (Private) <IAOPBaseUtilsPrivate>

- (void)injectFeedsView:(UIView *)feedsView;
- (Class)makeSubclassWithClass:(Class)origClass;
- (void)setupAopClass:(Class)aopClass;
- (Class)msgSendSuperClass;
- (Class)implAopViewClass;
- (void)addOverriteMethod:(SEL)seletor aopClass:(Class)aopClass;
- (void)addOverriteMethod:(SEL)seletor toMethod:(SEL)toSeletor aopClass:(Class)aopClass;

+ (instancetype)newInstance;

@end

NS_ASSUME_NONNULL_END

//
//  IMYAOPCollectionView.h
//  IMYAOPFeedsView
//
//  Created by ljh on 16/5/20.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMYAOPCollectionViewUtils.h"
#import "IMYAOPCollectionViewUtils+Proxy.h"

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (IMYAOPFeedsViewUtils)

///创建并获取：aop_utils
@property (nonatomic, readonly, strong) IMYAOPCollectionViewUtils *aop_utils;

///是否注入了：aop_utils
@property (nonatomic, readonly, assign) BOOL aop_installed;

@end

NS_ASSUME_NONNULL_END

//
//  IMYAOPCollectionViewUtils+Delegate.h
//  IMYAOPFeedsView
//
//  Created by ljh on 16/5/20.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import "IMYAOPCollectionViewUtils.h"

NS_ASSUME_NONNULL_BEGIN

#if _has_chtwaterfall_layout_
@interface IMYAOPCollectionViewUtils (UICollectionViewDelegate) <UICollectionViewDelegateFlowLayout, CHTCollectionViewDelegateWaterfallLayout>
#else
@interface IMYAOPCollectionViewUtils (UICollectionViewDelegate) <UICollectionViewDelegateFlowLayout>
#endif

@end

NS_ASSUME_NONNULL_END

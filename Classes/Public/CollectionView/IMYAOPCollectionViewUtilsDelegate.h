//
//  IMYAOPCollectionViewUtilsDelegate.h
//  Pods
//
//  Created by ljh on 2018/10/22.
//

#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class IMYAOPCollectionViewInsertBody, IMYAOPCollectionViewUtils;

@protocol IMYAOPCollectionViewDelegate <UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout>
@optional
- (void)aopCollectionUtils:(IMYAOPCollectionViewUtils *)collectionUtils willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)aopCollectionUtils:(IMYAOPCollectionViewUtils *)collectionUtils didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol IMYAOPCollectionViewDataSource <UICollectionViewDataSource>
@required
//可以获取真实的 sectionNumber 并在这边进行一些AOP的数据初始化
- (void)aopCollectionUtils:(IMYAOPCollectionViewUtils *)collectionUtils numberOfSections:(NSInteger)sectionNumber;

@end

NS_ASSUME_NONNULL_END

//
//  IMYAOPCollectionViewUtils.m
//  IMYAOPFeedsView
//
//  Created by ljh on 16/5/20.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import "IMYAOPCollectionViewUtils.h"
#import "IMYAOPBaseUtils+Private.h"
#import "UICollectionView+IMYAOPCollectionView.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface IMYAOPCollectionViewUtils ()

@property (nullable, nonatomic, weak) id<UICollectionViewDelegate> origDelegate;
@property (nullable, nonatomic, weak) id<UICollectionViewDataSource> origDataSource;

@property (nullable, nonatomic, weak) UICollectionView *collectionView;

///collectionView Class
@property (nullable, nonatomic, strong) Class collectionViewClass;
///是否由UI 进行调用
@property (nonatomic, assign) NSInteger isUICalling;

+ (instancetype)aopUtilsWithCollectionView:(UICollectionView *)collectionView;
- (void)injectCollectionView;

@end

@implementation IMYAOPCollectionViewUtils

+ (instancetype)aopUtilsWithCollectionView:(UICollectionView *)collectionView {
    IMYAOPCollectionViewUtils *aopUtils = [self newInstance];
    aopUtils.collectionView = collectionView;
    return aopUtils;
}

- (void)setOrigDelegate:(id<UICollectionViewDelegate>)delegate {
    if (_origDelegate != delegate) {
        _origDelegate = delegate;
        id collectionView = self.collectionView;
        [collectionView aop_refreshDelegate];
    }
}

- (void)setOrigDataSource:(id<UICollectionViewDataSource>)dataSource {
    if (_origDataSource != dataSource) {
        _origDataSource = dataSource;
        id collectionView = self.collectionView;
        [collectionView aop_refreshDataSource];
    }
}

- (void)setDelegate:(id<IMYAOPCollectionViewDelegate>)delegate {
    if (_delegate != delegate) {
        _delegate = delegate;
        id collectionView = self.collectionView;
        [collectionView aop_refreshDelegate];
    }
}

- (void)setDataSource:(id<IMYAOPCollectionViewDataSource>)dataSource {
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        id collectionView = self.collectionView;
        [collectionView aop_refreshDataSource];
    }
}

- (void)injectCollectionView {
    UICollectionView *collectionView = self.collectionView;

    _origDataSource = collectionView.dataSource;
    _origDelegate = collectionView.delegate;

    [self injectFeedsView:collectionView];
}

#pragma mark - install aop method

- (Class)implAopViewClass {
    return [UICollectionView imy_aopClass];
}

- (Class)msgSendSuperClass {
    return [UICollectionView class];
}

- (void)setupAopClass:(Class)aopClass {
    ///纯手动敲打
    [self addOverriteMethod:@selector(class) aopClass:aopClass];
    [self addOverriteMethod:@selector(setDelegate:) aopClass:aopClass];
    [self addOverriteMethod:@selector(delegate) aopClass:aopClass];
    [self addOverriteMethod:@selector(setDataSource:) aopClass:aopClass];
    [self addOverriteMethod:@selector(dataSource) aopClass:aopClass];

    ///UI Calling
    [self addOverriteMethod:@selector(reloadData) aopClass:aopClass];
    [self addOverriteMethod:@selector(layoutSubviews) aopClass:aopClass];
    [self addOverriteMethod:@selector(setBounds:) aopClass:aopClass];
    [self addOverriteMethod:@selector(bringSubviewToFront:) aopClass:aopClass];
    [self addOverriteMethod:@selector(sendSubviewToBack:) aopClass:aopClass];
    [self addOverriteMethod:@selector(willMoveToSuperview:) aopClass:aopClass];
    [self addOverriteMethod:@selector(willMoveToWindow:) aopClass:aopClass];
    [self addOverriteMethod:@selector(didMoveToWindow) aopClass:aopClass];
    [self addOverriteMethod:@selector(didMoveToSuperview) aopClass:aopClass];
    [self addOverriteMethod:@selector(touchesBegan:withEvent:) aopClass:aopClass];
    [self addOverriteMethod:@selector(touchesMoved:withEvent:) aopClass:aopClass];
    [self addOverriteMethod:@selector(touchesEnded:withEvent:) aopClass:aopClass];
    [self addOverriteMethod:@selector(touchesCancelled:withEvent:) aopClass:aopClass];
    [self addOverriteMethod:@selector(touchesEstimatedPropertiesUpdated:) aopClass:aopClass];
    [self addOverriteMethod:@selector(touchesShouldBegin:withEvent:inContentView:) aopClass:aopClass];
    [self addOverriteMethod:@selector(touchesShouldCancelInContentView:) aopClass:aopClass];
    [self addOverriteMethod:@selector(gestureRecognizerShouldBegin:) aopClass:aopClass];

    ///add real reload function
    [self addOverriteMethod:@selector(aop_refreshDataSource) aopClass:aopClass];
    [self addOverriteMethod:@selector(aop_refreshDelegate) aopClass:aopClass];
    [self addOverriteMethod:@selector(aop_containVisibleCells:) aopClass:aopClass];
    [self addOverriteMethod:@selector(aop_containVisibleSupplementaryViews:ofKind:) aopClass:aopClass];

    // Info
    [self addOverriteMethod:@selector(dequeueReusableCellWithReuseIdentifier:forIndexPath:) aopClass:aopClass];
    [self addOverriteMethod:@selector(dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:) aopClass:aopClass];
    [self addOverriteMethod:@selector(indexPathsForSelectedItems) aopClass:aopClass];
    [self addOverriteMethod:@selector(indexPathsForVisibleItems) aopClass:aopClass];
    [self addOverriteMethod:@selector(selectItemAtIndexPath:animated:scrollPosition:) aopClass:aopClass];
    [self addOverriteMethod:@selector(deselectItemAtIndexPath:animated:) aopClass:aopClass];
    [self addOverriteMethod:@selector(setCollectionViewLayout:animated:) aopClass:aopClass];
    [self addOverriteMethod:@selector(setCollectionViewLayout:animated:completion:) aopClass:aopClass];
    [self addOverriteMethod:@selector(startInteractiveTransitionToCollectionViewLayout:completion:) aopClass:aopClass];
    [self addOverriteMethod:@selector(finishInteractiveTransition) aopClass:aopClass];
    [self addOverriteMethod:@selector(cancelInteractiveTransition) aopClass:aopClass];
    [self addOverriteMethod:@selector(numberOfSections) aopClass:aopClass];
    [self addOverriteMethod:@selector(numberOfItemsInSection:) aopClass:aopClass];
    [self addOverriteMethod:@selector(layoutAttributesForItemAtIndexPath:) aopClass:aopClass];
    [self addOverriteMethod:@selector(layoutAttributesForSupplementaryElementOfKind:atIndexPath:) aopClass:aopClass];
    [self addOverriteMethod:@selector(indexPathForItemAtPoint:) aopClass:aopClass];
    [self addOverriteMethod:@selector(indexPathForCell:) aopClass:aopClass];
    [self addOverriteMethod:@selector(cellForItemAtIndexPath:) aopClass:aopClass];
    [self addOverriteMethod:@selector(visibleCells) aopClass:aopClass];
    [self addOverriteMethod:@selector(supplementaryViewForElementKind:atIndexPath:) aopClass:aopClass];
    [self addOverriteMethod:@selector(visibleSupplementaryViewsOfKind:) aopClass:aopClass];
    [self addOverriteMethod:@selector(indexPathsForVisibleSupplementaryElementsOfKind:) aopClass:aopClass];
    [self addOverriteMethod:@selector(scrollToItemAtIndexPath:atScrollPosition:animated:) aopClass:aopClass];
    [self addOverriteMethod:@selector(insertSections:) aopClass:aopClass];
    [self addOverriteMethod:@selector(deleteSections:) aopClass:aopClass];
    [self addOverriteMethod:@selector(reloadSections:) aopClass:aopClass];
    [self addOverriteMethod:@selector(moveSection:toSection:) aopClass:aopClass];
    [self addOverriteMethod:@selector(insertItemsAtIndexPaths:) aopClass:aopClass];
    [self addOverriteMethod:@selector(deleteItemsAtIndexPaths:) aopClass:aopClass];
    [self addOverriteMethod:@selector(reloadItemsAtIndexPaths:) aopClass:aopClass];
    [self addOverriteMethod:@selector(moveItemAtIndexPath:toIndexPath:) aopClass:aopClass];
    [self addOverriteMethod:@selector(performBatchUpdates:completion:) aopClass:aopClass];
    [self addOverriteMethod:@selector(beginInteractiveMovementForItemAtIndexPath:) aopClass:aopClass];
    [self addOverriteMethod:@selector(updateInteractiveMovementTargetPosition:) aopClass:aopClass];
    [self addOverriteMethod:@selector(endInteractiveMovement) aopClass:aopClass];
    [self addOverriteMethod:@selector(cancelInteractiveMovement) aopClass:aopClass];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    BOOL responds = NO;
    responds = ([self.origDelegate respondsToSelector:aSelector] || [self.origDataSource respondsToSelector:aSelector]);
    if (!responds) {
        responds = ([self.delegate respondsToSelector:aSelector] || [self.dataSource respondsToSelector:aSelector]);
    }
    if (!responds) {
        responds = (aSelector == @selector(collectionView:willDisplayCell:forItemAtIndexPath:) ||
                    aSelector == @selector(collectionView:didEndDisplayingCell:forItemAtIndexPath:));
    }
    return responds;
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    BOOL conforms = NO;
    conforms = ([self.origDelegate conformsToProtocol:aProtocol] || [self.origDataSource conformsToProtocol:aProtocol]);
    if (!conforms) {
        conforms = ([self.delegate conformsToProtocol:aProtocol] || [self.delegate conformsToProtocol:aProtocol]);
    }
    return conforms;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if ([self.origDelegate respondsToSelector:aSelector]) {
        return [(id)self.origDelegate methodSignatureForSelector:aSelector];
    } else if ([self.origDataSource respondsToSelector:aSelector]) {
        return [(id)self.origDataSource methodSignatureForSelector:aSelector];
    } else if ([self.delegate respondsToSelector:aSelector]) {
        return [(id)self.delegate methodSignatureForSelector:aSelector];
    } else if ([self.dataSource respondsToSelector:aSelector]) {
        return [(id)self.dataSource methodSignatureForSelector:aSelector];
    }
    return [super methodSignatureForSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return nil;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    if ([self.origDelegate respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:self.origDelegate];
    } else if ([self.origDataSource respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:self.origDataSource];
    }
    
    if ([self.delegate respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:self.delegate];
    } else if ([self.dataSource respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:self.dataSource];
    }
    
    if ([super respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:self];
    }
}

- (void)dealloc {
    IMYLog(@"dealloc aop collection utils");
}

@end


static const void *kIMYAOPCollectionUtilsKey = &kIMYAOPCollectionUtilsKey;
@implementation UICollectionView (AOPTableViewUtils)

- (IMYAOPCollectionViewUtils *)aop_utils {
    IMYAOPCollectionViewUtils *aopUtils = objc_getAssociatedObject(self, kIMYAOPCollectionUtilsKey);
    if (!aopUtils) {
        @synchronized(self) {
            aopUtils = objc_getAssociatedObject(self, kIMYAOPCollectionUtilsKey);
            if (!aopUtils) {
                ///获取aop utils
                aopUtils = [IMYAOPCollectionViewUtils aopUtilsWithCollectionView:self];
                objc_setAssociatedObject(self, kIMYAOPCollectionUtilsKey, aopUtils, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [aopUtils injectCollectionView];
            }
        }
    }
    return aopUtils;
}

- (BOOL)aop_installed {
    IMYAOPCollectionViewUtils *aopUtils = objc_getAssociatedObject(self, kIMYAOPCollectionUtilsKey);
    if (aopUtils) {
        return YES;
    }
    return NO;
}

@end

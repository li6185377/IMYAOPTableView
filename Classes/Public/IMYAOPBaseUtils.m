//
//  IMYAOPBaseUtils.m
//  IMYAOPFeedsView
//
//  Created by ljh on 2018/10/19.
//

#import "IMYAOPBaseUtils.h"
#import <objc/message.h>
#import <objc/runtime.h>

static NSString *const kAOPFeedsViewPrefix = @"kIMYAOP_";

@interface IMYAOPBaseUtils ()

@property (nullable, nonatomic, strong) NSMutableIndexSet *sections;
@property (nullable, nonatomic, strong) NSMutableDictionary *sectionMap;

///orig Feeds View Class
@property (nullable, nonatomic, strong) Class origViewClass;
///是否由UI 进行调用
@property (nonatomic, assign) NSInteger isUICalling;

@end

@implementation IMYAOPBaseUtils

+ (instancetype)newInstance {
    return [super new];
}

- (void)insertWithSections:(NSArray<IMYAOPBaseInsertBody *> *)insertSections {
    NSArray<IMYAOPBaseInsertBody *> *array = [insertSections sortedArrayUsingComparator:^NSComparisonResult(IMYAOPBaseInsertBody *_Nonnull obj1, IMYAOPBaseInsertBody *_Nonnull obj2) {
        if (obj1.section > obj2.section) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];

    NSMutableIndexSet *insertArray = [NSMutableIndexSet indexSet];
    [array enumerateObjectsUsingBlock:^(IMYAOPBaseInsertBody *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSInteger section = obj.section;
        while (YES) {
            BOOL hasEqual = NO;
            if ([insertArray containsIndex:section]) {
                section++;
                hasEqual = YES;
                break;
            }
            if (hasEqual == NO) {
                break;
            }
        }
        [insertArray addIndex:section];
        obj.resultSection = section;
    }];
    self.sections = insertArray;
}

- (void)insertWithIndexPaths:(NSArray<IMYAOPBaseInsertBody *> *)indexPaths {
    NSArray<IMYAOPBaseInsertBody *> *array = [indexPaths sortedArrayUsingComparator:^NSComparisonResult(IMYAOPBaseInsertBody *_Nonnull obj1, IMYAOPBaseInsertBody *_Nonnull obj2) {
        return [obj1.indexPath compare:obj2.indexPath];
    }];

    NSMutableDictionary *insertMap = [NSMutableDictionary dictionary];
    [array enumerateObjectsUsingBlock:^(IMYAOPBaseInsertBody *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSInteger section = obj.indexPath.section;
        NSInteger row = obj.indexPath.row;
        NSMutableArray *rowArray = insertMap[@(section)];
        if (!rowArray) {
            rowArray = [NSMutableArray array];
            [insertMap setObject:rowArray forKey:@(section)];
        }
        while (YES) {
            BOOL hasEqual = NO;
            for (NSIndexPath *inserted in rowArray) {
                if (inserted.row == row) {
                    row++;
                    hasEqual = YES;
                    break;
                }
            }
            if (hasEqual == NO) {
                break;
            }
        }
        NSIndexPath *insertPath = [NSIndexPath indexPathForRow:row inSection:section];
        [rowArray addObject:insertPath];
        obj.resultIndexPath = insertPath;
    }];
    self.sectionMap = insertMap;
}

#pragma mark - 注入 aop class

- (void)injectFeedsView:(UIView *)feedsView {
    struct objc_super objcSuper = {.super_class = [self aop_sendSuperClass], .receiver = feedsView};
    ((void (*)(void *, SEL, id))(void *)objc_msgSendSuper)(&objcSuper, @selector(setDelegate:), self);
    ((void (*)(void *, SEL, id))(void *)objc_msgSendSuper)(&objcSuper, @selector(setDataSource:), self);

    self.origViewClass = [feedsView class];
    Class aopClass = [self makeSubclassWithClass:self.origViewClass];
    if (![self.origViewClass isSubclassOfClass:aopClass]) {
        [self bindingFeedsView:feedsView aopClass:aopClass];
    }
}

- (void)bindingFeedsView:(UIView *)feedsView aopClass:(Class)aopClass {
    id observationInfo = [feedsView observationInfo];
    NSArray *observanceArray = [observationInfo valueForKey:@"_observances"];
    ///移除旧的KVO
    for (id observance in observanceArray) {
        NSString *keyPath = [observance valueForKeyPath:@"_property._keyPath"];
        id observer = [observance valueForKey:@"_observer"];
        if (keyPath && observer) {
            [feedsView removeObserver:observer forKeyPath:keyPath];
        }
    }
    object_setClass(feedsView, aopClass);
    ///添加新的KVO
    for (id observance in observanceArray) {
        NSString *keyPath = [observance valueForKeyPath:@"_property._keyPath"];
        id observer = [observance valueForKey:@"_observer"];
        if (observer && keyPath) {
            void *context = NULL;
            NSUInteger options = 0;
            @try {
                Ivar _civar = class_getInstanceVariable([observance class], "_context");
                if (_civar) {
                    context = ((void *(*)(id, Ivar))(void *)object_getIvar)(observance, _civar);
                }
                Ivar _oivar = class_getInstanceVariable([observance class], "_options");
                if (_oivar) {
                    options = ((NSUInteger(*)(id, Ivar))(void *)object_getIvar)(observance, _oivar);
                }
                /// 不知道为什么，iOS11 返回的值 会填充8个字节。。 128
                if (options >= 128) {
                    options -= 128;
                }
            } @catch (NSException *exception) {
                IMYLog(@"%@", exception.debugDescription);
            }
            if (options == 0) {
                options = (NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew);
            }
            [feedsView addObserver:observer forKeyPath:keyPath options:options context:context];
        }
    }
}

#pragma mark - install aop method
- (Class)makeSubclassWithClass:(Class)origClass {
    NSString *className = NSStringFromClass(origClass);
    NSString *aopClassName = [kAOPFeedsViewPrefix stringByAppendingString:className];
    Class aopClass = NSClassFromString(aopClassName);

    if (aopClass) {
        return aopClass;
    }
    aopClass = objc_allocateClassPair(origClass, aopClassName.UTF8String, 0);

    [self setupAopClass:aopClass];

    objc_registerClassPair(aopClass);
    return aopClass;
}

- (void)setupAopClass:(Class)aopClass {
    NSAssert(NO, @"必须子类实现!");
}

- (Class)aop_sendSuperClass {
    NSAssert(NO, @"必须子类实现!");
    return [UIView class];
}

- (Class)aop_implViewClass {
    NSAssert(NO, @"必须子类实现!");
    return [UIView class];
}

- (void)addOverriteMethod:(SEL)seletor aopClass:(Class)aopClass {
    NSString *seletorString = NSStringFromSelector(seletor);
    NSString *aopSeletorString = [NSString stringWithFormat:@"aop_%@", seletorString];
    SEL aopMethod = NSSelectorFromString(aopSeletorString);
    [self addOverriteMethod:seletor toMethod:aopMethod aopClass:aopClass];
}

- (void)addOverriteMethod:(SEL)seletor toMethod:(SEL)toSeletor aopClass:(Class)aopClass {
    Class implClass = [self aop_implViewClass];
    Method method = class_getInstanceMethod(implClass, toSeletor);
    if (method == NULL) {
        method = class_getInstanceMethod(implClass, seletor);
    }
    const char *types = method_getTypeEncoding(method);
    IMP imp = method_getImplementation(method);
    class_addMethod(aopClass, seletor, imp, types);
}

@end

@implementation IMYAOPBaseUtils (IndexPath)

- (NSIndexPath *)realIndexPathByTable:(NSIndexPath *)tableIndexPath {
    if (!tableIndexPath) {
        return nil;
    }
    NSInteger section = tableIndexPath.section;
    NSInteger row = tableIndexPath.row;

    NSMutableArray<NSIndexPath *> *array = self.sectionMap[@(section)];
    NSInteger cutCount = 0;
    for (NSIndexPath *obj in array) {
        if (obj.row == row) {
            cutCount = -1;
            break;
        }
        if (obj.row < row) {
            cutCount++;
        } else {
            break;
        }
    }
    if (cutCount < 0) {
        return nil;
    }
    ///如果该位置不是广告， 则转为逻辑index
    section = [self realSectionByTable:section];
    NSIndexPath *realIndexPath = [NSIndexPath indexPathForRow:row - cutCount inSection:section];
    return realIndexPath;
}

- (NSIndexPath *)tableIndexPathByReal:(NSIndexPath *)realIndexPath {
    if (realIndexPath == nil) {
        return nil;
    }
    NSInteger section = realIndexPath.section;
    NSInteger row = realIndexPath.row;

    ///转为table section
    section = [self tableSectionByReal:section];

    NSMutableArray<NSIndexPath *> *array = self.sectionMap[@(section)];
    for (NSIndexPath *obj in array) {
        if (obj.row <= row) {
            row += 1;
        } else {
            break;
        }
    }
    NSIndexPath *tableIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    return tableIndexPath;
}

- (NSArray<NSIndexPath *> *)realIndexPathsByTableIndexPaths:(NSArray<NSIndexPath *> *)tableIndexPaths {
    NSMutableArray *toArray = [NSMutableArray array];
    [tableIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSIndexPath *realIndexPath = [self realIndexPathByTable:obj];
        if (realIndexPath) {
            [toArray addObject:realIndexPath];
        }
    }];
    return toArray;
}

- (NSArray<NSIndexPath *> *)tableIndexPathsByRealIndexPaths:(NSArray<NSIndexPath *> *)realIndexPaths {
    NSMutableArray *toArray = [NSMutableArray array];
    [realIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSIndexPath *tableIndexPath = [self tableIndexPathByReal:obj];
        if (tableIndexPath) {
            [toArray addObject:tableIndexPath];
        }
    }];
    return toArray;
}

- (NSInteger)tableSectionByReal:(NSInteger)realSection {
    __block NSInteger section = realSection;
    [self.sections enumerateIndexesUsingBlock:^(NSUInteger insertSection, BOOL *_Nonnull stop) {
        if (insertSection <= section) {
            section += 1;
        } else {
            *stop = YES;
        }
    }];
    return section;
}

- (NSInteger)realSectionByTable:(NSInteger)tableSection {
    __block NSInteger cutCount = 0;
    [self.sections enumerateIndexesUsingBlock:^(NSUInteger insertSection, BOOL *_Nonnull stop) {
        if (insertSection == tableSection) {
            cutCount = -1;
            *stop = YES;
        }
        if (insertSection < tableSection) {
            cutCount += 1;
        }
    }];
    if (cutCount >= 0) {
        NSInteger realCount = tableSection - cutCount;
        return realCount;
    }
    return -1;
}

- (NSIndexSet *)tableSectionsByRealSet:(NSIndexSet *)realSet {
    NSMutableIndexSet *sections = [NSMutableIndexSet indexSet];
    [realSet enumerateIndexesUsingBlock:^(NSUInteger realIndex, BOOL *_Nonnull stop) {
        NSInteger section = [self tableSectionByReal:realIndex];
        if (section >= 0) {
            [sections addIndex:section];
        }
    }];
    return sections;
}

- (NSIndexSet *)realSectionsByTableSet:(NSIndexSet *)tableSet {
    NSMutableIndexSet *sections = [NSMutableIndexSet indexSet];
    [tableSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *_Nonnull stop) {
        NSInteger section = [self realSectionByTable:idx];
        if (section >= 0) {
            [sections addIndex:section];
        }
    }];
    return sections;
}

@end

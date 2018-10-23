//
//  IMYAOPBaseInsertBody.h
//  IMYAOPFeedsView
//
//  Created by ljh on 16/5/20.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMYAOPBaseInsertBody : NSObject

+ (instancetype)insertBodyWithSection:(NSInteger)section;
+ (instancetype)insertBodyWithIndexPath:(NSIndexPath *)indexPath;

///预期插入的 section 位置
@property (nonatomic, assign) NSInteger section;
///预期插入的 IndexPath 位置
@property (nullable, nonatomic, copy) NSIndexPath *indexPath;

///最终插入后的section
@property (nonatomic, assign) NSInteger resultSection;
///最终插入后的IndexPath
@property (nullable, nonatomic, copy) NSIndexPath *resultIndexPath;

@end


@interface IMYAOPBaseRawModel : NSObject

+ (instancetype)rawWithModel:(id)model indexPath:(NSIndexPath *)indexPath;

@property (nonatomic, readonly) NSIndexPath *indexPath;
@property (nonatomic, readonly) id model;

@end

NS_ASSUME_NONNULL_END

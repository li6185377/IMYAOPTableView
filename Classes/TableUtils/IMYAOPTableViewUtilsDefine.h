//
//  IMYAOPTableViewUtilsDefine.h
//  IMYAdvertisementDemo
//
//  Created by ljh on 16/5/20.
//  Copyright © 2016年 IMY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IMYAOPTableViewInsertBody, IMYAOPTableViewUtils;
@protocol IMYAOPTableViewDelegate <UITableViewDelegate>

@required
- (void)aopTableUtils:(IMYAOPTableViewUtils*)tableUtils willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath;

@optional
///实现了这个方法 将不会再走原有的 获取 height 的方法  帖子列表置顶广告使用
- (CGFloat)aopTableUtils:(IMYAOPTableViewUtils*)tableUtils heightForHeaderInSection:(NSInteger)section;

@end

@protocol IMYAOPTableViewDataSource <UITableViewDataSource>

@required
- (void)aopTableUtils:(IMYAOPTableViewUtils*)tableUtils numberOfSection:(NSInteger)sectionNumber;

@end

///禁止独立初始化
@protocol IMY_UNAVAILABLE_ATTRIBUTE_ALLOC
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype) new UNAVAILABLE_ATTRIBUTE;
+ (instancetype)alloc UNAVAILABLE_ATTRIBUTE;
@end

///数据类型
typedef NS_ENUM(NSUInteger, IMYAOPType) {
    ///原始数据
    IMYAOPTypeRaw,
    ///插入数据
    IMYAOPTypeInsert,
    ///全部数据
    IMYAOPTypeAll,
};
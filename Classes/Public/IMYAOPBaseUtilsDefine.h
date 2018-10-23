//
//  IMYAOPBaseUtilsDefine.h
//  IMYAOPFeedsView
//
//  Created by ljh on 16/5/20.
//  Copyright © 2016年 ljh. All rights reserved.
//

#ifndef IMYAOPBaseUtilsDefine_h
#define IMYAOPBaseUtilsDefine_h

#import <UIKit/UIKit.h>

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

#ifndef IMYLog

#ifdef DEBUG
#define IMYLog(s, ...) NSLog(@"<%@:(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#else
#define IMYLog(...)
#endif

#endif

#endif /* IMYAOPBaseUtilsDefine_h */

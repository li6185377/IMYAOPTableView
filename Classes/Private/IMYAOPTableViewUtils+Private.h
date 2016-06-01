//
//  IMYAOPTableViewUtils+Private.h
//  IMYAdvertisementDemo
//
//  Created by ljh on 16/4/16.
//  Copyright © 2016年 IMY. All rights reserved.
//

#import "IMYAOPTableViewUtils.h"

@protocol IADTableViewUtilsPrivate

@property (nonatomic, weak) id<UITableViewDelegate> tableDelegate;
@property (nonatomic, weak) id<UITableViewDataSource> tableDataSource;

@property (nonatomic, strong) NSMutableArray<NSNumber*>* sections;
@property (nonatomic, strong) NSMutableDictionary* sectionMap;

@property (nonatomic) Class tableViewClass;

///是否由UI 进行调用
@property (nonatomic, assign) NSInteger isUICalling;

@end

@interface IMYAOPTableViewUtils (Private) <IADTableViewUtilsPrivate>

@end

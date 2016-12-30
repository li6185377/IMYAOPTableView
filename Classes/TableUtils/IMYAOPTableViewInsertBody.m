//
//  IMYAOPTableViewInsertBody.m
//  AOPTableView
//
//  Created by ljh on 16/5/31.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import "IMYAOPTableViewInsertBody.h"

@implementation IMYAOPTableViewInsertBody

+ (instancetype)insertBodyWithSection:(NSInteger)section
{
    IMYAOPTableViewInsertBody *body = [[self alloc] init];
    body.section = section;
    return body;
}

+ (instancetype)insertBodyWithIndexPath:(NSIndexPath *)indexPath
{
    IMYAOPTableViewInsertBody *body = [[self alloc] init];
    body.indexPath = indexPath;
    return body;
}

@end

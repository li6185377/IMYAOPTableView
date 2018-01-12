//
//  IMYAOPTableViewInsertBody.m
//  AOPTableView
//
//  Created by ljh on 16/5/31.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import "IMYAOPTableViewInsertBody.h"

@implementation IMYAOPTableViewInsertBody

+ (instancetype)insertBodyWithSection:(NSInteger)section {
    IMYAOPTableViewInsertBody *body = [[self alloc] init];
    body.section = section;
    return body;
}

+ (instancetype)insertBodyWithIndexPath:(NSIndexPath *)indexPath {
    IMYAOPTableViewInsertBody *body = [[self alloc] init];
    body.indexPath = indexPath;
    return body;
}

@end

@implementation IMYAOPTableViewRawModel
@synthesize model = _model;
@synthesize indexPath = _indexPath;

- (instancetype)initWithModel:(id)model indexPath:(NSIndexPath *)indexPath {
    self = [super init];
    if (self) {
        _model = model;
        _indexPath = indexPath;
    }
    return self;
}

+ (instancetype)rawWithModel:(id)model indexPath:(NSIndexPath *)indexPath {
    return [[self alloc] initWithModel:model indexPath:indexPath];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"indexPath:(%ld, %ld)  model:(%@)", _indexPath.section, _indexPath.row, _model];
}

@end

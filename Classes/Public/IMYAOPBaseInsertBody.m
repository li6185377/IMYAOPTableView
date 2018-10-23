//
//  IMYAOPBaseInsertBody.m
//  IMYAOPFeedsView
//
//  Created by ljh on 16/5/20.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import "IMYAOPBaseInsertBody.h"

@implementation IMYAOPBaseInsertBody

+ (instancetype)insertBodyWithSection:(NSInteger)section {
    IMYAOPBaseInsertBody *body = [[self alloc] init];
    body.section = section;
    return body;
}

+ (instancetype)insertBodyWithIndexPath:(NSIndexPath *)indexPath {
    IMYAOPBaseInsertBody *body = [[self alloc] init];
    body.indexPath = indexPath;
    return body;
}

@end

@implementation IMYAOPBaseRawModel
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

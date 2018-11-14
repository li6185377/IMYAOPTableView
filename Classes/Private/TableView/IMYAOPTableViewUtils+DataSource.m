//
//  IMYAOPTableViewUtils+DataSource.m
//  IMYAOPFeedsView
//
//  Created by ljh on 16/5/20.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import "IMYAOPTableViewUtils+DataSource.h"
#import "IMYAOPTableViewUtils+Private.h"

#define kAOPUserIndexPathCode                                           \
    NSIndexPath *userIndexPath = [self userIndexPathByFeeds:indexPath]; \
    id<IMYAOPTableViewDataSource> dataSource = nil;                     \
    if (userIndexPath) {                                                \
        dataSource = (id)self.origDataSource;                           \
        indexPath = userIndexPath;                                      \
    } else {                                                            \
        dataSource = self.dataSource;                                   \
        isInjectAction = YES;                                           \
    }                                                                   \
    if (isInjectAction) {                                               \
        self.isUICalling += 1;                                          \
    }

#define kAOPUserSectionCode                                    \
    NSInteger userSection = [self userSectionByFeeds:section]; \
    id<IMYAOPTableViewDataSource> dataSource = nil;            \
    if (userSection >= 0) {                                    \
        dataSource = (id)self.origDataSource;                  \
        section = userSection;                                 \
    } else {                                                   \
        dataSource = self.dataSource;                          \
        isInjectAction = YES;                                  \
    }                                                          \
    if (isInjectAction) {                                      \
        self.isUICalling += 1;                                 \
    }

#define kAOPUICallingSaved          \
    BOOL isInjectAction = NO;       \
    self.isUICalling -= 1;

#define kAOPUICallingResotre        \
    if (isInjectAction) {           \
        self.isUICalling -= 1;      \
    }                               \
    self.isUICalling += 1;

@implementation IMYAOPTableViewUtils (UITableViewDataSource)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    kAOPUICallingSaved;
    NSInteger numberOfSection = 1;
    if ([self.origDataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        numberOfSection = [self.origDataSource numberOfSectionsInTableView:tableView];
    }
    ///初始化回调
    [self.dataSource aopTableUtils:self numberOfSection:numberOfSection];

    ///总number section
    if (numberOfSection > 0) {
        numberOfSection = [self feedsSectionByUser:numberOfSection];
    }
    kAOPUICallingResotre;
    return numberOfSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    kAOPUICallingSaved;
    NSInteger userSection = [self userSectionByFeeds:section];
    NSInteger rowCount = 0;
    if (userSection >= 0) {
        section = userSection;
        rowCount = [self.origDataSource tableView:tableView numberOfRowsInSection:section];

        NSIndexPath *feedsIndexPath = [self feedsIndexPathByUser:[NSIndexPath indexPathForRow:rowCount inSection:section]];
        rowCount = feedsIndexPath.row;
    } else {
        NSMutableArray<NSIndexPath *> *array = self.sectionMap[@(section)];
        for (NSIndexPath *obj in array) {
            if (obj.row <= rowCount) {
                rowCount += 1;
            } else {
                break;
            }
        }
    }
    kAOPUICallingResotre;
    return rowCount;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    kAOPUICallingSaved;
    kAOPUserIndexPathCode;
    UITableViewCell *cell = nil;
    if ([dataSource respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
        cell = [dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    if (![cell isKindOfClass:[UITableViewCell class]]) {
        cell = [UITableViewCell new];
        if (dataSource) {
            NSAssert(NO, @"Cell is Nil");
        }
    }
    kAOPUICallingResotre;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    kAOPUICallingSaved;
    kAOPUserSectionCode;
    NSString *title = nil;
    if ([dataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
        title = [dataSource tableView:tableView titleForHeaderInSection:section];
    }
    kAOPUICallingResotre;
    return title;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    kAOPUICallingSaved;
    kAOPUserSectionCode;
    NSString *title = nil;
    if ([dataSource respondsToSelector:@selector(tableView:titleForFooterInSection:)]) {
        title = [dataSource tableView:tableView titleForFooterInSection:section];
    }
    kAOPUICallingResotre;
    return title;
}

// Editing

// Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    kAOPUICallingSaved;
    kAOPUserIndexPathCode;
    BOOL canEditing = NO;
    if ([dataSource respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)]) {
        canEditing = [dataSource tableView:tableView canEditRowAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
    return canEditing;
}

// Moving/reordering

// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    kAOPUICallingSaved;
    kAOPUserIndexPathCode;
    BOOL canMove = NO;
    if ([dataSource respondsToSelector:@selector(tableView:canMoveRowAtIndexPath:)]) {
        canMove = [dataSource tableView:tableView canMoveRowAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
    return canMove;
}

// Index

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView __TVOS_PROHIBITED // return list of section titles to display in section index view (e.g. "ABCD...Z#")
{
    // 只回调给业务方，不管注入方
    kAOPUICallingSaved;
    NSArray<NSString *> *userArray = @[];
    if ([self.origDataSource respondsToSelector:@selector(sectionIndexTitlesForTableView:)]) {
        userArray = [self.origDataSource sectionIndexTitlesForTableView:tableView];
    }
    kAOPUICallingResotre;
    return userArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index __TVOS_PROHIBITED // tell table which section corresponds to section title/index (e.g. "B",1))
{
    // 只回调给业务方，不管注入方
    kAOPUICallingSaved;
    NSInteger atIndex = index;
    if ([self.origDataSource respondsToSelector:@selector(tableView:sectionForSectionIndexTitle:atIndex:)]) {
        atIndex = [self.origDataSource tableView:tableView sectionForSectionIndexTitle:title atIndex:index];
    }
    kAOPUICallingResotre;
    return atIndex;
}

// Data manipulation - insert and delete support

// After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
// Not called for edit actions using UITableViewRowAction - the action's handler will be invoked instead
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    kAOPUICallingSaved;
    kAOPUserIndexPathCode;
    if ([dataSource respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) {
        [dataSource tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
}

// Data manipulation - reorder / moving support

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    kAOPUICallingSaved;
    NSIndexPath *source = [self userIndexPathByFeeds:sourceIndexPath];
    NSIndexPath *destin = [self userIndexPathByFeeds:destinationIndexPath];
    if ([self.origDataSource respondsToSelector:@selector(tableView:moveRowAtIndexPath:toIndexPath:)]) {
        [self.origDataSource tableView:tableView moveRowAtIndexPath:source toIndexPath:destin];
    }
    kAOPUICallingResotre;
}

@end

//
//  IMYAOPTableViewUtils+UITableViewDataSource.m
//  IMYAdvertisementDemo
//
//  Created by ljh on 16/4/15.
//  Copyright © 2016年 IMY. All rights reserved.
//

#import "IMYAOPTableViewUtils+DataSource.h"
#import "IMYAOPTableViewUtils+Private.h"

#define kAOPRealIndexPathCode                                           \
    NSIndexPath* realIndexPath = [self realIndexPathByTable:indexPath]; \
    id<UITableViewDataSource> dataSource = nil;                         \
    if (realIndexPath) {                                                \
        dataSource = self.tableDataSource;                              \
        indexPath = realIndexPath;                                      \
    }                                                                   \
    else {                                                              \
        dataSource = self.dataSource;                                   \
    }

#define kAOPRealSectionCode                                    \
    NSInteger realSection = [self realSectionByTable:section]; \
    id<UITableViewDataSource> dataSource = nil;                \
    if (realSection >= 0) {                                    \
        dataSource = self.tableDataSource;                     \
        section = realSection;                                 \
    }                                                          \
    else {                                                     \
        dataSource = self.dataSource;                          \
    }

#define kAOPUICallingSaved \
    self.isUICalling -= 1;

#define kAOPUICallingResotre \
    self.isUICalling += 1;

@implementation IMYAOPTableViewUtils (UITableViewDataSource)
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    kAOPUICallingSaved;
    NSInteger numberOfSection = 1;
    if ([self.tableDataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        numberOfSection = [self.tableDataSource numberOfSectionsInTableView:tableView];
    }
    ///初始化回调
    [self.dataSource aopTableUtils:self numberOfSection:numberOfSection];

    ///总number section
    if (numberOfSection > 0) {
        numberOfSection = [self tableSectionByReal:numberOfSection];
    }
    kAOPUICallingResotre;
    return numberOfSection;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    kAOPUICallingSaved;
    NSInteger realSection = [self realSectionByTable:section];
    NSInteger rowCount = 0;
    if (realSection >= 0) {
        section = realSection;
        rowCount = [self.tableDataSource tableView:tableView numberOfRowsInSection:section];

        NSIndexPath* tableIndexPath = [self tableIndexPathByReal:[NSIndexPath indexPathForRow:rowCount inSection:section]];
        rowCount = tableIndexPath.row;
    }
    else {
        NSMutableArray<NSIndexPath*>* array = self.sectionMap[@(section)];
        for (NSIndexPath* obj in array) {
            if (obj.row <= rowCount) {
                rowCount += 1;
            }
            else {
                break;
            }
        }
    }
    kAOPUICallingResotre;
    return rowCount;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    UITableViewCell* cell = nil;
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
- (nullable NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    kAOPUICallingSaved;
    kAOPRealSectionCode;
    NSString* title = nil;
    if ([dataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
        title = [dataSource tableView:tableView titleForHeaderInSection:section];
    }
    kAOPUICallingResotre;
    return title;
}
- (nullable NSString*)tableView:(UITableView*)tableView titleForFooterInSection:(NSInteger)section
{
    kAOPUICallingSaved;
    kAOPRealSectionCode;
    NSString* title = nil;
    if ([dataSource respondsToSelector:@selector(tableView:titleForFooterInSection:)]) {
        title = [dataSource tableView:tableView titleForFooterInSection:section];
    }
    kAOPUICallingResotre;
    return title;
}

// Editing

// Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    BOOL canEditing = NO;
    if ([dataSource respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)]) {
        canEditing = [dataSource tableView:tableView canEditRowAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
    return canEditing;
}

// Moving/reordering

// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
- (BOOL)tableView:(UITableView*)tableView canMoveRowAtIndexPath:(NSIndexPath*)indexPath
{
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    BOOL canMove = NO;
    if ([dataSource respondsToSelector:@selector(tableView:canMoveRowAtIndexPath:)]) {
        canMove = [dataSource tableView:tableView canMoveRowAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
    return canMove;
}

// Index

- (nullable NSArray<NSString*>*)sectionIndexTitlesForTableView:(UITableView*)tableView __TVOS_PROHIBITED // return list of section titles to display in section index view (e.g. "ABCD...Z#")
{
    NSAssert(NO, @"NO Impl");
    return nil;
}
- (NSInteger)tableView:(UITableView*)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index __TVOS_PROHIBITED // tell table which section corresponds to section title/index (e.g. "B",1))
{
    NSAssert(NO, @"NO Impl");
    return index;
}

// Data manipulation - insert and delete support

// After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
// Not called for edit actions using UITableViewRowAction - the action's handler will be invoked instead
- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    if ([dataSource respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) {
        [dataSource tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
}

// Data manipulation - reorder / moving support

- (void)tableView:(UITableView*)tableView moveRowAtIndexPath:(NSIndexPath*)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath
{
    kAOPUICallingSaved;
    NSIndexPath* source = [self realIndexPathByTable:sourceIndexPath];
    NSIndexPath* destin = [self realIndexPathByTable:destinationIndexPath];
    if ([self.tableDataSource respondsToSelector:@selector(tableView:moveRowAtIndexPath:toIndexPath:)]) {
        [self.tableDataSource tableView:tableView moveRowAtIndexPath:source toIndexPath:destin];
    }
    kAOPUICallingResotre;
}
@end

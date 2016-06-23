//
//  IMYAOPTableViewUtils+UITableViewDelegate.m
//  IMYAdvertisementDemo
//
//  Created by ljh on 16/4/15.
//  Copyright © 2016年 IMY. All rights reserved.
//

#import "IMYAOPTableViewUtils+Delegate.h"
#import "IMYAOPTableViewUtils+Private.h"

#define kAOPRealIndexPathCode                                           \
    NSIndexPath* realIndexPath = [self realIndexPathByTable:indexPath]; \
    id<UITableViewDelegate> delegate = nil;                             \
    if (realIndexPath) {                                                \
        delegate = self.tableDelegate;                                  \
        indexPath = realIndexPath;                                      \
    }                                                                   \
    else {                                                              \
        delegate = self.delegate;                                       \
    }

#define kAOPRealSectionCode                                    \
    NSInteger realSection = [self realSectionByTable:section]; \
    id<UITableViewDelegate> delegate = nil;                    \
    if (realSection >= 0) {                                    \
        delegate = self.tableDelegate;                         \
        section = realSection;                                 \
    }                                                          \
    else {                                                     \
        delegate = self.delegate;                              \
    }

#define kAOPUICallingSaved \
    self.isUICalling -= 1;

#define kAOPUICallingResotre \
    self.isUICalling += 1;

@implementation IMYAOPTableViewUtils (UITableViewDelegate)
// Display customization
- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    kAOPUICallingSaved;
    ///回调给ad manager 虚拟广告位的上报
    [self.delegate aopTableUtils:self willDisplayCell:cell forRowAtIndexPath:indexPath];
    
    kAOPRealIndexPathCode;
    if ([delegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]) {
        [delegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
}
- (void)tableView:(UITableView*)tableView willDisplayHeaderView:(UIView*)view forSection:(NSInteger)section
{
    kAOPUICallingSaved;
    kAOPRealSectionCode;
    if ([delegate respondsToSelector:@selector(tableView:willDisplayHeaderView:forSection:)]) {
        [delegate tableView:tableView willDisplayHeaderView:view forSection:section];
    }
    kAOPUICallingResotre;
}
- (void)tableView:(UITableView*)tableView willDisplayFooterView:(UIView*)view forSection:(NSInteger)section
{
    kAOPUICallingSaved;
    kAOPRealSectionCode;
    if ([delegate respondsToSelector:@selector(tableView:willDisplayFooterView:forSection:)]) {
        [delegate tableView:tableView willDisplayFooterView:view forSection:section];
    }
    kAOPUICallingResotre;
}
- (void)tableView:(UITableView*)tableView didEndDisplayingCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    if ([delegate respondsToSelector:@selector(tableView:didEndDisplayingCell:forRowAtIndexPath:)]) {
        [delegate tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
}
- (void)tableView:(UITableView*)tableView didEndDisplayingHeaderView:(UIView*)view forSection:(NSInteger)section
{
    kAOPUICallingSaved;
    kAOPRealSectionCode;
    if ([delegate respondsToSelector:@selector(tableView:didEndDisplayingHeaderView:forSection:)]) {
        [delegate tableView:tableView didEndDisplayingHeaderView:view forSection:section];
    }
    kAOPUICallingResotre;
}
- (void)tableView:(UITableView*)tableView didEndDisplayingFooterView:(UIView*)view forSection:(NSInteger)section
{
    kAOPUICallingSaved;
    kAOPRealSectionCode;
    if ([delegate respondsToSelector:@selector(tableView:didEndDisplayingFooterView:forSection:)]) {
        [delegate tableView:tableView didEndDisplayingFooterView:view forSection:section];
    }
    kAOPUICallingResotre;
}

// Variable height support

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    CGFloat cellHeight = 0;
    if ([delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        cellHeight = [delegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    else if (delegate) {
        cellHeight = tableView.rowHeight;
    }
    kAOPUICallingResotre;
    return cellHeight;
}
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(aopTableUtils:heightForHeaderInSection:)]) {
        return [self.delegate aopTableUtils:self heightForHeaderInSection:section];
    }
    kAOPUICallingSaved;
    kAOPRealSectionCode;
    CGFloat sectionHeight = 0;
    if ([delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
        sectionHeight = [delegate tableView:tableView heightForHeaderInSection:section];
    }
    else if (delegate) {
        sectionHeight = tableView.sectionHeaderHeight;
    }
    kAOPUICallingResotre;
    return sectionHeight;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    kAOPUICallingSaved;
    kAOPRealSectionCode;
    CGFloat sectionHeight = 0;
    if ([delegate respondsToSelector:@selector(tableView:heightForFooterInSection:)]) {
        sectionHeight = [delegate tableView:tableView heightForFooterInSection:section];
    }
    else if (delegate) {
        sectionHeight = tableView.sectionFooterHeight;
    }
    kAOPUICallingResotre;
    return sectionHeight;
}

// Use the estimatedHeight methods to quickly calcuate guessed values which will allow for fast load times of the table.
// If these methods are implemented, the above -tableView:heightForXXX calls will be deferred until views are ready to be displayed, so more expensive logic can be placed there.
- (CGFloat)tableView:(UITableView*)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    CGFloat cellHeight = 0;
    if ([delegate respondsToSelector:@selector(tableView:estimatedHeightForRowAtIndexPath:)]) {
        cellHeight = [delegate tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
    }
    else if (delegate) {
        cellHeight = tableView.rowHeight;
    }
    kAOPUICallingResotre;
    return cellHeight;
}
- (CGFloat)tableView:(UITableView*)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    kAOPUICallingSaved;
    kAOPRealSectionCode;
    CGFloat sectionHeight = 0;
    if ([delegate respondsToSelector:@selector(tableView:estimatedHeightForHeaderInSection:)]) {
        sectionHeight = [delegate tableView:tableView estimatedHeightForHeaderInSection:section];
    }
    else if (delegate) {
        sectionHeight = tableView.sectionHeaderHeight;
    }
    kAOPUICallingResotre;
    return sectionHeight;
}
- (CGFloat)tableView:(UITableView*)tableView estimatedHeightForFooterInSection:(NSInteger)section
{
    kAOPUICallingSaved;
    kAOPRealSectionCode;
    CGFloat sectionHeight = 0;
    if ([delegate respondsToSelector:@selector(tableView:estimatedHeightForFooterInSection:)]) {
        sectionHeight = [delegate tableView:tableView estimatedHeightForFooterInSection:section];
    }
    else if (delegate) {
        sectionHeight = tableView.sectionFooterHeight;
    }
    kAOPUICallingResotre;
    return sectionHeight;
}

// Section header & footer information. Views are preferred over title should you decide to provide both

- (nullable UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    kAOPUICallingSaved;
    kAOPRealSectionCode;
    UIView* headerView = nil;
    if ([delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
        headerView = [delegate tableView:tableView viewForHeaderInSection:section];
    }
    kAOPUICallingResotre;
    return headerView;
}
- (nullable UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    kAOPUICallingSaved;
    kAOPRealSectionCode;
    UIView* headerView = nil;
    if ([delegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
        headerView = [delegate tableView:tableView viewForFooterInSection:section];
    }
    kAOPUICallingResotre;
    return headerView;
}
- (void)tableView:(UITableView*)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath*)indexPath
{
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    if ([delegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)]) {
        [delegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
    kAOPUICallingResotre;
}

// Selection

// -tableView:shouldHighlightRowAtIndexPath: is called when a touch comes down on a row.
// Returning NO to that message halts the selection process and does not cause the currently selected row to lose its selected look while the touch is down.
- (BOOL)tableView:(UITableView*)tableView shouldHighlightRowAtIndexPath:(NSIndexPath*)indexPath
{
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    BOOL canHighlight = YES;
    if ([delegate respondsToSelector:@selector(tableView:shouldHighlightRowAtIndexPath:)]) {
        canHighlight = [delegate tableView:tableView shouldHighlightRowAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
    return canHighlight;
}
- (void)tableView:(UITableView*)tableView didHighlightRowAtIndexPath:(NSIndexPath*)indexPath
{
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    if ([delegate respondsToSelector:@selector(tableView:didHighlightRowAtIndexPath:)]) {
        [delegate tableView:tableView didHighlightRowAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
}
- (void)tableView:(UITableView*)tableView didUnhighlightRowAtIndexPath:(NSIndexPath*)indexPath
{
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    if ([delegate respondsToSelector:@selector(tableView:didUnhighlightRowAtIndexPath:)]) {
        [delegate tableView:tableView didUnhighlightRowAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
}

// Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
- (nullable NSIndexPath*)tableView:(UITableView*)tableView willSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    if ([delegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)]) {
        indexPath = [delegate tableView:tableView willSelectRowAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
    return indexPath;
}
- (nullable NSIndexPath*)tableView:(UITableView*)tableView willDeselectRowAtIndexPath:(NSIndexPath*)indexPath
{
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    if ([delegate respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:)]) {
        indexPath = [delegate tableView:tableView willDeselectRowAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
    return indexPath;
}

// Called after the user changes the selection.
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    if ([delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
}
- (void)tableView:(UITableView*)tableView didDeselectRowAtIndexPath:(NSIndexPath*)indexPath
{
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    if ([delegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)]) {
        [delegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
}

// Editing

// Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath
{
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    UITableViewCellEditingStyle editStyle = UITableViewCellEditingStyleNone;
    if ([delegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)]) {
        editStyle = [delegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
    return editStyle;
}
- (nullable NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexPath
{
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    NSString* title = nil;
    if ([delegate respondsToSelector:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:)]) {
        title = [delegate tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
    return title;
}
- (nullable NSArray<UITableViewRowAction*>*)tableView:(UITableView*)tableView editActionsForRowAtIndexPath:(NSIndexPath*)indexPath
{
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    id actions = nil;
    if ([delegate respondsToSelector:@selector(tableView:editActionsForRowAtIndexPath:)]) {
        actions = [delegate tableView:tableView editActionsForRowAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
    return actions;
}

// Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
- (BOOL)tableView:(UITableView*)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath*)indexPath
{
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    BOOL shouldIndent = YES;
    if ([delegate respondsToSelector:@selector(tableView:shouldIndentWhileEditingRowAtIndexPath:)]) {
        shouldIndent = [delegate tableView:tableView shouldIndentWhileEditingRowAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
    return shouldIndent;
}

// The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath*)indexPath
{
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    if ([delegate respondsToSelector:@selector(tableView:willBeginEditingRowAtIndexPath:)]) {
        [delegate tableView:tableView willBeginEditingRowAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
}
- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath*)indexPath
{
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    if ([delegate respondsToSelector:@selector(tableView:didEndEditingRowAtIndexPath:)]) {
        [delegate tableView:tableView didEndEditingRowAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
}

// Moving/reordering

// Allows customization of the target row for a particular row as it is being moved/reordered
- (NSIndexPath*)tableView:(UITableView*)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath*)sourceIndexPath toProposedIndexPath:(NSIndexPath*)proposedDestinationIndexPath
{
    kAOPUICallingSaved;
    NSIndexPath* realOne = [self realIndexPathByTable:sourceIndexPath];
    NSIndexPath* realTwo = [self realIndexPathByTable:proposedDestinationIndexPath];

    NSIndexPath* resultIndexPath = proposedDestinationIndexPath;
    if (realOne && realTwo) {
        if ([self.tableDelegate respondsToSelector:@selector(tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)]) {
            resultIndexPath = [self.tableDelegate tableView:tableView targetIndexPathForMoveFromRowAtIndexPath:realOne toProposedIndexPath:realTwo];
            resultIndexPath = [self tableIndexPathByReal:resultIndexPath];
        }
    }
    kAOPUICallingResotre;
    return resultIndexPath;
}

// Indentation

- (NSInteger)tableView:(UITableView*)tableView indentationLevelForRowAtIndexPath:(NSIndexPath*)indexPath
{
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    NSInteger indentationLevel = 0;
    if ([delegate respondsToSelector:@selector(tableView:indentationLevelForRowAtIndexPath:)]) {
        indentationLevel = [delegate tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
    return indentationLevel;
}

// Copy/Paste.  All three methods must be implemented by the delegate.

- (BOOL)tableView:(UITableView*)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath*)indexPath
{
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    BOOL shouldShow = YES;
    if ([delegate respondsToSelector:@selector(tableView:shouldShowMenuForRowAtIndexPath:)]) {
        shouldShow = [delegate tableView:tableView shouldShowMenuForRowAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
    return shouldShow;
}
- (BOOL)tableView:(UITableView*)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath*)indexPath withSender:(nullable id)sender
{
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    BOOL canPerform = NO;
    if ([delegate respondsToSelector:@selector(tableView:canPerformAction:forRowAtIndexPath:withSender:)]) {
        canPerform = [delegate tableView:tableView canPerformAction:action forRowAtIndexPath:indexPath withSender:sender];
    }
    kAOPUICallingResotre;
    return canPerform;
}
- (void)tableView:(UITableView*)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath*)indexPath withSender:(nullable id)sender
{
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    if ([delegate respondsToSelector:@selector(tableView:performAction:forRowAtIndexPath:withSender:)]) {
        [delegate tableView:tableView performAction:action forRowAtIndexPath:indexPath withSender:sender];
    }
    kAOPUICallingResotre;
}

// Focus

- (BOOL)tableView:(UITableView*)tableView canFocusRowAtIndexPath:(NSIndexPath*)indexPath
{
    kAOPUICallingSaved;
    kAOPRealIndexPathCode;
    BOOL canFocus = YES;
    if ([delegate respondsToSelector:@selector(tableView:canFocusRowAtIndexPath:)]) {
        canFocus = [delegate tableView:tableView canFocusRowAtIndexPath:indexPath];
    }
    kAOPUICallingResotre;
    return canFocus;
}
- (nullable NSIndexPath*)indexPathForPreferredFocusedViewInTableView:(UITableView*)tableView
{
    kAOPUICallingSaved;
    NSIndexPath* indexPath = nil;
    if ([self.tableDelegate respondsToSelector:@selector(indexPathForPreferredFocusedViewInTableView:)]) {
        indexPath = [self.tableDelegate indexPathForPreferredFocusedViewInTableView:tableView];
        if (indexPath) {
            indexPath = [self tableIndexPathByReal:indexPath];
        }
    }
    kAOPUICallingResotre;
    return indexPath;
}
@end

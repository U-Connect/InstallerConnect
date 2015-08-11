//
//  EXDataGridDelegate.h
//  EXEXDataGrid
//
//  Created by Kiryl Lishynski on 8/06/12.
//  Copyright (c) 2012 Exairo Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EXDataGrid.h"
#import "EXDataGridColumn.h"

//DataGrid notification keys
#define columnNotification @"column" //name of the notification
#define select @"select" //Used when user selects row
#define deselct @"deselct" //Used when user deselects row

//Needed to represent direction of dragging
typedef enum {
    DragDirectionLeft = 0,
    DragDirectionRight = 1
} DragDirection;


@class EXDataGrid;
@class EXDataGridColumn;
@class EXDataGridCell;

//Must be implemented by view controller, which contains DataGrid.
@protocol EXDataGridDelegate <NSObject>

@required
- (int)numberOfRowsInDataGrid:(EXDataGrid*)dataGrid; //number of rows in every column
- (int)numberOfColumnsInDataGrid:(EXDataGrid*)dataGrid; //number of columns in whole DataGrid
- (float)dataGrid:(EXDataGrid*)dataGrid heightOfRow:(int)rowNumber; //height of the specific row;
- (float)dataGrid:(EXDataGrid*)dataGrid widthOfColumn:(int)columnNumber; //width of the specific
- (EXDataGridCell*)dataGrid:(EXDataGrid*)dataGrid cellForColumn:(int)columnNumber row:(int)rowNumber; //You can customize appearance and context of the cell.

@optional
- (void)dataGrid:(EXDataGrid*)dataGrid didSelectCellAtColumn:(int)columnNumber row:(int)rowNumber; //Called, when specific cell was selected.
- (void)dataGrid:(EXDataGrid *)dataGrid didSelectColumn:(int)columnNumber; //Called when specific column was selected.
- (void)dataGrid:(EXDataGrid*)dataGrid moveColumnFrom:(int)sourceColumnNumber toColumn:(int)destinationColumnNumber; //Called, when dragging of column was ended.
- (UIView*)headerViewForColumn:(int)columnNumber; //This method must be return custom header view for each column. Use if you not implement - (NSString*)titleForColumn:(int)columnNumber;
- (NSString*)titleForColumn:(int)columnNumber; //returns string title for each default header view. Use if you not implement - (UIView*)headerViewForColumn:(int)columnNumber;
- (float)headerViewHeight; //If you implement this method and this method returns value different from 0, implement 1 of 2 previous methods.
@end

//scroll the whole DataGrid, when single column was scrolled. Also used to reorder columns.
@protocol EXDataGridColumnDelegate <NSObject>
@required
- (void)columnDidScroll:(CGPoint)contentOffset;
- (void)columnDidDrag:(EXDataGridColumn*)column direction:(DragDirection)direction locationOfTouch:(float)location;
- (void)columnDraggingEnded:(EXDataGridColumn*)column fromNumber:(int)fromNumber toNumber:(int)toNumber;

@end


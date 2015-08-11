//
//  EXDataGridRow.h
//  EXEXDataGrid
//
//  Created by Kiryl Lishynski on 8/06/12.
//  Copyright (c) 2012 Exairo Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXDataGrid.h"
#import "EXDataGridDelegate.h"

@class EXDataGrid;


//represents single column of grid view

@interface EXDataGridColumn : UITableView <UITableViewDataSource, UITableViewDelegate> {
    
    float cellHeight; //used to set frame to cell
    float headerViewHeight; //height of header view
    float xCoordInSuperView; //stored coord of position in superview when dragging begins
    
    int columnSavedNumber; //saved number of the column
    
    BOOL editingEnabled;
}

@property (nonatomic, assign) id<EXDataGridDelegate> dataGridDelegate;
@property (nonatomic, assign) id<EXDataGridColumnDelegate> dataGridColumnDelegate;

@property (nonatomic, readonly) int numberOfRows; //number of rows in column

@property (nonatomic) int columnNumber; //number of the column

@property (nonatomic, retain) UIColor *headerViewBackgroundColor; //header view background color
@property (nonatomic, retain) UIColor *headerViewTextColor; //header view text color
@property (nonatomic, retain) UIColor *borderColor; //color of the border
@property (nonatomic) float borderWidth; //width of the border

@property (nonatomic,getter = iColumnSelected) BOOL columnSelected;
@property (nonatomic) CGRect baseFrame; //needed to frame swapping.

//selects and deselects column. Send YES to  setSelectedFromTouchEvent only when you click on column header.
- (void)setEditingEnabled:(BOOL)editingEnabled;
- (void)setSelectedFromTouchEvent:(BOOL)selected;
- (void)setDeselected;
@end

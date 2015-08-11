//
//  EXDataGrid.m
//  EXEXDataGrid
//
//  Created by Kiryl Lishynski on 8/06/12.
//  Copyright (c) 2012 Exairo Ltd. All rights reserved.
//

#import "EXDataGrid.h"

@implementation EXDataGrid

@synthesize dataGridDelegate = _dataGridDelegate;
@synthesize headerViewBackgroundColor = _headerViewBackgroundColor;
@synthesize headerViewTextColor = _headerViewTextColor;
@synthesize bordersColor = _bordersColor;
@synthesize bordersWidth = _bordersWidth;
@synthesize editingEnabled = _editingEnabled;
@synthesize timerInterval = _timerInterval;
@synthesize animationDuration = _animationDuration;
@synthesize autoscrollAreaWidth = _autoscrollAreaWidth;
@synthesize firstColumnLocked = _firstColumnLocked;

#pragma mark - init

- (id)init
{
    self = [super init];
    if(self) {
        
    }
    return self;
}


//initialization.
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        
        columns = [[NSMutableArray alloc] init];
        
        [self setBounces:NO];
        [self setBouncesZoom:NO];
        [self setShowsHorizontalScrollIndicator:YES];
        [self setShowsVerticalScrollIndicator:YES];
        self.delegate = self;
        
        self.headerViewTextColor = [UIColor blackColor];
        self.headerViewBackgroundColor = [UIColor lightGrayColor];
        
        _timerInterval = 0.004;
        _animationDuration = 0.2;
        _autoscrollAreaWidth = 50;
        _bordersWidth = 0.5;
        self.bordersColor = [UIColor lightGrayColor];
        
    }
    return self;
}

- (void)dealloc
{
    _dataGridDelegate = nil;
    [_headerViewBackgroundColor release];
    [_headerViewTextColor release];
    [_bordersColor release];
    [columns removeAllObjects];
    [columns release];
    
    [super dealloc];
}

#pragma mark - ScrollView Delegate
//Determine visible columns and set content offset to the scroll view
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float rightCornerX = self.contentOffset.x + self.frame.size.width;
    float columnRightCornerX;
    
    for(EXDataGridColumn *column in columns) {
        columnRightCornerX = column.frame.origin.x + column.frame.size.width;
        if((self.contentOffset.x < column.frame.origin.x && column.frame.origin.x < rightCornerX) || (columnRightCornerX < rightCornerX && columnRightCornerX > self.contentOffset.x)) {
            for(EXDataGridColumn *col in columns) {
                [col setContentOffset:CGPointMake(col.contentOffset.x, column.contentOffset.y)];
            }
            break;
        } else {
            continue;
        }
    }
    if(_firstColumnLocked) {
        EXDataGridColumn *firstColumn = columns.firstObject;
        [firstColumn setFrame:CGRectMake(scrollView.contentOffset.x, scrollView.contentOffset.y, firstColumn.frame.size.width, firstColumn.frame.size.height)];
    }
}

#pragma mark - public methods implementation
//reload all data. Recreate all column
- (void)reloadData
{
    columnsWidth = 0;
    
    numberOfColumns = [_dataGridDelegate numberOfColumnsInDataGrid:self];
    numberOfRows = [_dataGridDelegate numberOfRowsInDataGrid:self];
    
    if(numberOfColumns == 0) {
        return;
    }
    
    [columns removeAllObjects];
    for(UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    for(int currentColumnNumber = 0; currentColumnNumber < numberOfColumns; currentColumnNumber++) {
        [self addColumn:currentColumnNumber];
    }
    [self setContentSize:CGSizeMake(columnsWidth, ((EXDataGridColumn*)[columns lastObject]).frame.size.height)];
}

//reload single column
- (void)reloadColumn:(int)columnNumber
{
    EXDataGridColumn *column = [columns objectAtIndex:columnNumber];
    [column reloadData];
}


//reload single row
- (void)reloadRow:(int)rowNumber
{
    NSArray *indexes = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
    for(EXDataGridColumn *column in columns) {
        [column reloadRowsAtIndexPaths:indexes withRowAnimation:UITableViewRowAnimationNone];
    }
}

//get exising cell from cell queue of specific column
- (EXDataGridCell*)cellDequeueReusableIdentifier:(NSString *)identifier forColumn:(int)column
{
    return [[columns objectAtIndex:column] dequeueReusableCellWithIdentifier:identifier];
    
}

//exchange 2 rows
- (void)moveRowFrom:(int)sourceRowNumber toRow:(int)destinationColumnNumber
{
    for(EXDataGridColumn *column in columns) {
        [column moveRowAtIndexPath:[NSIndexPath indexPathForRow:sourceRowNumber inSection:0] toIndexPath:[NSIndexPath indexPathForRow:destinationColumnNumber inSection:0]];
    }
}

//exchange 2 columns
- (void)moveColumnFrom:(int)sourceColumnNumber toColumn:(int)destinationColumnNumber
{
    EXDataGridColumn *sourceColumn = [columns objectAtIndex:sourceColumnNumber];
    EXDataGridColumn *destinationColumn = [columns objectAtIndex:destinationColumnNumber];
    
    CGRect destinationColumnFrame = destinationColumn.frame;
    
    [UIView animateWithDuration:0.7 animations:^(void)
     {
         destinationColumn.frame = sourceColumn.frame;
         sourceColumn.frame = destinationColumnFrame;
     } completion:^(BOOL finished) {
         destinationColumn.baseFrame = destinationColumn.frame;
         sourceColumn.baseFrame = sourceColumn.frame;
         [self exchangeColumns:sourceColumn to:destinationColumn];
     }];
}

#pragma mark - select/deselect
- (void)selectColumn:(int)columnNumber
{
    if(columnNumber >= [columns count]) {
        return;
    }
    
    EXDataGridColumn *column = [columns objectAtIndex:columnNumber];
    //send NO to selectedFromTouchEvent if column selected programatically
    [column setSelectedFromTouchEvent:NO];
}

- (void)deselectColumn:(int)columnNumber
{
    if(columnNumber >= [columns count]) {
        return;
    }
    
    EXDataGridColumn *column = [columns objectAtIndex:columnNumber];
    [column setDeselected];
}

//select row
//post notification to select a row
- (void)selectRow:(int)rowNumber
{
    if(rowNumber >= numberOfRows) {
        return;
    }
    
    NSNumber *rowNum = [NSNumber numberWithInt:rowNumber];
    [[NSNotificationCenter defaultCenter] postNotificationName:columnNotification object:nil userInfo:[NSDictionary dictionaryWithObject:rowNum forKey:select]];
    
    
}
//post notification to each column to deselect cell at specific row
- (void)deselectRow:(int)rowNumber
{
    if(rowNumber >= numberOfRows) {
        return;
    }
    
    NSNumber *rowNum = [NSNumber numberWithInt:rowNumber];
    [[NSNotificationCenter defaultCenter] postNotificationName:columnNotification object:nil userInfo:[NSDictionary dictionaryWithObject:rowNum forKey:deselct]];
}

#pragma mark - navigate to
//scroll to first row
- (void)navigateToFirstRowAnimated:(BOOL)animated
{
    EXDataGridColumn *column = [columns lastObject];
    [column scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:animated];
    [self columnDidScroll:column.contentOffset];
}

- (void)navigateToColumn:(int)columnNumber animated:(BOOL)animated
{
    if(columnNumber >= [columns count]) {
        return;
    }
    
    EXDataGridColumn *column = [columns objectAtIndex:columnNumber];
    if(column.frame.origin.x + self.frame.size.width > self.contentSize.width) {
        [self setContentOffset:CGPointMake(self.contentSize.width - self.frame.size.width, self.contentOffset.y) animated:animated];
    } else {
        [self setContentOffset:column.frame.origin animated:animated];
    }
    
}

- (void)navigateToRow:(int)rowNumber animated:(BOOL)animated
{
    
    EXDataGridColumn *column = [columns lastObject];
    if(rowNumber >= column.numberOfRows) {
        return;
    }
    [column scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:animated];
    [self columnDidScroll:column.contentOffset];
}


#pragma mark - properties setters implementation
- (void)setDataGridDelegate:(id<EXDataGridDelegate>)dataGridDelegate
{
    _dataGridDelegate = dataGridDelegate;
    if(_dataGridDelegate) {
        [self reloadData];
    }
}

- (void)setScrollEnabled:(BOOL)scrollEnabled
{
    [super setScrollEnabled:scrollEnabled];
    for(EXDataGridColumn *column in columns) {
        [column setScrollEnabled:scrollEnabled];
    }
}

- (void)setBordersColor:(UIColor *)bordersColor
{
    [_bordersColor release];
    _bordersColor = [bordersColor retain];
}

- (void)setHeaderViewBackgroundColor:(UIColor *)headerViewBackgroundColor
{
    [_headerViewBackgroundColor release];
    _headerViewBackgroundColor = [headerViewBackgroundColor retain];
}

- (void)setHeaderViewTextColor:(UIColor *)headerViewTextColor
{
    [_headerViewTextColor release];
    _headerViewTextColor = [headerViewTextColor retain];
}


//reload data after new frame was set
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if(self.dataGridDelegate) {
        [self reloadData];
    }
}

//set editing mode to data grid. Editing mode allows reordering of columns and rows by user.
- (void)setEditingEnabled:(BOOL)editingEnabled
{
    
    _editingEnabled = editingEnabled;
    for(EXDataGridColumn *column in columns) {
        [column setEditingEnabled:_editingEnabled];
    }
}

//set locking of the first column (if YES - first column will be alway visible).
- (void)setFirstColumnLocked:(BOOL)firstColumnLocked
{
    _firstColumnLocked = firstColumnLocked;
    [self setContentOffset:[self contentOffset] animated:NO];
    EXDataGridColumn *firstColumn = [columns firstObject];
    if(_firstColumnLocked) {
        [self bringSubviewToFront:firstColumn];
        firstColumn.frame = CGRectMake(self.contentOffset.x, self.contentOffset.y, firstColumn.frame.size.width, firstColumn.frame.size.height);
    } else {
        [self sendSubviewToBack:firstColumn];
        firstColumn.frame = CGRectMake(0, 0, firstColumn.frame.size.width, firstColumn.frame.size.height);
    }
}

#pragma mark - private methods implementation
//Add specified column to the subviews of DataGrid and to the columns array.
- (void)addColumn:(int)columnNumber
{
    EXDataGridColumn *dataGridColumn = [[EXDataGridColumn alloc] init];
    dataGridColumn.columnNumber = columnNumber;
  
    [dataGridColumn setFrame:CGRectMake(columnsWidth, 0, [_dataGridDelegate dataGrid:self widthOfColumn:columnNumber],self.frame.size.height)];
    dataGridColumn.borderColor = _bordersColor;
    dataGridColumn.borderWidth = _bordersWidth;
    dataGridColumn.headerViewTextColor = _headerViewTextColor;
    dataGridColumn.headerViewBackgroundColor = _headerViewBackgroundColor;
    [dataGridColumn setEditingEnabled:_editingEnabled];
    columnsWidth += dataGridColumn.frame.size.width;
    columnNumber++;

    dataGridColumn.baseFrame = dataGridColumn.frame;
    dataGridColumn.dataGridDelegate = self.dataGridDelegate; //setup delegate to the one source
    dataGridColumn.dataGridColumnDelegate = self;
    [self addSubview:dataGridColumn];
    [columns addObject:dataGridColumn];
    [dataGridColumn release];
}

- (void)invalidateTimer
{
    [timer invalidate];
    [timer release];
    timer = nil;
}

//scroll to right.
- (void)scrollToRight
{
    if((self.contentOffset.x + self.frame.size.width) <= self.contentSize.width) {
        [self setContentOffset:CGPointMake(self.contentOffset.x + 1, self.contentOffset.y) animated:NO];
        [self checkNeedFoExchange];
    } else {
        [self invalidateTimer];
    }
}

//scroll to left
- (void)scrollToLeft
{
    if(self.contentOffset.x >= 0) {
        [self setContentOffset:CGPointMake(self.contentOffset.x - 1, self.contentOffset.y) animated:NO];
        
        [self checkNeedFoExchange];
    } else {
        [self invalidateTimer];
    }
}

- (void)checkNeedFoExchange
{
    draggableColumn.center = CGPointMake(self.contentOffset.x + locationOfTouch, draggableColumn.center.y); //set center to the column
    EXDataGridColumn *currentColumn ;
    if(dragDirection == DragDirectionLeft) {
        if(draggableColumn.columnNumber - 1 >= 0) {
            currentColumn  = [columns objectAtIndex:draggableColumn.columnNumber - 1]; //obtain column before draggable column
            float rightBorder = draggableColumn.frame.origin.x + draggableColumn.frame.size.width;
            if(rightBorder > (currentColumn.frame.origin.x + currentColumn.frame.size.width/2) && draggableColumn.frame.origin.x  < (currentColumn.frame.origin.x + currentColumn.frame.size.width/2) )  {
                draggableColumn.baseFrame = CGRectMake(currentColumn.baseFrame.origin.x, draggableColumn.baseFrame.origin.y, draggableColumn.baseFrame.size.width, draggableColumn.baseFrame.size.height);
                
                currentColumn.baseFrame = CGRectMake(draggableColumn.baseFrame.origin.x + draggableColumn.baseFrame.size.width,
                                                     currentColumn.frame.origin.y, currentColumn.frame.size.width, currentColumn.frame.size.height);
                [self exchangeColumns:currentColumn to:draggableColumn];
                [UIView animateWithDuration:_animationDuration animations:^(void) {
                    
                    currentColumn.frame = currentColumn.baseFrame;
                }];
            }
        }
    } else {
        if(draggableColumn.columnNumber + 1 < [columns count]) {
            EXDataGridColumn *currentColumn = [columns objectAtIndex:draggableColumn.columnNumber + 1];
            float rightBorder = draggableColumn.frame.origin.x + draggableColumn.frame.size.width;
            if(rightBorder > (currentColumn.frame.origin.x + currentColumn.frame.size.width/2) && draggableColumn.frame.origin.x  < (currentColumn.frame.origin.x + currentColumn.frame.size.width/2) )  {
                draggableColumn.baseFrame = CGRectMake(currentColumn.baseFrame.origin.x + currentColumn.baseFrame.size.width - draggableColumn.frame.size.width, draggableColumn.baseFrame.origin.y, draggableColumn.baseFrame.size.width, draggableColumn.baseFrame.size.height);
                currentColumn.baseFrame = CGRectMake(draggableColumn.baseFrame.origin.x - currentColumn.frame.size.width,
                                                     currentColumn.frame.origin.y, currentColumn.frame.size.width, currentColumn.frame.size.height);
                [self exchangeColumns:draggableColumn to:currentColumn];
                [UIView animateWithDuration:_animationDuration animations:^(void) {
                    currentColumn.frame = currentColumn.baseFrame;
                }];
                
            }
        }
    }
}

- (void)exchangeColumns:(EXDataGridColumn*)firstColumn to:(EXDataGridColumn*)secondColumn
{
    int colNumber = firstColumn.columnNumber;
    firstColumn.columnNumber = secondColumn.columnNumber;
    secondColumn.columnNumber = colNumber;
    
    [columns removeObjectAtIndex:secondColumn.columnNumber];
    [columns insertObject:firstColumn atIndex:firstColumn.columnNumber];
}


#pragma mark - EXDataGridColumnDelegate
//invoked when column was scrolled vertically. Set content offset of the column to other columns.
- (void)columnDidScroll:(CGPoint)contentOffset
{
    float rightCornerX = self.contentOffset.x + self.frame.size.width;
    for(EXDataGridColumn *column in columns) {
        float columnRightCorenrX = column.frame.origin.x + column.frame.size.width;
        if((self.contentOffset.x < column.frame.origin.x && column.frame.origin.x < rightCornerX) ||
           (columnRightCorenrX < rightCornerX && columnRightCorenrX > self.contentOffset.x)) {
            [column setContentOffset:contentOffset];
        }
    }
}

//invoked when column dragged horizontally.
- (void)columnDidDrag:(EXDataGridColumn *)column direction:(DragDirection)direction locationOfTouch:(float)location
{
    locationOfTouch = location - self.contentOffset.x; //determine location of touch in data grid
    
    //check if location of touch in the right area and contentoffset not reached maximum value
    if(locationOfTouch > (self.frame.size.width - _autoscrollAreaWidth) && (self.contentOffset.x < self.contentSize.width - self.frame.size.width)) {
        [self invalidateTimer];
        dragDirection = direction;
        draggableColumn = column;
        timer = [[NSTimer scheduledTimerWithTimeInterval:_timerInterval target:self selector:@selector(scrollToRight) userInfo:nil repeats:YES] retain];
        
        //check if location of touch in the right area and contentoffset is still greater than 0
    } else if ( locationOfTouch < self.frame.origin.x + _autoscrollAreaWidth && self.contentOffset.x > 0){
        [self invalidateTimer];
        dragDirection = direction;
        draggableColumn = [column retain];
        timer = [[NSTimer scheduledTimerWithTimeInterval:_timerInterval target:self selector:@selector(scrollToLeft) userInfo:nil repeats:YES] retain];
        
        //no need in autoscrolling. Drag column manually
    } else {
        [self invalidateTimer];
        draggableColumn = column;
        dragDirection = direction;
        [self checkNeedFoExchange];
    }
}

//set frame to specific column and invoke method of the delegate.
- (void)columnDraggingEnded:(EXDataGridColumn*)column fromNumber:(int)fromNumber toNumber:(int)toNumber
{
    [self invalidateTimer];
    [UIView animateWithDuration:_animationDuration animations:^(void) {
        [column setFrame:column.baseFrame];
        
    }];
    
    if(fromNumber!=toNumber && [_dataGridDelegate respondsToSelector:@selector(dataGrid:moveColumnFrom:toColumn:)]) {
        [_dataGridDelegate dataGrid:self moveColumnFrom:fromNumber toColumn:toNumber];
    }
}

@end
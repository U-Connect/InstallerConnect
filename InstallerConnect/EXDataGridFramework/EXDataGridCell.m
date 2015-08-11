//
//  EXDataGridTableCell.m
//  EXEXDataGrid
//
//  Created by Kiryl Lishynski on 8/06/12.
//  Copyright (c) 2012 Exairo Ltd. All rights reserved.
//

#import "EXDataGridCell.h"

@implementation EXDataGridCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setSelectionStyle:UITableViewCellSelectionStyleGray];
        
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end

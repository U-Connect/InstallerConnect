//
//  ICBarcodeGridCell.m
//  InstallerConnect
//
//  Created by Venkat Yennam on 6/16/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import "ICBarcodeGridCell.h"

@implementation ICBarcodeGridCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.barcodeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Barcode.png"]];
        [self.barcodeImageView setFrame:CGRectMake(5, 5, 130, 50)];
        [self addSubview:self.barcodeImageView];
        
        self.barcodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 57, 130, 21)];
        self.barcodeLabel.textAlignment = NSTextAlignmentCenter;
        [self.barcodeLabel setAdjustsFontSizeToFitWidth:YES];
        [self.barcodeLabel setFont:[UIFont systemFontOfSize:17]];
        [self addSubview:self.barcodeLabel];
        //[self.textLabel setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

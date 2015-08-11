//
//  ICBarcodeGridCell.h
//  InstallerConnect
//
//  Created by Venkat Yennam on 6/16/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import "EXDataGridCell.h"

@interface ICBarcodeGridCell : EXDataGridCell
@property (nonatomic, strong) UIImageView *barcodeImageView;
@property (nonatomic, strong) UILabel *barcodeLabel;
@end

//
//  ICBarcodeTableViewCell.m
//  InstallerConnect
//
//  Created by Venkat Yennam on 6/12/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import "ICBarcodeTableViewCell.h"

@implementation ICBarcodeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate index:(NSInteger)index
{
    self.barCodesCollectionView.dataSource = dataSourceDelegate;
    self.barCodesCollectionView.delegate = dataSourceDelegate;
    self.barCodesCollectionView.tag = index;
    
    [self.barCodesCollectionView reloadData];
}

@end

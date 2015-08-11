//
//  ICBarcodeTableViewCell.h
//  InstallerConnect
//
//  Created by Venkat Yennam on 6/12/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICBarcodeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *barCodesCollectionView;
-(void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate index:(NSInteger)index;
@end

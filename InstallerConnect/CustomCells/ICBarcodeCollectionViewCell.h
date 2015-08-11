//
//  ICBarcodeCollectionViewCell.h
//  InstallerConnect
//
//  Created by Venkat Yennam on 6/12/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICBarcodeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UITextField *barCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *barCodeCoumnNumberLabel;
@end

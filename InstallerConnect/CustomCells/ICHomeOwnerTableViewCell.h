//
//  ICHomeOwnerTableViewCell.h
//  InstallerConnect
//
//  Created by Venkat Yennam on 6/9/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICHomeOwnerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *homeOwnerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIView *homeOwnerView;

@end

//
//  ICBarcodesViewController.h
//  InstallerConnect
//
//  Created by Venkat Yennam on 6/12/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICServicesHelper.h"

@interface ICBarcodesViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) NSMutableArray *multiDimBarcodes;
@property (nonatomic) NSInteger nRows;
@property (nonatomic) NSInteger nColumns;
@property (nonatomic) NSInteger selectedSegmentIndex;
@property (strong, nonatomic) ICHomeOwner* homeOwnerDetails;
@property (strong, nonatomic) ICSiteDetails* siteDetails;
@end

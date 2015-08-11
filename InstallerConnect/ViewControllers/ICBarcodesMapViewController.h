//
//  ICBarcodesMapViewController.h
//  InstallerConnect
//
//  Created by Venkat Yennam on 6/16/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXDataGrid.h"
#import "ICServicesHelper.h"
#import "ICHomeOwnerSystemDetailsViewController.h"

@interface ICBarcodesMapViewController : UIViewController<EXDataGridDelegate>
@property (strong, nonatomic) NSMutableArray *multiDimBarcodes;
@property (nonatomic) NSInteger nRows;
@property (nonatomic) NSInteger nColumns;
@property (nonatomic) NSInteger selectedSegmentIndex;
@property (nonatomic) NSInteger selectedPickerIndex;
@property (strong, nonatomic) NSString* base64ImageData;
@property (strong, nonatomic) UIImage* installtionMapImage;
@property (strong, nonatomic) ICHomeOwner* homeOwnerDetails;
@property (strong, nonatomic) ICSiteDetails* siteDetails;
@property (weak, nonatomic) id<ICHomeOwnerVCDelegate> hoVCdelegate;
@property (strong, nonatomic) ICBarCodes* icBarCodes;
@end

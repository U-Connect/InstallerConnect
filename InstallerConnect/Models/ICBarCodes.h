//
//  ICBarCodes.h
//  InstallerConnect
//
//  Created by Venkat Yennam on 6/8/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "ICBarCode.h"

@interface ICBarCodes : JSONModel
@property (strong, nonatomic) NSMutableArray <ICBarCode>*barcodes;
@end

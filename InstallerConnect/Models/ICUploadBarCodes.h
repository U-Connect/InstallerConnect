//
//  ICUploadBarCodes.h
//  InstallerConnect
//
//  Created by Venkat Yennam on 6/11/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface ICUploadBarCodes : JSONModel
@property (strong, nonatomic) NSString<Optional>* PVSerialNo;
@property (strong, nonatomic) NSString<Optional>* InverterSerialNo;
@property (strong, nonatomic) NSString<Optional>* MeterSerialNo;
@property (strong, nonatomic) NSString<Optional>* ControllerId;
@property (strong, nonatomic) NSString<Optional>* Base64LayoutImage;
@property (strong, nonatomic) NSString<Optional>* LayoutfileName;
@property (strong, nonatomic) NSString<Optional>* PartnerName;
@end

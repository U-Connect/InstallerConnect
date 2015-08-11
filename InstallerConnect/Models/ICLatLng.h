//
//  ICLatLng.h
//  InstallerConnect
//
//  Created by Venkat Yennam on 5/28/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface ICLatLng : JSONModel
@property (assign, nonatomic) double lat;
@property (assign, nonatomic) double lng;
@end

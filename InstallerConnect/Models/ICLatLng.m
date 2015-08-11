//
//  ICLatLng.m
//  InstallerConnect
//
//  Created by Venkat Yennam on 5/28/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import "ICLatLng.h"

@implementation ICLatLng
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"Lat"   :   @"lat",
                                                       @"Lng"   :   @"lng"
                                                       }];
}
@end

//
//  ICBarCodes.m
//  InstallerConnect
//
//  Created by Venkat Yennam on 6/8/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import "ICBarCodes.h"

@implementation ICBarCodes
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"Barcodes"    :   @"barcodes"
                                                       }];
}
@end

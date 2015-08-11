//
//  ICBarCode.m
//  InstallerConnect
//
//  Created by Venkat Yennam on 6/11/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import "ICBarCode.h"

@implementation ICBarCode
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"Text"          :   @"barCode",
                                                       @"Data"          :   @"data",
                                                       @"Type"          :   @"type",
                                                       @"Length"        :   @"length",
                                                       @"Page"          :   @"page",
                                                       @"Rotation"      :   @"rotation",
                                                       @"Left"          :   @"left",
                                                       @"Right"         :   @"right",
                                                       @"Top"           :   @"top",
                                                       @"Bottom"        :   @"bottom"
                                                       }];
}
@end

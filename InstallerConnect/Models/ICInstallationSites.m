//
//  ICInstallationSites.m
//  InstallerConnect
//
//  Created by Venkat Yennam on 6/8/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import "ICInstallationSites.h"

@implementation ICInstallationSites
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"results"    :   @"siteRecords"
                                                       }];
}
@end

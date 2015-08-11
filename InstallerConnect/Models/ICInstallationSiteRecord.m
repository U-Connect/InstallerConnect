//
//  ICInstallationSiteRecord.m
//  InstallerConnect
//
//  Created by Venkat Yennam on 6/8/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import "ICInstallationSiteRecord.h"

@implementation ICInstallationSiteRecord

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"SiteId"         :   @"siteId",
                                                       @"HOInternalId"   :   @"homeOwnerId",
                                                       @"HOFirstName"    :   @"homeOwnerFirstName",
                                                       @"HOLastName"     :   @"homeOwnerLastName",
                                                       @"HOAddress"      :   @"homeOwnerAddress",
                                                       @"HOPhone"        :   @"homeOwnerPhone",
                                                       @"AppointmentDate":   @"appointmentDate",
                                                       @"SaiInstaller"   :   @"installer",
                                                       @"SaiInstallerId" :   @"installerId"
                                                       }];
}

@end

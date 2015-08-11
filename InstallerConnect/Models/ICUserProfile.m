//
//  ICUserProfile.m
//  InstallerConnect
//
//  Created by Venkat Yennam on 5/26/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import "ICUserProfile.h"

@implementation ICUserProfile
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"Application"       :   @"application",
                                                       @"Role"              :   @"role",
                                                       @"NSInternalId"      :   @"nsInternalId",
                                                       @"PartnerId"         :   @"partnerId"
                                                       }];
}
@end

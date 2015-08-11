//
//  ICUserLogin.m
//  InstallerConnect
//
//  Created by Venkat Yennam on 5/26/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import "ICUserLogin.h"

@implementation ICUserLogin
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id"    :   @"oktaSessionId"
                                                       }];
}
@end

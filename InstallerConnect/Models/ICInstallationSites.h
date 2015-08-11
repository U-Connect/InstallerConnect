//
//  ICInstallationSites.h
//  InstallerConnect
//
//  Created by Venkat Yennam on 6/8/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "ICInstallationSiteRecord.h"

@interface ICInstallationSites : JSONModel

@property (strong, nonatomic) NSArray <ICInstallationSiteRecord>*siteRecords;

@end

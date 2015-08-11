//
//  ICServicesHelper.h
//  InstallerConnect
//
//  Created by Venkat Yennam on 6/8/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICJSONResponse.h"
#import "ICServerConstants.h"
#import "ICUserLogin.h"
#import "AsyncInterfaceTask.h"
#import "ICHomeOwner.h"
#import "ICSiteDetails.h"
#import "ICInstallationSites.h"
#import "ICBarCodes.h"
#import "ICBarCodes.h"
#import "ICUploadBarCodes.h"

#ifdef DEBUG_MODE
#define DebugLog( s, ... ) NSLog( @"<%@:(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DebugLog( s, ... )
#endif

@interface ICServicesHelper : NSObject

@property(nonatomic, strong) ICUserLogin *userLogin;
/*
 Retrieves the singleton instance of the ICServicesHelper
 */

+(ICServicesHelper*)getInstance;

/**
 Execute a login for the current user.
 */
- (ICJSONResponse*)doLogin:(NSString*)userName passWord:(NSString*)passWord;
- (ICJSONResponse*)resetPassword:(NSString*)userName;
- (ICJSONResponse*)getHomeOwnerDetails:(NSString*)homeOwnerId;
- (ICJSONResponse*)getSiteDetailsByHomeOwenr:(NSString*)homeOwnerId;
- (ICJSONResponse*)getAssignedInstallations:(NSString*)installerId;
- (ICJSONResponse*)uploadBarCodes:(ICUploadBarCodes*)barCodes forSiteId:(NSString*)siteId;
- (ICJSONResponse*)readBarcodes :(NSData*)imageData;
@end

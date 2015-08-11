//
//  ICInstallationSiteRecord.h
//  InstallerConnect
//
//  Created by Venkat Yennam on 6/8/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol ICInstallationSiteRecord
@end

@interface ICInstallationSiteRecord : JSONModel
@property (strong, nonatomic) NSString<Optional>* siteId;//SiteId
@property (strong, nonatomic) NSString<Optional>* homeOwnerId;//HOInternalId
@property (strong, nonatomic) NSString<Optional>* homeOwnerFirstName;//HOFirstName
@property (strong, nonatomic) NSString<Optional>* homeOwnerLastName;//HOLastName
@property (strong, nonatomic) NSString<Optional>* homeOwnerAddress;//HOAddress
@property (strong, nonatomic) NSString<Optional>* homeOwnerPhone;//HOPhone
@property (strong, nonatomic) NSString<Optional>* appointmentDate;//AppointmentDate
@property (strong, nonatomic) NSString<Optional>* installer;//SaiInstaller
@property (strong, nonatomic) NSString<Optional>* installerId;//SaiInstallerId
@end

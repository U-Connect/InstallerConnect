//
//  ICUserProfile.h
//  InstallerConnect
//
//  Created by Venkat Yennam on 5/26/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface ICUserProfile : JSONModel
@property (strong, nonatomic) NSString<Optional>* email;
@property (strong, nonatomic) NSString<Optional>* firstName;
@property (strong, nonatomic) NSString<Optional>* lastName;
@property (strong, nonatomic) NSString<Optional>* login;
@property (strong, nonatomic) NSString<Optional>* mobilePhone;
@property (strong, nonatomic) NSString<Optional>* secondEmail;
@property (strong, nonatomic) NSString<Optional>* application;
@property (strong, nonatomic) NSString<Optional>* nsInternalId;
@property (strong, nonatomic) NSString<Optional>* partnerId;
@property (strong, nonatomic) NSString<Optional>* role;

@end

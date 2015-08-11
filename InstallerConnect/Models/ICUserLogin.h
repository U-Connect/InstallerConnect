//
//  ICUserLogin.h
//  InstallerConnect
//
//  Created by Venkat Yennam on 5/26/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "ICUserProfile.h"

@interface ICUserLogin : JSONModel
@property (strong, nonatomic) NSString<Optional>* oktaSessionId;
@property (strong, nonatomic) NSString<Optional>* userId;
@property (strong, nonatomic) NSString<Optional>* mfaActive;
@property (strong, nonatomic) NSString<Optional>* cookieToken;
@property (strong, nonatomic) ICUserProfile<Optional>* profile;
@end

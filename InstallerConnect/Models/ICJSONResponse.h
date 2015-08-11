//
//  ICJSONResponse.h
//  InstallerConnect
//
//  Created by Venkat Yennam on 6/8/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface ICJSONResponse : JSONModel
@property (nonatomic, assign) BOOL success;
@property (nonatomic, strong) id<NSObject> data;
@property (nonatomic, strong) NSString *responseString;
@property (nonatomic, strong) NSString *error;
@property (nonatomic, strong) NSString *errorCode;
@property (nonatomic, strong) NSString *errorSummary;
@property (nonatomic, strong) NSDictionary *headers;

@end

//
//  ICUtilities.h
//  InstallerConnect
//
//  Created by Venkat Yennam on 6/15/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICUtilities : NSObject
+ (BOOL)isConnected;
+ (BOOL) NSStringIsValidEmail:(NSString *)checkString;
@end

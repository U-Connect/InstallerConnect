//
//  ICBarCode.h
//  InstallerConnect
//
//  Created by Venkat Yennam on 6/11/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol ICBarCode
@end

@interface ICBarCode : JSONModel
@property (strong, nonatomic) NSString<Optional>* barCode;
@property (strong, nonatomic) NSString<Optional>* data;
@property (strong, nonatomic) NSString<Optional>* type;
@property (strong, nonatomic) NSString<Optional>* length;
@property (strong, nonatomic) NSString<Optional>* page;
@property (strong, nonatomic) NSString<Optional>* rotation;
@property (nonatomic) NSInteger left;
@property (nonatomic) NSInteger top;
@property (nonatomic) NSInteger right;
@property (nonatomic) NSInteger bottom;
@property (strong, nonatomic) NSString<Optional>* File;
@end

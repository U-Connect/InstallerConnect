//
//  ICJSONResponse.m
//  InstallerConnect
//
//  Created by Venkat Yennam on 6/8/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import "ICJSONResponse.h"

@implementation ICJSONResponse 
-(id) init {
    if (!(self = [super init]))
        return nil;
    
    self.success=YES;
    
    return self;
}
@end

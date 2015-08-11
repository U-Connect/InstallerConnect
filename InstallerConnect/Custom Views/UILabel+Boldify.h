//
//  UILabel+Boldify.h
//  InstallerConnect
//
//  Created by Venkat Yennam on 7/16/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Boldify)
- (void) boldSubstring: (NSString*) substring;
- (void) boldRange: (NSRange) range;
@end

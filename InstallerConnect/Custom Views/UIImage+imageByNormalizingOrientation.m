//
//  UIImage+imageByNormalizingOrientation.m
//  InstallerConnect
//
//  Created by Venkat Yennam on 8/12/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import "UIImage+imageByNormalizingOrientation.h"

@implementation UIImage (imageByNormalizingOrientation)
- (UIImage*)imageByNormalizingOrientation {
    if (self.imageOrientation == UIImageOrientationUp)
        return self;
    
    CGSize size = self.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    [self drawInRect:(CGRect){{0, 0}, size}];
    UIImage* normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return normalizedImage;
}
@end

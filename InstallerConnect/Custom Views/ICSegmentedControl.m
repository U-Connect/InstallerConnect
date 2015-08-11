//
//  ICSegmentedControl.m
//  InstallerConnect
//
//  Created by Venkat Yennam on 6/29/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import "ICSegmentedControl.h"

@implementation ICSegmentedControl

// this sends a value changed event even if we reselect the currently selected segment
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSInteger current = self.selectedSegmentIndex;
    [super touchesEnded:touches withEvent:event];
    if (current == self.selectedSegmentIndex) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

@end

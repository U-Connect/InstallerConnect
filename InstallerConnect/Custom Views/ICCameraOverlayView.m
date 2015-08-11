//
//  ICCameraOverlayView.m
//  InstallerConnect
//
//  Created by Venkat Yennam on 6/11/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import "ICCameraOverlayView.h"

@implementation ICCameraOverlayView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Clear the background of the overlay:
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        UIImageView *overlayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlaygraphic.png"]];
        [overlayImageView setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height - 76)];
        [self addSubview:overlayImageView];
        
        // Load the image to show in the overlay:
        UIView *bottomView = [[UIView alloc] init];
        [bottomView setFrame:CGRectMake(frame.origin.x, CGRectGetMaxY(frame)-76, frame.size.width, 76)];
        bottomView.backgroundColor = [UIColor blackColor];
        
        
        UIButton *takePictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [takePictureButton setImage:[UIImage imageNamed:@"Record.png"] forState:UIControlStateNormal];
        [takePictureButton setFrame:CGRectMake(CGRectGetMidX(bottomView.frame)-38, 0, 76, 76)];
        [takePictureButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:takePictureButton];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [cancelButton setFrame:CGRectMake(CGRectGetMaxX(bottomView.frame)-110, 5, 100, 72)];
        [cancelButton addTarget:self action:@selector(cancelPhoto) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:cancelButton];
        
        
        
        [self addSubview:bottomView];
    }
    return self;
}

/*
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Clear the background of the overlay:
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        
        // Load the image to show in the overlay:
        UIImageView *overlayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlaygraphic.png"]];
        [overlayImageView setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
        [self addSubview:overlayImageView];
        
        UIButton *overlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [overlayButton setImage:[UIImage imageNamed:@"scanbutton.png"] forState:UIControlStateNormal];
        [overlayButton setFrame:CGRectMake(CGRectGetMidX(frame) - 30, CGRectGetMaxY(frame)-50, 60, 30)];
        [overlayButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:overlayButton];
    }
    return self;
}
 */

- (void) takePhoto {
    NSLog (@"device orientation = %ld",[UIApplication sharedApplication].statusBarOrientation);
    [self.imagePicker takePicture];
    //NSLog(@"takePicture");
}

- (void)cancelPhoto {
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}

@end

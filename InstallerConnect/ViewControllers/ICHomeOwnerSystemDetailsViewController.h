//
//  ICHomeOwnerSystemDetailsViewController.h
//  InstallerConnect
//
//  Created by Venkat Yennam on 6/10/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICInstallationSiteRecord.h"
#import "MBProgressHUD.h"

@protocol ICHomeOwnerVCDelegate <NSObject>
- (void)barCodesUploaded:(NSString *)barCodes;
@end

@interface ICHomeOwnerSystemDetailsViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, ICHomeOwnerVCDelegate, MBProgressHUDDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) ICInstallationSiteRecord *siteRecord;
@end

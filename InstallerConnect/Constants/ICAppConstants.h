//
//  ICAppConstants.h
//  InstallerConnect
//
//  Created by Venkat Yennam on 6/9/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ICAppConstants <NSObject>

#define ID_SEGUE_HOME_OWNER_SYSTEM_DETAILS                  @"homeOwnerSystemDetails"

#define USER_NAME_HINT_TEXT                                 @"Username"
#define PASSWORD_HINT_TEXT                                  @"Password"
#define USER_NAME_KEY                                       @"SEUsername"
#define PASSWORD_KEY                                        @"SEPassword"
#define REMEMBER_ME_KEY                                     @"SERememberMe"
#define INSTALLER_ROLE                                      @"Installer"
#define LOGIN_VALIDATION_ERROR                              @"Please enter a Username and Password to continue."
#define LOGIN_ROLE_ERROR                                    @"You do not have permisson to access Installer Connect. Please contact admistrator."
#define LOGIN_EROOR                                         @"The Username or Password you entered is incorrect. Please click 'OK' to reenter the Username and Password."

#define TITLE_OK                                            @"OK"
#define TITLE_CANCEL                                        @"Cancel"
#define TITLE_RESET                                         @"Reset"
#define TITLE_RETRY                                         @"Retry"
#define TITLE_CONTINUE                                      @"Continue"
#define TITLE_SCAN                                          @"Scan"
#define TITLE_RESCAN                                        @"Rescan"
#define TITLE_SUBMIT                                        @"Submit"
#define TITLE_SAVE                                          @"Save"
#define TITLE_UPLOAD                                        @"Upload"
#define TITLE_VIEW_DETAILS                                  @"View Details"
#define TITLE_FORGOT_PASSWORD                               @"Reset Password"
#define TITLE_NO_CONNECTIVITY                               @"No Connectivity"
#define TITLE_ERROR                                         @"Error"
#define TITLE_UPLOAD_ERROR                                  @"Upload Error"
#define NO_CONNECTIVITY_MSG                                 @"The internet connection appears to be offline. Please check your settings."
#define RESET_PASSWORD_ERROR                                @"Resetting password failed. Please try again."
#define RESET_PASSWORD_SUCCESS                              @"Your password has been reset successfully. Your new password has been sent to your email address."
#define RESET_PASSWORD_MSG                                  @"To reset your password, Please enter your Username."
#define SITE_RECORDS_DOEST_NOT_EXIST                        @"There are no records. Pull down to refresh."
#define SITE_RECORDS_EROOR                                  @"Failed to retrieve the records. Please try again."
#define HOME_DETAILS_EROOR                                  @"Failed to retrieve the home owner details. Please try again."
#define UPOAD_EROOR                                         @"Failed to upoad barcodes. Please try again."

#define PV_MODULES                                          @"PV Modules"
#define INVERTERS                                           @"Inverter(s)"
#define METERS                                              @"Meter(s)"
#define GATEWAY                                             @"Gateway"
#define PV_MODULES_EXPECTED_MSG                             @"The number of expected PV Modules barcodes to upload : "
#define INVERTERS_EXPECTED_MSG                              @"The number of expected Inverters barcodes to upload : "
#define METERS_EXPECTED_MSG                                 @"The number of expected Meter barcodes to upload : "
#define GATEWAY_EXPECTED_MSG                                @"The number of expected Gateway barcodes to upload : "
#define BARCODES_EXPECTED_MSG                               @"The number of expected barcodes to upload : "
#define BARCODES_DETECTED_MSG                               @"The number of barcodes detected to upload : "
#define BARCODES_ZERO_MSG                                   @"No barcodes found. Please try again."



@end


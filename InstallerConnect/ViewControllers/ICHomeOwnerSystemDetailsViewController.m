//
//  ICHomeOwnerSystemDetailsViewController.m
//  InstallerConnect
//
//  Created by Venkat Yennam on 6/10/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import "ICHomeOwnerSystemDetailsViewController.h"
#import "ICServicesHelper.h"
#import "ICAppConstants.h"
#import "ICCameraOverlayView.h"
#import "ICBarCode.h"
#import "ICBarcodesMapViewController.h"
#import "ICUtilities.h"
#import <CoreMotion/CMMotionManager.h>
#import "UIImage+fixOrientation.h"
#import "ICSegmentedControl.h"
#import "UILabel+Boldify.h"
#import "UIImage+imageByNormalizingOrientation.h"


#define SCAN_ALERT_TAG 1
#define VIEW_ALERT_TAG 2
#define RESCAN_ALERT_TAG 3

@interface ICHomeOwnerSystemDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
//Home Owner
@property (weak, nonatomic) IBOutlet UIView *homeOwnerView;
@property (weak, nonatomic) IBOutlet UILabel *homeOwnerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeOwnerAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeOwnerPhoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeOwnerEmailIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *salesPersonNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *salesPersonPhoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *salesPersonEmailIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *partnerSalesPersonTitleLabel;

//Product Details
@property (weak, nonatomic) IBOutlet UIView *productDetailsView;
@property (weak, nonatomic) IBOutlet UILabel *systemSizeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *inverterMFRTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *inverterQtyTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pvModuleModelTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *monitoringModelTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPVModulesTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalUploadedbarcodesTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalUploadedbarcodesValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *systemSizeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *inverterMFRValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *inverterQtyValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *pvModuleModelValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *monitoringModelValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPVModulesValueLabel;


//Installed Serial Numbers
@property (weak, nonatomic) IBOutlet UIView *serialNumbersView;
@property (weak, nonatomic) IBOutlet ICSegmentedControl *barCodesSegmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;

@property (strong, nonatomic) ICHomeOwner* homeOwnerDetails;
@property (strong, nonatomic) ICSiteDetails* siteDetails;
@property (strong, nonatomic) ICBarCodes* icBarCodes;
@property (strong, nonatomic) NSString* base64ImageData;
@property (strong, nonatomic) UIImage* installtionMapImage;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) NSMutableArray *multiDimBarcodes;
@property (strong, nonatomic) NSMutableArray *readBarCodes;
@property (strong, nonatomic) NSArray *pvModulesBarCodes;
@property (strong, nonatomic) NSArray *inverterBarCodes;
@property (strong, nonatomic) NSArray *meterBarCodes;
@property (strong, nonatomic) NSArray *gatewayBarCodes;
@property (nonatomic) NSInteger nRows;
@property (nonatomic) NSInteger nColumns;
@property (nonatomic) NSInteger uploadedBarCodesCount;
@property (nonatomic) NSInteger expectedBarCodesCount;
@property (strong, nonatomic) NSString *scanAlertTitle;
@property (strong, nonatomic) NSString *scanAlertMessage;
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (nonatomic) UIInterfaceOrientation deviceOrientation;
@property (nonatomic) double rotation;
@property (strong, nonatomic) MBProgressHUD *mbProgressHUD;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (strong, nonatomic) NSMutableArray *monitoringTypes;
@property (nonatomic) NSInteger selectedPickerIndex;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightContraint;
@end

@implementation ICHomeOwnerSystemDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self applyshadowToView:self.homeOwnerView];
    [self applyshadowToView:self.productDetailsView];
    [self applyshadowToView:self.serialNumbersView];
    self.motionManager = [[CMMotionManager alloc] init];
    self.title = @"System Details";
    self.monitoringTypes = [[NSMutableArray alloc] initWithObjects:@"Gateway",@"Locus",nil];
    [self initHomeOwnerDetails];
    [self getHomeOwnerDetails];
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBar.topItem.title = @"System Details";
    [super viewDidAppear:animated];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.scrollView.contentSize = self.contentView.frame.size;
}

-(void) applyshadowToView: (UIView*)view {
    view.layer.shadowOffset = CGSizeMake(1, 1);
    view.layer.shadowColor = [[UIColor grayColor] CGColor];
    view.layer.shadowRadius = 2.0f;
    view.layer.shadowOpacity = 1.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning : YES");
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    // Dispose of any resources that can be recreated.
}

- (void)initHomeOwnerDetails {
    CGRect sizeRect = [UIScreen mainScreen].applicationFrame;
    CGFloat height = sizeRect.size.height;
    if(height > 510) {
        self.viewHeightContraint.constant = height - 44.0f;
    }
    //home owner details
    self.homeOwnerNameLabel.text            =   @"";
    self.homeOwnerAddressLabel.text         =   @"";
    self.homeOwnerPhoneNumberLabel.text     =   @"";
    self.homeOwnerEmailIdLabel.text         =   @"";
    //sales person details
    self.salesPersonNameLabel.text          =   @"";
    self.salesPersonPhoneNumberLabel.text   =   @"";
    self.salesPersonEmailIdLabel.text       =   @"";
    //product details
    self.systemSizeValueLabel.text          =   @"";
    self.inverterMFRValueLabel.text         =   @"";
    self.inverterQtyValueLabel.text         =   @"";
    self.pvModuleModelValueLabel.text       =   @"";
    self.monitoringModelValueLabel.text     =   @"";
    self.totalPVModulesValueLabel.text      =   @"";
    
    self.partnerSalesPersonTitleLabel.text  =   @"";
    self.systemSizeTitleLabel.text          =   @"";
    self.inverterMFRTitleLabel.text         =   @"";
    self.inverterQtyTitleLabel.text         =   @"";
    self.pvModuleModelTitleLabel.text       =   @"";
    self.monitoringModelTitleLabel.text     =   @"";
    self.totalPVModulesTitleLabel.text      =   @"";
    
    self.totalUploadedbarcodesTitleLabel.text = @"";
    self.totalUploadedbarcodesValueLabel.text = @"";
    
    self.barCodesSegmentedControl.selectedSegmentIndex = 0;
    self.selectedPickerIndex = -1;
    self.pvModulesBarCodes = nil;
    self.inverterBarCodes = nil;
    self.meterBarCodes = nil;
    self.gatewayBarCodes = nil;
    
    //self.readBarCodes = [[NSMutableArray alloc] init];
    self.multiDimBarcodes = [[NSMutableArray alloc] init];
    self.nRows = 0;
    self.nColumns = 0;
}

- (void)updateHomeOwnerDetails {
    //home owner details
    self.homeOwnerNameLabel.text            = [NSString stringWithFormat:@"%@ %@", self.homeOwnerDetails.firstName, self.homeOwnerDetails.lastName];
    self.homeOwnerAddressLabel.text         = [NSString stringWithFormat:@"%@ \n%@ %@", self.homeOwnerDetails.street, self.homeOwnerDetails.state, self.homeOwnerDetails.zip];
    self.homeOwnerPhoneNumberLabel.text     = self.homeOwnerDetails.homePhone;
    self.homeOwnerEmailIdLabel.text         = self.homeOwnerDetails.email;
    //sales person details
    self.salesPersonNameLabel.text          = self.homeOwnerDetails.salespersonName;
    self.salesPersonPhoneNumberLabel.text   = self.homeOwnerDetails.salespersonCellPhone;
    self.salesPersonEmailIdLabel.text       = self.homeOwnerDetails.salespersonEmail;
    //product details
    self.systemSizeValueLabel.text          = self.homeOwnerDetails.systemSize;
    self.inverterMFRValueLabel.text         = self.homeOwnerDetails.inverterMfrModel;
    self.inverterQtyValueLabel.text         = self.homeOwnerDetails.inverterQuantity;
    self.pvModuleModelValueLabel.text       = self.homeOwnerDetails.pvModuleModel;
    self.monitoringModelValueLabel.text     = self.homeOwnerDetails.monitoringModel;
    self.totalPVModulesValueLabel.text      = self.homeOwnerDetails.totalPVModules;
    
    self.partnerSalesPersonTitleLabel.text  =   @"Sales Person :";
    self.systemSizeTitleLabel.text          =   @"System Size :";
    self.inverterMFRTitleLabel.text         =   @"Inverter Model :";
    self.inverterQtyTitleLabel.text         =   @"Inverter Quantity :";
    self.pvModuleModelTitleLabel.text       =   @"PV Module Model :";
    self.monitoringModelTitleLabel.text     =   @"Monitoring Model :";
    self.totalPVModulesTitleLabel.text      =   @"PV Modules Quantity :";
    self.totalUploadedbarcodesTitleLabel.text = @"Total uploaded barcodes :";
}

- (void)updateSiteDetails {
    self.pvModulesBarCodes = [self.siteDetails.pvSerialNum componentsSeparatedByString:@","];
    self.inverterBarCodes = [self.siteDetails.inverterSerialNum componentsSeparatedByString:@","];
    self.meterBarCodes = [self.siteDetails.meterSerialNum componentsSeparatedByString:@","];
    self.gatewayBarCodes = [self.siteDetails.controllerId componentsSeparatedByString:@","];
    
    [self updateBardCodesStatus:self.barCodesSegmentedControl.selectedSegmentIndex];
}

- (void)barCodesUploaded:(NSString *)barCodes {
    NSArray *barCodesArray = [barCodes componentsSeparatedByString:@","];
    switch (self.barCodesSegmentedControl.selectedSegmentIndex) {
        case 0://PV Modules
            self.pvModulesBarCodes = barCodesArray;
            break;
        case 1://Inverters
            self.inverterBarCodes = barCodesArray;
            break;
        case 2://Meters
            if(self.selectedPickerIndex == 0) {
                self.meterBarCodes = barCodesArray;
            }
            else {
                self.gatewayBarCodes = barCodesArray;
            }
            break;
    }
    [self updateBardCodesStatus:self.barCodesSegmentedControl.selectedSegmentIndex];
}

- (void)getHomeOwnerDetails {
    if([ICUtilities isConnected]) {
        //[self.loadingIndicator startAnimating];
        self.mbProgressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.mbProgressHUD.labelText = @"Loading Details...";
        self.mbProgressHUD.delegate = self;
        ICServicesHelper *servicesHelper = [ICServicesHelper getInstance];
        __block ICJSONResponse *jsonResponse = nil;
        BOOL (^serviceBlock)() = ^() {
            jsonResponse = [servicesHelper getHomeOwnerDetails:self.siteRecord.homeOwnerId];//self.siteRecord.homeOwnerId;
            
            return YES;
        };
        
        void (^mainBlock)() = ^() {
            if(jsonResponse.success) {
                self.homeOwnerDetails = (ICHomeOwner*)jsonResponse.data;
                [self getSiteDetails];
            }
            else {
                [self.loadingIndicator stopAnimating];
                [self showAlert:TITLE_ERROR message:HOME_DETAILS_EROOR];
            }
        };
        
        [AsyncInterfaceTask dispatchBackgroundTask:serviceBlock withInterfaceUpdate:mainBlock];
    }
    else {
        [self showAlert:TITLE_NO_CONNECTIVITY message:NO_CONNECTIVITY_MSG];
    }
}

- (void)getSiteDetails {
    ICServicesHelper *servicesHelper = [ICServicesHelper getInstance];
    __block ICJSONResponse *jsonResponse = nil;
    BOOL (^serviceBlock)() = ^() {
        jsonResponse = [servicesHelper getSiteDetailsByHomeOwenr:self.siteRecord.homeOwnerId];//self.siteRecord.homeOwnerId;
        
        return YES;
    };
    
    void (^mainBlock)() = ^() {
        [self.mbProgressHUD hide:YES];//[self.loadingIndicator stopAnimating];
        [self updateHomeOwnerDetails];
        if(jsonResponse.success) {
            self.siteDetails = (ICSiteDetails*)jsonResponse.data;
            [self updateSiteDetails];
        }
        else {
            
        }
    };
    
    [AsyncInterfaceTask dispatchBackgroundTask:serviceBlock withInterfaceUpdate:mainBlock];
}

- (void)showAlert:(NSString*)title message:(NSString*)message {
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:TITLE_OK otherButtonTitles:nil] show];
}

- (IBAction)segmentSwitch:(UISegmentedControl *)sender {
    if(![self.loadingIndicator isAnimating]) {
        //[self updateBardCodesStatus:sender.selectedSegmentIndex];
        if(sender.selectedSegmentIndex != 2) {
            self.selectedPickerIndex = -1;
            [self updateBardCodesStatus:sender.selectedSegmentIndex];
        }
        else {
            [self showMonitoringActionSheet];
        }
    }
}

- (void)updateBardCodesStatus:(NSInteger)segmentIndex {
    self.uploadedBarCodesCount = 0;
    switch (segmentIndex) {
        case 0://PV Modules
            self.totalUploadedbarcodesTitleLabel.text = @"Total uploaded PV Modules barcodes :";
            self.scanAlertTitle= PV_MODULES;
            self.scanAlertMessage = PV_MODULES_EXPECTED_MSG;
            if(self.pvModulesBarCodes != nil && [self.pvModulesBarCodes count] > 0) {
                self.uploadedBarCodesCount = [self.pvModulesBarCodes count];
                self.totalUploadedbarcodesValueLabel.text = [@([self.pvModulesBarCodes count]) stringValue];
            }
            else {
                self.totalUploadedbarcodesValueLabel.text = @"0";
            }
            self.expectedBarCodesCount = [self.homeOwnerDetails.totalPVModules integerValue];
            break;
        case 1://Inverters
            self.totalUploadedbarcodesTitleLabel.text = @"Total uploaded Inverter barcodes :";
            self.scanAlertTitle= INVERTERS;
            self.scanAlertMessage = INVERTERS_EXPECTED_MSG;
            if(self.inverterBarCodes  != nil && [self.inverterBarCodes count] > 0) {
                self.uploadedBarCodesCount = [self.inverterBarCodes count];
                self.totalUploadedbarcodesValueLabel.text = [@([self.inverterBarCodes count]) stringValue];
            }
            else {
                self.totalUploadedbarcodesValueLabel.text = @"0";
            }
            self.expectedBarCodesCount = [self.homeOwnerDetails.inverterQuantity integerValue];
            break;
        case 2://Meters
            /*self.totalUploadedbarcodesTitleLabel.text = @"Total uploaded Meter barcodes :";
            self.scanAlertTitle= METERS;
            self.scanAlertMessage = METERS_EXPECTED_MSG;
            if(self.meterBarCodes != nil && [self.meterBarCodes count] > 0) {
                self.uploadedBarCodesCount = [self.meterBarCodes count];
                self.totalUploadedbarcodesValueLabel.text = [@([self.meterBarCodes count]) stringValue];
            }
            self.expectedBarCodesCount = 1;*/
            [self updateMonitoringBardCodesStatus];
            break;
    }
    self.totalUploadedbarcodesValueLabel.text = [@(self.uploadedBarCodesCount) stringValue];
    
}

- (void)updateMonitoringBardCodesStatus {
    switch (self.selectedPickerIndex) {
        case 0:
            self.totalUploadedbarcodesTitleLabel.text = @"Total uploaded Meter barcodes :";
            self.scanAlertTitle= METERS;
            self.scanAlertMessage = METERS_EXPECTED_MSG;
            if(self.meterBarCodes != nil && [self.meterBarCodes count] > 0) {
                self.uploadedBarCodesCount = [self.meterBarCodes count];
                self.totalUploadedbarcodesValueLabel.text = [@([self.meterBarCodes count]) stringValue];
            }
            else {
                self.totalUploadedbarcodesValueLabel.text = @"0";
            }
            self.expectedBarCodesCount = 1;
            break;
        case 1:
            self.totalUploadedbarcodesTitleLabel.text = @"Total uploaded Gateway barcodes :";
            self.scanAlertTitle= GATEWAY;
            self.scanAlertMessage = GATEWAY_EXPECTED_MSG;
            if(self.gatewayBarCodes != nil && [self.gatewayBarCodes count] > 0) {
                self.uploadedBarCodesCount = [self.gatewayBarCodes count];
                self.totalUploadedbarcodesValueLabel.text = [@([self.gatewayBarCodes count]) stringValue];
            }
            else {
                self.totalUploadedbarcodesValueLabel.text = @"0";
            }
            self.expectedBarCodesCount = 1;
            break;
    }
}

-(void)showMonitoringActionSheet {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Meter(s)", @"Gateway", nil];
    
    [actionSheet showInView:self.view];
}

- (IBAction)scanButtonTapped:(id)sender {
    if(![self.loadingIndicator isAnimating]) {
        [self showScanAlert];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"Index = %ld - Title = %@", (long)buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
    if(buttonIndex != 2) {
        self.selectedPickerIndex = buttonIndex;
        [self updateMonitoringBardCodesStatus];
    }
    else if(self.selectedPickerIndex == -1) {
        self.barCodesSegmentedControl.selectedSegmentIndex = 0;
    }
}

- (void)launchPickerController {
    self.nRows = 0;
    self.nColumns = 0;
    [self.multiDimBarcodes removeAllObjects];
    self.base64ImageData = nil;
    self.installtionMapImage = nil;
    self.icBarCodes = nil;
    if(self.imagePicker == nil) {
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.allowsEditing = NO;
        self.imagePicker.showsCameraControls = NO;
        self.imagePicker.navigationBarHidden = YES;
        self.imagePicker.toolbarHidden = YES;
        self.imagePicker.extendedLayoutIncludesOpaqueBars = YES;
        //show it
        CGRect layerRect = [[UIScreen mainScreen] bounds];
        ICCameraOverlayView *overlay = [[ICCameraOverlayView alloc] initWithFrame:layerRect];
        overlay.imagePicker = self.imagePicker;
        self.imagePicker.cameraOverlayView = overlay;
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        // establish the height to width ratio of the camera
        float heightRatio = 4.0f / 3.0f;
        // calculate the height of the camera based on the screen width
        float cameraHeight = screenSize.width * heightRatio;
        // calculate the ratio that the camera height needs to be scaled by
        float scale = screenSize.height / cameraHeight;
        self.imagePicker.cameraViewTransform = CGAffineTransformMakeTranslation(0, (screenSize.height - cameraHeight) / 2.0);
        self.imagePicker.cameraViewTransform = CGAffineTransformScale(self.imagePicker.cameraViewTransform, scale, scale);
    }
    //[self startDeviceMotionUpdates];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
}

- (void)showScanAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.scanAlertTitle
                                                    message:[NSString stringWithFormat:@"%@ %ld", BARCODES_EXPECTED_MSG, (long)self.expectedBarCodesCount]
                                                   delegate:self
                                          cancelButtonTitle:TITLE_CANCEL
                                          otherButtonTitles:TITLE_CONTINUE, nil];
    alert.tag = SCAN_ALERT_TAG;
    [alert show];
}

- (void)showViewAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.scanAlertTitle
                                                    message:[NSString stringWithFormat:@"%@ %ld", BARCODES_DETECTED_MSG, (unsigned long)self.icBarCodes.barcodes.count]
                                                   delegate:self
                                          cancelButtonTitle:TITLE_CANCEL
                                          otherButtonTitles:TITLE_CONTINUE, nil];
    alert.tag = VIEW_ALERT_TAG;
    [alert show];
}

- (void)showNoBarcodesAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.scanAlertTitle
                                                    message:BARCODES_ZERO_MSG
                                                   delegate:self
                                          cancelButtonTitle:TITLE_CANCEL
                                          otherButtonTitles:TITLE_RESCAN, nil];
    alert.tag = RESCAN_ALERT_TAG;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == SCAN_ALERT_TAG) {
        if(buttonIndex == 1) {
            //Continue button pressed.
            [self launchPickerController];
        }
    }
    else if(alertView.tag == VIEW_ALERT_TAG) {
        if(buttonIndex == 1) {
            [self createMultiDimensionBarcodesArray];
            [self performSegueWithIdentifier:@"barcodesMapView" sender:self];//barcodesView
        }
    }
    else if(alertView.tag == RESCAN_ALERT_TAG) {
        if(buttonIndex == 1) {
            [self launchPickerController];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    //NSLog (@"imagePickerController dOrientation = %ld, iOrientation = %ld",self.deviceOrientation, orientation);
    //[self stopDeviceMotionUpdates];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    self.mbProgressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.mbProgressHUD.labelText = @"Reading Barcodes";
    self.mbProgressHUD.delegate = self;
    self.mbProgressHUD.dimBackground = YES;
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    image = [image imageByNormalizingOrientation];//[image fixOrientation:self.deviceOrientation]
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    self.installtionMapImage = [UIImage imageWithData:imageData];
    UIImageWriteToSavedPhotosAlbum(self.installtionMapImage, nil, nil, nil);
    NSLog(@"image width = %f , height = %f", self.installtionMapImage.size.width,self.installtionMapImage.size.height);
    [self readBarcodes:imageData];
}

- (void)readBarcodes :(NSData*)imageData {
    __block ICJSONResponse *jsonResponse = nil;
    BOOL (^serviceBlock)() = ^() {
        jsonResponse = [[ICServicesHelper getInstance] readBarcodes:imageData];
        return YES;
    };
    
    void (^mainBlock)() = ^() {
        if(jsonResponse.success) {
            self.icBarCodes = (ICBarCodes*)jsonResponse.data;
            if(self.icBarCodes.barcodes.count > 0) {
                self.base64ImageData = [imageData base64EncodedStringWithOptions:0];
                self.installtionMapImage = [self imageByDrawingRectOnBarCodes:self.installtionMapImage];
                self.readBarCodes = [[NSMutableArray alloc] initWithArray:self.icBarCodes.barcodes copyItems:YES];
                [self showViewAlert];
            }
            else {
                [self showNoBarcodesAlert];
            }
            [self.mbProgressHUD hide:YES];//[self.loadingIndicator stopAnimating];
        }
        else {
            
        }
    };
    
    [AsyncInterfaceTask dispatchBackgroundTask:serviceBlock withInterfaceUpdate:mainBlock];
}

- (UIImage *)imageByDrawingRectOnBarCodes:(UIImage *)image
{
    // begin a graphics context of sufficient size
    UIGraphicsBeginImageContext(image.size);
    
    // draw original image into the context
    [image drawAtPoint:CGPointZero];
    
    // get the context for CoreGraphics
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor * whiteColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    UIColor * lightGrayColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
    UIColor * redColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]; // NEW
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    drawLinearGradientColorForImage(context, imageRect, whiteColor.CGColor, lightGrayColor.CGColor);
    
    for(ICBarCode *icBarocde in self.icBarCodes.barcodes) {
        
        CGRect strokeRect = CGRectMake(icBarocde.left - 2, icBarocde.top - 1,
                                       icBarocde.right - icBarocde.left + 4,
                                       icBarocde.bottom - icBarocde.top + 2);
        strokeRect = CGRectInset(strokeRect, 1, 1);
        CGContextSetStrokeColorWithColor(context, redColor.CGColor);
        CGContextSetLineWidth(context, 8);
        CGContextStrokeRect(context, strokeRect);
    }
    
    // make image out of bitmap context
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    // free the context
    UIGraphicsEndImageContext();
    
    return retImage;
}

void drawLinearGradientColorForImage(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
}

NSComparator comparatorBlock = ^(ICBarCode *icBarcode1, ICBarCode *icBarcode2) {
    if (icBarcode1.top + icBarcode1.left > icBarcode2.top + icBarcode2.left) {
        return (NSComparisonResult)NSOrderedDescending;
    }
    if (icBarcode1.top + icBarcode1.left < icBarcode2.top + icBarcode2.left) {
        return (NSComparisonResult)NSOrderedAscending;
    }
    return (NSComparisonResult)NSOrderedSame;
};

-(void) createMultiDimensionBarcodesArray {
    [self.readBarCodes sortUsingComparator:comparatorBlock];
    while ([self.readBarCodes count] > 0) {
       /* for(ICBarCode *icBarCode in self.readBarCodes) {
            NSLog(@"barcode top = %ld , left = %ld,right = %ld ,bottom = %ld barcodeText = %@", (long)icBarCode.top,(long)icBarCode.left,(long)icBarCode.right,(long)icBarCode.bottom, icBarCode.barCode);
        } */
        [self separateColumnData];
    }
    
   // NSLog(@"nRows = %ld nColumns = %ld mulitBarCodes count = %lu  mulitBarCodes = %@ ", (long)self.nRows,(long)self.nColumns,(unsigned long)[self.multiDimBarcodes count], self.multiDimBarcodes);
}

-(void) separateColumnData {
    NSMutableArray *barCodesColumn = [[NSMutableArray alloc] init];
    NSMutableIndexSet *indexesToDelete = [NSMutableIndexSet indexSet];
    NSUInteger index = 0;
    ICBarCode *minSEBarCode = [self.readBarCodes objectAtIndex:0];
    //NSLog(@"minmum barcode top = %ld , left = %ld,right = %ld ,bottom = %ld barcodeText = %@", (long)minSEBarCode.top,(long)minSEBarCode.left,(long)minSEBarCode.right,(long)minSEBarCode.bottom, minSEBarCode.barCode);
    NSInteger width = minSEBarCode.right - minSEBarCode.left;
    for(ICBarCode *icBarCode in self.readBarCodes) {
        if(icBarCode.left < (minSEBarCode.left + width)) {
            if((minSEBarCode.right - icBarCode.left) > (width/2) ) {
                //NSLog(@"index to delete = %lu", (unsigned long)index);
                [indexesToDelete addIndex:index];
                [barCodesColumn addObject:icBarCode];
            }
        }
        index++;
    }
    
   /* for(ICBarCode *icBarCode in barCodesColumn) {
        NSLog(@"barCodesColumn top = %ld , left = %ld,barcodeText = %@", (long)icBarCode.top,(long)icBarCode.left, icBarCode.barCode);
    }
    */
    
    if([barCodesColumn count] > 0) {
        [self.multiDimBarcodes insertObject:barCodesColumn atIndex:self.nColumns];
        [self.readBarCodes removeObjectsAtIndexes:indexesToDelete];
        self.nColumns++;
        if(self.nRows < [barCodesColumn count]) {
            self.nRows = [barCodesColumn count];
        }
    }
    
   /* for(ICBarCode *icBarCode in self.readBarCodes) {
        NSLog(@"reminaing barcodes barcodeText = %@", icBarCode.barCode);
    }
    */
}

//device motion updates

- (void)startDeviceMotionUpdates {
    if (self.motionManager.deviceMotionAvailable) {
        self.motionManager.deviceMotionUpdateInterval = 0.01f;
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                                withHandler:^(CMDeviceMotion *data, NSError *error) {
                                                    self.rotation = atan2(data.gravity.x, data.gravity.y);
                                                    [self updateDeviceOrientation];
                                                    // NSLog (@"device rotation = %f",self.rotation);
                                                }];
    }
}

- (void)stopDeviceMotionUpdates {
    [self.motionManager stopDeviceMotionUpdates];
}

- (void)updateDeviceOrientation {
    double angle = self.rotation;
    if(angle >= -2.25 && angle <= -0.25)
    {
        if(self.deviceOrientation != UIInterfaceOrientationLandscapeLeft)
        {
            self.deviceOrientation = UIInterfaceOrientationLandscapeLeft;
        }
    }
    else if(angle >= -1.75 && angle <= 0.75)
    {
        if(self.deviceOrientation != UIInterfaceOrientationPortraitUpsideDown)
        {
            self.deviceOrientation = UIInterfaceOrientationPortraitUpsideDown;
        }
    }
    else if(angle >= 0.75 && angle <= 2.25)
    {
        if(self.deviceOrientation != UIInterfaceOrientationLandscapeRight)
        {
            self.deviceOrientation = UIInterfaceOrientationLandscapeRight;
        }
    }
    else if(angle <= -2.25 || angle >= 2.25)
    {
        if(self.deviceOrientation != UIInterfaceOrientationPortrait)
        {
            self.deviceOrientation = UIInterfaceOrientationPortrait;
        }
    }
    
}

#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [self.mbProgressHUD removeFromSuperview];
    self.mbProgressHUD = nil;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ICBarcodesMapViewController *barcodesViewController = (ICBarcodesMapViewController *)[segue destinationViewController];
    barcodesViewController.multiDimBarcodes = self.multiDimBarcodes;
    barcodesViewController.nRows = self.nRows;
    barcodesViewController.nColumns = self.nColumns;
    barcodesViewController.selectedSegmentIndex = self.barCodesSegmentedControl.selectedSegmentIndex;
    barcodesViewController.selectedPickerIndex = self.selectedPickerIndex;
    barcodesViewController.homeOwnerDetails = self.homeOwnerDetails;
    barcodesViewController.siteDetails = self.siteDetails;
    barcodesViewController.base64ImageData = self.base64ImageData;
    barcodesViewController.installtionMapImage = self.installtionMapImage;
    barcodesViewController.icBarCodes = self.icBarCodes;
    barcodesViewController.hoVCdelegate = self;
}


@end

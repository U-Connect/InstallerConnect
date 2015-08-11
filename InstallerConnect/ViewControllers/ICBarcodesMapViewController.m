//
//  ICBarcodesMapViewController.m
//  InstallerConnect
//
//  Created by Venkat Yennam on 6/16/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import "ICBarcodesMapViewController.h"
#import "ICBarcodeGridCell.h"
#import "ICBarCode.h"
#import "ICAppConstants.h"
#import "ICUtilities.h"
#import "MBProgressHUD.h"
#import "UIBarcodeView.h"

#define SUCCESS_ALERT_TAG 1
#define FAILED_ALERT_TAG 2
@interface ICBarcodesMapViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIView *installationMapView;
@property (strong, nonatomic) NSString *barCodesToUpload;
@property (strong, nonatomic) ICUploadBarCodes *icUploadBarCodes;
@property (strong, nonatomic) EXDataGrid *grid;
@property (strong, nonatomic) NSMutableArray *headers;

@end

@implementation ICBarcodesMapViewController

static NSString *identifier = @"DataGridcell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.navigationBar.topItem.title = @"Back";
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    //create instance of DataGrid
    self.grid = [[EXDataGrid alloc] init];
    [self.grid setFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height - 64)];
    //self.grid.dataGridDelegate = self; //set delegate
    //self.grid.bordersWidth = 0.5; //set whidth of the border
    //[self.view addSubview:self.grid]; //and add datagrid as subview
    //[self.view bringSubviewToFront:self.loadingIndicator];
    
    self.imageScrollView.minimumZoomScale = 1.0;
    self.imageScrollView.maximumZoomScale = 6.0;
    self.imageScrollView.contentSize = self.installationMapView.frame.size;
    self.imageScrollView.opaque = NO;
    self.imageScrollView.backgroundColor = [UIColor clearColor];
    
    self.installtionMapImage = [self imageByDrawingRectOnImage:self.installtionMapImage];//[self addBarcodeBorders];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.installtionMapImage];
    imageView.frame = self.installationMapView.bounds;
    imageView.contentMode = UIViewContentModeScaleToFill;
    [self.installationMapView addSubview:imageView];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:TITLE_UPLOAD style:UIBarButtonItemStylePlain target:self action:@selector(uploadBarcodes)];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    [self updateBarCodesToUpload];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.installationMapView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    
}

- (void)addBarcodeBorders {
   /* NSInteger navBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat widthScale = self.installtionMapImage.size.width / screenRect.size.width;
    CGFloat heightScale = self.installtionMapImage.size.height / (screenRect.size.height - navBarHeight);
    
    for(ICBarCode *icBarocde in self.icBarCodes.barcodes) {
       CGRect borderRect = CGRectMake((icBarocde.left/widthScale) - 2, (icBarocde.top/heightScale) - 1,((icBarocde.right - icBarocde.left)/widthScale) + 4, ((icBarocde.bottom - icBarocde.top)/heightScale) + 2);
        UIBarcodeView *barcodeView = [[UIBarcodeView alloc] initWithFrame:borderRect];
        barcodeView.opaque = NO;
        [self.installationMapView addSubview:barcodeView];
        CGRect strokeRect = CGRectMake(icBarocde.left, icBarocde.top,
                                       icBarocde.right - icBarocde.left,
                                       icBarocde.bottom - icBarocde.top);
        self.installtionMapImage = [self imageByDrawingRectOnImage:self.installtionMapImage rect:strokeRect];
    }*/
    
}

- (UIImage *)imageByDrawingRectOnImage:(UIImage *)image
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
    drawLinearGradientColor(context, imageRect, whiteColor.CGColor, lightGrayColor.CGColor);
    
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

void drawLinearGradientColor(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
}

- (void)updateBarCodesToUpload {
    self.barCodesToUpload = @"";
    for (int row=0; row < self.nRows; row++) {
        for (int col=0; col < self.multiDimBarcodes.count; col++) {
            NSMutableArray *columnData = [self.multiDimBarcodes objectAtIndex:col];
            if([columnData count] > row) {
                ICBarCode *icBarCode = (ICBarCode*)[columnData objectAtIndex:row];
                self.barCodesToUpload = [NSString stringWithFormat:@"%@,%@", self.barCodesToUpload,icBarCode.barCode];
            }
        }
    }
    if ([self.barCodesToUpload hasPrefix:@","] && [self.barCodesToUpload length] > 1) {
        self.barCodesToUpload = [self.barCodesToUpload substringFromIndex:1];
    }
    
    self.icUploadBarCodes = [[ICUploadBarCodes alloc] init];
    self.icUploadBarCodes.Base64LayoutImage = self.base64ImageData;
    self.icUploadBarCodes.LayoutfileName = self.homeOwnerDetails.homeOwnerId;
    self.icUploadBarCodes.PartnerName = self.homeOwnerDetails.partnerName;
    switch (self.selectedSegmentIndex) {
        case 0:
            self.icUploadBarCodes.PVSerialNo = self.barCodesToUpload;
            self.title = @"PV Modules";
            self.icUploadBarCodes.LayoutfileName = [self.icUploadBarCodes.LayoutfileName stringByAppendingString:@"_PVModules"];
            break;
        case 1:
            self.icUploadBarCodes.InverterSerialNo = self.barCodesToUpload;
            self.title = @"Inverter(s)";
            self.icUploadBarCodes.LayoutfileName = [self.icUploadBarCodes.LayoutfileName stringByAppendingString:@"_Inverters"];
            break;
        case 2:
            if(self.selectedPickerIndex == 0) {
                self.icUploadBarCodes.MeterSerialNo = self.barCodesToUpload;
                self.title = @"Meter(s)";
                self.icUploadBarCodes.LayoutfileName = [self.icUploadBarCodes.LayoutfileName stringByAppendingString:@"_Meters"];
            }
            else {
                self.icUploadBarCodes.ControllerId = self.barCodesToUpload;
                self.title = @"Gateway";
                self.icUploadBarCodes.LayoutfileName = [self.icUploadBarCodes.LayoutfileName stringByAppendingString:@"_Gateway"];
            }
            break;
    }
}

- (void) uploadBarcodes {
    if([ICUtilities isConnected]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Uploading Data";
        hud.dimBackground = YES;
        ICServicesHelper *servicesHelper = [ICServicesHelper getInstance];
        __block ICJSONResponse *jsonResponse = nil;
        BOOL (^serviceBlock)() = ^() {
            jsonResponse = [servicesHelper uploadBarCodes:self.icUploadBarCodes forSiteId:self.homeOwnerDetails.siteId];
            
            return YES;
        };
        
        void (^mainBlock)() = ^() {
            [hud hide:YES];//[self.loadingIndicator stopAnimating];
            if(jsonResponse.success) {
                [self showSuccessAlert];
            }
            else {
                [self showAlert:TITLE_UPLOAD_ERROR message:UPOAD_EROOR];
            }
        };
        
        [AsyncInterfaceTask dispatchBackgroundTask:serviceBlock withInterfaceUpdate:mainBlock];
    }
    else {
        [self showAlert:TITLE_NO_CONNECTIVITY message:NO_CONNECTIVITY_MSG];
    }
}

- (void)showAlert:(NSString*)title message:(NSString*)message {
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:TITLE_OK otherButtonTitles:nil] show];
}

- (void)showSuccessAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"Upload sucessful."
                                                   delegate:self
                                          cancelButtonTitle:TITLE_OK
                                          otherButtonTitles:nil];
    alert.tag = SUCCESS_ALERT_TAG;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == SUCCESS_ALERT_TAG) {
        if(buttonIndex == 0) {
            [self.hoVCdelegate barCodesUploaded:self.barCodesToUpload];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


#pragma mark - EXDataGridMethods
- (int)numberOfRowsInDataGrid:(EXDataGrid *)dataGrid
{
    return (int)self.nRows;
}

- (int)numberOfColumnsInDataGrid:(EXDataGrid*)dataGrid;
{
    return (int)[self.multiDimBarcodes count];
}

- (float)dataGrid:(EXDataGrid *)dataGrid heightOfRow:(int)rowNumber
{
    return 80;
    
}

- (float)dataGrid:(EXDataGrid *)dataGrid widthOfColumn:(int)columnNumber
{
    return 140 ;
}

- (EXDataGridCell*)dataGrid:(EXDataGrid *)dataGrid cellForColumn:(int)columnNumber row:(int)rowNumber
{
    ICBarcodeGridCell *cell = (ICBarcodeGridCell*)[dataGrid cellDequeueReusableIdentifier:identifier forColumn:columnNumber];
    if(!cell) {
        cell = [[ICBarcodeGridCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSMutableArray *columnData = [self.multiDimBarcodes objectAtIndex:columnNumber];
    if([columnData count] > rowNumber) {
        ICBarCode *icBarCode = (ICBarCode*)[columnData objectAtIndex:rowNumber];
        cell.barcodeLabel.text = icBarCode.barCode;
        cell.barcodeImageView.image = [UIImage imageNamed:@"Barcode.png"];
    }
    else {
        cell.barcodeLabel.text =  @"";
        cell.barcodeImageView.image = nil;
    }
    return cell;
}

- (void)dataGrid:(EXDataGrid *)dataGrid didSelectColumn:(int)columnNumber
{
    NSLog(@"Did select column %d",columnNumber);
}

- (void)dataGrid:(EXDataGrid *)dataGrid didSelectCellAtColumn:(int)columnNumber row:(int)rowNumber
{
    NSLog(@"Did selected cell at column %d and row %d",columnNumber, rowNumber);
}

- (float)headerViewHeight
{
    return 40;
}

- (NSString*)titleForColumn:(int)columnNumber
{
    return [@(columnNumber +1) stringValue];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

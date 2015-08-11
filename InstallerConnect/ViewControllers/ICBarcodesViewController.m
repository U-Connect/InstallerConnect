//
//  ICBarcodesViewController.m
//  InstallerConnect
//
//  Created by Venkat Yennam on 6/12/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import "ICBarcodesViewController.h"
#import "ICBarcodeTableViewCell.h"
#import "ICBarcodeCollectionViewCell.h"
#import "ICBarCode.h"
#import "ICAppConstants.h"
#import "ICUtilities.h"

@interface ICBarcodesViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UITableView *barCodesTableView;
@property (strong, nonatomic) NSString *barCodesToUpload;
@property (strong, nonatomic) ICUploadBarCodes *icUploadBarCodes;
@end

@implementation ICBarcodesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:TITLE_UPLOAD style:UIBarButtonItemStylePlain target:self action:@selector(uploadBarcodes)];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self updateBarCodesToUpload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    switch (self.selectedSegmentIndex) {
        case 0:
            self.icUploadBarCodes.PVSerialNo = self.barCodesToUpload;
            break;
        case 1:
            self.icUploadBarCodes.InverterSerialNo = self.barCodesToUpload;
            break;
        case 2:
            self.icUploadBarCodes.MeterSerialNo = self.barCodesToUpload;
            break;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.nRows;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ICBarcodeTableViewCell *cell = (ICBarcodeTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"barcodeTableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(ICBarcodeTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setCollectionViewDataSourceDelegate:self index:indexPath.row];
}

#pragma mark - UICollectionViewDataSource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.multiDimBarcodes count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ICBarcodeCollectionViewCell *cell = (ICBarcodeCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"barcodeCollectionViewCell" forIndexPath:indexPath];
    NSInteger tableRow = collectionView.tag;
    NSMutableArray *columnData = [self.multiDimBarcodes objectAtIndex:indexPath.row];
    if([columnData count] > tableRow) {
        ICBarCode *icBarCode = (ICBarCode*)[columnData objectAtIndex:tableRow];
        cell.barCodeCoumnNumberLabel.text = [NSString stringWithFormat:@"%ld",(long)(indexPath.row + 1)];
        cell.barCodeLabel.text = icBarCode.barCode;
    }
    else {
        cell.barCodeCoumnNumberLabel.text = @"";
        cell.barCodeLabel.text =  @"";
    }
    return cell;
}

- (void) uploadBarcodes {
    if([ICUtilities isConnected]) {
    [self.loadingIndicator startAnimating];
    ICServicesHelper *servicesHelper = [ICServicesHelper getInstance];
    __block ICJSONResponse *jsonResponse = nil;
    BOOL (^serviceBlock)() = ^() {
        jsonResponse = [servicesHelper uploadBarCodes:self.icUploadBarCodes forSiteId:self.homeOwnerDetails.siteId];
        
        return YES;
    };
    
    void (^mainBlock)() = ^() {
        [self.loadingIndicator stopAnimating];
        if(jsonResponse.success) {
            [self showSuccessAlert];
        }
        else {
            [self showAlert:TITLE_ERROR message:UPOAD_EROOR];
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
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0) {
         [self.navigationController popViewControllerAnimated:YES];
    }
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

//
//  ICInstallationSitesTableViewController.m
//  InstallerConnect
//
//  Created by Venkat Yennam on 6/9/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import "ICInstallationSitesTableViewController.h"
#import "ICServicesHelper.h"
#import "ICAppConstants.h"
#import "ICHomeOwnerTableViewCell.h"
#import "ICHomeOwnerSystemDetailsViewController.h"
#import "ICUtilities.h"



@interface ICInstallationSitesTableViewController ()
@property (weak, nonatomic) IBOutlet UITableView *installtionSitesTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (strong, nonatomic) ICInstallationSites *installationSites;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) ICInstallationSiteRecord *selectedSiteRecord;
@property (strong, nonatomic) MBProgressHUD *mbProgressHUD;
@property (nonatomic, strong) NSMutableArray *searchResult;
@end

@implementation ICInstallationSitesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.errorLabel.hidden = YES;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Log Out" style:UIBarButtonItemStylePlain target:self action:@selector(logOut)];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.installtionSitesTableView addSubview:self.refreshControl];
    
    [self.searchDisplayController.searchResultsTableView registerClass:[ICHomeOwnerTableViewCell class]
                                                forCellReuseIdentifier:@"homeOwnerCell"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //[self.loadingIndicator startAnimating];
    [self getAssignedSiteRecords];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) logOut {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self hideErrorLabel];
    [self getAssignedSiteRecords];
}

- (void)getAssignedSiteRecords {
    if([ICUtilities isConnected]) {
        self.mbProgressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.mbProgressHUD.labelText = @"Loading...";
        self.mbProgressHUD.delegate = self;
        ICServicesHelper *servicesHelper = [ICServicesHelper getInstance];
        __block ICJSONResponse *jsonResponse = nil;
        BOOL (^serviceBlock)() = ^() {
            jsonResponse = [servicesHelper getAssignedInstallations:servicesHelper.userLogin.profile.partnerId];//servicesHelper.userLogin.profile.partnerId @"313746" @"314198" @"300801"
            return YES;
        };
        
        void (^mainBlock)() = ^() {
            [self.mbProgressHUD hide:YES];//[self.loadingIndicator stopAnimating];
            [self.refreshControl endRefreshing];
            if(jsonResponse.success) {
                self.installationSites = (ICInstallationSites*)jsonResponse.data;
                if(self.installationSites != nil && [self.installationSites.siteRecords count] > 0) {
                    self.searchResult = [NSMutableArray arrayWithCapacity:[self.installationSites.siteRecords count]];
                    [self hideErrorLabel];
                    [self.installtionSitesTableView reloadData];
                }
                else {
                    [self showErrorLabel];
                }
            }
            else {
                [self showErrorLabel];
                [self showErrorAlert];
            }
        };
        
        [AsyncInterfaceTask dispatchBackgroundTask:serviceBlock withInterfaceUpdate:mainBlock];
    }
    else {
        self.errorLabel.hidden = NO;
        self.errorLabel.text = NO_CONNECTIVITY_MSG;
    }
}

- (void)showErrorLabel {
    self.errorLabel.hidden = NO;
    self.errorLabel.text = SITE_RECORDS_DOEST_NOT_EXIST;
}

- (void)hideErrorLabel {
    self.errorLabel.hidden = YES;
    self.errorLabel.text = @"";
}

- (void)showErrorAlert {
    [[[UIAlertView alloc] initWithTitle:nil
                            message:SITE_RECORDS_EROOR
                            delegate:self
                            cancelButtonTitle:TITLE_CANCEL
                            otherButtonTitles:TITLE_RETRY, nil] show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        //Retry button pressed.
        //[self.loadingIndicator startAnimating];
        [self getAssignedSiteRecords];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [self.searchResult count];
    }
    else
    {
        return [self.installationSites.siteRecords count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    // To "clear" the footer view
    return [UIView new] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ICHomeOwnerTableViewCell *cell = [self.installtionSitesTableView dequeueReusableCellWithIdentifier:@"homeOwnerCell" forIndexPath:indexPath];
    ICInstallationSiteRecord *siteRecord = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        siteRecord = (ICInstallationSiteRecord*)[self.searchResult objectAtIndex:indexPath.row];
    }
    else
    {
        siteRecord = (ICInstallationSiteRecord*)[self.installationSites.siteRecords objectAtIndex:indexPath.row];
    }
    

    cell.homeOwnerNameLabel.text = [NSString stringWithFormat:@"%@ %@", siteRecord.homeOwnerFirstName, siteRecord.homeOwnerLastName];
    cell.phoneNumberLabel.text = siteRecord.homeOwnerPhone;
    cell.addressLabel.text = [siteRecord.homeOwnerAddress stringByReplacingOccurrencesOfString:@"\n" withString:@" "];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    /*cell.homeOwnerView.layer.shadowOffset = CGSizeZero;//CGSizeMake(1, 1);
    cell.homeOwnerView.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
    cell.homeOwnerView.layer.shadowRadius = 4.0f;
    cell.homeOwnerView.layer.shadowOpacity = 0.80f;*/
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        self.selectedSiteRecord = (ICInstallationSiteRecord*)[self.searchResult objectAtIndex:indexPath.row];
    }
    else {
        self.selectedSiteRecord = (ICInstallationSiteRecord*)[self.installationSites.siteRecords objectAtIndex:indexPath.row];
    }
    [self performSegueWithIdentifier:ID_SEGUE_HOME_OWNER_SYSTEM_DETAILS sender:self];
}


//Filtering
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [self.searchResult removeAllObjects];
    NSPredicate *predicateFirstName = [NSPredicate predicateWithFormat:@"homeOwnerFirstName contains[c] %@", searchText];
    NSPredicate *predicateLastName = [NSPredicate predicateWithFormat:@"homeOwnerLastName contains[c] %@", searchText];
    NSPredicate *predicateAddress = [NSPredicate predicateWithFormat:@"homeOwnerAddress contains[c] %@", searchText];
    NSArray *subPredicates = [NSArray arrayWithObjects:predicateFirstName, predicateLastName, predicateAddress, nil];
    NSPredicate *orPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:subPredicates];
    
    self.searchResult = [NSMutableArray arrayWithArray:[self.installationSites.siteRecords filteredArrayUsingPredicate:orPredicate]];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
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
    if ([segue.identifier isEqualToString:ID_SEGUE_HOME_OWNER_SYSTEM_DETAILS]) {
        ICHomeOwnerSystemDetailsViewController *homeOwnerDetailsVC = (ICHomeOwnerSystemDetailsViewController *)segue.destinationViewController;
        homeOwnerDetailsVC.siteRecord = self.selectedSiteRecord;
    }
}


@end

//
//  ICHomeOwner.h
//  InstallerConnect
//
//  Created by Venkat Yennam on 5/28/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "ICLatLng.h"

@interface ICHomeOwner : JSONModel
@property (strong, nonatomic) NSString<Optional>* salesPersonId;//SalesPersonId
@property (strong, nonatomic) NSString<Optional>* partnerCustId;//PartnerCustId
@property (strong, nonatomic) NSString<Optional>* siteId;//SiteId
@property (strong, nonatomic) NSString<Optional>* homeOwnerId;//SunEdCustId
@property (strong, nonatomic) NSString<Optional>* modsolarLeadId;//ModsolarLeadId
@property (strong, nonatomic) NSString<Optional>* partnerId;//PartnerId
@property (strong, nonatomic) NSString<Optional>* proposalIds;//ProposalIds
@property (strong, nonatomic) NSString<Optional>* canvasserId;//CanvasserId

@property (strong, nonatomic) NSString<Optional>* coHLastName;//CoHLastName
@property (strong, nonatomic) NSString<Optional>* coHFirstName;//CoHFirstName
@property (strong, nonatomic) NSString<Optional>* coHEmail;//CoHEmail

@property (strong, nonatomic) NSString<Optional>* firstName;//FirstName
@property (strong, nonatomic) NSString<Optional>* lastName;//LastName
@property (strong, nonatomic) NSString<Optional>* email;//Email
@property (strong, nonatomic) NSString<Optional>* cellPhone;//CellPhone
@property (strong, nonatomic) NSString<Optional>* homePhone;//HomePhone

@property (strong, nonatomic) NSString<Optional>* salespersonName;//SalesPersonName
@property (strong, nonatomic) NSString<Optional>* salespersonCellPhone;//HomePhone
@property (strong, nonatomic) NSString<Optional>* salespersonEmail;//Email
@property (strong, nonatomic) NSString<Optional>* partnerName;//PartnerName
@property (strong, nonatomic) NSString<Optional>* canvasserName;//CanvasserName

@property (strong, nonatomic) NSString<Optional>* street;//Street
@property (strong, nonatomic) NSString<Optional>* city;//City
@property (strong, nonatomic) NSString<Optional>* state;//State
@property (strong, nonatomic) NSString<Optional>* zip;//Zip
@property (strong, nonatomic) ICLatLng<Optional>* latLng;//LatLng

@property (strong, nonatomic) NSString<Optional>* electricalUtility;//ElectricalUtility
@property (strong, nonatomic) NSString<Optional>* avgMonthlyUtilityBill;//AvgMonthlyUtilityBill
@property (strong, nonatomic) NSString<Optional>* purchaseType;//PurchaseType

@property (strong, nonatomic) NSString<Optional>* campaignSubcategory;//CampaignSubcategory
@property (strong, nonatomic) NSString<Optional>* campaignSource;//CampaignSource

@property (strong, nonatomic) NSString<Optional>* lastUpdatedOn;//LastUpdatedOn
@property (strong, nonatomic) NSString<Optional>* contractSignedDate;//ContractSignedDate
@property (strong, nonatomic) NSString<Optional>* pdaApprovedDate;//PdaapprovedDate
@property (strong, nonatomic) NSString<Optional>* pdaUpdateDate;//PdaupdateDate
@property (strong, nonatomic) NSString<Optional>* pdaPhaseStatus;//PdaphaseStatus
@property (strong, nonatomic) NSString<Optional>* contractStatus;//ContractStatus
@property (strong, nonatomic) NSString<Optional>* proposalStatus;//ProposalStatus
@property (strong, nonatomic) NSString<Optional>* creditStatus;//CreditStatus
@property (strong, nonatomic) NSString<Optional>* financingProgram;//FinancingProgram

//Design and production details
@property (strong, nonatomic) NSString<Optional>* inverterMfrModel;//InverterMfrModel
@property (strong, nonatomic) NSString<Optional>* inverterQuantity;//InverterQuantity
@property (strong, nonatomic) NSString<Optional>* monitoringModel;//MonitoringModel
@property (strong, nonatomic) NSString<Optional>* pvModuleModel;//PvModuleModel
@property (strong, nonatomic) NSString<Optional>* systemSize;//SystemSize
@property (strong, nonatomic) NSString<Optional>* totalPVModules;//TotalPVModules

@end

//
//  ICHomeOwner.m
//  InstallerConnect
//
//  Created by Venkat Yennam on 5/28/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import "ICHomeOwner.h"

@implementation ICHomeOwner
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"SalesPersonId"         :   @"salesPersonId",
                                                       @"LastUpdatedOn"         :   @"lastUpdatedOn",
                                                       @"ContractStatus"        :   @"contractStatus",
                                                       @"CoHLastName"           :   @"coHLastName",
                                                       @"CoHFirstName"          :   @"coHFirstName",
                                                       @"Street"                :   @"street",
                                                       @"PdaapprovedDate"       :   @"pdaApprovedDate",
                                                       @"FinancingProgram"      :   @"financingProgram",
                                                       @"ProposalStatus"        :   @"proposalStatus",
                                                       @"PartnerCustId"         :   @"partnerCustId",
                                                       @"CreditStatus"          :   @"creditStatus",
                                                       @"LastName"              :   @"lastName",
                                                       @"PartnerName"           :   @"partnerName",
                                                       @"AvgMonthlyUtilityBill" :   @"avgMonthlyUtilityBill",
                                                       @"PurchaseType"          :   @"purchaseType",
                                                       @"CampaignSubcategory"   :   @"campaignSubcategory",
                                                       @"HomePhone"             :   @"homePhone",
                                                       @"CoHEmail"              :   @"coHEmail",
                                                       @"ElectricalUtility"     :   @"electricalUtility",
                                                       @"FirstName"             :   @"firstName",
                                                       @"Zip"                   :   @"zip",
                                                       @"CampaignSource"        :   @"campaignSource",
                                                       @"ContractSignedDate"    :   @"contractSignedDate",
                                                       @"PdaphaseStatus"        :   @"pdaPhaseStatus",
                                                       @"SiteId"                :   @"siteId",
                                                       @"SunEdCustId"           :   @"homeOwnerId",
                                                       @"ModsolarLeadId"        :   @"modsolarLeadId",
                                                       @"City"                  :   @"city",
                                                       @"SalesPersonName"       :   @"salespersonName",
                                                       @"CanvasserName"         :   @"canvasserName",
                                                       @"PdaupdateDate"         :   @"pdaUpdateDate",
                                                       @"CanvasserId"           :   @"canvasserId",
                                                       @"Email"                 :   @"email",
                                                       @"CellPhone"             :   @"cellPhone",
                                                       @"State"                 :   @"state",
                                                       @"ProposalIds"           :   @"proposalIds",
                                                       @"PartnerId"             :   @"partnerId",
                                                       @"LatLng"                :   @"latLng",
                                                       @"InverterMfrModel"      :   @"inverterMfrModel",
                                                       @"InverterQuantity"      :   @"inverterQuantity",
                                                       @"MonitoringModel"       :   @"monitoringModel",
                                                       @"PvModuleModel"         :   @"pvModuleModel",
                                                       @"SystemSize"            :   @"systemSize",
                                                       @"TotalPVModules"        :   @"totalPVModules",
                                                       @"SalespersonEmail"      :   @"salespersonEmail",
                                                       @"SalespersonCellPhone"  :   @"salespersonCellPhone"
                                                       }];
}
@end

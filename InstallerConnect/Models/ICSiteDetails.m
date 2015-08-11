//
//  ICSiteDetails.m
//  InstallerConnect
//
//  Created by Venkat Yennam on 6/8/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import "ICSiteDetails.h"

@implementation ICSiteDetails

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                @"SalesPersonId"                                :   @"salesPersonId",
                                @"LastUpdatedOn"                                :   @"lastUpdatedOn",
                                @"ApprovedPVRebateApplicationStatus"            :   @"approvedPVRebateApplicationStatus",
                                @"SystemInstallation"                           :   @"systemInstallation",
                                @"SubstantialCompletionDate"                    :   @"substantialCompletionDate",
                                @"GovernmentAuthorizationCertificateStatus"     :   @"governmentAuthorizationCertificateStatus",
                                @"FinalCompletionCertificate"                   :   @"finalCompletionCertificate",
                                @"LastName"                                     :   @"lastName",
                                @"HomePhone"                                    :   @"homePhone",
                                @"FinalPTOStatus"                               :   @"finalPTOStatus",
                                @"BuiltShadingReport"                           :   @"builtShadingReport",
                                @"CustomerAcceptanceForm"                       :   @"customerAcceptanceForm",
                                @"FinalPTO"                                     :   @"finalPTO",
                                @"BuildingInspection"                           :   @"buildingInspection",
                                @"BuiltElectricalDiagram"                       :   @"builtElectricalDiagram",
                                @"Ptophase"                                     :   @"ptophase",
                                @"PromisedInstallDate"                          :   @"promisedInstallDate",
                                @"Ptonotification"                              :   @"ptonotification",
                                @"SubstantialCompletionPaymentStatus"           :   @"substantialCompletionPaymentStatus",
                                @"SiteVisitDate"                                :   @"siteVisitDate",
                                @"BuiltRoofDiagramStatus"                       :   @"builtRoofDiagramStatus",
                                @"SunEdCustId"                                  :   @"sunEdCustId",
                                @"SubstantialCompletionCertificateStatus"       :   @"substantialCompletionCertificateStatus",
                                @"BuiltShadingReportStatus"                     :   @"builtShadingReportStatus",
                                @"CellPhone"                                    :   @"cellPhone",
                                @"Email"                                        :   @"email",
                                @"BuildingInspectionStatus"                     :   @"buildingInspectionStatus",
                                @"SubstantialCompletionCertificate"             :   @"substantialCompletionCertificate",
                                @"PartnerId"                                    :   @"partnerId",
                                @"PvSerialNum"                                  :   @"pvSerialNum",
                                @"PdaapprovalDate"                              :   @"pdaapprovalDate",
                                @"AssignedCPM"                                  :   @"assignedCPM",
                                @"PtopaymentStatus"                             :   @"ptoPaymentStatus",
                                @"Street"                                       :   @"street",
                                @"Lienwaiver"                                   :   @"lienwaiver",
                                @"SiteVisitStatus"                              :   @"siteVisitStatus",
                                @"BuildingPermit"                               :   @"buildingPermit",
                                @"LienwaiverStatus"                             :   @"lienwaiverStatus",
                                @"BuiltElectricalDiagramStatus"                 :   @"builtElectricalDiagramStatus",
                                @"ThreeLineElectricalStatus"                    :   @"threeLineElectricalStatus",
                                @"CustomerAcceptanceFormStatus"                 :   @"customerAcceptanceFormStatus",
                                @"GovernmentAuthorizationCertificate"           :   @"governmentAuthorizationCertificate",
                                @"FirstName"                                    :   @"firstName",
                                @"ThreeLineElectricalUpdateDate"                :   @"threeLineElectricalUpdateDate",
                                @"Zip"                                          :   @"zip",
                                @"ThreeLineElectrical"                          :   @"threeLineElectrical",
                                @"ContractSignedDate"                           :   @"contractSignedDate",
                                @"ShadeAnalysis"                                :   @"shadeAnalysis",
                                @"PdaphaseStatus"                               :   @"pdaPhaseStatus",
                                @"SiteId"                                       :   @"siteId",
                                @"Ptodate"                                      :   @"ptoDate",
                                @"NetMeteringAppDocStatus"                      :   @"netMeteringAppDocStatus",
                                @"InverterSerialNum"                            :   @"inverterSerialNum",
                                @"NetMeteringAppDoc"                            :   @"netMeteringAppDoc",
                                @"BuiltRoofDiagram"                             :   @"builtRoofDiagram",
                                @"BuildingPermitStatus"                         :   @"buildingPermitStatus",
                                @"FinalCompletionCertificateStatus"             :   @"finalCompletionCertificateStatus",
                                @"City"                                         :   @"city",
                                @"ShadeAnalysisStatus"                          :   @"shadeAnalysisStatus",
                                @"ApprovedPVRebateApplication"                  :   @"approvedPVRebateApplication",
                                @"MeterSerialNum"                               :   @"meterSerialNum",
                                @"SystemInstallationStatus"                     :   @"systemInstallationStatus",
                                @"PdaupdateDate"                                :   @"pdaUpdateDate",
                                @"State"                                        :   @"state",
                                @"Address"                                      :   @"address",
                                @"ArrayLayout"                                  :   @"arrayLayout",
                                @"ControllerId"                                 :   @"controllerId",
                                @"ArrayLayoutStatus"                            :   @"arrayLayoutStatus",
                                @"SubstantialCompletionPhase"                   :   @"substantialCompletionPhase"
                                                       }];
    
}

@end

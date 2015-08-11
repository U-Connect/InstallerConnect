//
//  ICServicesHelper.m
//  InstallerConnect
//
//  Created by Venkat Yennam on 6/8/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import "ICServicesHelper.h"

@interface ICServicesHelper ()
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *passWord;
@end

@implementation ICServicesHelper
static ICServicesHelper *defaultHelper = nil;
NSInteger HTTP_OK = 200;
NSInteger HTTP_UNAUTHORIZED = 401;

+ (ICServicesHelper *)getInstance {
    @synchronized(self) {
        if (!defaultHelper) {
            defaultHelper = [[self alloc] init];
        }
    }
    
    return defaultHelper;
}

- (ICJSONResponse*)doLogin:(NSString*)userName passWord:(NSString*)passWord {
    self.userName = userName;
    self.passWord = passWord;
    NSString *url = [NSString stringWithFormat:@"%@/%@", DEFAULT_HOST, LOGIN_SERVICE];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 userName, @"username",
                                 passWord, @"password",
                                 nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:requestData options:0 error:nil];
    [request setValue:@"no-cache" forHTTPHeaderField:@"cache-control"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    
    NSHTTPURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *json = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    ICJSONResponse* jsonResponse = [[ICJSONResponse alloc] init];
    if (([response statusCode] != HTTP_OK) || error) {
        jsonResponse = [jsonResponse initWithString:json error:nil];
        jsonResponse.error = [error localizedDescription];
        jsonResponse.success = NO;
        
        DebugLog(@"Error while logging in:\t%@", jsonResponse.error);
        return jsonResponse;
    }
    //Handel error case here
    /*if ([dict isEqual:[NSNull null]]) {
        jsonResponse.error = @"Login Failed";
        jsonResponse.success = NO;
        
        return jsonResponse;
    }*/
    
    NSError *parsingError;
    ICUserLogin* userLogin = [[ICUserLogin alloc] initWithString:json error:&parsingError];
    jsonResponse.data = userLogin;
    self.userLogin = userLogin;
    return jsonResponse;
}

- (ICJSONResponse*)resetPassword:(NSString*)userName {
    NSString *url = [NSString stringWithFormat:@"%@/%@", DEFAULT_HOST, RESET_PASSWORD_SERVICE];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 userName, @"email",
                                 nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:requestData options:0 error:nil];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *response;
    NSError *error;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    ICJSONResponse* jsonResponse = [[ICJSONResponse alloc] init];
    if (error) {
        jsonResponse.error = [error localizedDescription];
        jsonResponse.success = NO;
        
        DebugLog(@"Error while logging in:\t%@", jsonResponse.error);
        return jsonResponse;
    }
    
    //Handel error case here
    /*if ([dict isEqual:[NSNull null]]) {
     jsonResponse.error = @"Login Failed";
     jsonResponse.success = NO;
     
     return jsonResponse;
     }*/
    
    return jsonResponse;
}

- (ICJSONResponse*)getHomeOwnerDetails:(NSString*)homeOwnerId {
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@", DEFAULT_HOST, HOME_OWNER_SERVICE, homeOwnerId];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [request setValue:@"no-cache" forHTTPHeaderField:@"cache-control"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:self.userLogin.oktaSessionId forHTTPHeaderField:@"x-okta-session-id"];
    [request setHTTPMethod:@"GET"];
    
    NSHTTPURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    ICJSONResponse* jsonResponse = [[ICJSONResponse alloc] init];
    if (([response statusCode] != HTTP_OK) || error) {
        if(([response statusCode] == HTTP_UNAUTHORIZED) || (error.code == -1012)) {
            jsonResponse = [[ICServicesHelper getInstance] doLogin:self.userName passWord:self.passWord];
            if(jsonResponse.success) {
                return [[ICServicesHelper getInstance] getHomeOwnerDetails:homeOwnerId];
            }
            else {
                return jsonResponse;
            }
        }
        else {
            jsonResponse.error = [error localizedDescription];
            jsonResponse.success = NO;
        }
        
        DebugLog(@"Error while logging in:\t%@", jsonResponse.error);
        return jsonResponse;
    }
    NSString *json = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSError *parsingError;
    ICHomeOwner* homeOwner = [[ICHomeOwner alloc] initWithString:json error:&parsingError];
    jsonResponse.data = homeOwner;
    
    return jsonResponse;
}

- (ICJSONResponse*)getSiteDetailsByHomeOwenr:(NSString*)homeOwnerId {
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@", DEFAULT_HOST, SITE_DETAILS_SERVICE, homeOwnerId];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setValue:@"no-cache" forHTTPHeaderField:@"cache-control"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:self.userLogin.oktaSessionId forHTTPHeaderField:@"x-okta-session-id"];
    [request setHTTPMethod:@"GET"];
    
    NSHTTPURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    ICJSONResponse* jsonResponse = [[ICJSONResponse alloc] init];
    if (([response statusCode] != HTTP_OK) || error) {
        if(([response statusCode] == HTTP_UNAUTHORIZED) || (error.code == -1012)) {
            jsonResponse = [[ICServicesHelper getInstance] doLogin:self.userName passWord:self.passWord];
            if(jsonResponse.success) {
                return [[ICServicesHelper getInstance] getSiteDetailsByHomeOwenr:homeOwnerId];
            }
            else {
                return jsonResponse;
            }
        }
        else {
            jsonResponse.error = [error localizedDescription];
            jsonResponse.success = NO;
        }
        
        DebugLog(@"Error while logging in:\t%@", jsonResponse.error);
        return jsonResponse;
    }
    
    NSString *json = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    //Handel error case here
    /*if ([dict isEqual:[NSNull null]]) {
     jsonResponse.error = @"Login Failed";
     jsonResponse.success = NO;
     
     return jsonResponse;
     }*/
    
    NSError *parsingError;
    ICSiteDetails* siteDetails = [[ICSiteDetails alloc] initWithString:json error:&parsingError];
    jsonResponse.data = siteDetails;
    
    return jsonResponse;
}

- (ICJSONResponse*)getAssignedInstallations:(NSString*)partnerId {
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@", DEFAULT_HOST, INSTALLATIONS_JOBS_SERVICE, partnerId];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    //[request setValue:@"no-cache" forHTTPHeaderField:@"cache-control"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:self.userLogin.oktaSessionId forHTTPHeaderField:@"x-okta-session-id"];
    [request setHTTPMethod:@"GET"];
    
    NSHTTPURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    ICJSONResponse* jsonResponse = [[ICJSONResponse alloc] init];
    if (([response statusCode] != HTTP_OK) || error) {
        if(([response statusCode] == HTTP_UNAUTHORIZED) || (error.code == -1012)) {
            jsonResponse = [[ICServicesHelper getInstance] doLogin:self.userName passWord:self.passWord];
            if(jsonResponse.success) {
                return [[ICServicesHelper getInstance] getAssignedInstallations:partnerId];
            }
            else {
                return jsonResponse;
            }
        }
        else {
            jsonResponse.error = [error localizedDescription];
            jsonResponse.success = NO;
        }
        
        DebugLog(@"Error while logging in:\t%@", jsonResponse.error);
        return jsonResponse;
    }
    NSString *json = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    //Handel error case here
    /*if ([dict isEqual:[NSNull null]]) {
     jsonResponse.error = @"Login Failed";
     jsonResponse.success = NO;
     
     return jsonResponse;
     }*/
    
    NSError *parsingError;
   ICInstallationSites* installationSites = [[ICInstallationSites alloc] initWithString:json error:&parsingError];
    jsonResponse.data = installationSites;
    
    return jsonResponse;
}

- (ICJSONResponse*)uploadBarCodes:(ICUploadBarCodes*)barCodes forSiteId:(NSString*)siteId {
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@", DEFAULT_HOST, UPLOAD_SERVICE, siteId];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    NSData *postData = [[barCodes toJSONString] dataUsingEncoding:NSUTF8StringEncoding];
    //[request setValue:@"no-cache" forHTTPHeaderField:@"cache-control"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:self.userLogin.oktaSessionId forHTTPHeaderField:@"x-okta-session-id"];
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *response;
    NSError *error;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    ICJSONResponse* jsonResponse = [[ICJSONResponse alloc] init];
    if (([response statusCode] != HTTP_OK) || error) {
        if(([response statusCode] == HTTP_UNAUTHORIZED) || (error.code == -1012)) {
            jsonResponse = [[ICServicesHelper getInstance] doLogin:self.userName passWord:self.passWord];
            if(jsonResponse.success) {
                return [[ICServicesHelper getInstance] uploadBarCodes:barCodes forSiteId:siteId];
            }
            else {
                return jsonResponse;
            }
        }
        else {
            jsonResponse.error = [error localizedDescription];
            jsonResponse.success = NO;
        }
        
        DebugLog(@"Error while logging in:\t%@", jsonResponse.error);
        return jsonResponse;
    }
    //NSString *json = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    //Handel error case here
    /*if ([dict isEqual:[NSNull null]]) {
     jsonResponse.error = @"Login Failed";
     jsonResponse.success = NO;
     
     return jsonResponse;
     }*/
    
    return jsonResponse;
}

- (ICJSONResponse*)readBarcodes :(NSData*)imageData {
    //NSLog(@"readBarcodes ");
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://wabr.inliteresearch.com/barcodes"]];
    [request setValue:@"nGnui0QC0hCCIxzxiqvTPJG3pssKSJhg" forHTTPHeaderField:@"Authorization"];
    [request setValue:@"103" forHTTPHeaderField:@"tbr"];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:120];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];;
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    // post body
    NSMutableData *body = [NSMutableData data];
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"imageCaption"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", @"Some Caption"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add image data
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=imageName.jpg\r\n", @"imageFormKey"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    NSLog(@"readBarcodes ==> request time ");
    
    NSURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    ICJSONResponse* jsonResponse = [[ICJSONResponse alloc] init];
    if (error) {
        jsonResponse.error = [error localizedDescription];
        jsonResponse.success = NO;
        
        DebugLog(@"Error while logging in:\t%@", jsonResponse.error);
        return jsonResponse;
    }
    NSString *json = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"readBarcodes response ==> %@", json);
    NSError *parsingError;
    ICBarCodes* barcodes = [[ICBarCodes alloc] initWithString:json error:&parsingError];
    jsonResponse.data = barcodes;
    
    return jsonResponse;

}


@end

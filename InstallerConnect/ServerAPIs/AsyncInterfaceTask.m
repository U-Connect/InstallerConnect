//
//  AsyncInterfaceTask.m
//  QumuSDK
//
//  Created by Edward Majcher on 4/11/12.
//  Copyright (c) 2012 Qumu. All rights reserved.
//

#import "AsyncInterfaceTask.h"
#import <CommonCrypto/CommonDigest.h>

@implementation AsyncInterfaceTask

static NSObject* navigationMutex;

//weak reference to the last navigation task submiited to dispatchNavigationBackgroundTask
static CFUUIDRef lastNavTaskId;

+(void)initialize {
    navigationMutex = [[NSObject alloc]init];
    lastNavTaskId = nil;
}

+(void)dispatchBackgroundTask:(BOOL (^)()) bTask withInterfaceUpdate:(void (^)()) mTask {
    dispatch_queue_t asyncQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
    dispatch_async(asyncQueue, ^{
        @autoreleasepool {		
        
            if (bTask()) {      
                dispatch_sync(dispatch_get_main_queue(), mTask);
            }
        
        }
    });
}

+(void)dispatchNavigationBackgroundTask:(BOOL (^)()) bTask withInterfaceUpdate:(void (^)()) mTask {
    CFUUIDRef myTaskId;
    
    @synchronized(navigationMutex) {
        myTaskId = CFUUIDCreate(NULL);
        lastNavTaskId = myTaskId;
    }

    dispatch_queue_t asyncQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
    dispatch_async(asyncQueue, ^{
        @autoreleasepool {
            @try {
                @synchronized(navigationMutex) {
                    if (!lastNavTaskId || !CFEqual(myTaskId, lastNavTaskId)) {
                        return;
                    }
                }
                if (bTask()) {
                    @synchronized(navigationMutex) {
                        if (lastNavTaskId && CFEqual(myTaskId, lastNavTaskId)) {
                            lastNavTaskId = NULL;
                            dispatch_sync(dispatch_get_main_queue(), mTask);
                        }
                    }
                }
            } @finally {
                CFRelease(myTaskId);
            }
        }
    });
}

@end
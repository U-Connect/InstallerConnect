//
//  AsyncInterfaceTask.h
//  QumuSDK
//
//  Created by Edward Majcher on 4/11/12.
//  Copyright (c) 2012 Qumu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL (^AsyncBgBlock_t)();
typedef void (^AsyncFgBlock_t)();


@interface AsyncInterfaceTask : NSObject 

/**
 Submits a pair of blocks to GCD asynchronously, the first block returns a BOOL and if it evaluates to YES,
 the second will be executed.
 */
+(void)dispatchBackgroundTask:(AsyncBgBlock_t) bTask withInterfaceUpdate:(AsyncFgBlock_t) mTask;

/**
 Submits a pair of blocks to GCD asynchrounsly, but will only ever execute one of them if multiple are submitted
 during the execution of another pair of blocks.  The last pair of blocks submitted will always superseed any subsequent
 blocks submitted.  A typical usage is to register only one click in the user interface for navigating accross pages.
 */
+(void)dispatchNavigationBackgroundTask:(AsyncBgBlock_t) bTask withInterfaceUpdate:(AsyncFgBlock_t) mTask;

@end

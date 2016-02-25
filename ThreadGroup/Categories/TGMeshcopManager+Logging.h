//
//  TGMeshcopManager+Logging.h
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 8/13/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGMeshcopManager.h"

@interface TGMeshcopManager (Logging)

- (NSString *)logStringForManagementParameter:(MCMgmtParamID_t)parameter;
- (NSString *)logStringForCallbackIdentifier:(MCCallback_t)callbackType;

@end

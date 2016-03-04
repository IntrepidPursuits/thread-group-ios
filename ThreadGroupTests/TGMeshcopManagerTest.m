//
//  TGMeshcopManagerTest.m
//  ThreadGroup
//
//  Created by Stephen Wong on 3/2/16.
//  Copyright © 2016 Intrepid Pursuits. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TGMeshcopManager.h"

@interface TGMeshcopManagerTest : XCTestCase

@end

@implementation TGMeshcopManagerTest

- (void)testSharedManager {
    XCTAssertNotNil([TGMeshcopManager sharedManager]);
}
@end

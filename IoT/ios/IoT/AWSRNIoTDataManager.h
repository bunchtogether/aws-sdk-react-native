//
// Copyright 2010-2016 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the &quot;License&quot;).
// You may not use this file except in compliance with the License.
// A copy of the License is located at
//
// http://aws.amazon.com/apache2.0
//
// or in the &quot;license&quot; file accompanying this file. This file is distributed
// on an &quot;AS IS&quot; BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
// express or implied. See the License for the specific language governing
// permissions and limitations under the License.


#import <Foundation/Foundation.h>
#import <AWSLambda/AWSLambda.h>

#import "RCTEventDispatcher.h"
#import "RCTBridgeModule.h"

@interface AWSRNIoTDataManager : NSObject <RCTBridgeModule>

@property (strong, nonatomic) AWSIoTDataManager* IoTDataManager;

@end


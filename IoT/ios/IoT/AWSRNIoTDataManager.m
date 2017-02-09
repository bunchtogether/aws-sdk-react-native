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
//

#import "AWSRNIoTDataManager.h"
#import "AWSRNHelper.h"
#import "AWSRNCognitoCredentials.h"
#import "RCTLog.h"

@implementation RCTConvert (IoTMQTTStatus)
RCT_ENUM_CONVERTER(AWSIoTMQTTStatus, (@{
                                        @"AWSIoTMQTTStatusUnknown": @(AWSIoTMQTTStatusUnknown),
                                        @"AWSIoTMQTTStatusConnecting": @(AWSIoTMQTTStatusConnecting),
                                        @"AWSIoTMQTTStatusConnected": @(AWSIoTMQTTStatusConnected),
                                        @"AWSIoTMQTTStatusDisconnected": @(AWSIoTMQTTStatusDisconnected),
                                        @"AWSIoTMQTTStatusConnectionRefused": @(AWSIoTMQTTStatusConnectionRefused),
                                        @"AWSIoTMQTTStatusConnectionError": @(AWSIoTMQTTStatusConnectionError),
                                        @"AWSIoTMQTTStatusProtocolError": @(AWSIoTMQTTStatusProtocolError)
                                      }), AWSIoTMQTTStatusUnknown, integerValue)
@end


@implementation AWSRNIoTDataManager{
  AWSIoTDataManager* IoTDataManager;
}
@synthesize bridge = _bridge;

RCT_EXPORT_MODULE(AWSRNIoTClient);

- (NSDictionary *)constantsToExport
{
  return @{
           @"AWSIoTMQTTStatusUnknown": @(AWSIoTMQTTStatusUnknown),
           @"AWSIoTMQTTStatusConnecting": @(AWSIoTMQTTStatusConnecting),
           @"AWSIoTMQTTStatusConnected": @(AWSIoTMQTTStatusConnected),
           @"AWSIoTMQTTStatusDisconnected": @(AWSIoTMQTTStatusDisconnected),
           @"AWSIoTMQTTStatusConnectionRefused": @(AWSIoTMQTTStatusConnectionRefused),
           @"AWSIoTMQTTStatusConnectionError": @(AWSIoTMQTTStatusConnectionError),
           @"AWSIoTMQTTStatusProtocolError": @(AWSIoTMQTTStatusProtocolError)
         }
};

RCT_EXPORT_METHOD(initWithOptions:(NSDictionary *)options){
  AWSRNHelper *helper = [[AWSRNHelper alloc]init];
  AWSRNCognitoCredentials* CognitoCredentials = (AWSRNCognitoCredentials*)[_bridge moduleForName:@"AWSRNCognitoCredentials"];
  int count = 0;
  while(![CognitoCredentials getCredentialsProvider] && count != 5){
    [NSThread sleepForTimeInterval:0.25];
    count++;
  }
  if(![CognitoCredentials getCredentialsProvider]){
    @throw [NSException exceptionWithName:@"InvalidArgument" reason:@"AWSCognitoCredentials is not initialized" userInfo:options];
  }
  AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:[helper regionTypeFromString:[options objectForKey:@"region"]] credentialsProvider:[CognitoCredentials getCredentialsProvider]];
  [AWSIoTDataManager registerIoTDataManagerWithConfiguration:configuration forKey:@"react-native-IoT"];
  [configuration addUserAgentProductToken:@"AWSIoT"];
  self.IoTDataManager = [AWSIoTDataManager IoTDataManagerForKey:@"react-native-IoT"];
}

- void updateConnectionStatus:(AWSIoTMQTTStatus status) {
  NSDictionary *parameters = @{@"status":@(status)};
  [self.bridge.eventDispatcher sendAppEventWithName:@"IoTConnected" body:parameters];
}

RCT_EXPORT_METHOD(connectWithClientId:(NSString *)clientId certificateId:(NSString *)certificateId){
  [self.IoTDataManager connectWithClientId:clientId certificateId:certificateId cleanSession:true statusCallback:self.updateConnectionStatus];
}

RCT_EXPORT_METHOD(connectUsingWebSocketWithClientId:(NSString *)clientId){
  [self.IoTDataManager connectUsingWebSocketWithClientId:clientId cleanSession:true statusCallback:self.updateConnectionStatus];
}

RCT_EXPORT_METHOD(disconnect){
  [self.IoTDataManager disconnect];
}

RCT_EXPORT_METHOD(publishToTopic:(NSString *)topic message:(NSString *)message callback:(RCTResponseSenderBlock)callback){
  BOOL response = [iotDataManager publishString:message onTopic:topic QoS:AWSIoTMQTTQoSMessageDeliveryAttemptedAtLeastOnce];
  NSDictionary *parameters = @{@"response" : [NSNumber numberWithBool:response]};
  callback(@[[NSNull null], parameters]);
};

RCT_EXPORT_METHOD(subscribeToTopic:(NSString *)topic callback:(RCTResponseSenderBlock)callback){
  void (^messageCallback)(NSData *) = ^(NSData *data) {
    NSString *body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self.bridge.eventDispatcher sendAppEventWithName:@"IoTMessage" body:body];
  };
  BOOL response = [self.IoTDataManager subscribeToTopic:topic QoS:AWSIoTMQTTQoSMessageDeliveryAttemptedAtLeastOnce messageCallback:messageCallback];
  NSDictionary *parameters = @{@"response" : [NSNumber numberWithBool:response]};
  callback(@[[NSNull null], parameters]);
};

RCT_EXPORT_METHOD(unsubscribeFromTopic:(NSString *)topic callback:(RCTResponseSenderBlock)callback){
  [self.IoTDataManager unsubscribeTopic:topic];
  NSDictionary *parameters = @{@"response" : [NSNumber numberWithBool:true]};
  callback(@[[NSNull null], parameters]);
};

@end

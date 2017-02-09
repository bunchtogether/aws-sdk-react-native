//
// Copyright 2010-2016 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License").
// You may not use this file except in compliance with the License.
// A copy of the License is located at
//
// http://aws.amazon.com/apache2.0
//
// or in the "license" file accompanying this file. This file is distributed
// on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
// express or implied. See the License for the specific language governing
// permissions and limitations under the License.
//

import React, { Component } from 'react';
import {
  Platform,
  NativeModules,
} from 'react-native';

var IoTDataManager = NativeModules.AWSRNIoTDataManager;

export default class AWSIoTDataManager {
 /*
  * Represents a AWSIoTDataManager class
  * @constructor
  */
  constructor(){

  }
 /*
  * Creates an IoT data manager with the given region and registers it.
  * @param {string} region - the service region
  * @example
  * InstanceOfDynamoDBClient.initWithOptions({"region":"bucketRegion"})
  */
  initWithOptions(options){
    IoTDataManager.initWithOptions(options);
  }

  async connectWithClientId(clientId, certificateId){
    var returnValue = await IoTDataManager.connectWithClientId(clientId, certificateId);
    return returnValue;
  }

  async connectUsingWebSocketWithClientId(clientId){
    var returnValue = await IoTDataManager.connectUsingWebSocketWithClientId(clientId);
    return returnValue;
  }

  async disconnect(){
    await IoTDataManager.disconnect();
  }

  async publishToTopic(topic, message){
    var returnValue = await IoTDataManager.publishToTopic(topic, message);
    return returnValue;
  }

  async subscribeToTopic(topic){
    var returnValue = await IoTDataManager.subscribeToTopic(topic);
    return returnValue;
  }

  async unsubscribeFromTopic(topic){
    var returnValue = await IoTDataManager.unsubscribeFromTopic(topic);
    return returnValue;
  }

}

//
//  CallbackBase.cpp
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 7/22/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#include "CallbackBase.h"
#include <cacommon.h>
#include <cainterface.h>
#include <MeshCop.h>
#include <logger.h>
#include <string>

#define TAG "MeshCop"

void CallbackBase::onPetitionResult(const CallbackResult_COMM_PET *result) {
    OICLog(INFO, TAG, "onPetitionResult called but not implemented");
}

bool CallbackBase::onJoinUrlQuery(const CallbackResult_JOIN_URL *result) {
    OICLog(INFO, TAG, "onJoinUrlQuery called but not implemented");
    if (!result) {
        return false;
    }
    
    return (!result->provisioningURL || !strlen(result->provisioningURL));
}

void CallbackBase::onJoinFinished(const CallbackResult_JOIN_FIN *result, char *vendorStackVersion, int vsvLength, char *vendorData, int vdLength) {
    OICLog(INFO, TAG, "onJoinFinished called but not implemented");
}

void CallbackBase::onErrorResponse(int mcResult, int caResponseResult, char *token, int tokenLength) {
    OICLogv(INFO, TAG, "onErrorResponse called but not implemented: %d, %d", mcResult, caResponseResult);
}

void CallbackBase::onMgmtParamReceivedInt(int mcMgmtParamID, int paramValue) {
    OICLogv(INFO, TAG, "onMgmtParamReceivedInt called but not implemented: %d", paramValue);
}

void CallbackBase::onMgmtParamReceivedStr(int mcMgmtParamID, char* paramValue){
    OICLogv(INFO, TAG, "onMgmtParamReceivedStr called but not implemented: %s", paramValue);
}

void CallbackBase::onMgmtParamReceivedRaw(int mcMgmtParamID, char *paramValue, int paramLength){
    OICLogv(INFO, TAG, "onMgmtParamReceivedRaw called but not implemented: %d", paramLength);
}

void CallbackBase::onMgmtParamReceivedObj(int mcMgmtParamID, MCMgmtSecurityPolicy_t* securityPolicy) {
    OICLog(INFO, TAG, "onMgmtParamReceivedObj called but not implemented.");
}

void CallbackBase::onMgmtParamsSet(bool success, char *token, int tokenLength) {
    OICLogv(INFO, TAG, "onMgmtParamsSet called but not implemented: %d", success);
}

CallbackResult::~CallbackResult() {}

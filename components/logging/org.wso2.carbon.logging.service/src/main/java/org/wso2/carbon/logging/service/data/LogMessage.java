/*
 * Copyright 2005-2007 WSO2, Inc. (http://wso2.com)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.wso2.carbon.logging.service.data;

public class LogMessage {
    private String logMessage;
    private String type;

    public LogMessage(String logMessage, String type){
        this.logMessage = logMessage;
        this.type = type;
    }

    public String getLogMessage() {
        return logMessage;
    }

    public String getType() {
        return type;
    }
}

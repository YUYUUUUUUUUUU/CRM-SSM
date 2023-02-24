package com.sdjtu.crm.commons.utils;

import java.util.UUID;

/**
 * @PROJECT_NAME: CRM-SSM
 * @USER: YUYU
 * @DATE: 2023/2/15 18:20
 * @DESCRIPTION:
 */
public class UuidUtil {
    public static String getUuid(){
        return UUID.randomUUID().toString().replaceAll("-","");
    }
}

package com.sdjtu.crm.commons.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * @PROJECT_NAME: CRM-SSM
 * @USER: YUYU
 * @DATE: 2023/2/14 19:38
 * @DESCRIPTION:    转换日期格式
 */
public class DateFormatUtil {
    /**
     * 将日期格式转为yyyy-MM-dd HH:mm:ss的字符串
     * @param date
     * @return
     */
    public static String DateTimeFromat(Date date){
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return simpleDateFormat.format(date);
    }
}

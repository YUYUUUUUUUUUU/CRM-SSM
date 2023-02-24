package com.sdjtu.crm.workbench.service;

import com.sdjtu.crm.workbench.pojo.Activity;

import java.util.List;
import java.util.Map;

/**
 * @PROJECT_NAME: CRM-SSM
 * @USER: YUYU
 * @DATE: 2023/2/15 16:03
 * @DESCRIPTION:
 */
public interface ActivityService {
    int saveActivity(Activity activity);

    List<Activity> queryActivityByCondictionForPage(Map<String,Object> map);
    int queryCountByCondiction(Map<String,Object> map);

    int dropActivityByIds(String[] ids);
    Activity queryActivityById(String id);

    int modifyActivity(Activity activity);
    List<Activity> queryAllActivity();
}

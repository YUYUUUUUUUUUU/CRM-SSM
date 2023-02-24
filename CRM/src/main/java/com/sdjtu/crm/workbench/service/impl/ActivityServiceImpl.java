package com.sdjtu.crm.workbench.service.impl;

import com.sdjtu.crm.workbench.mapper.ActivityMapper;
import com.sdjtu.crm.workbench.pojo.Activity;
import com.sdjtu.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

/**
 * @PROJECT_NAME: CRM-SSM
 * @USER: YUYU
 * @DATE: 2023/2/15 16:04
 * @DESCRIPTION:
 */
@Service
@Transactional
public class ActivityServiceImpl implements ActivityService {
    @Autowired
    private ActivityMapper activityMapper;
    @Override
    public int saveActivity(Activity activity) {
        return activityMapper.insertActivity(activity);
    }

    @Override
    public List<Activity> queryActivityByCondictionForPage(Map<String, Object> map) {

        return activityMapper.selectActivityByCondictionForPage(map);
    }

    @Override
    public int queryCountByCondiction(Map<String, Object> map) {
        return activityMapper.selectCountyCondiction(map);
    }

    @Override
    public int dropActivityByIds(String[] ids) {
        return activityMapper.deleteActivitiesByIds(ids);
    }

    @Override
    public Activity queryActivityById(String id) {
        return activityMapper.selectActivityById(id);
    }

    @Override
    public int modifyActivity(Activity activity) {
        return activityMapper.updateActivityById(activity);
    }

    @Override
    public List<Activity> queryAllActivity() {
        return activityMapper.selectAllActivity();
    }
}

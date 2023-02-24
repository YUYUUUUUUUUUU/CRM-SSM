package com.sdjtu.crm.workbench.mapper;

import com.sdjtu.crm.workbench.pojo.Activity;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * @PROJECT_NAME: CRM-SSM
 * @USER: YUYU
 * @DATE: 2023/2/15 15:47
 * @DESCRIPTION:
 */
public interface ActivityMapper {
    /**
     * 新增活动信息
     * @param activity
     * @return
     */
    int insertActivity(Activity activity);

    /**
     * 根据条件查询活动，并进行分页
     * @param map
     * @return
     */
    List<Activity> selectActivityByCondictionForPage(Map<String,Object> map);

    /**
     * 根据条件查询活动条数
     * @param map
     * @return
     */
    int selectCountyCondiction(Map<String,Object> map);

    /**
     * 根据id删除活动
     * @param ids
     * @return
     */
    int deleteActivitiesByIds(String[] ids);
    /**
     * 根据id查询活动
     */
    Activity selectActivityById(String id);

    /**
     * 根据id修改活动信息
     * @param activity
     * @return
     */
    int updateActivityById(Activity activity);

    /**
     * 查询所有活动
     * @return
     */
    List<Activity> selectAllActivity();
}

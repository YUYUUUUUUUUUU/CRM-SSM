package com.sdjtu.crm.settings.service;

import com.sdjtu.crm.settings.pojo.User;

import java.util.List;
import java.util.Map;

/**
 * @PROJECT_NAME: CRM-SSM
 * @USER: YUYU
 * @DATE: 2023/2/10 23:29
 * @DESCRIPTION:
 */
public interface UserService {
    /**
     *根据账号密码查询用户信息
     * @param map
     * @return
     */
    User queryUserByLoginActAndPwd(Map<String ,Object> map);

    /**
     * 查询所有在职用户信息
     * @return
     */
    List<User> queryAllUsers();
}

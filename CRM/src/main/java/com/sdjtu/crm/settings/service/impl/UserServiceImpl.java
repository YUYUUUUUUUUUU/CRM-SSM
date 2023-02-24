package com.sdjtu.crm.settings.service.impl;

import com.sdjtu.crm.settings.mapper.UserMapper;
import com.sdjtu.crm.settings.pojo.User;
import com.sdjtu.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

/**
 * @PROJECT_NAME: CRM-SSM
 * @USER: YUYU
 * @DATE: 2023/2/10 23:32
 * @DESCRIPTION:
 */
@Transactional
@Service("userService")
public class UserServiceImpl implements UserService {
    @Autowired
    UserMapper userMapper;
    @Override
    public User queryUserByLoginActAndPwd(Map<String, Object> map) {
        return userMapper.selectByActnoAndPwd(map);
    }

    @Override
    public List<User> queryAllUsers() {
        return userMapper.selectAllUsers();
    }
}

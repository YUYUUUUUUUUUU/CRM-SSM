package com.sdjtu.crm.settings.web.controller;

import com.sdjtu.crm.commons.contants.Contant;
import com.sdjtu.crm.commons.pojo.ReturnMessage;
import com.sdjtu.crm.commons.utils.DateFormatUtil;
import com.sdjtu.crm.settings.pojo.User;
import com.sdjtu.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * @PROJECT_NAME: CRM-SSM
 * @USER: YUYU
 * @DATE: 2023/2/10 21:17
 * @DESCRIPTION:
 */
@RequestMapping("/settings/qx/user")
@Controller
public class UserController {
    @Autowired
    UserService userService;
    @RequestMapping("/toLogin.do")
    public String toLogin(){
        return "settings/qx/user/login";
    }

    @RequestMapping("/islogin.do")
    @ResponseBody
    public Object islogin(@RequestParam("loginAct") String loginAct,
                          @RequestParam("loginPwd")String loginPwd,
                          @RequestParam("isRemPwd")String isRemPwd,
                          HttpServletRequest request,
                          HttpSession session,
                          HttpServletResponse response){
        Map<String,Object> map = new HashMap<>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
        System.out.println(map);
        User user = userService.queryUserByLoginActAndPwd(map);

        ReturnMessage returnMessage=new ReturnMessage();
        if (user==null){
            //账号密码不存在，请重新登录
            returnMessage.setCode(Contant.FAIL_CODE);
            returnMessage.setMessage("账号密码不存在，请重新登录");
        } else{//检查账号是否合法

            if (DateFormatUtil.DateTimeFromat(new Date()).compareTo(user.getExpireTime())>0){
                //登录失败，账号已过期
                returnMessage.setCode(Contant.FAIL_CODE);
                returnMessage.setMessage("账号已过期");
            } else if (!user.getAllowIps().contains(request.getRemoteAddr())) {
                //登录失败，ip不被允许登录
                returnMessage.setCode(Contant.FAIL_CODE);
                returnMessage.setMessage("ip不被允许登录");
            } else if (user.getLockState().equals(0)) {
                //登录失败，该账号已被锁定
                returnMessage.setCode(Contant.FAIL_CODE);
                returnMessage.setMessage("该账号已被锁定");
            }else {
                //登录成功
                returnMessage.setCode(Contant.SUCCESS_CODE);
                //将客户信息存放到Session中
                session.setAttribute(Contant.SESSION_USER,user);
                //判断是否记住密码
                if (isRemPwd.equals("true")){//记住密码则将账号密码存到cookie中等待前端读取
                    Cookie cookie1 = new Cookie(Contant.COOKIE_LOGINACT,user.getLoginAct());
                    cookie1.setMaxAge(10*24*60*60);
                    response.addCookie(cookie1);
                    Cookie cookie2 = new Cookie(Contant.COOKIE_LOGINPWD,user.getLoginPwd());
                    cookie2.setMaxAge(10*24*60*60);
                    response.addCookie(cookie2);
                }else {//不记住密码则删除Cookie
                    Cookie cookie1 = new Cookie(Contant.COOKIE_LOGINACT,"1");
                    cookie1.setMaxAge(0);
                    response.addCookie(cookie1);
                    Cookie cookie2 = new Cookie(Contant.COOKIE_LOGINPWD,"1");
                    cookie2.setMaxAge(0);
                    response.addCookie(cookie2);
                }
            }

        }
        return returnMessage;
    }
    @RequestMapping("/toLogout.do")
    public String logout(HttpSession session,
                         HttpServletResponse response){
        //销毁session对象
        session.invalidate();
        //销毁cookie对象
        Cookie cookie1 = new Cookie(Contant.COOKIE_LOGINACT,"1");
        cookie1.setMaxAge(0);
        response.addCookie(cookie1);
        Cookie cookie2 = new Cookie(Contant.COOKIE_LOGINPWD,"1");
        cookie2.setMaxAge(0);
        response.addCookie(cookie2);
        return "redirect:/";
    }


}

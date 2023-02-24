package com.sdjtu.crm.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @PROJECT_NAME: CRM-SSM
 * @USER: YUYU
 * @DATE: 2023/2/10 21:13
 * @DESCRIPTION:
 */
@Controller
public class IndexController {
    @RequestMapping("/")
    public String toLogin(){
        return "index";
    }
}

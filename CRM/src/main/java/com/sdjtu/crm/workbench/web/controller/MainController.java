package com.sdjtu.crm.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @PROJECT_NAME: CRM-SSM
 * @USER: YUYU
 * @DATE: 2023/2/15 15:15
 * @DESCRIPTION:
 */
@Controller
public class MainController {

    @RequestMapping("/workbench/main/toIndex.do")
    public String tomainindex(){
        return "workbench/main/index";
    }


}

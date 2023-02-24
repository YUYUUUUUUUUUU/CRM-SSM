package com.sdjtu.crm.workbench.web.controller;

import com.sdjtu.crm.commons.contants.Contant;
import com.sdjtu.crm.commons.pojo.ReturnMessage;
import com.sdjtu.crm.commons.utils.DateFormatUtil;
import com.sdjtu.crm.commons.utils.UuidUtil;
import com.sdjtu.crm.settings.pojo.User;
import com.sdjtu.crm.settings.service.UserService;
import com.sdjtu.crm.workbench.pojo.Activity;
import com.sdjtu.crm.workbench.service.ActivityService;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @PROJECT_NAME: CRM-SSM
 * @USER: YUYU
 * @DATE: 2023/2/15 15:26
 * @DESCRIPTION:
 */
@Controller
public class ActivityController {
    @Autowired
    private ActivityService activityService;
    @Autowired
    private UserService userService;
    /**
     * 跳转到活动主页
     */
    @RequestMapping("/workbench/activity/toIndex.do")
    public String toActivity(HttpServletRequest request){
        //将用户信息存放到请求域中
        List<User> users = userService.queryAllUsers();

        request.setAttribute("users",users);
        //转发页面
        return "workbench/activity/index";

    }
    @ResponseBody
    @RequestMapping("workbench/activity/saveActivity.do")
    public Object saveActivity(Activity activity, HttpSession session){
        //给Activity对象的未赋值属性赋值
        activity.setCreateTime(DateFormatUtil.DateTimeFromat(new Date()));
        activity.setId(UuidUtil.getUuid());
        User user = (User) session.getAttribute(Contant.SESSION_USER);
        activity.setCreateBy(user.getId());
        System.out.println(activity.getOwner().length());
        ReturnMessage returnMessage = new ReturnMessage();
        try {
            //保存活动
            int count = activityService.saveActivity(activity);

            //是否保存成功
            if (count==1){
                returnMessage.setCode(Contant.SUCCESS_CODE);
            }else {
                returnMessage.setCode(Contant.FAIL_CODE);
                returnMessage.setMessage("系统繁忙，请稍后重试");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnMessage.setCode(Contant.FAIL_CODE);
            returnMessage.setMessage("系统繁忙，请稍后重试");
        }

        return returnMessage;
    }
    @RequestMapping("/workbench/activity/indexActivityListByCondictionForPage.do")
    @ResponseBody
    public Object indexActivityListByCondictionForPage(String name,String owner,String startDate,
                                                       String endDate,Integer beginPage,Integer pageSize){
        //封装数据
        Map<String,Object> map = new HashMap<>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("beginNo",(beginPage-1)*pageSize);
        map.put("pageSize",pageSize);
        //查询活动列表
        List<Activity> activityList = activityService.queryActivityByCondictionForPage(map);
        //查询活动条数
        int totalRows = activityService.queryCountByCondiction(map);
        //封装查询到的信息
        Map<String,Object> returnMap = new HashMap<>();
        returnMap.put("totalRows",totalRows);
        returnMap.put("activityList",activityList);
        return returnMap;
    }
    @ResponseBody
    @RequestMapping("/workbench/activity/deleteActivities.do")
    public Object deleteActivities(String[] id){
        ReturnMessage returnMessage = new ReturnMessage();
        try {
            System.out.println(id.length);
            for (int i = 0; i < id.length; i++) {
                System.out.println(id[i]);
            }
            int count = activityService.dropActivityByIds(id);
            if (count== id.length){
                returnMessage.setCode(Contant.SUCCESS_CODE);
            }else {
                returnMessage.setCode(Contant.FAIL_CODE);
                returnMessage.setMessage("系统繁忙，请稍后重试");
            }
        } catch (Exception e) {

            returnMessage.setCode(Contant.FAIL_CODE);
            returnMessage.setMessage("系统繁忙，请稍后重试");
            e.printStackTrace();
        }

        return returnMessage;
    }

    /**
     * 将
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping("/workbench/activity/showModifyDetail.do")
    public Object showModifyDetail(String id){
        Activity activity = activityService.queryActivityById(id);
        return activity;
    }
    @ResponseBody
    @RequestMapping("/workbench/activity/modifyActivity.do")
    public Object modifyActivity(Activity activity,HttpSession session){
        //封装参数
        User loginUser = (User) session.getAttribute(Contant.SESSION_USER);
        activity.setEditBy(loginUser.getId());
        activity.setEditTime(DateFormatUtil.DateTimeFromat(new Date()));
        ReturnMessage returnMessage = new ReturnMessage();
        try {
            //更新数据
            int count = activityService.modifyActivity(activity);
            if (count>0){
                returnMessage.setCode(Contant.SUCCESS_CODE);
            }else {
                returnMessage.setCode(Contant.FAIL_CODE);
                returnMessage.setMessage("系统繁忙，请稍后重试");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnMessage.setCode(Contant.FAIL_CODE);
            returnMessage.setMessage("系统繁忙，请稍后重试");
        }
       return returnMessage;

    }
    @RequestMapping("/workbench/activity/exportAllActivityList.do")
    public void exportAllActivityList(HttpServletResponse response)throws Exception{
        //将所有数据查询出来
        List<Activity> activities = activityService.queryAllActivity();
        //将数据存放到excel表格中
        HSSFWorkbook workbook = new HSSFWorkbook();
        HSSFSheet sheet = workbook.createSheet("活动列表");
        //填充表头
        HSSFRow row = sheet.createRow(0);
        HSSFCell cell = row.createCell(0);
        cell.setCellValue("ID");
        cell = row.createCell(1);
        cell.setCellValue("所有人");
        cell = row.createCell(2);
        cell.setCellValue("活动名称");
        cell = row.createCell(3);
        cell.setCellValue("开始日期");
        cell = row.createCell(4);
        cell.setCellValue("结束日期");
        cell = row.createCell(5);
        cell.setCellValue("花费/万元");
        cell = row.createCell(6);
        cell.setCellValue("描述");
        cell = row.createCell(7);
        cell.setCellValue("创建时间");
        cell = row.createCell(8);
        cell.setCellValue("创建人");
        cell = row.createCell(9);
        cell.setCellValue("最近编辑时间");
        cell = row.createCell(10);
        cell.setCellValue("最近编辑人");
        //填充数据
        if (activities!=null&&activities.size()>0){
            Activity activity =null;
            for (int i = 0; i < activities.size(); i++) {
                activity = activities.get(i);
                row = sheet.createRow(i+1);
                cell = row.createCell(0);
                cell.setCellValue(activity.getId());
                cell = row.createCell(1);
                cell.setCellValue(activity.getOwner());
                cell = row.createCell(2);
                cell.setCellValue(activity.getName());
                cell = row.createCell(3);
                cell.setCellValue(activity.getStartDate());
                cell = row.createCell(4);
                cell.setCellValue(activity.getEndDate());
                cell = row.createCell(5);
                cell.setCellValue(activity.getCost());
                cell = row.createCell(6);
                cell.setCellValue(activity.getDescription());
                cell = row.createCell(7);
                cell.setCellValue(activity.getCreateTime());
                cell = row.createCell(8);
                cell.setCellValue(activity.getCreateBy());
                cell = row.createCell(9);
                cell.setCellValue(activity.getEditTime());
                cell = row.createCell(10);
                cell.setCellValue(activity.getEditBy());
            }
        }

        //响应到前端
        response.setContentType("application/octet-stream;charset=UTF-8");
        response.addHeader("Content-Disposition","attachment;filename=activityList.xls");
        OutputStream out = response.getOutputStream();

        workbook.write(out);
        workbook.close();
        out.flush();
    }
}

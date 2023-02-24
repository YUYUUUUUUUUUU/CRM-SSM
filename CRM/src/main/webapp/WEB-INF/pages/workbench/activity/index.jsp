<%@ page import="java.util.List" %>
<%@ page import="com.sdjtu.crm.settings.pojo.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
	<%	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+
	request.getContextPath()+"/";
	%>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet">
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<%--<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>--%>
<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
<%--<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>--%>
<script type="text/javascript">
	var rsc_bs_pag = {
		go_to_page_title: '跳转到',
		rows_per_page_title: '每页显示',
		current_page_label: '页',
		current_page_abbr_label: 'p.',
		total_pages_label: 'of',
		total_pages_abbr_label: '/',
		total_rows_label: 'of',
		rows_info_records: '记录',
		go_top_text: '首页',
		go_prev_text: '上一页',
		go_next_text: '下一页',
		go_last_text: '尾页'
	};
	(function($){

		$.fn.datetimepicker.dates['zh-CN'] = {
			days: ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"],
			daysShort: ["周日", "周一", "周二", "周三", "周四", "周五", "周六", "周日"],
			daysMin:  ["日", "一", "二", "三", "四", "五", "六", "日"],
			months: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
			monthsShort: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
			today: "今天",
			suffix: [],
			meridiem: ["上午", "下午"]
		};
	}(jQuery));
	$(function(){
		$(".myDate").datetimepicker({
			language:"zh-CN",
			format:"yyyy-mm-dd",
			minView:"month",
			initialDate: new Date(),
			autoclose:true,
			clearBtn:true,
			todayBtn:true
		})
		//加载页面过程中将活动列表展示，默认第一页，一页十条
		queryActivityListByCondition(1,10);
		//单机查询按钮进行查询
		$("#queryBtn").click(function () {
			queryActivityListByCondition(1,	$("#pageDiv").bs_pagination("getOption","rowsPerPage"))
		})
		//增加活动按钮，展示模态窗口
		$("#create-activity").click(function (){
			$("#createActivityModal").modal("show")
		})
		//保存活动
		$("#savaBtn").click(function () {
			//获取数据
			var owner = $("#create-marketActivityOwner").val();
			var name = $.trim($("#create-marketActivityName").val())
			var startDate = $.trim($("#create-startTime").val())
			var endDate = $.trim($("#create-endTime").val())
			var cost = $.trim($("#create-cost").val())
			var description = $.trim($("#create-describe").val())
			if (owner==''){
				alert("所有者不能为空")
				return
			}
			if (name==""){
				alert("名称不能为空")
				return;
			}
			if (startDate!=""&&endDate!=""){
				if (startDate>endDate){
					alert("开始日期晚于结束日期")
					return;
				}
			}
			var ret = /^(([1-9]\d*)|0)$/
			if (!ret.test(cost)) {
				alert("成本必须为非零整数")
				return;
			}

			$.ajax({
				url:"workbench/activity/saveActivity.do",
				data:{
					owner:owner,
					name:name,
					startDate:startDate,
					endDate:endDate,
					cost:cost,
					description:description
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if (data.code=="1"){
						$("#createActivityModal").modal("hide")
						$("saveform").reset();
					}else {
						alert(data.message)
						$("#createActivityModal").modal("show")
					}
				}
			})
		})
		//全选按钮设置,全选，全不选
		$("#checkboxAll").click(function () {
			$("#activityTBody input[type='checkbox']").prop("checked",this.checked);
		})
		//动态列表所有条数的checkbox被选择，全选按钮选择，反之不选
		$("#activityTBody").on("click","input[type=checkbox]",function () {
			if ($("#activityTBody input[type='checkbox']:checked ").size()==
					$("#activityTBody input[type='checkbox'] ").size()){
				$("#checkboxAll").prop("checked",true)
			}else {
				$("#checkboxAll").prop("checked",false)

			}
		})
		$("#deleteBtn").click(function () {
			var checkboxs = $("#activityTBody input[type='checkbox']:checked");
			if (checkboxs.size()==0){
				alert("请选择要删除的活动")
				return;
			}
			//收集参数
			var idStr = ""
			$.each(checkboxs,function (index,checkbox) {
				idStr+="id="+checkbox.value+"&"
			})
			idStr =idStr.substring(0,idStr.length-1)
			if (window.confirm("是否确定删除？")){
				$.ajax({
					url:"workbench/activity/deleteActivities.do",
					type:"post",
					data:idStr,
					dataType:"json",
					success:function (data) {
						if (data.code==1){
							queryActivityListByCondition(1,$("#pageDiv").bs_pagination("getOption","rowsPerPage"))
						}else {
							alert(data.message)
						}
					}
				})
			}



		})
		//点击修改按钮获取将要修改的详细信息展示到模态窗口中
		$("#modifyBtn").click(function () {
			//收集验证信息
			var checkboxs = $("#activityTBody input[type='checkbox']:checked")
			if (checkboxs.size()==0){
				alert("请选择要修改的活动")
				return;
			}
			if (checkboxs.size()>1){
				alert("每次只能修改一条活动")
				return;
			}
			var id = checkboxs.val();
			$.ajax({
				url:"workbench/activity/showModifyDetail.do",
				type:"post",
				data:{id:id},
				dataType:"json",
				success:function (data) {
					//向修改的模态窗口赋值
					$("#edit-marketActivityOwner").val(data.owner)
					$("#edit-marketActivityName").val(data.name)
					$("#edit-startTime").val(data.startDate)
					$("#edit-endTime").val(data.endDate)
					$("#edit-cost").val(data.cost)
					$("#edit-describe").val(data.description)
					$("#edit-id").val(data.id)
					//显示模态窗口
					$("#editActivityModal").modal("show")
				}
			})
		})
		$("#savaModifyBtn").click(function () {
			//收集数据
			var owner = $("#edit-marketActivityOwner").val()
			var name = $.trim($("#edit-marketActivityName").val())
			var startDate = $("#edit-startTime").val()
			var endDate = $("#edit-endTime").val()
			var cost = $.trim($("#edit-cost").val())
			var description = $("#edit-describe").val()
			var id = $("#edit-id").val()
			//进行验证功能
			if (owner==''){
				alert("所有者不能为空")
				return
			}
			if (name==""){
				alert("名称不能为空")
				return;
			}
			if (startDate!=""&&endDate!=""){
				if (startDate>endDate){
					alert("开始日期晚于结束日期")
					return;
				}
			}
			var ret = /^(([1-9]\d*)|0)$/
			if (!ret.test(cost)) {
				alert("成本必须为非零整数")
				return;
			}
			$.ajax({
				url:"workbench/activity/modifyActivity.do",
				type:"post",
				data:{
					owner:owner,
					name:name,
					startDate:startDate,
					endDate:endDate,
					cost:cost,
					description:description,
					id:id
				},
				success:function (data) {
					if (data.code==1){
						queryActivityListByCondition($("#pageDiv").bs_pagination("getOption","currentPage"),$("#pageDiv").bs_pagination("getOption","rowsPerPage"))
						$("#editActivityModal").modal("hide")
					}else {
						alert(data.message)
						$("#editActivityModal").modal("show")

					}
				}
			})
		})
		//批量导出按钮添加事件
		$("#exportActivityAllBtn").click(function () {
			window.location.href="workbench/activity/exportAllActivityList.do";
		})
	});
	function queryActivityListByCondition(pageNo,pageSize) {
		//获取参数
		var name = $("#query-name").val();
		var owner = $("#query-owner").val();
		var startDate = $("#query-startDate").val();
		var endDate = $("#query-endDate").val();
		var beginPage = pageNo;
		var pageSize = pageSize;
		$.ajax({
			url: "workbench/activity/indexActivityListByCondictionForPage.do",
			type: "post",
			data: {
				name:name,
				owner:owner,
				startDate:startDate,
				endDate:endDate,
				beginPage:beginPage,
				pageSize:pageSize
			},
			dataType: "json",
			success:function (data) {
				// $("#totalRowB").html(data.totalRows)
				var htmlStr = "";
				$.each(data.activityList,function (index,activity) {
					htmlStr+="<tr class=\"active\">"
					htmlStr+="	<td><input type=\"checkbox\" id='mychebox' value='"+activity.id+"' /></td>"
					htmlStr+="	<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='detail.html';\">"+activity.name+"</a></td>"
					htmlStr+="	<td>"+activity.owner+"</td>"
					htmlStr+="	<td>"+activity.startDate+"</td>"
					htmlStr+="	<td>"+activity.endDate+"</td>"
					htmlStr+="</tr>"
				})
				/*填充列表*/
				$("#activityTBody").html(htmlStr)
				/*翻页共能实现*/
				var totalPages =1;
				if (data.totalRows%pageSize==0){
					totalPages = data.totalRows/pageSize

				}else {
					totalPages = parseInt(data.totalRows/pageSize)+1

				}
				$("#pageDiv").bs_pagination({
					currentPage:beginPage,
					rowsPerPage:pageSize,
					totalRows:data.totalRows,
					totalPages:totalPages,

					visiblePageLinks: 5,
					showGoToPage: true,
					showRowsInfo: true,
					showRowsPerPage: true,

					onChangePage:function (event, pageObject) {

						queryActivityListByCondition(pageObject.currentPage,pageObject.rowsPerPage)
					}
				})
			}

		})

	}

</script>
</head>
<body>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal" role="form" id="saveform">

						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">

								<select class="form-control" id="create-marketActivityOwner">
									<c:forEach items="${requestScope.users}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>

						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label"  >开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control myDate" id="create-startTime" readonly>
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control myDate" id="create-endTime" readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>

					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="savaBtn">保存</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal" role="form">
						<%--被修改的活动的id--%>
						<input type="hidden" id="edit-id" />

						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">
									<c:forEach items="${requestScope.users}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control myDate" id="edit-startTime">
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control myDate" id="edit-endTime" >
							</div>
						</div>

						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" value="5,000">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
							</div>
						</div>

					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="savaModifyBtn">更新</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 导入市场活动的模态窗口 -->
    <div class="modal fade" id="importActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
                </div>
                <div class="modal-body" style="height: 350px;">
                    <div style="position: relative;top: 20px; left: 50px;">
                        请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
                    </div>
                    <div style="position: relative;top: 40px; left: 50px;">
                        <input type="file" id="activityFile">
                    </div>
                    <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                        <h3>重要提示</h3>
                        <ul>
                            <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                            <li>给定文件的第一行将视为字段名。</li>
                            <li>请确认您的文件大小不超过5MB。</li>
                            <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                            <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                            <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                            <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
                </div>
            </div>
        </div>
    </div>


	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">

			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="query-name">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="query-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="text" id="query-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="text" id="query-endDate">
				    </div>
				  </div>

				  <button type="button" class="btn btn-default" id="queryBtn">查询</button>

				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="create-activity"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="modifyBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
                    <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal" ><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
                    <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）</button>
                    <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
                </div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkboxAll"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityTBody">
						<%--<tr class="active">
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">发传单</a></td>
                            <td>zhangsan</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">发传单</a></td>
                            <td>zhangsan</td>
                            <td>2020-10-10</td>
                            <td>2020-10-20</td>
                        </tr>--%>
					</tbody>
				</table>
				<div id="pageDiv"></div>
			</div>

<%--			<div style="height: 50px; position: relative;top: 30px;" id="pageDiv">--%>
<%--				<div>
					<button type="button" class="btn btn-default" style="cursor: default;">共<b id="totalRowB">50</b>条记录</button>
				</div>
				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">
					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>
					<div class="btn-group">
						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
							10
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu" role="menu">
							<li><a href="#">20</a></li>
							<li><a href="#">30</a></li>
						</ul>
					</div>
					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
				</div>
				<div style="position: relative;top: -88px; left: 285px;">
					<nav>
						<ul class="pagination">
							<li class="disabled"><a href="#">首页</a></li>
							<li class="disabled"><a href="#">上一页</a></li>
							<li class="active"><a href="#">1</a></li>
							<li><a href="#">2</a></li>
							<li><a href="#">3</a></li>
							<li><a href="#">4</a></li>
							<li><a href="#">5</a></li>
							<li><a href="#">下一页</a></li>
							<li class="disabled"><a href="#">末页</a></li>
						</ul>
					</nav>
				</div>--%>
<%--			</div>--%>

		</div>

	</div>
</body>
</html>

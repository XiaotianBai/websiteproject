<%@ page language="java" import="java.util.*"  contentType="text/html;charset=UTF-8"%> 
<%@ page import="com.xiaotianbaiproject.po.PostInfo" %>
<%@ page import="com.xiaotianbaiproject.po.UserInfo" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1 , user-scalable=no">
<title>ReplySearch</title>
<link href="<%=basePath %>plugins/bootstrap.css" rel="stylesheet">
<link href="<%=basePath %>plugins/bootstrap-dashen.css" rel="stylesheet">
<link href="<%=basePath %>plugins/font-awesome.css" rel="stylesheet">
<link href="<%=basePath %>plugins/animate.css" rel="stylesheet">
<link href="<%=basePath %>plugins/bootstrap-datetimepicker.min.css" rel="stylesheet" media="screen">
</head>
<body style="margin-top:70px;">
<jsp:include page="../header.jsp"></jsp:include>
<div class="container">
	<div class="row">
		<div class="col-md-12 wow fadeInUp" data-wow-duration="0.5s">
			<div>
				<!-- Nav tabs -->
				<ul class="nav nav-tabs" role="tablist">
			    	<li role="presentation" ><a href="<%=basePath %>Reply/frontlist">ReplyList</a></li>
			    	<li role="presentation" class="active"><a href="#replyAdd" aria-controls="replyAdd" role="tab" data-toggle="tab">AddReply</a></li>
				</ul>
				<!-- Tab panes -->
				<div class="tab-content">
				    <div role="tabpanel" class="tab-pane" id="replyList">
				    </div>
				    <div role="tabpanel" class="tab-pane active" id="replyAdd"> 
				      	<form class="form-horizontal" name="replyAddForm" id="replyAddForm" enctype="multipart/form-data" method="post"  class="mar_t15">
						  <div class="form-group">
						  	 <label for="reply_postInfoObj_postInfoId" class="col-md-2 text-right">OriginalPost:</label>
						  	 <div class="col-md-8">
							    <select id="reply_postInfoObj_postInfoId" name="reply.postInfoObj.postInfoId" class="form-control">
							    </select>
						  	 </div>
						  </div>
						  <div class="form-group">
						  	 <label for="reply_content" class="col-md-2 text-right">ReplyContent:</label>
						  	 <div class="col-md-8">
							    <textarea id="reply_content" name="reply.content" rows="8" class="form-control" placeholder="Input ReplyContent"></textarea>
							 </div>
						  </div>
						  <div class="form-group">
						  	 <label for="reply_userObj_user_name" class="col-md-2 text-right">Replier:</label>
						  	 <div class="col-md-8">
							    <select id="reply_userObj_user_name" name="reply.userObj.user_name" class="form-control">
							    </select>
						  	 </div>
						  </div>
						  <div class="form-group">
						  	 <label for="reply_replyTimeDiv" class="col-md-2 text-right">ReplyTime:</label>
						  	 <div class="col-md-8">
				                <div id="reply_replyTimeDiv" class="input-group date reply_replyTime col-md-12" data-link-field="reply_replyTime">
				                    <input class="form-control" id="reply_replyTime" name="reply.replyTime" size="16" type="text" value="" placeholder="Choose ReplyTime" readonly>
				                    <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
				                    <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
				                </div>
						  	 </div>
						  </div>
								            <div class="form-group">
								            	<span class="col-md-2""></span>
								            	<span onclick="ajaxReplyAdd();" class="btn btn-primary bottom5 top5">Add</span>
								            </div>
						</form> 
				        <style>#replyAddForm .form-group {margin:10px;}  </style>
					</div>
				</div>
			</div>
		</div>
	</div> 
</div>

<jsp:include page="../footer.jsp"></jsp:include> 
<script src="<%=basePath %>plugins/jquery.min.js"></script>
<script src="<%=basePath %>plugins/bootstrap.js"></script>
<script src="<%=basePath %>plugins/wow.min.js"></script>
<script src="<%=basePath %>plugins/bootstrapvalidator/js/bootstrapValidator.min.js"></script>
<script type="text/javascript" src="<%=basePath %>plugins/bootstrap-datetimepicker.min.js" charset="UTF-8"></script>
<script type="text/javascript" src="<%=basePath %>plugins/locales/bootstrap-datetimepicker.en-US.js" charset="UTF-8"></script>
<script>
var basePath = "<%=basePath%>";
	//UploadAddReplyInfo
	function ajaxReplyAdd() { 
		//Upload之前先Validate表单
		$("#replyAddForm").data('bootstrapValidator').validate();
		if(!$("#replyAddForm").data('bootstrapValidator').isValid()){
			return;
		}
		jQuery.ajax({
			type : "post",
			url : basePath + "Reply/add",
			dataType : "json" , 
			data: new FormData($("#replyAddForm")[0]),
			success : function(obj) {
				if(obj.success){ 
					alert("SaveSuccessful！");
					$("#replyAddForm").find("input").val("");
					$("#replyAddForm").find("textarea").val("");
				} else {
					alert(obj.message);
				}
			},
			processData: false, 
			contentType: false, 
		});
	} 
$(function(){
	/*click hide*/
    $('.navbar-collapse a').click(function(){
        $('.navbar-collapse').collapse('hide');
    });
    new WOW().init();
	//ValidateReplyAddForm
	$('#replyAddForm').bootstrapValidator({
		feedbackIcons: {
			valid: 'glyphicon glyphicon-ok',
			invalid: 'glyphicon glyphicon-remove',
			validating: 'glyphicon glyphicon-refresh'
		},
		fields: {
			"reply.content": {
				validators: {
					notEmpty: {
						message: "ReplyContent cannot be empty",
					}
				}
			},
			"reply.replyTime": {
				validators: {
					notEmpty: {
						message: "ReplyTime cannot be empty",
					}
				}
			},
		}
	}); 
	//InitializeOriginalPostValues 
	$.ajax({
		url: basePath + "PostInfo/listAll",
		type: "get",
		success: function(postInfos,response,status) { 
			$("#reply_postInfoObj_postInfoId").empty();
			var html="";
    		$(postInfos).each(function(i,postInfo){
    			html += "<option value='" + postInfo.postInfoId + "'>" + postInfo.pTitle + "</option>";
    		});
    		$("#reply_postInfoObj_postInfoId").html(html);
    	}
	});
	//InitializeReplierValues 
	$.ajax({
		url: basePath + "UserInfo/listAll",
		type: "get",
		success: function(userInfos,response,status) { 
			$("#reply_userObj_user_name").empty();
			var html="";
    		$(userInfos).each(function(i,userInfo){
    			html += "<option value='" + userInfo.user_name + "'>" + userInfo.name + "</option>";
    		});
    		$("#reply_userObj_user_name").html(html);
    	}
	});
	//ReplyTimePart
	$('#reply_replyTimeDiv').datetimepicker({
		language:  'en-US',  //Displaylanguage
		format: 'yyyy-mm-dd hh:ii:ss',
		weekStart: 1,
		todayBtn:  1,
		autoclose: 1,
		minuteStep: 1,
		todayHighlight: 1,
		startView: 2,
		forceParse: 0
	}).on('hide',function(e) {
		//Validate Date
		$('#replyAddForm').data('bootstrapValidator').updateStatus('reply.replyTime', 'NOT_VALIDATED',null).validateField('reply.replyTime');
	});
})
</script>
</body>
</html>

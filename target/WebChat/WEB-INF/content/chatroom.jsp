<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%request.setCharacterEncoding ("UTF-8");%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="zh-cn">
<head>
	<title>WebChat Room</title>
	<script src="//cdn.bootcss.com/jquery/3.2.1/jquery.min.js"></script>
	<link rel="stylesheet" href="//cdn.bootcss.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
	<script src="${pageContext.request.contextPath}/js/ajaxfileupload.js"></script>
	<style>
		body{
			margin-top:20px;
		}
		.toolbar {
			border: 1px solid #ccc;
		}
		.text {
			border: 1px solid #ccc;
			height: 136px;
		}
		.alert-info{
			width:66%;
			float:left;
		}
		.alert-success{
			width:66%;
			float:right;
		}
		.rounded-circle{
			margin:0 auto;
		}
	</style>
</head>
<body>
<div class="container-fluid">
	<div class="row">
		<div class="col-md-3">
			<div class="card  ">
				<div class="card-header ">
					当前登录用户
				</div>
				<div class="card-body">
					<img src="${pageContext.request.contextPath}/images/${sessionScope.uid}.jpg" alt="Zz" class="rounded-circle" width="100" height="100">
					<ul class="list-group list-group-flush">
						<li class="list-group-item ">你好，${sessionScope.username}</li>
					</ul>
				</div>
				<div class="card-body">
					<a href="logout" class="list-group-item ">退出</a>
				</div>
			</div>
			<div class="card " id="online">
				<div class="card-header ">
					当前在线的其他用户
				</div>
				<div class="card-body ">
					<div class="list-group" id="users">
					</div>
				</div>
			</div>
			<div class="card bg-light">
				<div class="card-header">
					群发系统广播
				</div>
				<div class="card-body">
					<div class="input-group">
						<input type="text" class="form-control" id="msg" aria-describedby="basic-addon2">
						<div class="input-group-append">
							<button class="btn btn-outline-secondary" id="broadcast" type="button">发送</button>
						</div>
					</div>
				</div>

			</div>
			<div class="card bg-light">
				<div class="card-body">
					欢迎使用WebChat!<br>
					<a href="http://wh1te.club">My blog</a>
				</div>
			</div>
		</div>
		<div class="col-md-9">
			<div class="card bg-light">
				<div class="card-header">
					<p id="talktitle"></p>
				</div>
				<div class="card-body">
					<div class="well" id="log-container" style="height:455px;overflow-y:scroll">

					</div>
					<div id="toolbar" class="toolbar">
					</div>
					<div id="mymsg" class="text"> <!--可使用 min-height 实现编辑区域自动增加高度-->
					</div>
					<!--<input type="text" id="myinfo" class="form-control col-md-12" /> <br>-->
					<button id="send" type="button" class="btn btn-outline-primary" style="float:right">发送</button>

					<!--ajax动态刷新图片
					<input type="file" name="file" id="file" onchange="uploadImg()">
					<input type="hidden" name="avatar" id="avatar">
					<img src="" alt="" id="avatarShow" width="100px" height="100px">-->
				</div>
			</div>
		</div>
	</div>
</div>
<script>
    $(document).ready(function() {
        // 指定websocket路径
        var websocket;
        if ('WebSocket' in window) {
            websocket = new WebSocket("ws://localhost:8080/ws?uid="+${sessionScope.uid});
        } else if ('MozWebSocket' in window) {
            websocket = new MozWebSocket("ws://localhost:8080/ws"+${sessionScope.uid});
        } else {
            websocket = new SockJS("http://localhost:8080/ws/sockjs"+${sessionScope.uid});
        }
        //var websocket = new WebSocket('ws://localhost:8080/Spring-websocket/ws');
        websocket.onmessage = function(event) {
            var data=JSON.parse(event.data);
            if(data.from>0||data.from==-1){//用户或者群消息:文本消息
                // 接收服务端的实时消息并添加到HTML页面中
                $("#log-container").append("<div class='alert alert-info'><label class='text-danger' >"+data.fromName+"&nbsp;"+data.date+"</label><div class='text-success'>"+data.text+"</div></div><br>");
                // 滚动条滚动到最低部
                scrollToBottom();
            }else if(data.from==0){//上线消息
                if(data.text!="${sessionScope.username}")
                {
                    $("#users").append('<a href="#" onclick="talk(this)" class="list-group-item">'+data.text+'</a>');
                    alert(data.text+"上线了");
                }
            }else if(data.from==-2){//下线消息
                if(data.text!="${sessionScope.username}")
                {
                    $("#users > a").remove(":contains('"+data.text+"')");
                    alert(data.text+"下线了");
                }
            }
        };
        $.post("onlineusers",function(data){
            for(var i=0;i<data.length;i++)
                $("#users").append('<a href="#" onclick="talk(this)" class="list-group-item ">'+data[i]+'</a>');
        });

        $("#broadcast").click(function(){
            $.post("broadcast",{"text":$("#msg").val()});
        });

        $("#send").click(function(){
            $.post("getuid",{"username":$("body").data("to")},function(d){
                var json = editor.txt.getJSON(); // 获取 JSON 格式的内容
				var jsonStr = JSON.stringify(json);
                if(!json){
                    return;
                }else{
                    var data={};
                    data["from"]="${sessionScope.uid}";
                    data["fromName"]="${sessionScope.username}";
                    data["to"]=d.uid;
                    //data["text"]=(json[0].children[0]).toString();
					data["text"]=editor.txt.text();


                    websocket.send(JSON.stringify(data));

                    $("#log-container").append("<div class='alert alert-success'><label class='text-info'>我&nbsp;"+new Date()+"</label><div class='text-info'>"+data["text"]+"</div></div><br><br>");
                    scrollToBottom();
                    editor.txt.clear();
                }
            });

        });






    });

    function talk(a){
        $("#talktitle").text("与"+a.innerHTML+"的聊天");
        $("body").data("to",a.innerHTML);
    }
    function scrollToBottom(){
        var div = document.getElementById('log-container');
        div.scrollTop = div.scrollHeight;
    }

    function sendFile(isWithText){
        var inputElement = document.getElementById("file");
        var fileList = inputElement.files;
        var file=fileList[0];
        if(!file) return;
        websocket.send(file.name+":fileStart");
        var reader = new FileReader();
        //以二进制形式读取文件
        reader.readAsArrayBuffer(file);
        //文件读取完毕后该函数响应
        reader.onload = function loaded(evt) {
            var blob = evt.target.result;
            //发送二进制表示的文件
            websocket.send(blob);
            if(isWithText){
                websocket.send(file.name+":fileFinishWithText");
            }else{
                websocket.send(file.name+":fileFinishSingle");
            }
            console.log("finnish");
        }
        inputElement.outerHTML=inputElement.outerHTML; //清空<input type="file">的值
    }
</script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/wangEditor.min.js" charset="utf-8"></script>
<script type="text/javascript">
    var E = window.wangEditor;
    var editor = new E('#toolbar', '#mymsg');// 两个参数也可以传入 elem 对象，class 选择器
    editor.customConfig.uploadImgServer = '/upload/uploadimg';
    editor.customConfig.uploadFileName = 'file';
    editor.customConfig.showLinkImg = false;
    editor.customConfig.uploadImgMaxSize = 3 * 1024 * 1024;
    editor.customConfig.uploadImgMaxLength = 5;
    editor.customConfig.debug = true;
    editor.create();


</script>
<script>
    //ajax提交信息
    function uploadImg() {
        if($("#file").val() != "") {
            $.ajaxFileUpload({
                type: "POST",
                url:"${pageContext.request.contextPath}/upload/uploadimg",
                dataType: "json",
                fileElementId:"file",  // 文件的id
                success: function(d){
                    if(d.code == 0) {
                        //alert("上传成功");
                        //图片显示
                        $("#avatar").attr("value",d.data.url);
                        $("#avatarShow").attr("src",d.data.url);
                    }
                },
                error: function () {
                    alert("上传失败");
                },
            });
        } else {
            alert("请先选择文件");
        }
    }
</script>
</body>
</html>

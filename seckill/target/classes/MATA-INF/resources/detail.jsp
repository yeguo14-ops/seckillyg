<%@page contentType="text/html; charset=UTF-8" language="java" %>
<%@include file="common/tag.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <title>秒杀商品详情页</title>
    <%@include file="common/head.jsp" %>
    <style>
        /* 全局样式 */
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Microsoft YaHei', 'PingFang SC', sans-serif;
        }

        /* 主卡片样式 */
        .seckill-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            border: none;
            overflow: hidden;
            margin-top: 60px;
            animation: fadeInUp 0.8s ease-out;
        }

        .seckill-card .panel-heading {
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%);
            color: white;
            padding: 30px;
            border: none;
        }

        .seckill-card .panel-heading h1 {
            margin: 0;
            font-size: 2.5em;
            font-weight: bold;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
        }

        .seckill-card .panel-body {
            padding: 50px 30px;
        }

        /* 倒计时样式 */
        .countdown-box {
            font-size: 2.2em;
            font-weight: bold;
            color: #e74c3c;
            letter-spacing: 2px;
        }

        .countdown-box .glyphicon-time {
            font-size: 1.2em;
            margin-right: 15px;
            animation: pulse 1.5s infinite;
        }

        /* 秒杀按钮样式 */
        #killBtn {
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%);
            border: none;
            padding: 15px 60px;
            font-size: 1.5em;
            border-radius: 50px;
            box-shadow: 0 10px 30px rgba(238, 90, 36, 0.4);
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 3px;
        }

        #killBtn:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 40px rgba(238, 90, 36, 0.6);
        }

        #killBtn:active {
            transform: translateY(0);
        }

        #killBtn.disabled {
            background: #95a5a6;
            box-shadow: none;
            cursor: not-allowed;
        }

        /* 状态标签 */
        .status-label {
            font-size: 1.5em;
            padding: 12px 30px;
            border-radius: 30px;
        }

        /* Modal 样式 */
        .modal-content {
            border-radius: 20px;
            border: none;
            box-shadow: 0 25px 50px rgba(0,0,0,0.3);
            overflow: hidden;
        }

        .modal-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            border: none;
        }

        .modal-header .modal-title {
            font-size: 1.8em;
            font-weight: bold;
        }

        .modal-body {
            padding: 35px;
        }

        .modal-footer {
            padding: 20px 35px;
            border-top: 1px solid #eee;
            text-align: center;
        }

        #killPhoneKey {
            height: 50px;
            font-size: 1.2em;
            border-radius: 10px;
            border: 2px solid #ddd;
            text-align: center;
            transition: border-color 0.3s;
        }

        #killPhoneKey:focus {
            border-color: #667eea;
            box-shadow: 0 0 10px rgba(102, 126, 234, 0.3);
        }

        #killPhoneBtn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px 40px;
            font-size: 1.1em;
            border-radius: 25px;
            transition: all 0.3s;
        }

        #killPhoneBtn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
        }

        /* 动画 */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(40px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes pulse {
            0%, 100% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.1);
            }
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .glyphicon-spin {
            animation: spin 1s infinite linear;
        }

        @keyframes slideInRight {
            from { transform: translateX(100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }

        @keyframes slideOutRight {
            from { transform: translateX(0); opacity: 1; }
            to { transform: translateX(100%); opacity: 0; }
        }

        /* 返回按钮 */
        .back-link {
            position: fixed;
            top: 20px;
            left: 20px;
            z-index: 1000;
        }

        .back-link a {
            color: white;
            font-size: 1.1em;
            text-decoration: none;
            background: rgba(255,255,255,0.2);
            padding: 10px 20px;
            border-radius: 25px;
            transition: all 0.3s;
        }

        .back-link a:hover {
            background: rgba(255,255,255,0.4);
            text-decoration: none;
        }
    </style>
</head>

<body>
<!-- 返回列表页 -->
<div class="back-link">
    <a href="${pageContext.request.contextPath}/seckill/list">
        <span class="glyphicon glyphicon-chevron-left"></span> 返回列表
    </a>
</div>

<div class="container">
    <div class="panel panel-default text-center seckill-card">
        <div class="panel-heading">
            <h1>${seckill.name}</h1>
        </div>
        <div class="panel-body">
            <h2 class="text-danger countdown-box">
                <!-- 显示Time(时间)图标 -->
                <span class="glyphicon glyphicon-time"></span>
                <!-- 显示秒杀开始的倒计时 -->
                <span id="seckill-box"></span>
            </h2>
        </div>
    </div>
</div>

<!-- 登录弹出层，用户输入手机号 -->
<div id="killPhoneModal" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title text-center">
                    <!-- 用户电话 -->
                    <span class="glyphicon glyphicon-phone"></span> 秒杀电话
                </h3>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-xs-8 col-xs-offset-2">
                        <input type="text" name="killPhone" id="killPhoneKey" placeholder="请填写手机号!"
                               class="form-control">
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <!-- 验证信息 -->
                <span id="killPhoneMessage" class="glyphicon"></span>
                <button type="button" id="killPhoneBtn" class="btn btn-success">
                    <span class="glyphicon glyphicon-phone"></span> 提交
                </button>
            </div>
        </div>
    </div>
</div>

<!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
<script src="https://apps.bdimg.com/libs/jquery/2.0.0/jquery.min.js"></script>
<!-- 新增：jQuery UI -->
<script src="https://apps.bdimg.com/libs/jqueryui/1.10.4/jquery-ui.min.js"></script>

<!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
<script src="https://apps.bdimg.com/libs/bootstrap/3.3.0/js/bootstrap.min.js"></script>
<!-- JQuery-Cookie 用于用户缓存，判断是否重复操作插件 -->
<script src="https://cdn.bootcss.com/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<!-- JQuery-CountDown实现倒计时功能 -->
<script src="https://cdn.bootcss.com/jquery.countdown/2.1.0/jquery.countdown.min.js"></script>
<!-- 引入seckill.js文件 -->
<script src="${pageContext.request.contextPath}/resources/script/seckill.js" type="text/javascript"></script>
<script type="text/javascript">
    jQuery(function () {
        // 使用EL表达式传入参数
        seckill.detail.init(
            {
                seckillId: ${seckill.seckillId},
                startTime: ${seckill.startTime.time}, // 毫秒
                endTime: ${seckill.endTime.time} // 毫秒
            });
    });
</script>
</body>
</html>
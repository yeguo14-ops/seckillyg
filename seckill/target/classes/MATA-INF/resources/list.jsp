<%@page contentType="text/html; charset=UTF-8" language="java" %>
<!-- 引入jstl -->
<%@include file="common/tag.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <title>秒杀商品列表页</title>
    <%@include file="common/head.jsp"%>
    <style>
        /* 全局样式 */
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Microsoft YaHei', 'PingFang SC', sans-serif;
            padding-bottom: 50px;
        }

        /* 页面标题区域 */
        .page-header-custom {
            text-align: center;
            padding: 40px 0 20px;
            color: white;
        }

        .page-header-custom h1 {
            font-size: 3em;
            font-weight: bold;
            text-shadow: 3px 3px 6px rgba(0,0,0,0.3);
            margin-bottom: 10px;
        }

        .page-header-custom p {
            font-size: 1.2em;
            opacity: 0.9;
        }

        /* 主卡片 */
        .main-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            border: none;
            overflow: hidden;
            animation: fadeInUp 0.8s ease-out;
        }

        .main-card .panel-heading {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            border: none;
        }

        .main-card .panel-heading h1 {
            margin: 0;
            font-size: 2em;
            font-weight: bold;
        }

        /* 表格样式 */
        .table-custom {
            margin: 0;
        }

        .table-custom thead tr {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
        }

        .table-custom thead th {
            padding: 18px 15px;
            font-size: 1.1em;
            font-weight: bold;
            color: #2c3e50;
            border-bottom: 3px solid #667eea;
            text-align: center;
        }

        .table-custom tbody tr {
            transition: all 0.3s ease;
        }

        .table-custom tbody tr:hover {
            background: linear-gradient(135deg, #f0f4ff 0%, #e8eeff 100%);
            transform: scale(1.01);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .table-custom tbody td {
            padding: 18px 15px;
            vertical-align: middle;
            text-align: center;
            font-size: 1.05em;
        }

        /* 商品名称 */
        .product-name {
            font-weight: bold;
            color: #2c3e50;
            font-size: 1.1em;
        }

        /* 库存进度条 */
        .stock-bar {
            width: 100%;
            height: 12px;
            background: #e9ecef;
            border-radius: 6px;
            overflow: hidden;
            position: relative;
        }

        .stock-bar-fill {
            height: 100%;
            border-radius: 6px;
            transition: width 0.5s ease;
        }

        .stock-high { background: linear-gradient(90deg, #00b894, #00cec9); }
        .stock-medium { background: linear-gradient(90deg, #fdcb6e, #e17055); }
        .stock-low { background: linear-gradient(90deg, #e74c3c, #c0392b); }

        .stock-text {
            font-size: 0.9em;
            color: #636e72;
            margin-top: 5px;
        }

        /* 时间样式 */
        .time-display {
            color: #2c3e50;
            font-weight: 500;
        }

        .time-display .glyphicon {
            color: #667eea;
            margin-right: 5px;
        }

        /* 详情按钮 */
        .btn-detail {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 8px 25px;
            border-radius: 20px;
            color: white;
            font-weight: bold;
            transition: all 0.3s;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }

        .btn-detail:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.5);
            color: white;
            text-decoration: none;
        }

        /* 状态标签 */
        .status-badge {
            padding: 6px 15px;
            border-radius: 15px;
            font-size: 0.85em;
            font-weight: bold;
        }

        .status-upcoming {
            background: #fff3cd;
            color: #856404;
        }

        .status-active {
            background: #d4edda;
            color: #155724;
        }

        .status-ended {
            background: #f8d7da;
            color: #721c24;
        }

        /* 统计卡片 */
        .stats-row {
            margin-bottom: 30px;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 25px;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            transition: all 0.3s;
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .stat-card .stat-icon {
            font-size: 2.5em;
            margin-bottom: 10px;
        }

        .stat-card .stat-number {
            font-size: 2em;
            font-weight: bold;
            color: #2c3e50;
        }

        .stat-card .stat-label {
            color: #636e72;
            font-size: 1em;
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

        /* 空状态 */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #636e72;
        }

        .empty-state .glyphicon {
            font-size: 4em;
            margin-bottom: 20px;
            color: #ddd;
        }
    </style>
</head>
<body>
<!-- 页面标题 -->
<div class="page-header-custom">
    <h1><span class="glyphicon glyphicon-flash"></span> 秒杀商品列表</h1>
    <p>限时抢购，先到先得</p>
</div>

<div class="container">
    <!-- 统计卡片 -->
    <div class="row stats-row">
        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-icon">🛍️</div>
                <div class="stat-number">${fn:length(list)}</div>
                <div class="stat-label">商品总数</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-icon">🔥</div>
                <div class="stat-number" id="activeCount">-</div>
                <div class="stat-label">正在进行</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-icon">⏰</div>
                <div class="stat-number" id="upcomingCount">-</div>
                <div class="stat-label">即将开始</div>
            </div>
        </div>
    </div>

    <!-- 秒杀商品列表 -->
    <div class="panel panel-default main-card">
        <div class="panel-heading text-center">
            <h1><span class="glyphicon glyphicon-list"></span> 商品列表</h1>
        </div>
        <div class="panel-body" style="padding: 0;">
            <table class="table table-hover table-custom">
                <thead>
                <tr>
                    <th>商品名称</th>
                    <th>库存情况</th>
                    <th>开始时间</th>
                    <th>结束时间</th>
                    <th>创建时间</th>
                    <th>状态</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="sk" items="${list}" varStatus="status">
                    <tr data-start="${sk.startTime.time}" data-end="${sk.endTime.time}">
                        <td>
                                <span class="product-name">
                                    <span class="glyphicon glyphicon-tag" style="color: #667eea; margin-right: 8px;"></span>
                                    ${sk.name}
                                </span>
                        </td>
                        <td>
                            <div class="stock-bar">
                                <div class="stock-bar-fill ${sk.number > 50 ? 'stock-high' : (sk.number > 10 ? 'stock-medium' : 'stock-low')}"
                                     style="width: ${sk.number > 100 ? 100 : sk.number}%"></div>
                            </div>
                            <div class="stock-text">剩余 ${sk.number} 件</div>
                        </td>
                        <td>
                                <span class="time-display">
                                    <span class="glyphicon glyphicon-play-circle"></span>
                                    <fmt:formatDate value="${sk.startTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                </span>
                        </td>
                        <td>
                                <span class="time-display">
                                    <span class="glyphicon glyphicon-stop"></span>
                                    <fmt:formatDate value="${sk.endTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                </span>
                        </td>
                        <td>
                                <span class="time-display">
                                    <span class="glyphicon glyphicon-time"></span>
                                    <fmt:formatDate value="${sk.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                </span>
                        </td>
                        <td>
                            <span class="status-badge" id="status-${status.index}">计算中...</span>
                        </td>
                        <td>
                            <a class="btn btn-detail" href="${pageContext.request.contextPath}/seckill/${sk.seckillId}/detail" target="_blank">
                                <span class="glyphicon glyphicon-eye-open"></span> 查看详情
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty list}">
                    <tr>
                        <td colspan="7">
                            <div class="empty-state">
                                <span class="glyphicon glyphicon-inbox"></span>
                                <h3>暂无秒杀商品</h3>
                                <p>请稍后再来查看</p>
                            </div>
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
<script src="https://apps.bdimg.com/libs/jquery/2.0.0/jquery.min.js"></script>
<!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
<script src="https://apps.bdimg.com/libs/bootstrap/3.3.0/js/bootstrap.min.js"></script>

<script>
    $(function() {
        // 计算并显示每个商品的状态
        var now = new Date().getTime();
        var activeCount = 0;
        var upcomingCount = 0;

        $('tbody tr[data-start]').each(function(index) {
            var startTime = parseInt($(this).data('start'));
            var endTime = parseInt($(this).data('end'));
            var statusBadge = $('#status-' + index);

            if (now > endTime) {
                statusBadge.text('已结束').addClass('status-ended');
            } else if (now >= startTime && now <= endTime) {
                statusBadge.text('进行中').addClass('status-active');
                activeCount++;
            } else {
                statusBadge.text('即将开始').addClass('status-upcoming');
                upcomingCount++;
            }
        });

        $('#activeCount').text(activeCount);
        $('#upcomingCount').text(upcomingCount);
    });
</script>
</body>
</html>
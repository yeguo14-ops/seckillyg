// 存放JS逻辑交互代码
var seckill = {
    // 封装秒杀相关ajax的URL
    URL: {
        now: function () {
            // 只保留一层 /seckill
            return '/seckill/time/now';
        },
        exposer: function (seckillID) {
            return '/seckill/' + seckillID + '/exposer';
        },
        execution: function (seckillID, md5) {
            return '/seckill/' + seckillID + '/' + md5 + '/execution';
        }
    },

    // 验证手机号
    validatePhone: function (phone) {
        if (phone && phone.length == 11 && !isNaN(phone)) {
            return true;
        } else {
            return false;
        }
    },

    // 显示Toast提示
    showToast: function(message, type) {
        type = type || 'info';
        var iconMap = {
            'success': 'glyphicon-ok-circle',
            'error': 'glyphicon-remove-circle',
            'info': 'glyphicon-info-sign',
            'warning': 'glyphicon-exclamation-sign'
        };
        var colorMap = {
            'success': '#00b894',
            'error': '#e74c3c',
            'info': '#667eea',
            'warning': '#fdcb6e'
        };

        var toast = $('<div class="seckill-toast" style="' +
            'position: fixed; top: 20px; right: 20px; z-index: 9999; ' +
            'background: white; padding: 15px 25px; border-radius: 10px; ' +
            'box-shadow: 0 10px 30px rgba(0,0,0,0.2); display: flex; ' +
            'align-items: center; gap: 10px; font-size: 1.1em; ' +
            'border-left: 4px solid ' + colorMap[type] + '; ' +
            'animation: slideInRight 0.3s ease-out;">' +
            '<span class="glyphicon ' + iconMap[type] + '" style="color: ' + colorMap[type] + '; font-size: 1.3em;"></span>' +
            '<span>' + message + '</span>' +
            '</div>');

        $('body').append(toast);

        setTimeout(function() {
            toast.css('animation', 'slideOutRight 0.3s ease-out');
            setTimeout(function() {
                toast.remove();
            }, 300);
        }, 3000);
    },

    // 秒杀详情页的交互逻辑
    detail: {
        // 秒杀详情页信息初始化
        init: function (params) {
            // 手机号验证，手机号登录，秒杀时间计时
            // 在cookie中查找和保存手机号
            var killPhone = $.cookie('killPhone');
            // 验证手机号
            if (!seckill.validatePhone(killPhone)) {
                // 绑定手机号，控制输出
                var killPhoneModal = $('#killPhoneModal');
                // 显示弹窗
                killPhoneModal.modal({
                    show: true, // 显示弹出层
                    backdrop: 'static', // 禁止位置关闭
                    keyboard: false // 关闭键盘事件
                });

                // 添加回车键提交支持
                $('#killPhoneKey').on('keypress', function(e) {
                    if (e.which === 13) {
                        $('#killPhoneBtn').click();
                    }
                });

                $('#killPhoneBtn').click(function () {
                    var inputPhone = $('#killPhoneKey').val();
                    console.log('inputPhone: ' + inputPhone);
                    if (seckill.validatePhone(inputPhone)) {
                        // 将电话号码写入到Cookie中，设置过期时间为1天
                        $.cookie('killPhone', inputPhone, {expires: 1, path: '/seckill'});
                        seckill.showToast('手机号验证成功！', 'success');
                        // 验证通过，刷新页面
                        setTimeout(function() {
                            window.location.reload();
                        }, 500);
                    } else {
                        $('#killPhoneMessage').hide().html('<label class="label label-danger">手机号格式错误，请输入11位数字！</label>').show(300);
                        seckill.showToast('请输入正确的11位手机号', 'error');
                    }
                });
            } else {
                // 已登录，显示欢迎信息
                console.log('已登录手机号: ' + killPhone);
            }

            // 已经登录成功
            // 计时校验逻辑
            var startTime = params['startTime'];
            var endTime = params['endTime'];
            var seckillID = params['seckillId'];

            // 显示加载状态
            var seckillBox = $('#seckill-box');
            seckillBox.html('<span class="glyphicon glyphicon-refresh glyphicon-spin"></span> 正在获取服务器时间...');

            $.get(seckill.URL.now(), {}, function (result) {
                if (result && result['success']) {
                    var nowTime = result['data'];
                    // 时间判断，计时交互
                    seckill.countDown(seckillID, nowTime, startTime, endTime);
                } else {
                    console.log('获取时间失败: ' + result);
                    seckill.showToast('获取服务器时间失败，请刷新页面重试', 'error');
                    seckillBox.html('<span class="label label-danger">获取时间失败</span>');
                }
            }).fail(function() {
                seckill.showToast('网络连接失败，请检查网络', 'error');
                seckillBox.html('<span class="label label-danger">网络连接失败</span>');
            });
        }
    },

    countDown: function (seckillID, nowTime, startTime, endTime) {
        console.log(seckillID + '_' + nowTime + '_' + startTime + '_' + endTime);
        var seckillBox = $('#seckill-box');

        // 时间判断
        if (nowTime > endTime) {
            // 秒杀结束
            seckillBox.html('<span class="label label-default status-label">秒杀已结束</span>');
        } else if (nowTime < startTime) {
            // 秒杀未开启，计时交互，计时事件绑定
            var killTime = new Date(startTime + 1000);
            seckillBox.countdown(killTime, function (event) {
                var format = event.strftime('秒杀倒计时： %D天 %H时 %M分 %S秒');
                seckillBox.html(format);
            }).on('finish.countdown', function () {
                seckill.handleSeckillkill(seckillID, seckillBox);
            });
        } else {
            // 秒杀开始
            seckill.handleSeckillkill(seckillID, seckillBox);
        }
    },

    handleSeckillkill: function (seckillID, node) {
        // 获取秒杀显示逻辑，执行秒杀
        node.hide().html('<button class="btn btn-primary btn-lg" id="killBtn">' +
            '<span class="glyphicon glyphicon-flash"></span> 立即秒杀</button>');

        // 显示加载动画
        node.append('<div id="exposerLoading" style="margin-top: 15px; color: #667eea;">' +
            '<span class="glyphicon glyphicon-refresh glyphicon-spin"></span> 正在获取秒杀地址...</div>');
        node.show();

        $.get(seckill.URL.exposer(seckillID), {}, function (result) {
            $('#exposerLoading').remove();

            // 在回调函数中，执行交互流程
            if (result && result['success']) {
                var exposer = result['data'];
                if (exposer['exposed']) {
                    // 开启秒杀，获取秒杀地址
                    var md5 = exposer['md5'];
                    var killUrl = seckill.URL.execution(seckillID, md5);
                    console.log('killUrl: ' + killUrl);

                    // 绑定秒杀时的点击事件
                    $('#killBtn').one('click', function () {
                        var btn = $(this);
                        // 1. 禁用按钮并显示加载
                        btn.addClass('disabled').html('<span class="glyphicon glyphicon-refresh glyphicon-spin"></span> 秒杀中...');

                        // 2. 发送秒杀请求，执行秒杀
                        $.post(killUrl, {}, function (result) {
                            if (result && result['success']) {
                                var killResult = result['data'];
                                var state = killResult['state'];
                                var stateInfo = killResult['stateInfo'];

                                // 根据状态显示不同样式
                                if (state === 1) {
                                    // 秒杀成功
                                    node.html('<span class="label label-success status-label">' +
                                        '<span class="glyphicon glyphicon-ok"></span> ' + stateInfo + '</span>');
                                    seckill.showToast('恭喜！秒杀成功！', 'success');
                                } else if (state === 0) {
                                    // 秒杀失败（已售罄等）
                                    node.html('<span class="label label-warning status-label">' +
                                        '<span class="glyphicon glyphicon-exclamation-sign"></span> ' + stateInfo + '</span>');
                                    seckill.showToast(stateInfo, 'warning');
                                } else {
                                    // 其他状态
                                    node.html('<span class="label label-info status-label">' + stateInfo + '</span>');
                                }
                            } else {
                                node.html('<span class="label label-danger status-label">秒杀请求失败</span>');
                                seckill.showToast('秒杀请求失败，请重试', 'error');
                            }
                        }).fail(function() {
                            btn.removeClass('disabled').html('<span class="glyphicon glyphicon-flash"></span> 立即秒杀');
                            seckill.showToast('网络异常，请重试', 'error');
                        });
                    });
                    node.show();
                } else {
                    // 未开启秒杀，浏览器进行计时操作
                    var now = exposer['now'];
                    var start = exposer['start'];
                    var end = exposer['end'];
                    seckill.countDown(seckillID, now, start, end);
                }
            } else {
                console.log('获取秒杀地址失败: ' + result);
                node.html('<span class="label label-danger status-label">获取秒杀信息失败</span>');
                seckill.showToast('获取秒杀信息失败', 'error');
            }
        }).fail(function() {
            $('#exposerLoading').remove();
            node.html('<span class="label label-danger status-label">网络请求失败</span>');
            seckill.showToast('网络请求失败', 'error');
        });
    }
};
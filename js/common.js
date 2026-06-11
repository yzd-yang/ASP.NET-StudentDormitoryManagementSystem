// ========== 公共脚本 ==========

// Toast 提示
function showToast(message, type) {
    type = type || 'success';
    var toast = document.createElement('div');
    toast.className = 'toast toast-' + type;
    toast.textContent = message;
    document.body.appendChild(toast);

    setTimeout(function () {
        toast.classList.add('show');
    }, 10);

    setTimeout(function () {
        toast.classList.remove('show');
        setTimeout(function () {
            document.body.removeChild(toast);
        }, 300);
    }, 3000);
}

// 确认弹窗
function confirmAction(message, callback) {
    if (confirm(message)) {
        callback();
    }
}

// 格式化日期
function formatDate(dateStr) {
    var date = new Date(dateStr);
    var year = date.getFullYear();
    var month = ('0' + (date.getMonth() + 1)).slice(-2);
    var day = ('0' + date.getDate()).slice(-2);
    var hours = ('0' + date.getHours()).slice(-2);
    var minutes = ('0' + date.getMinutes()).slice(-2);
    return year + '-' + month + '-' + day + ' ' + hours + ':' + minutes;
}

// 防抖函数
function debounce(func, wait) {
    var timeout;
    return function () {
        var context = this;
        var args = arguments;
        clearTimeout(timeout);
        timeout = setTimeout(function () {
            func.apply(context, args);
        }, wait);
    };
}

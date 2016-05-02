var focusFactory = function (direction) {
    return slate.operation('focus', {
        'direction': direction
    });
};

var focusLeft = focusFactory('left');
var focusRight = focusFactory('right');
var focusUp = focusFactory('up');
var focusDown = focusFactory('down');

var sendKeysFactory = function (keys, direction) {
    return slate.operation('shell', {
        //'command': '/usr/local/bin/tmux if-shell "echo \\"#{pane_current_command}\\" | grep -iqE \\"(^fzf.*\\$)|((^|\\/)g?(view|n?vim?x?)(diff)?\\$)\\"" "send-keys ' + keys + '" "select-pane -' + direction + '"',
        'command': '/usr/local/bin/fish -c "echo hi"',
        'wait': true
    });
};

var sendRightKeys = sendKeysFactory('C-l', 'R');
var sendLeftKeys = sendKeysFactory('C-h', 'L');
var sendDownKeys = sendKeysFactory('C-j', 'D');
var sendUpKeys = sendKeysFactory('C-k', 'U');

var focusUnlessItermFactory = function (focusDirectionOp, sendKeysOp) {
    return function (win) {
        var appName = win.app().name();
        if (appName === 'iTerm') {
            slate.log('CHECKING APP WINDOWS');
            win.app().eachWindow(function (window) {
                slate.log(window.title());
            });
        } else {
            win.doOperation(focusDirectionOp);
        }
    };
};

slate.bind('l:ctrl', focusUnlessItermFactory(focusRight, sendRightKeys));
slate.bind('h:ctrl', focusUnlessItermFactory(focusLeft, sendLeftKeys));
slate.bind('j:ctrl', focusUnlessItermFactory(focusDown, sendDownKeys));
slate.bind('k:ctrl', focusUnlessItermFactory(focusUp, sendUpKeys));

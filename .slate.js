slate.configAll({
    'layoutFocusOnActivate': true
});

//var focusFactory = function (direction) {
//    return slate.operation('focus', {
//        'direction': direction
//    });
//};
//
//var focusLeft = focusFactory('left');
//var focusRight = focusFactory('right');
//var focusUp = focusFactory('up');
//var focusDown = focusFactory('down');
//
//var sendKeysFactory = function (keys, direction) {
//    return slate.operation('shell', {
//        //'command': '/usr/local/bin/tmux if-shell "echo \\"#{pane_current_command}\\" | grep -iqE \\"(^fzf.*\\$)|((^|\\/)g?(view|n?vim?x?)(diff)?\\$)\\"" "send-keys ' + keys + '" "select-pane -' + direction + '"',
//        'command': '/usr/local/bin/fish -c "echo hi"',
//        'wait': true
//    });
//};
//
//var sendRightKeys = sendKeysFactory('C-l', 'R');
//var sendLeftKeys = sendKeysFactory('C-h', 'L');
//var sendDownKeys = sendKeysFactory('C-j', 'D');
//var sendUpKeys = sendKeysFactory('C-k', 'U');
//
//var focusUnlessItermFactory = function (focusDirectionOp, sendKeysOp) {
//    return function (win) {
//        var appName = win.app().name();
//        if (appName === 'iTerm') {
//            slate.log('CHECKING APP WINDOWS');
//            win.app().eachWindow(function (window) {
//                slate.log(window.title());
//            });
//        } else {
//            win.doOperation(focusDirectionOp);
//        }
//    };
//};
//
//slate.bind('l:ctrl', focusUnlessItermFactory(focusRight, sendRightKeys));
//slate.bind('h:ctrl', focusUnlessItermFactory(focusLeft, sendLeftKeys));
//slate.bind('j:ctrl', focusUnlessItermFactory(focusDown, sendDownKeys));
//slate.bind('k:ctrl', focusUnlessItermFactory(focusUp, sendUpKeys));

function throwOp (appName, screenId, screenSizeX, screenSizeY, screenOriginX, screenOriginY) {
    screenSizeX = screenSizeX || 'screenSizeX';
    screenSizeY = screenSizeY || 'screenSizeY';

    screenOriginX = screenOriginX || 'screenOriginX';
    screenOriginY = screenOriginY || 'screenOriginY';

    var slateThrowOp = slate.operation('throw', {
        'screen': screenId,
        'width': screenSizeX,
        'height': screenSizeY,
        'x': screenOriginX,
        'y': screenOriginY
    });

    return function () {
        var lowestPidAppWindow = null;
        var lowestPid = Infinity;
        slate.eachApp(function (appObject) {
            var mainWindow = appObject.mainWindow();
            if (appObject.name() === appName && mainWindow) {
                var pid = appObject.pid();
                if (pid < lowestPid) {
                    lowestPidAppWindow = mainWindow;
                    lowestPid = pid;
                }
            }
        });
        if (lowestPidAppWindow) {
            lowestPidAppWindow.doOperation(slateThrowOp);
        }
    };
}

function layoutThrowOp (appName) {
    var obj = {};
    obj[appName] = {
        'operations': [throwOp.apply(null, arguments)]
    };
    return obj;
}

function getSlateLayoutRecord (name, params) {
    return {
        name: name,
        params: Object.assign({
            'repeat': true
        }, params)
    }
}

var iTerm2Layout = getSlateLayoutRecord('iTerm2', layoutThrowOp('iTerm2', '1'));

var spotifyLayout = getSlateLayoutRecord('Spotify', layoutThrowOp('Spotify', '0'));

var googleChromeLayout = getSlateLayoutRecord('Google Chrome', layoutThrowOp('Google Chrome', '0'));

var intellijIdeaLayout = getSlateLayoutRecord('IntelliJ IDEA', layoutThrowOp('IntelliJ IDEA', '0'));

var googleChromeITermLayout = getSlateLayoutRecord('Google Chrome iTerm',
    Object.assign(
        layoutThrowOp('Google Chrome', '0', 'screenSizeX/2'),
        layoutThrowOp('iTerm2', '0', 'screenSizeX/2', 'screenSizeY', 'screenOriginX+newWindowSizeX'))
);

var isDirty = false;
var relaunch = slate.operation('relaunch');
var relaunchIfDirty = function () {
    if (isDirty) {
        isDirty = false;
        relaunch.run();
    }
};

function runBeforeThrowLayoutOp (appName) {
    return Object.assign({
        '_before_': {
            'operations': [runIfOp(appName), relaunchIfDirty]
        }

    }, layoutThrowOp.apply(null, arguments));
}

var runIfMap = {
    'iTerm2': '/Applications/iTerm 2.app',
    'Google Chrome': '/Applications/Google Chrome.app',
    'Firefox': '/Applications/Firefox.app',
    'Safari': '/Applications/Safari.app',
    'Spotify': '/Applications/Spotify.app'
};
function runIfOp (name) {
    return function () {
        var running = false;
        slate.eachApp(function (app) {
            if (app.name() == name) {
                running = true;
            }
        });
        if (!running) {
            isDirty = true;
            slate.shell('/usr/bin/open ' + '"' + runIfMap[name] + '"', true, '~/');
        }
    };
}

var mainGoogleChromeLayout = getSlateLayoutRecord('Main:Google Chrome', runBeforeThrowLayoutOp('Google Chrome', '1'));

var mainFirefoxLayout = getSlateLayoutRecord('Main:Firefox', runBeforeThrowLayoutOp('Firefox', '1'));

var mainSafariLayout = getSlateLayoutRecord('Main:Safari', runBeforeThrowLayoutOp('Safari', '1'));

function makeLayoutOp (layoutRecord) {
    return slate.operation('layout', {
        'name': slate.layout(layoutRecord.name, layoutRecord.params)
    });
}

slate.bind('n:ctrl', makeLayoutOp(iTerm2Layout));
slate.bind('i:ctrl', makeLayoutOp(googleChromeLayout));

slate.bind('n:cmd;ctrl', makeLayoutOp(spotifyLayout));
slate.bind('m:cmd;ctrl', makeLayoutOp(googleChromeITermLayout));
slate.bind('u:cmd;ctrl', makeLayoutOp(intellijIdeaLayout));

slate.bind('i:cmd;ctrl', makeLayoutOp(mainGoogleChromeLayout));
slate.bind('o:cmd;ctrl', makeLayoutOp(mainFirefoxLayout));
slate.bind('p:cmd;ctrl', makeLayoutOp(mainSafariLayout));

slate.bind('q:cmd;ctrl', slate.operation('hide', {
    'app': ['current']
}));

slate.bind('w:cmd;ctrl', slate.operation('corner', {
    'direction': 'top-left'
}));

slate.bind('space:ctrl', slate.operation('switch'));

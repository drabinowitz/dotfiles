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

function throwOp (screenId, screenSizeX, screenSizeY, screenOriginX, screenOriginY) {
    screenSizeX = screenSizeX || 'screenSizeX';
    screenSizeY = screenSizeY || 'screenSizeY';

    screenOriginX = screenOriginX || 'screenOriginX';
    screenOriginY = screenOriginY || 'screenOriginY';

    return slate.operation('throw', {
        'screen': screenId,
        'width': screenSizeX,
        'height': screenSizeY,
        'x': screenOriginX,
        'y': screenOriginY
    });
}

function getSlateLayoutRecord (name, params) {
    return {
        name: name,
        params: Object.assign({
            'repeat': true
        }, params)
    }
}

var relaunch = slate.operation('relaunch');

var iTermLayout = getSlateLayoutRecord('iTerm', {
    'iTerm': {
        'operations': [throwOp('1')]
    }
});

var spotifyLayout = getSlateLayoutRecord('Spotify', {
    'Spotify': {
        'operations': [throwOp('0')]
    }
});

var googleChromeLayout = getSlateLayoutRecord('Google Chrome', {
    'Google Chrome': {
        'operations': [throwOp('0')]
    }
});

var googleChromeITermLayout = getSlateLayoutRecord('Google Chrome iTerm', {
    'Google Chrome': {
        'operations': [throwOp('0', 'screenSizeX/2')]
    },

    'iTerm': {
        'operations': [
            throwOp('0', 'screenSizeX/2', 'screenSizeY', 'screenOriginX+newWindowSizeX')
        ]
    }
});

var mainGoogleChromeLayout = getSlateLayoutRecord('Main:Google Chrome', {
    'Google Chrome': {
        'operations': [throwOp('1')]
    },

    '_after_': {
        'operations': [relaunch]
    }
});

var mainFirefoxLayout = getSlateLayoutRecord('Main:Firefox', {
    'Firefox': {
        'operations': [throwOp('1')]
    },

    '_after_': {
        'operations': [relaunch]
    }
});

var mainSafariLayout = getSlateLayoutRecord('Main:Safari', {
    'Safari': {
        'operations': [throwOp('1')]
    },

    '_after_': {
        'operations': [relaunch]
    }
});

var runIfMap = {
    'iTerm': '/Applications/iTerm 2.app',
    'Google Chrome': '/Applications/Google Chrome.app',
    'Firefox': '/Applications/Firefox.app',
    'Safari': '/Applications/Safari.app',
    'Spotify': '/Applications/Spotify.app'
};
function runIf(name) {
    var running = false;
    slate.eachApp(function (app) {
        if (app.name() == name) {
            running = true;
        }
    });
    if (!running) {
      slate.shell('/usr/bin/open ' + '"' + runIfMap[name] + '"', true, '~/');
    }
}

function makeLayoutOp (layoutRecord) {
    return function () {
        for (var app in layoutRecord.params) {
            if (layoutRecord.params.hasOwnProperty(app)) {
                if (app !== '_before_' || app !== '_after_') {
                    runIf(app)
                }
            }
        }

        slate.operation('layout', {
            'name': slate.layout(layoutRecord.name, layoutRecord.params)
        }).run();
    };
}

slate.bind('n:ctrl', makeLayoutOp(iTermLayout));
slate.bind('i:ctrl', makeLayoutOp(googleChromeLayout));

slate.bind('n:cmd;ctrl', makeLayoutOp(spotifyLayout));
slate.bind('m:cmd;ctrl', makeLayoutOp(googleChromeITermLayout));
slate.bind('i:cmd;ctrl', makeLayoutOp(mainGoogleChromeLayout));
slate.bind('o:cmd;ctrl', makeLayoutOp(mainFirefoxLayout));
slate.bind('p:cmd;ctrl', makeLayoutOp(mainSafariLayout));

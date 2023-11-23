//
//  Scripts.swift
//  Kukushka_iOSSDK
//
//  Created by Aleksunder Volkov on 23.11.2023.
//

import Foundation

enum JScripts {
    static let addEventListener = """
            window.addEventListener('message', function(e) {
                window.webkit.messageHandlers.iosListener.postMessage(JSON.stringify(e.data));
            });
            """
    static let timerScript = """
                        window.postMessage("getTime","*");
                        """
}

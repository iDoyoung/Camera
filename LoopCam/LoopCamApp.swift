//
//  LoopCamApp.swift
//  LoopCam
//
//  Created by Doyoung on 2/24/25.
//

import SwiftUI

@main
struct LoopCamApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            CameraView(camera: CameraModel())
                .onChange(of: scenePhase) { _, newPhase in
                    switch newPhase {
                    case .active:
                        print("acive")
                    case .inactive:
                        print("inactive")
                    case .background:
                        print("background")
                        
                    @unknown default:
                        break
                    }
                }
        }
    }
}

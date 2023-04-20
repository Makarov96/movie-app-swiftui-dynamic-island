//
//  moviesApp.swift
//  movies
//
//  Created by Guerin Steven Colocho Chacon on 19/04/23.
//

import SwiftUI
import BackgroundTasks
import ActivityKit


class Sample: NSObject {
    
    
    
    var timer: Timer?
    var value: Int = 0
    var percent:Double = 0
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "myapprefresh")
        request.earliestBeginDate = .now.addingTimeInterval(24 * 3600)
        try? BGTaskScheduler.shared.submit(request)
        
        timer = Timer(timeInterval: 1, repeats: true, block: { [weak self] (timer) in
            guard let self = self else { return }
            
            self.value += 10
            self.percent += 0.0357

            print(self.percent)
            Task {
                let minValue: Int = 0
                let maxValue: Int = 280
                let valuePown: Int = 2
                
                if  self.value < maxValue {
                    await LiveActivityManager.updateActivity(id: LiveActivityManager.activity?.id ?? "", status: STATUSBUY.onRoad, x: self.value, percentIndicator:   self.percent )
                }else if ( self.value >= maxValue){
                    await LiveActivityManager.updateActivity(id: LiveActivityManager.activity?.id ?? "", status: STATUSBUY.delivered, x: maxValue, percentIndicator:   self.percent )
                    self.resetScheduleAppRefresh()
                }
            }
            
            
            
        })
        
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    func resetScheduleAppRefresh(){
        
        timer?.invalidate()
        timer = nil
        
    }
    
    
}

@main
struct moviesApp: App {
    @Environment(\.scenePhase) private var phase
    var sample:Sample = Sample()
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
        .onChange(of: phase) { newPhase in
            
            
            switch newPhase {
            case .background: sample.scheduleAppRefresh()
                
            case .active : sample.resetScheduleAppRefresh()
                
            default: break
            }
        }
    }
}

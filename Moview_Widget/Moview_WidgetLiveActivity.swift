//
//  Moview_WidgetLiveActivity.swift
//  Moview_Widget
//
//  Created by Guerin Steven Colocho Chacon on 19/04/23.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct Moview_WidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var value: Int
    }
    
    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct Moview_WidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for:MovieAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)
            
        } dynamicIsland: { context in
            
            DynamicIsland {
                
                DynamicIslandExpandedRegion(.leading) {
                    
                    
                    
                }
                DynamicIslandExpandedRegion(.trailing) {
                    
                }
                DynamicIslandExpandedRegion(.bottom) {
                    
                    VStack{
                        HStack{
                            
                            ZStack{
                                
                                Image(context.state.status.iconSet).resizable()
                                    .aspectRatio(contentMode: .fit).opacity(context.state.status.isOnRoad ? 0 : 1)
                                
                                
                                
                                Image(context.state.status.iconSet).resizable()
                                    .aspectRatio(contentMode: .fit).opacity(context.state.status.isOnRoad ? 1 : 0)
                                    .offset(x: CGFloat(context.state.offsetX), y: 0)
                                
                                
                                
                            }.frame(maxWidth: .infinity, alignment: .bottomLeading)
                            
                            
                            
                            
                        }
                        Rectangle().frame(width: .infinity,height: 5).cornerRadius(10)
                        VStack{
                            
                            Text("Estado actual: \(context.state.status.description)")
                            
                        }
                    }
                    
                }
            } compactLeading: {
                
                ZStack{
                  
                        ZStack {
                            
                            Circle()
                                .stroke(
                                    Color.green.opacity(0.5),
                                    lineWidth: 2
                                )
                            
                            context.state.percentIndicator == 0.9995999999999995 ? Image(systemName: "checkmark").font(.system(size: 10)).padding(3) :
                            Image(systemName: "bag.fill").font(.system(size: 10)).padding(3)
                            
                            
                            Circle()
                            // 2
                                .trim(from: 0, to: context.state.percentIndicator)
                                .stroke(
                                    Color.green,
                                    style: StrokeStyle(
                                        lineWidth: 2,
                                        lineCap: .round
                                    )
                                )
                                .rotationEffect(.degrees(-90))
                            
                        }.frame(maxWidth: 20, maxHeight: 20).padding(.trailing,5)
                        
                        
                    
                }
                
                
            } compactTrailing: {
    
            } minimal: {
                
                
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

struct Moview_WidgetLiveActivity_Previews: PreviewProvider {
    static let attributes = MovieAttributes()
    static let contentState = MovieAttributes.ContentState(price: 30.4, status: STATUSBUY.onRoad, movieName: "Sample", offsetX: 0, percentIndicator: 0.0)
    //maxPErcent indicator : 0.9995999999999995
    
    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}

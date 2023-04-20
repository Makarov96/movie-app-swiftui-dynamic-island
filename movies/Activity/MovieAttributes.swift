//
//  MovieAttributes.swift
//  movie
//
//  Created by Guerin Steven Colocho Chacon on 17/04/23.
//

import Foundation
import ActivityKit
import UIKit


class MovieAttributes:ActivityAttributes{
    public typealias MovieStatus = ContentState
    
   static var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    public struct ContentState: Codable, Hashable{
        var price:CGFloat
        var status: STATUSBUY = STATUSBUY.none
        var movieName: String
        var offsetX: Int
        var percentIndicator: Double
      
    }
    
 
    
}





enum STATUSBUY:Codable, CustomStringConvertible{
    case none
    case verify
    case onRoad
    case delivered
    
    var description : String {
       switch self {
       // Use Internationalization, as appropriate.
       case .none: return "No asignado"
       case .verify: return "Verify"
       case .onRoad: return "En camino"
       case .delivered: return "Entregado"
       }
     }
    
    var isOnRoad : Bool {
        if self == .onRoad{
            return true
        } else if self == .delivered{
            return true
        }else {
            return false
        }
    }
    
    var iconSet : String {
        // Use Internationalization, as appropriate.
        if .none == self{
            return "delivery-man"
        }else if .onRoad == self {
            return "on-road"
        }else if .verify == self {
            return "package"
        }else if .delivered == self {
            return "deliveried"
        }else {
            return "delivery-man"
        }
    }
    
}

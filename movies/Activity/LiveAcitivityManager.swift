//
//  LiveAcitivityManager.swift
//  movie
//
//  Created by Guerin Steven Colocho Chacon on 18/04/23.
//


import Foundation
import ActivityKit
import UIKit


typealias CompletedBlock = (URL?) -> ()

class LiveActivityManager {
    
    
    static  var activity: Activity<MovieAttributes>?
    static func startActivity(movie: Movie) async{
      
      
   
        let movieAttributes = MovieAttributes()
    
        var initState = MovieAttributes.ContentState(price: 30.5, status: STATUSBUY.none, movieName: movie.title, offsetX: 0, percentIndicator: 0.0)
        activity =   try? Activity<MovieAttributes>.request(attributes: movieAttributes, contentState: initState)
        
    }
    
    
    static func updateActivity(id: String,status: STATUSBUY, x: Int, percentIndicator: Double) async {
       
     
        let updatedContentState = MovieAttributes.ContentState(price: 35.7, status: status, movieName:  activity?.content.state.movieName ?? "Hola", offsetX:x, percentIndicator: percentIndicator)
           let activity = Activity<MovieAttributes>.activities.first(where: { $0.id == id })
           await activity?.update(using: updatedContentState)
       }
    

 
    

    
}


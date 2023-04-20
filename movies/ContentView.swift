//
//  ContentView.swift
//  movies
//
//  Created by Guerin Steven Colocho Chacon on 19/04/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader{geo in
            ZStack(alignment: .center ){
              Login()
            }
            .ignoresSafeArea()
            .frame(width: geo.size.width, height: geo.size.height)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

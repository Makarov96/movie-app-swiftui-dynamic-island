//
//  Login.swift
//  movie
//
//  Created by Guerin Steven Colocho Chacon on 16/04/23.
//

import SwiftUI

struct Login: View {
    
    @State var navigateTo:Bool = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                
                Image("movie-grid")
                ZStack(alignment:.center){
                    
                    
                }
                .frame(maxWidth: .infinity, maxHeight:.infinity ) .background(
                    LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom)
                )
                
                VStack(spacing:10){
                 
                    Text("ULTIMATE DESTIONATION FOR CINEMATIC ADVENTURE")  .font(.system(size: 50))
                        .padding()
                        .foregroundColor(.white)
                 
                    Button {
                        navigateTo = true
                    } label: {
                        Text("Let's Get Started    →")
                            .frame(width: 300, height: 20)
                            .font(.system(size: 20))
                            .padding()
                            .foregroundColor(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                        
                    }
                    
                }.padding(.horizontal,90)
                    .padding(.top,290)
                  
                
                
            }
            .ignoresSafeArea()
      
            .navigationDestination(isPresented: $navigateTo) {
                MovieScreen().navigationBarBackButtonHidden(true)
                }
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}

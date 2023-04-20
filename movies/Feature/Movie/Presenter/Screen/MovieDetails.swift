//
//  MovieDetails.swift
//  movie
//
//  Created by Guerin Steven Colocho Chacon on 14/04/23.
//

import SwiftUI
import ActivityKit
import Kingfisher
struct MovieDetails: View {
    @State var activity: Activity<MovieAttributes>? = nil
    @StateObject var movie:Movie
    @State var isMovieBuyed:Bool = false

    var onTap: () -> Void

    @State private var animationAmount = 0.0
    
    @Binding  var cirucularAnination:Bool
    
    @Binding var animationBag: Double
    
    let namespace: Namespace.ID
//    @Binding var isDisplay: Bool
    
    var frame:Double
  
    var geo: GeometryProxy
    

    init(movie: Movie, onTap: @escaping () -> Void,namespace: Namespace.ID, frame: Double, geo: GeometryProxy,  cirucularAnination:  Binding<Bool> = .constant(false), animationBag: Binding<Double> = .constant(0.0)) {
        self._movie = StateObject(wrappedValue: movie)
        self.onTap = onTap
        self.namespace = namespace
        self.frame = frame
        self.geo = geo
        self._cirucularAnination = cirucularAnination
        self._animationBag = animationBag
    }

    var body: some View {
        
        ZStack{
            
     
        VStack{
            VStack{
                
                KFImage.url(URL(string: movie.bestImage))
                    .resizable().aspectRatio(contentMode: .fill).frame(maxHeight: frame * 3).matchedGeometryEffect(id: movie.id, in: namespace)
            }.frame(maxHeight: frame)
            
            VStack(spacing:0){
                HStack{
                    ForEach(0..<self.movie.stars){index in
                       
                        
                        Image(systemName: "star.fill").foregroundColor(Color.yellow).font(.system(size: 25))
                            .opacity(animationAmount)
                            .animation(.easeInOut(duration: Double(index)), value: animationAmount)
                        
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: geo.size.height * 0.1, alignment: .leading)
                
                Text(movie.description) .multilineTextAlignment(.leading)
                    .lineLimit(50).foregroundColor(Color.white)
            }.padding(.top,geo.size.height * 0.1)
                .padding(.horizontal,geo.size.width * 0.04)
          Spacer()
            Button {
             
                withAnimation() {
                    self.onTap()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                      
                        Task{
                           await LiveActivityManager.startActivity(movie: movie)
                        }
                        animationBag += 1
                        self.cirucularAnination = true
                       
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 ) {
                        animationBag = 0
                    }
                }
           
              
               
             
            } label: {
                Text("Buy at $4.60")
                    .foregroundColor(Color.white)
                    .frame(maxWidth: geo.size.width * 0.8, maxHeight: geo.size.height * 0.06 )
                    .overlay(    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.white, lineWidth: 2))
            }.offset(y:-40)

        }}
       
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .background(Color("backgroundColor"))
        .onTapGesture {
            self.onTap()
        }
      
        .onAppear{
            animationAmount += 1
        }
        .onDisappear{
            isMovieBuyed = false
        }

    }
}

struct MovieDetails_Previews: PreviewProvider {
    static var previews: some View {
        @Namespace var namespace
        GeometryReader{ geo in
            
            MovieDetails(movie: Movie(title: "reter", description: "lsidufoisguiodfguiodfihdufiohgdiufpgsupiodgosipdguopsdgupsdpgusduopgspdougusipdguopsdgupsdgpusdpugsupdgpusdguopsdguopsdpugspudoguposdguopsdgpuspdugupsdgpusdgpspdougsdgupsdgupsdgupsdgpousd", bestImage: "https://images.squarespace-cdn.com/content/v1/552672afe4b0c26feae01486/1637782853123-J37VI8VX2QL82KJP5U5W/DUNE_Indy_Movie_Poster_1.jpeg?format=1500w", raiting: 0.0, stars: 5), onTap:{},namespace: namespace, frame: 50, geo: geo, cirucularAnination: .constant(false))
        }
    }
}

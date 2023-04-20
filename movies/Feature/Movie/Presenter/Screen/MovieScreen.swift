//
//  MovieScreen.swift
//  movie
//
//  Created by Guerin Steven Colocho Chacon on 11/04/23.
//
import Combine
import SwiftUI
import ActivityKit
import Kingfisher



class Movie: Identifiable, ObservableObject{
    @Published var id = UUID()
    @Published var title: String
    @Published var description: String
    @Published var bestImage: String
    @Published var raiting: CGFloat
    @Published var stars: Int
    
    init(id: UUID = UUID(), title: String, description: String, bestImage: String, raiting: CGFloat, stars: Int) {
        self.id = id
        self.title = title
        self.description = description
        self.bestImage = bestImage
        self.raiting = raiting
        self.stars = stars
    }
    
    
    func update(with newMovie:Movie){
        
        self.id = newMovie.id
        self.title = newMovie.title
        self.description = newMovie.description
        self.bestImage = newMovie.bestImage
        self.raiting = newMovie.raiting
        self.stars = newMovie.stars
    }
    
    static func getRecentMovies() -> [Movie] {
        let movies = [
            Movie(title: "Dune", description: "Feature adaptation of Frank Herbert's science fiction novel, about the son of a noble family entrusted with the protection of the most valuable asset and most vital element in the galaxy.", bestImage: "https://images.squarespace-cdn.com/content/v1/552672afe4b0c26feae01486/1637782853123-J37VI8VX2QL82KJP5U5W/DUNE_Indy_Movie_Poster_1.jpeg?format=1500w",raiting: 4.5, stars: 5),
            Movie(title: "The French Dispatch", description: "A love letter to journalists set in an outpost of an American newspaper in a fictional 20th-century French city that brings to life a collection of stories published in 'The French Dispatch Magazine'.", bestImage: "https://d4gvcu3i34zpu.cloudfront.net/media/original_images/poster-83b0a716-04b6-4aef-8ffb-0619fd3762e1.jpg",raiting: 7.6, stars: 3),
            Movie(title: "No Time to Die", description: "Bond has left active service and is enjoying a tranquil life in Jamaica. His peace is short-lived when his old friend Felix Leiter from the CIA turns up asking for help. The mission to rescue a kidnapped scientist turns out to be far more treacherous than expected, leading Bond onto the trail of a mysterious villain armed with dangerous new technology.", bestImage: "https://www.themoviedb.org/t/p/original/4q2NNj4S5dG2RLF9CpXsej7yXl.jpg",raiting: 4.5,stars: 5),
            Movie(title: "The Batman", description: "In his second year of fighting crime, Batman explores the corruption that plagues Gotham City and how it may tie to his own family, in addition to coming into conflict with a serial killer known as the Riddler.", bestImage:"https://assets-prd.ignimgs.com/2022/01/26/thebatman-newbutton-1643232430643.jpg",raiting: 3.5,stars: 4),
            Movie(title: "The Matrix Resurrections", description: "The fourth installment in The Matrix franchise. Plot unknown.", bestImage: "https://static.wikia.nocookie.net/matrix/images/b/bd/The_Matrix_Resurrections_digital_release_cover.jpg/revision/latest/scale-to-width-down/700?cb=20220218002244",raiting: 9.6,stars: 4),
            Movie(title: "Spider-Man: No Way Home", description: "A continuation of Spider-Man Far From Home", bestImage: "https://www.sonypictures.com/sites/default/files/styles/max_560x840/public/title-key-art/spidermannowayhome_onesheet_rating_extended_V1.jpg?itok=zCHneiV0", raiting: 8.5,stars:3)
        ]
        return movies
    }
}




struct MovieScreen: View {
    var movie:[Movie] = Movie.getRecentMovies()
    
    @Namespace
    private var animation
    
    @State
    var showNewView:Bool = false
    
    @State var animationBag:Double = 0.0
    
    @StateObject
    var moviePass:Movie = Movie(title: "", description: "", bestImage: "", raiting: 0, stars: 0)
    
    @State private var activity: Activity<MovieAttributes>? = nil
    
    @State private var circularAnimation: Bool = false
    
    @Environment(\.scenePhase) private var scenePhase


    
    var frame: Double {
        showNewView ? 400 : 380
    }
    
    var circularFrame: Double {
        circularAnimation ? 35 : 400
    }
    
    var animationPositionY: Double{
        circularAnimation ?  -397 : 0
    }
    
  
    
    var body: some View {
        
        GeometryReader{geo in
            
          
            ZStack{
                
                if showNewView {
                    
                    
                    MovieDetails(movie: self.moviePass, onTap: {
                        withAnimation {
                            self.showNewView = false
                        }
                    },namespace: animation,  frame: frame, geo: geo, cirucularAnination: $circularAnimation, animationBag: $animationBag)
                    
                }else{
             
        
                    VStack{
                        
                        PageViewBuilder(conf:Conf(itemHeight: frame, itemWidth: 270,padding: 0,cornerRadius:8),count: movie.count) {
                            index in
                            ZStack(alignment: .bottom){
                               
                                KFImage.url(URL(string: movie[index].bestImage))
                                    .resizable().aspectRatio(contentMode: .fill).matchedGeometryEffect(id: movie[index].id, in: animation)
          
                                
                                ZStack{
                                    
                                    
                                }
                                .frame(maxWidth: geo.size.width * 0.7, maxHeight: geo.size.height * 0.6) .background(
                                    LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom)
                                ).onTapGesture {
                                    
                                    withAnimation() {
                                        animationBag = 0.0
                                        circularAnimation = false
                                        self.showNewView.toggle()
                                        self.moviePass.update(with: movie[index])
                                        
                                    }
          
                                }
                                
                                VStack(alignment:.leading){
                                    Text(movie[index].title)
                                        .fontWeight(.heavy)
                                        .font(.system(size: 20))
                                        .foregroundColor(Color.white)
                                        .frame(maxWidth: .infinity, alignment:.leading).background(Color.clear)
                                    
                                    Spacer(minLength: geo.size.height * 0.002)
                                    HStack{
                                        ForEach(0..<self.movie[index].stars){_ in
                                            Image(systemName: "star.fill").foregroundColor(Color.yellow)
                                            
                                        }
                                    }
                                    
                                    Spacer(minLength: geo.size.height * 0.002)
                                    Text("People's like movie: \(movie[index].raiting, specifier: "%.1f") K")
                                        .fontWeight(.regular)
                                        .font(.system(size: 13))
                                        .foregroundColor(Color.white)
                                        .frame(maxWidth: .infinity, alignment:.leading).background(Color.clear)
                                    
                                }.frame(maxWidth: geo.size.width * 0.6, maxHeight: geo.size.height * 0.10,alignment:.leading)
                                    .background(Color.clear)
                                    .padding(.trailing,geo.size.width * 0.09)
                                    .padding(.leading,geo.size.width * 0.04)
                                    .padding(.bottom, geo.size.height * 0.05)
                                
                            }
                        }
                        
                    }.frame(maxWidth:.infinity, maxHeight: .infinity)
              
                    
                    ZStack(alignment:.center){
                   
                        RoundedRectangle(cornerRadius: circularAnimation ? 505 : 0)
                            .fill(animationBag == 1 ? .black : .clear)
                            .frame(width: circularFrame, height: circularFrame , alignment: .center)
                                 .animation(.easeIn(duration: 1.2))
                        
                        Image(systemName: "bag.fill")
                            .foregroundColor(circularAnimation ? .white : .clear)
                            .opacity(animationBag)
                            .animation(.easeIn(duration: 1.2), value: animationBag)
                    }
                    .offset(x: 0, y: animationPositionY)
                   
                 
                
                 
                }
                
            
            }
            .background(Color("backgroundColor"))
            .ignoresSafeArea()
            
        }
        .onAppear{
  
        }
       
        
        
        
    }
}

struct MovieScreen_Previews: PreviewProvider {
    static var previews: some View {
        MovieScreen( moviePass: Movie(title: "", description: "", bestImage: "", raiting: 0.0, stars: 0))
    }
}



struct CacheAsyncImage<Content>: View where Content: View{
    
    private let url: URL
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content
    
    init(
        url: URL,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ){
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }
    
    var body: some View{
        if let cached = ImageCache[url]{
            
            content(.success(cached))
        }else{
            
            AsyncImage(
                url: url,
                scale: scale,
                transaction: transaction
            ){phase in
                cacheAndRender(phase: phase)
            }
        }
    }
    func cacheAndRender(phase: AsyncImagePhase) -> some View{
        if case .success (let image) = phase {
            ImageCache[url] = image
        }
        return content(phase)
    }
}
fileprivate class ImageCache{
    static private var cache: [URL: Image] = [:]
    static subscript(url: URL) -> Image?{
        get{
            ImageCache.cache[url]
        }
        set{
            ImageCache.cache[url] = newValue
        }
    }
}

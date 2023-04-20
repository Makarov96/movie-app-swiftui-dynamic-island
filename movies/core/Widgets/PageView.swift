

import SwiftUI

protocol ManagementBuilder: ObservableObject{
    func onDragEnded(drag: DragGesture.Value)
    func getOffset(_ i:Int) -> CGFloat
    func relativeLoc() -> Int
    func getHeight(_ i:Int) -> CGFloat
    func getOpacity(_ i:Int) -> Double
}


struct Conf{
    var itemHeight:CGFloat
    var color: Color
    var itemWidth: CGFloat
    var padding:CGFloat
    var cornerRadius: CGFloat
    
    init(itemHeight: CGFloat, itemWidth:CGFloat = 300,color: Color = Color.white, padding:CGFloat = 20, cornerRadius: CGFloat = 10) {
        self.itemHeight = itemHeight
        self.color = color
        self.itemWidth = itemWidth
        self.padding = padding
        self.cornerRadius = cornerRadius
    }
}


class Builder: ManagementBuilder, ObservableObject{

    
    var views:[AnyView] = []
    @Published var carouselLocation = 0
    @GestureState var dragState = DragState.inactive
    var conf:Conf
    private var lenghtViews: Int = 0
    var elementCount:Int = 0
    
    init(views: [AnyView]=[], carouselLocation: Int = 0, conf: Conf, elementCount:Int = 0) {
        self.views = views
        self.carouselLocation = carouselLocation
        self.elementCount = elementCount
       
        self.conf = conf
        validationCountView()
    }
    
    func validationCountView()->Void{
        if views.isEmpty{
            lenghtViews = elementCount
        }else{
            lenghtViews = views.count
        }
    }
    
    
    
    func onDragEnded(drag: DragGesture.Value) {
        let dragThreshold:CGFloat = 200
        if drag.predictedEndTranslation.width > dragThreshold || drag.translation.width > dragThreshold{
            carouselLocation =  carouselLocation - 1
        } else if (drag.predictedEndTranslation.width) < (-1 * dragThreshold) || (drag.translation.width) < (-1 * dragThreshold)
        {
            carouselLocation =  carouselLocation + 1
        }
    }
    
    func getOffset(_ i: Int) -> CGFloat {
        
        //This sets up the central offset
        if (i) == relativeLoc()
        {
            //Set offset of cental
            return self.dragState.translation.width
        }
            //These set up the offset +/- 1
        else if
            (i) == relativeLoc() + 1
                ||
                (relativeLoc() == lenghtViews - 1 && i == 0)
        {
            //Set offset +1
            return self.dragState.translation.width + (300 + conf.padding)
        }
        else if
            (i) == relativeLoc() - 1
                ||
                (relativeLoc() == 0 && (i) ==  lenghtViews - 1)
        {
            //Set offset -1
            return self.dragState.translation.width - (300 + conf.padding)
        }
            //These set up the offset +/- 2
        else if
            (i) == relativeLoc() + 2
                ||
                (relativeLoc() == lenghtViews-1 && i == 1)
                ||
                (relativeLoc() == lenghtViews-2 && i == 0)
        {
            return self.dragState.translation.width + (2*(300 + conf.padding))
        }
        else if
            (i) == relativeLoc() - 2
                ||
                (relativeLoc() == 1 && i == lenghtViews-1)
                ||
                (relativeLoc() == 0 && i == lenghtViews-2)
        {
            //Set offset -2
            return self.dragState.translation.width - (2*(300 + conf.padding))
        }
            //These set up the offset +/- 3
        else if
            (i) == relativeLoc() + 3
                ||
                (relativeLoc() == lenghtViews-1 && i == 2)
                ||
                (relativeLoc() == lenghtViews-2 && i == 1)
                ||
                (relativeLoc() == lenghtViews-3 && i == 0)
        {
            return self.dragState.translation.width + (3*(300 + conf.padding))
        }
        else if
            (i) == relativeLoc() - 3
                ||
                (relativeLoc() == 2 && i == lenghtViews-1)
                ||
                (relativeLoc() == 1 && i == lenghtViews-2)
                ||
                (relativeLoc() == 0 && i == lenghtViews-3)
        {
            //Set offset -2
            return self.dragState.translation.width - (3*(300 + conf.padding))
        }
            //This is the remainder
        else {
            return 10000
        }

    }
    
    func relativeLoc() -> Int {
        return ((lenghtViews * 10000) + carouselLocation) % lenghtViews
        
    }
    
    func getHeight(_ i: Int) -> CGFloat {
        if i == relativeLoc(){
            return conf.itemHeight
        } else {
            return conf.itemHeight - 100
        }
    }
    
    func getOpacity(_ i: Int) -> Double {
        if i == relativeLoc()
            || i + 1 == relativeLoc()
            || i - 1 == relativeLoc()
            || i + 2 == relativeLoc()
            || i - 2 == relativeLoc()
            || (i + 1) - lenghtViews == relativeLoc()
            || (i - 1) + lenghtViews == relativeLoc()
            || (i + 2) - lenghtViews == relativeLoc()
            || (i - 2) + lenghtViews == relativeLoc()
        {
            return 1
        } else {
            return 0
        }
    }
    
    
}


struct PageViewBuilder<T> : View where T : View{
    var count:Int
    var conf:Conf
    @ViewBuilder var builder: (_ index:Int) -> T
    @StateObject private var management: Builder

    public init(animation:Namespace.ID? = nil,conf:Conf,count: Int = 0, @ViewBuilder builder: @escaping (_ index:Int) -> T ) {
        self.count = count
        self.builder = builder
        self.conf = conf
      
        self._management = StateObject(wrappedValue:  Builder( conf: conf, elementCount: count))
      
    }
    
   
    var body: some View{
        ZStack{
            VStack{
                ZStack{
                    ForEach(0..<self.count, id: \.self){i in
                        VStack{
                            Spacer()
                          
                            self.builder(i)
                                .frame(width:conf.itemWidth, height: management.getHeight(i)).background(conf.color)
                            .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
                                .background(Color.white)
                                .cornerRadius(conf.cornerRadius)
                            .shadow(radius: 3)
                            .opacity(management.getOpacity(i))
                            .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
                            .offset(x: management.getOffset(i))
                            .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
                            Spacer()
                        }
                    }
                    
                }.gesture(
                    
                    DragGesture()
                        .updating(self.management.$dragState) { drag, state, transaction in
                            state = .dragging(translation: drag.translation)
                    }
                        .onEnded(management.onDragEnded)
                    
                )
                
                Spacer()
            }
        }
    }
}


struct PageView: View {
 

    var views:[AnyView]
    var conf:Conf
    @ObservedObject private var management: Builder
    init(views: [AnyView], conf: Conf) {
    
        self.views = views
        self.conf = conf
        self.management = Builder(views: views, conf: conf)
    }

    
    var body: some View {
        ZStack{
            VStack{
                
                ZStack{
                    ForEach(0..<views.count){i in
                        VStack{
                            Spacer()
                            self.views[i]
                                .frame(width:300, height: management.getHeight(i))
                            .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
                                .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                                
                                
                            .opacity(management.getOpacity(i))
                            .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
                            .offset(x: management.getOffset(i))
                            .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
                            Spacer()
                        }
                    }
                    
                }.gesture(
                    
                    DragGesture()
                        .updating(self.management.$dragState) { drag, state, transaction in
                            state = .dragging(translation: drag.translation)
                    }
                        .onEnded(management.onDragEnded)
                    
                )
                
                Spacer()
            }
            VStack{
                Spacer()
                Spacer().frame(height:conf.itemHeight + 50)
                Text("\(management.relativeLoc() + 1)/\(views.count)").padding()
                Spacer()
            }
        }
    }
    
    
}





enum DragState {
    case inactive
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    
    var isDragging: Bool {
        switch self {
        case .inactive:
            return false
        case .dragging:
            return true
        }
    }
}

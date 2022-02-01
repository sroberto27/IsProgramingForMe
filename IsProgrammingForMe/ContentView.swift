//
//  ContentView.swift
//  IsProgrammingForMe
//
//  Created by roberto salazar on 12/2/21.

/*
 the name of the app
 ISProgrammingForMe
 the author of the app
 Roberto Salazar
 in a single sentence, the intent or purpose of the app
 the purpose of the app is to let people know if they have some inclination to be good programmers by taking a quiz. it also providade with intersting information about coding jobs.
 a list of required techniques starting
 Video player
 Animation movement
 Graphs and statistics
 Coredata
 
 a description of what the app does and how it does it
The app starts showing a video to the user about coding. then the user can go and take a quiz to know if coding
 is for then. at the end of the quiz the app shows the results and also shows somo intersting graphs and statistics
 about programming jobs. the app uses a json file to store the ten questions of the quiz and also the video link. using arrays and buttons the app counts the points that the user earns depending on the users' answer. at the end the total quiz grade is calculated adding the array values. the score and the date is stored using coredata so the user can check old scores results.
 
 */

import SwiftUI
import Combine
import AVKit
import CoreData


var flag = false
struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var spacerService = SpacerService()
   // @State var voteTypes : [String] = ["Dislike", "OK", "LIKE"]
    @State var voteChoice: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0]
    @State var theQ = ""
    @State var tranf = ""
    @State var totalScore = 0
    @State var counter = 0
    // graph oj jobs by area
    @State var Industries = [
        SourdoughSearchDataPoint(rating: 38, name: "Tech Companies 38%"),
            SourdoughSearchDataPoint(rating: 9, name: "Finance 9%"),
            SourdoughSearchDataPoint(rating: 8, name: "Health care 8%"),
            SourdoughSearchDataPoint(rating: 7, name: "Manufactoring 7%"),
            SourdoughSearchDataPoint(rating: 6, name: "Engineering 6%"),
            SourdoughSearchDataPoint(rating: 6, name: "Government 6%"),
            SourdoughSearchDataPoint(rating: 21, name: "Others 21%")
    ]
    //graph job salary by years of experience
    @State var Experience = [
        SourdoughSearchDataPoint(rating: 69, name: "Entry Lvl 69K"),
            SourdoughSearchDataPoint(rating: 84, name: "Early Lvl 84K"),
            SourdoughSearchDataPoint(rating: 107, name: "Mid Lvl 107K"),
            SourdoughSearchDataPoint(rating: 123, name: "Experienced 123K"),
            SourdoughSearchDataPoint(rating: 123, name: "Late Lvl 123K")
    ]
    //salary by lenguage
    @State var Lenguage = [
        SourdoughSearchDataPoint(rating: 123, name: "IOS 123K"),
            SourdoughSearchDataPoint(rating: 121, name: "Android 121K"),
            SourdoughSearchDataPoint(rating: 110, name: "Python 110K"),
            SourdoughSearchDataPoint(rating: 105, name: "C++ 105K"),
            SourdoughSearchDataPoint(rating: 103, name: "JAVA 103K")
    ]
    @State var LenguagePopularity = [
        SourdoughSearchDataPoint(rating: 19, name: "JavaScript 19%"),
            SourdoughSearchDataPoint(rating: 16, name: "Python 16%"),
            SourdoughSearchDataPoint(rating: 11, name: "JAVA 11%"),
            SourdoughSearchDataPoint(rating: 9, name: "GO 9%"),
            SourdoughSearchDataPoint(rating: 8, name: "C++ 8%"),
        SourdoughSearchDataPoint(rating: 37, name: "Other 37%")
    ]
    
    //animamation
    @State private var animateThis = false
    func setCounter( value: Int){
        counter = value
    }
    func IncreaseCounter(){
        if counter < 12 {
            //flag = false
            counter += 1
        }else{
            counter = 0
        }
        
//        if counter == 11{
//            flag = true
//            counter = 0
//        }
    }
    func DecreaseCounter(){
        if counter>0 {
            counter -= 1
        }else{
            counter = 0
        }
    }
    func getCounter()-> Int{
        return counter
    }
    func recordScore( score: Int){
        if counter  < 12 {
        voteChoice[counter] = score
        }
    }
    func resetScores(scores : Int){
        for n in 0...11 {
            voteChoice[n] = scores
        }
        totalScore = 0
    }
    func getToltalScore()-> Int{
        for scores in voteChoice {
            totalScore += scores
        }
        
        return totalScore
    }
    private func addItem(str: String) {
        tranf = str
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        let datetime = formatter.string(from: now)
        let newItem = Item(context: viewContext)
        newItem.score = tranf
        newItem.date = datetime
        newItem.realD = now
            

            do {
                try viewContext.save()
                tranf = ""
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        
    }
    var body: some View {
        NavigationView {
            VStack {
                
                    ForEach(spacerService.spacers, id: \.self) { spacer in
                     //   Text("somethin 1")
                        Text("Is Coding For You?").font(.title).padding()
                           // Text(spacer.questions[counter].question).padding(55)
                        Text(theQ).font(.title3)
                        
                        //Text(spacer.questions[counter].question).padding(55)
                        VStack{
                            if counter == 0{
                                VStack {
                                    GeometryReader { greader in
                                                HStack {
                                                    Image(systemName: "questionmark.circle")
                                                }
                                                .frame(width: greader.size.width,
                                                       height: greader.size.height/2,
                                                       alignment: self.animateThis ? .bottom : .top )
                                    }
                                    .edgesIgnoringSafeArea([.all])
                                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: true))
                                    .onAppear {
                                        self.animateThis = true
                                        print("lololo")
                                        print(spacer.link!)
                                    }
                                            // playing a video that is part of the project
//                                            VideoPlayer(player: AVPlayer(
//                                                url:  Bundle.main.url(
//                                                    forResource: "What do programmers do?", withExtension: "mp4")!))
//                                        .frame(height: 400)
                                            VideoPlayer(player: AVPlayer(
                                                url:  URL(string: spacer.link!)!))
                                        .frame(height: 400)
                                    Button(" Start TEST ") {
                                       
                                        IncreaseCounter()
                                        print(counter)
                                        theQ = spacer.questions[counter].question
                                    }.padding()
                                        .font(.title3)
                                 }
                                
                                
                            }else{
                                if counter == 11 {
                                    VStack{
                                    Text("is your total escore ").onAppear(){
                                        if !flag{
                                            print("ttgottttttttttttgdgfd")
                                        theQ = "\(getToltalScore())"
                                        addItem(str: theQ)
                                        }
                                        print(voteChoice)
                                    }.padding()
                                        Text("0 to 9 points = You will not like this career.")
                                        Text("10 to 15 points = You are the right person for the job.")
                                        Text("16 to 20 points = You are perfect for this career")
                                        
                                    Button(" RE-TEST ") {
                                        flag = false
                                        setCounter(value: 0)
                                        resetScores(scores: 0)
                                        print(voteChoice)
                                        print(counter)
                                        theQ = spacer.questions[counter].question
                                    }.font(.title3)
                                        List{
                                            ZStack {
                                                        VStack {
                                                            Text("Industries Developers Work")
                                                                .font(.system(size: 25))
                                                            HStack {
                                                                ForEach(Industries) {
                                                                    BarViewPercent(dataPoint: $0)
                                                                }.font(.system(size: 9))
                                                                
                                                            }
                                                        }
                                                
                                            }
                                            ZStack {
                                                        VStack {
                                                            Text("IOS developers Avg annual salary by experience")
                                                                .font(.system(size: 25))
                                                            HStack {
                                                                ForEach(Experience) {
                                                                    BarViewSalary(dataPoint: $0)
                                                                }.font(.system(size: 8.5))
                                                                
                                                            }
                                                        }
                                                
                                            }
                                            ZStack {
                                                        VStack {
                                                            Text("Salary by Languages")
                                                                .font(.system(size: 25))
                                                            HStack {
                                                                ForEach(Lenguage) {
                                                                    BarViewSalary(dataPoint: $0)
                                                                }.font(.system(size: 10))

                                                            }
                                                        }

                                            }
                                            ZStack {
                                                        VStack {
                                                            Text("Language Popularity By GIT HUB repositories")
                                                                .font(.system(size: 25))
                                                            HStack {
                                                                ForEach(LenguagePopularity) {
                                                                    BarViewPercent(dataPoint: $0)
                                                                }.font(.system(size: 9))

                                                            }
                                                        }

                                            }
//                                            List {
//                                                ForEach(items) { item in
//                                                    NavigationLink {
//                                                        Text("Item at \(item.score!)")
//                                                    } label: {
//                                                        Text(item.score!)
//                                                    }
//                                                }
//
//                                            }
                                            
                                           
                                                    NavigationLink(destination: OldScores()){
                                                        Text("CHECK old TEST results").foregroundColor(.blue)
                                                    }
                                            
                                        }
                                        
//                                    Button(" Check your Score ") {
//                                        counter = 0
//                                        IncreaseCounter()
//                                        print(counter)
//
//                                    }.padding()
                                  //  theQ =
                                }
                                }else{
                                    Button(" Dislike ") {
                                        IncreaseCounter()
                                        recordScore(score: 0)
                                        print(counter)
                                        theQ = spacer.questions[counter].question
                                    }.padding()
                                        .font(.title3)
                    
                              
                                    Button(" Okay "){
                                        IncreaseCounter()
                                        recordScore(score: 1)
                                        print(counter)
                                        theQ = spacer.questions[counter].question
                                    }.padding()
                                        .font(.title3)
                                
                                    Button(" Like "){
                                        IncreaseCounter()
                                        recordScore(score: 2)
                                        print(counter)
                                        theQ = spacer.questions[counter].question
                                    }.padding()
                                        .font(.title3)
                              
                                }
                            }
                        
                    }
                    }.onAppear(){
                        //setCounter(value: 0)
                        print("counter inicial \(getCounter())")
                        
                    }
                

                    
                
                    if spacerService.errorMessage.count == 0 {
                        Text("\(spacerService.errorMessage)")
                    }
                
                
            }
        }.onAppear(perform: {spacerService.getSpacers()})
    }}

struct Questions: Decodable, Hashable {
    var question: String!
}

struct Spacers: Decodable, Hashable {
    var questions: [Questions] = []
    var link: String!
}
class SpacerService: ObservableObject {
 @Published var errorMessage: String = ""
 @Published var spacers: [Spacers] = []
 private var cancellableSet: Set<AnyCancellable> = []
 func getSpacers() {
     let spacersurl = URL(string:"https://api.jsonbin.io/b/619532a862ed886f9150220b/6")!
     
     URLSession.shared
         .dataTaskPublisher(for: URLRequest(url: spacersurl))
         .map(\.data)
         .decode(type: Spacers.self, decoder: JSONDecoder())
         .receive(on: RunLoop.main)
         .sink { completion in
             switch completion {
             case .finished:
                 break
             case .failure(let error):
                 self.errorMessage = error.localizedDescription
             }
         } receiveValue: {
             self.spacers.insert($0, at: 0)
         }.store(in: &cancellableSet)
 }
}
struct SourdoughSearchDataPoint: Identifiable {
    let id = UUID()
    let rating: Int
    let name: String
}
struct BarViewSalary: View {
    var dataPoint: SourdoughSearchDataPoint
    //@State var val = 1
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 35, height: 129)
            
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 35,height: CGFloat(dataPoint.rating * 1))
            }
            Text(dataPoint.name)
                .rotationEffect(.degrees(0))
        }
    }
}
struct BarViewPercent: View {
    var dataPoint: SourdoughSearchDataPoint
    //@State var val = 1
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 35, height: 129)
            
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 35,height: CGFloat(dataPoint.rating * 2))
            }
            Text(dataPoint.name)
                .rotationEffect(.degrees(0))
        }
    }
}

//private let itemFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .short
//    formatter.timeStyle = .medium
//    return formatter
//}()


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

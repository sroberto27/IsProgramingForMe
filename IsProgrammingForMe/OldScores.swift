//
//  OldScores.swift
//  IsProgrammingForMe
//
//  Created by roberto salazar on 12/3/21.
//

import SwiftUI

struct OldScores: View {

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.realD, ascending: false)],
        animation: .default)
    private var items: FetchedResults<Item>
    var body: some View {
        Text("OLD Scores")
        NavigationView{
            List {
                ForEach(items, id: \.self) { item in
                        
                        Text("Score: \(item.score!)     Date: \(item.date!)")
                    }
            }
        }.onAppear(){
            flag = true
        }
       
        
        
    }
}

struct OldScores_Previews: PreviewProvider {
    static var previews: some View {
        OldScores()
    }
}

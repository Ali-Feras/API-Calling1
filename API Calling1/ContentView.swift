//
//  ContentView.swift
//  API Calling1
//
//  Created by Ali on 26/07/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var singles = [Single]()
    @State private var showingAlert = false
    var body: some View {
        NavigationView {
            List(singles) {single in
                NavigationLink(
                    destination: VStack {
                        Text(single.rank)
                        Text(single.title)
                        Text(single.artist)
                        Text("Last week: \(single.lastWeek)")
                        Text("Peak position: \(single.peakPosition)")
                        Text("Weeks on chart: \(single.weeksOnChart)")
                        Text("Detail: \(single.detail)")
                    },
                    label: {
                        HStack {
                            Text(single.rank)
                            Text(single.title)
                            Text(single.artist)
                        }
                    })
            }
            .navigationTitle( "Top Songs")
        }
        .onAppear(perform: {
            queryAPI()
        })
        .alert(isPresented: $showingAlert, content: {
            Alert(title: Text("Loading Error"),
                  message: Text("There was a problem loading the data"),
                  dismissButton: .default(Text("OK")))
        })
    }
    
    func queryAPI() {
        let apiKey = "&rapidapi-key=05f449da62msh370ceb6d1410ef5p1864afjsn99d62602e505"
        let query = "https://billboard-api2.p.rapidapi.com/hot-100?date=2022-07-28&range=1-10\(apiKey)"
        if let url = URL(string: query) {
            if let data = try? Data(contentsOf: url) {
                let json = try! JSON(data: data)
                let content = json["content"].dictionaryValue
                for i in 1...10 {
                    if let item = content[String(i)]?.dictionaryValue {
                        let rank = item["rank"]!.stringValue
                        let title = item["title"]!.stringValue
                        let artist = item["artist"]!.stringValue
                        let lastWeek = item["last week"]!.stringValue
                        let peakPosition = item["peak position"]!.stringValue
                        let weeksOnChart = item["weeks on chart"]!.stringValue
                        let detail = item["detail"]!.stringValue
                        let single = Single(rank: rank, title: title, artist:artist, lastWeek: lastWeek, peakPosition:peakPosition, weeksOnChart: weeksOnChart, detail:detail)
                        singles.append(single)
                    }
                }
                return
            }
        }
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Single: Identifiable {
    let id = UUID()
    let rank: String
    let title: String
    let artist: String
    let lastWeek: String
    let peakPosition: String
    let weeksOnChart: String
    let detail: String
}

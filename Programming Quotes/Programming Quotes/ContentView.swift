//
//  ContentView.swift
//  Programming Quotes
//

import SwiftUI

struct ContentView: View {
  
  @State private var quoteData: QuoteData?

  var body: some View {
    HStack {
      Spacer()
      
      VStack(alignment: .trailing) {
        Spacer()
        
        Text(quoteData?.quoteText ?? "")
          .font(.title2)
        Text("- \(quoteData?.author ?? "")")
          .font(.title2)
          .padding(.top)
        
        Spacer()
        
        Button(action: loadData) {
          Image(systemName: "arrow.clockwise")
        }
        .font(.title)
        .padding(.top)
      }
    }
    .multilineTextAlignment(.trailing)
    .padding()
    .onAppear(perform: loadData)
  }

  private func loadData() {
    guard let url = URL(string: "https://api.forismatic.com/api/1.0/?method=getQuote&format=jsonp&jsonp=parseQuote") else {
      return
    }
    URLSession.shared.dataTask(with: url) { data, response, error in
      guard let data = data else { return }
      if let decodedData = try? JSONDecoder().decode(QuoteData.self, from: data) {
        DispatchQueue.main.async {
          self.quoteData = decodedData
        }
      }
    }.resume()
  }
}

struct QuoteData: Decodable {
  var quoteText : String
  var author: String
  var id: String
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

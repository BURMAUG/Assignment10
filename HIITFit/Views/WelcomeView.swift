/// Copyright (c) 2021 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

struct WelcomeView: View {
    @State private var showHistory = false
    @Binding var selectedTab: Int
    @EnvironmentObject var history: HistoryStore
    var getStartedButton: some View {
        RaisedButton(btn_text: "Get Started") {
        selectedTab = 0
      }
      .padding()
    }

    
    var historyButton: some View {
      Button(
        action: {
          showHistory = true
        }, label: {
          Text("History")
            .fontWeight(.bold)
            .padding([.leading, .trailing], 5)
        })
        .padding(.bottom, 10)
        .buttonStyle(EmbossedButtonStyle())
    }


    var body: some View {
        GeometryReader { geometry in
          VStack {
            HeaderView(
              selectedTab: $selectedTab,
              titleText: "Welcome")
            Spacer()
            // container view starts
            ContainerView {
              VStack {
                WelcomeView.images
                WelcomeView.welcomeText
                getStartedButton
                Spacer()
                historyButton
                  .sheet(isPresented: $showHistory) {
                      HistoryView(showHistory: $showHistory).environmentObject(history)
                  }
              }//Vstack ends
            }//container ends
            .frame(height: geometry.size.height * 0.8)
          }
        }

    }

}

struct WelcomeView_Previews: PreviewProvider {
  static var previews: some View {
    WelcomeView(selectedTab: .constant(9))
  }
}
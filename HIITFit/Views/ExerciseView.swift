import SwiftUI
import AVKit

struct ExerciseView: View {
    @EnvironmentObject var history: HistoryStore
    @State private var showHistory = false
    @State private var showSuccess = false
    @Binding var selectedTab: Int
    let index: Int
    @State private var timerDone = false
    @State private var showTimer = false
    @State private var showSheet: Bool = false
    @State private var exerciseSheet: ExerciseSheet?

    enum ExerciseSheet {
      case history, timer, success
    }


  var lastExercise: Bool {
    index + 1 == Exercise.exercises.count
  }

  var body: some View {
    GeometryReader { geometry in
      VStack {
        HeaderView(
          selectedTab: $selectedTab,
          titleText: Exercise.exercises[index].exerciseName)
          .padding(.bottom)
          Spacer()
          ContainerView {
            VStack {
              video(size: geometry.size)
              startExerciseButton
                .padding(20)
              RatingView(exerciseIndex: index)
                .padding()
              Spacer()
              historyButton
            }
          }
          .frame(height: geometry.size.height * 0.8)
          .sheet(isPresented: $showSheet, onDismiss: {
            showSuccess = false
            showHistory = false
            if exerciseSheet == .timer {
              if timerDone {
              history.addDoneExercise(Exercise.exercises[index].exerciseName)
                timerDone = false
              }
              showTimer = false
              if lastExercise {
                showSuccess = true
                showSheet = true
                exerciseSheet = .success
              } else {
                selectedTab += 1
              }
            } else {
              exerciseSheet = nil
            }
            showTimer = false
          }, content: {
            if let exerciseSheet = exerciseSheet {
              switch exerciseSheet {
              case .history:
                HistoryView(showHistory: $showHistory)
                  .environmentObject(history)
              case .timer:
                  TimerView(timerDone:  $timerDone, exerciseName: Exercise.exercises[index].exerciseName)// Exercise.exercises[index].exerciseName
              case .success:
                SuccessView(selectedTab: $selectedTab)
              }
            }
          })
      }
    }
  }
    //introduced
    @ViewBuilder
    func video(size: CGSize) -> some View {
      if let url = Bundle.main.url(
        forResource: Exercise.exercises[index].videoName,
          withExtension: "mp4") {
        VideoPlayer(player: AVPlayer(url: url))
          .frame(height: size.height * 0.25)
          .clipShape(RoundedRectangle(cornerRadius: 12))
          .padding(20)
      } else {
        Text(
          "Couldn't find \(Exercise.exercises[index].videoName).mp4")
          .foregroundColor(.red)
      }
    }

    //done
  var startExerciseButton: some View {
    RaisedButton(btn_text: "Start Exercise") {
      showTimer.toggle()
        showSheet = true
        exerciseSheet = .timer
    }
  }

    //done
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
}
//done
struct ExerciseView_Previews: PreviewProvider {
  static var previews: some View {
    ExerciseView(selectedTab: .constant(0), index: 0)
      .environmentObject(HistoryStore())
  }
}

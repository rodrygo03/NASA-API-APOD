//
//  ContentView.swift
//  APOD
//
//  Created by rodrigo Orozco  on 2/26/24.
//

import SwiftUI


struct ContentView: View {
    @State private var picOfDay = APOD()
    var body: some View {
        VStack(spacing: 3) {
            Text(picOfDay.date)
                .font(.headline)
            Text(picOfDay.title)
                .font(.title)
                .multilineTextAlignment(.center)
            AsyncImage(url: URL(string: picOfDay.hdurl)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                }
                else if phase.error != nil  {
                    Text("Error loading image")
                }
                else {
                    ProgressView()
                }
            }
        }


        ScrollView  {
            VStack {
                Text(picOfDay.explanation)
                    .lineSpacing(8)
                    .padding([.horizontal, .bottom])
            }
        }

        .task {
            do {
                try await picOfDay = fetchAPOD()
                print("Success")
            } catch CallError.fileNotFound {
                print("file not found")
            } catch CallError.contentError {
                print("error in file contents")
            } catch CallError.invalidResponse {
                print("Non 200 status code")
            } catch CallError.invalidURL {
                print("Error with URL")
            } catch {
                print("Other error")
            }
        }

    }
}
#Preview {
    ContentView()
}

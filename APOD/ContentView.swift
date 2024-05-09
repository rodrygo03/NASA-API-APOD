//
//  ContentView.swift
//  APOD
//
//  Created by rodrigo Orozco  on 2/26/24.
//

import SwiftUI
import WebKit


struct VideoView: UIViewRepresentable   {
    let apod: APOD
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let url = URL(string: apod.url) else {return}
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

/* Testing Video Media Type using hard link*/
//var s = "https://www.youtube.com/embed/l36UkYtq6m0?rel=0"
//struct tView: UIViewRepresentable   {
//    let str: String
//    
//    func makeUIView(context: Context) -> WKWebView {
//        return WKWebView()
//    }
//    func updateUIView(_ uiView: WKWebView, context: Context) {
//        guard let url = URL(string: str) else {return}
//        let request = URLRequest(url: url)
//        uiView.load(request)
//    }
//}

struct ContentView: View {
    @State private var picOfDay = APOD()
    var body: some View {
        VStack(spacing: 3) {
            Text(picOfDay.date)
                .font(.headline)
            Text(picOfDay.title)
                .font(.title)
                .multilineTextAlignment(.center)
            
            // define a closer to allow readiablity ?
            if (picOfDay.media_type == "video") {
                VideoView(apod: picOfDay)
            }
            else {
                AsyncImage(url: URL(string: picOfDay.url)) { phase in
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
                print(picOfDay.url)
            } catch CallError.fileNotFound {
                print("file not found")
            } catch CallError.contentError {
                print("error in file contents")
            } catch CallError.invalidResponse {
                print("Non 200 status code")
            } catch CallError.invalidURL {
                print("Error with URL")
            } catch {
                print("Other error: \(error)")
            }
        }

    }
}

#Preview {
    ContentView()
}

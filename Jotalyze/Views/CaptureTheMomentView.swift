//
//  CaptureTheMomentView.swift
//  Jotalyze
//
//  Created by Adam Heidmann on 3/18/25.
//

import PhotosUI
import SwiftUI
import UIKit

struct CaptureTheMomentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Environment(\.requestReview) var requestReview
    @Environment(\.dismiss) var dismiss
    @State var journalManager: JournalManager
    
    @FocusState private var isTextFieldFocused: Bool
    
    @State var momentEntryText = ""
    
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    // Raw item selected from library
    @State private var attachedPhoto: UIImage? = nil
    
    @State private var isCameraPresented = false
        @State private var capturedImage: UIImage?
    
    var body: some View {
        
        ZStack{
            
            if attachedPhoto != nil || capturedImage != nil {
                if colorScheme == .light {
                    Color.white.ignoresSafeArea()
                }
                if colorScheme == .dark {
                    Color.black.ignoresSafeArea()
                }
            } else {
                
                backgroundColor.ignoresSafeArea()
            }
            VStack{
                HStack{
                    Button("Cancel"){
                        dismiss()
                    }.tint(colorScheme == .light ? .black : .white)
                    Spacer()
                    
                    if attachedPhoto != nil || capturedImage != nil{
                        Button{
                           
                            Task {
                                    await savePictureEntryAsync()
                                    dismiss()
                                }

                            if journalManager.journalEntries.count == 5 || journalManager.journalEntries.count == 20 || journalManager.journalEntries.count == 50 || journalManager.journalEntries.count == 75 ||
                                journalManager.journalEntries.count == 100 {
                                requestReview()
                            }
                            
                            //calendarViewSelected = nil
                            //allSelected = true
                            
                            
                        }label:{
                                   Text("Save")
                        }.disabled(momentEntryText.isEmpty).tint(colorScheme == .light ? .black : .white)
                    }
                    
                }.padding(.bottom, 30).padding(.top, 20)
                
                
                if attachedPhoto == nil && capturedImage == nil{
                    
                    
                    VStack(spacing: 20){
                        
                        
                        VStack {
                            // Upload Photo Button
                            
                            
                            PhotosPicker(selection: $selectedPhotoItem, matching: .images){
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10).foregroundStyle(colorScheme == .light ? .white : darkGrayColor).frame(width: 250, height: 50).shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                                    Text("Upload Photo")
                                        .foregroundStyle(colorScheme == .light ? .black : .white)
                                        .fontWeight(.light)
                                }
                            }.tint(colorScheme == .light ? .black : .white)
                            
                            
                        }.padding(.top, 150)
                            .onChange(of: selectedPhotoItem) { _, newPhotoItem in
                                capturedImage = nil
                                Task {
                                    if let data = try? await newPhotoItem?.loadTransferable(type: Data.self),
                                       let uiImage = UIImage(data: data) {
                                        
                                        attachedPhoto = uiImage // Now safe to display or upload
                                    }
                                }
                            }
                        
                        
                        VStack{
                            Button{
                                selectedPhotoItem = nil
                                attachedPhoto = nil
                                isCameraPresented = true
                            }label:{
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10).foregroundStyle(colorScheme == .light ? .white : darkGrayColor).frame(width: 250, height: 50).shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                                    Text("Take Photo")
                                } .fontWeight(.light)
                                    .foregroundStyle(colorScheme == .light ? .black : .white)
                            }
                            .sheet(isPresented: $isCameraPresented) {
                                CameraPicker(isPresented: $isCameraPresented, capturedImage: $capturedImage).ignoresSafeArea()
                            }
                            
                            
                            
                        }
                        
                        Spacer()
                    }
                }
                
                VStack{
                    // Show confirmation / preview
                    if let attachedPhoto = attachedPhoto {
                        VStack{
                            
                            Image(uiImage: attachedPhoto)
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .frame(maxWidth: 100, maxHeight: 100)
                            
                            HStack{
                                Image(systemName: "checkmark.circle").font(.caption)
                                Text("Photo Attached").font(.caption)
                            }.foregroundStyle(colorScheme == .light ? .black : .white).padding(.top, 10).fontWeight(.light)
                            
                        }
                    }
                    
                    if let image = capturedImage {
                        VStack{

                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .frame(maxWidth: 100, maxHeight: 100)
                            
                            HStack{
                                Image(systemName: "checkmark.circle").font(.caption)
                                Text("Photo Attached").font(.caption)
                            }.foregroundStyle(colorScheme == .light ? .black : .white).padding(.top, 10).fontWeight(.light)
                            
                        }
                    }
                    
                    
                }.padding(.bottom, 5)
                
                
                if attachedPhoto != nil || capturedImage != nil {
                    Divider().padding(.vertical, 10)
                    
                    ScrollViewReader{proxy in
                        ScrollView{
                            ZStack(alignment: .topLeading){
                                if momentEntryText.isEmpty {
                                    Text("What are your thoughts and feelings about this moment? What emotions come to mind?").fontWeight(.light).foregroundStyle(Color(UIColor.placeholderText))
                                }
                                TextField("", text: $momentEntryText, axis: .vertical).id("bottom")
                                    .fontWeight(.light)
                                    .focused($isTextFieldFocused)
                                    .tint(colorScheme == .light ? .black : .white)
                            }
                        }.frame(height: 130)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    isTextFieldFocused = true // Delay to ensure it works
                                    
                                }
                            }
                        
                            .onTapGesture {
                                isTextFieldFocused = true // Focus when tapped anywhere in the area
                            }
                            .onChange(of: momentEntryText) {
                                withAnimation {
                                    proxy.scrollTo("bottom", anchor: .bottom)
                                }
                            }
                        
                    }
                }
                
                
                Spacer()
            }.padding(.horizontal)
        }
    }
    
    var backgroundColor: some View {
        Color.gray.opacity(0.1)
    }
    
    func savePictureEntryAsync() async {
        // Capture the current state safely
        let image = capturedImage ?? attachedPhoto
        let text = momentEntryText

        guard let image else { return }

        let imagesDir = JournalManager.shared.imagesDirectory()
        let fileURL = imagesDir.appendingPathComponent("\(UUID()).png")

        if let pngData = image.pngData() {
            try? pngData.write(to: fileURL, options: .completeFileProtection)

            let newEntry = JournalEntry(
                id: UUID(),
                mood: "",
                title: "",
                entry: text,
                date: Date.now,
                entryType: "Photo",
                imageData: nil,
                thumbnailPath: fileURL.lastPathComponent
            )
            
            // ✅ Add to in-memory cache immediately to avoid placeholder flicker
            ImageCache.shared.cache.setObject(image, forKey: newEntry.id.uuidString as NSString)

            // Save and refresh on main actor
            await MainActor.run {
                JournalManager.shared.saveJournalEntry(newEntry)
                JournalManager.shared.getAllJournalEntries()
            }
        }
    }
    
    var darkGrayColor: Color {
        Color(red: 25/255, green: 25/255, blue: 25/255)
    }
    
}

#Preview {
    CaptureTheMomentView(journalManager: JournalManager())
}

struct CameraPicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var capturedImage: UIImage?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraPicker

        init(parent: CameraPicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.capturedImage = image
            }
            parent.isPresented = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

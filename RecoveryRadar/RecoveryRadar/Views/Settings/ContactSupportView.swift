import SwiftUI

struct ContactSupportView: View {
    @State private var feedbackText = ""
    @State private var email = ""
    @State private var isSending = false
    @State private var showSuccess = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Your Email", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                } header: {
                    Text("Contact Info")
                }

                Section {
                    TextField("Describe your issue or feedback...", text: $feedbackText, axis: .vertical)
                        .lineLimit(5...10)
                } header: {
                    Text("Feedback")
                }

                Section {
                    Button(action: sendFeedback) {
                        HStack {
                            Spacer()
                            if isSending {
                                ProgressView()
                            } else {
                                Text("Send Feedback")
                                    .bold()
                            }
                            Spacer()
                        }
                    }
                    .disabled(feedbackText.isEmpty || email.isEmpty || isSending)
                }
            }
            .navigationTitle("Contact Support")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
            .alert("Thank You!", isPresented: $showSuccess) {
                Button("OK") { dismiss() }
            } message: {
                Text("Your feedback has been received. We'll get back to you soon.")
            }
        }
    }

    private func sendFeedback() {
        isSending = true
        let mailto = "support@zzoutuo.com?subject=RecoveryRadar%20Feedback&body=\(feedbackText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        if let url = URL(string: "mailto:\(mailto)") {
            UIApplication.shared.open(url)
        }
        isSending = false
        showSuccess = true
    }
}

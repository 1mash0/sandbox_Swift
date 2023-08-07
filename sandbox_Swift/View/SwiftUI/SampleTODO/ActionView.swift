import SwiftUI

struct ActionView: View {
    @Environment(\.dismiss) var dismiss

    let delegate: ActionProtocol

    @State var text: String
    let path: SampleTODOView.RouterPath

    init(
        delegate: ActionProtocol,
        text: String,
        path: SampleTODOView.RouterPath
    ) {
        self.delegate = delegate
        _text = .init(initialValue: text)
        self.path = path
    }

    var body: some View {
        VStack(spacing: 16) {
            TextField(path.placeHolder, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(path.text) {
                switch path {
                    case .add:
                        delegate.add(text: text)
                    case let .update(index, _):
                        delegate.update(text: text, index: index)
                }
                dismiss()
            }
        }
        .padding()
    }
}

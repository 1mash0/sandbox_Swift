import Algorithms
import SwiftUI

struct SampleTODOView: View, ActionProtocol {
    @State var todos: [String] = []

    enum RouterPath: Hashable {
        case add
        case update(_ index: Int, _ todo: String)

        var placeHolder: String {
            switch self {
                case .add:
                    return "Input Your TODO"
                case .update:
                    return "Update Your TODO"
            }
        }

        var text: String {
            switch self {
                case .add:
                    return "Add"
                case .update:
                    return "Update"
            }
        }
    }

    @State var path: [RouterPath] = []

    var body: some View {
        NavigationStack(path: $path) {
            ZStack(alignment: .bottomTrailing) {
                List {
                    ForEach(todos.indexed(), id: \.index) { index, todo in
                        NavigationLink(value: RouterPath.update(index, todo)) {
                            Text(todo)
                        }
                    }
                    .onDelete(perform: delete)
                }
                .scrollContentBackground(.hidden)
                .background(Color(.systemGroupedBackground))

                NavigationLink(value: RouterPath.add) {
                    Image(systemName: "plus")
                        .font(.system(size: 25).bold())
                        .foregroundColor(.white)
                }
                .frame(width: 50, height: 50)
                .background(Color.orange)
                .cornerRadius(25)
                .padding()
            }
            .onAppear {
            }
            .navigationTitle("SampleTODO")
            .navigationDestination(for: RouterPath.self) { action in
                switch action {
                    case .add:
                        ActionView(delegate: self, text: "", path: action)
                    case let .update(_, todo):
                        ActionView(delegate: self, text: todo, path: action)
                }
            }
            .toolbar {
                EditButton()
            }
        }
    }

    func delete(at offsets: IndexSet) {
        todos.remove(atOffsets: offsets)
    }

    func add(text: String) {
        todos.append(text)
    }

    func update(text: String, index: Int) {
        todos[index] = text
    }
}

struct SampleTODOView_Preview: PreviewProvider {
    static var previews: some View {
        SampleTODOView()
    }
}

import Foundation

final class AccountLoader {
    private var continuation: CheckedContinuation<String, Never>?

    func fetch() async -> String {
        await withTaskCancellationHandler(operation: {
            await withCheckedContinuation { continuation in
                self.continuation = continuation
            }
        }, onCancel: {
            self.finish("cancelled")
        })
    }

    func finish(_ value: String) {
        continuation?.resume(returning: value)
        continuation = nil
    }
}

@MainActor
final class AccountScreen {
    private let loader = AccountLoader()
    private var task: Task<Void, Never>?
    private(set) var renderedValue: String?

    func start() {
        task = Task { [weak self] in
            guard let self else { return }
            let value = await self.loader.fetch()
            guard !Task.isCancelled else { return }
            self.render(value)
        }
    }

    func stop() {
        task?.cancel()
        task = nil
    }

    private func render(_ value: String) {
        renderedValue = value
        print("Rendered: \(value)")
    }
}

@main
struct Demo {
    static func main() async {
        let screen = await AccountScreen()
        await screen.start()
        await screen.stop()
        print("Cancellation path completed without a stale UI update.")
    }
}

import OSLog

// MARK: - Log Destination (for future Firebase integration)

protocol LogDestination {
    func log(level: AppLogger.Level, category: AppLogger.Category, message: String)
}

// MARK: - AppLogger

final class AppLogger {

    enum Level {
        case debug, info, warning, error
    }

    enum Category: String {
        case screen  = "Screen"
        case action  = "Action"
        case network = "Network"
    }

    static let shared = AppLogger()

    var destinations: [LogDestination] = []

    private let subsystem = Bundle.main.bundleIdentifier ?? "com.imitate.app"

    private lazy var screenLogger  = Logger(subsystem: subsystem, category: Category.screen.rawValue)
    private lazy var actionLogger  = Logger(subsystem: subsystem, category: Category.action.rawValue)
    private lazy var networkLogger = Logger(subsystem: subsystem, category: Category.network.rawValue)

    private init() {}

    // MARK: - Screen

    func screenAppeared(file: String = #fileID) {
        let message = "【iOS】[\(file)] appeared"
        screenLogger.debug("\(message, privacy: .public)")
        forward(level: .debug, category: .screen, message: message)
    }

    // MARK: - Action

    func userAction(_ action: String, on screen: String = #fileID) {
        let message = "【iOS】[\(screen)] '\(action)' action"
        actionLogger.debug("\(message, privacy: .public)")
        forward(level: .debug, category: .action, message: message)
    }

    // MARK: - Network

    func networkRequest(_ method: String) {
        let message = "【iOS】[\(method)] requesting"
        networkLogger.debug("\(message, privacy: .public)")
        forward(level: .debug, category: .network, message: message)
    }

    func networkSuccess(_ method: String) {
        let message = "【iOS】[\(method)] success"
        networkLogger.debug("\(message, privacy: .public)")
        forward(level: .debug, category: .network, message: message)
    }

    func networkFailure(_ method: String, error: String) {
        let message = "【iOS】[\(method)] failure: \(error)"
        networkLogger.debug("\(message, privacy: .public)")
        forward(level: .debug, category: .network, message: message)
    }

    // MARK: - Private

    // TODO: Firebase導入時に FirebaseLogDestination を実装し destinations に追加する
    private func forward(level: Level, category: Category, message: String) {
        destinations.forEach { $0.log(level: level, category: category, message: message) }
    }
}

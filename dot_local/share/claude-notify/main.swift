import AppKit
import UserNotifications

final class Notifier: NSObject, NSApplicationDelegate, UNUserNotificationCenterDelegate {
    let center = UNUserNotificationCenter.current()
    let args = Array(CommandLine.arguments.dropFirst())

    func applicationWillFinishLaunching(_ notification: Notification) {
        center.delegate = self
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        guard let message = args.last else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { exit(0) }
            return
        }
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            guard granted else {
                fputs("claude-notify: \(error?.localizedDescription ?? "notifications are off")\n", stderr)
                exit(1)
            }
            let content = UNMutableNotificationContent()
            content.title = self.args.count > 1 ? self.args[0] : "Claude Code"
            content.body = message
            content.sound = .default
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
            self.center.add(request) { exit($0 == nil ? 0 : 1) }
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse,
                                withCompletionHandler done: @escaping () -> Void) {
        if let ghostty = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.mitchellh.ghostty") {
            NSWorkspace.shared.openApplication(at: ghostty, configuration: .init())
        }
        done()
        exit(0)
    }
}

let notifier = Notifier()
NSApplication.shared.delegate = notifier
NSApplication.shared.run()

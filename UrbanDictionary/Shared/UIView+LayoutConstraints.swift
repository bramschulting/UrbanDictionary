import UIKit

extension UIView {

    func layoutConstraints(toFill view: UIView, insetBy insets: UIEdgeInsets? = nil) -> [NSLayoutConstraint] {
        return [self.topAnchor.constraint(equalTo: view.topAnchor, constant: insets?.top ?? 0),
                self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(insets?.bottom ?? 0)),
                self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets?.left ?? 0),
                self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(insets?.right ?? 0))]
    }

}

import UIKit

class DefinitionCell: UITableViewCell {

    // MARK: - Private Types

    private enum Constant {
        static let cellInsets = UIEdgeInsets(top: 24, left: 15, bottom: 24, right: 15)

        static let stackViewSpacing: CGFloat = 8

        static let wordFont: UIFont = .systemFont(ofSize: 32, weight: .black)
        static let definitionFont: UIFont = .systemFont(ofSize: 16)
        static let exampleFont: UIFont = .italicSystemFont(ofSize: 16)

        static let definitionColor: UIColor = .darkGray
        static let exampleColor: UIColor = .gray

        static let definitionAndExampleSpacing: CGFloat = 24
    }

    // MARK: - Private Properties

    private let viewModel: DefinitionViewModel

    // MARK: - Init

    init(viewModel: DefinitionViewModel, reuseIdentifier: String?) {
        self.viewModel = viewModel

        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        configureSubviews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Subviews

    private lazy var wordLabel: UILabel = {
        let wordLabel = UILabel()
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.font = Constant.wordFont
        wordLabel.text = viewModel.word
        wordLabel.numberOfLines = 0

        return wordLabel
    }()

    private lazy var definitionTextView: UITextView = {
        let definitionTextView = UITextView()
        definitionTextView.translatesAutoresizingMaskIntoConstraints = false
        definitionTextView.isScrollEnabled = false
        definitionTextView.isEditable = false
        definitionTextView.isSelectable = true
        definitionTextView.delegate = self
        definitionTextView.textContainer.lineFragmentPadding = 0
        definitionTextView.textContainerInset = .zero

        let attributedText = NSMutableAttributedString(attributedString: viewModel.definition)
        let fullRange = NSRange(location: 0, length: attributedText.length)
        attributedText.addAttribute(.font, value: Constant.definitionFont, range: fullRange)
        attributedText.addAttribute(.foregroundColor, value: Constant.definitionColor, range: fullRange)

        definitionTextView.attributedText = attributedText

        return definitionTextView
    }()

    private lazy var exampleTextView: UITextView = {
        let exampleTextView = UITextView()
        exampleTextView.translatesAutoresizingMaskIntoConstraints = false
        exampleTextView.isScrollEnabled = false
        exampleTextView.isEditable = false
        exampleTextView.isSelectable = true
        exampleTextView.delegate = self
        exampleTextView.textContainer.lineFragmentPadding = 0
        exampleTextView.textContainerInset = .zero

        let attributedText = NSMutableAttributedString(attributedString: viewModel.example)
        let fullRange = NSRange(location: 0, length: attributedText.length)
        attributedText.addAttribute(.font, value: Constant.exampleFont, range: fullRange)
        attributedText.addAttribute(.foregroundColor, value: Constant.exampleColor, range: fullRange)

        exampleTextView.attributedText = attributedText

        return exampleTextView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [wordLabel, definitionTextView, exampleTextView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = Constant.stackViewSpacing

        stackView.setCustomSpacing(Constant.definitionAndExampleSpacing, after: definitionTextView)

        return stackView
    }()

    private func configureSubviews() {
        contentView.addSubview(stackView)
    }

    private func configureLayout() {
        NSLayoutConstraint.activate(stackView.layoutConstraints(toFill: contentView, insetBy: Constant.cellInsets))
    }

}

// MARK: - Protocol UITextViewDelegate

extension DefinitionCell: UITextViewDelegate {

    func textView(_ textView: UITextView,
                  shouldInteractWith URL: URL,
                  in characterRange: NSRange,
                  interaction: UITextItemInteraction) -> Bool {
        viewModel.didSelect(url: URL)

        return false
    }

}

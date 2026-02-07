// Copyright (c) 2022. Isaak Hanimann.
// This file is part of PsychonautWiki Journal.
//
// PsychonautWiki Journal is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public Licence as published by
// the Free Software Foundation, either version 3 of the License, or (at
// your option) any later version.
//
// PsychonautWiki Journal is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with PsychonautWiki Journal. If not, see https://www.gnu.org/licenses/gpl-3.0.en.html.

import Foundation

struct QuestionAndAnswer: Identifiable, Hashable {
    let id = UUID()
    let question: String
    let answer: String

    static let list: [QuestionAndAnswer] = [
        QuestionAndAnswer(
            question: NSLocalizedString("faq_q1", comment: ""),
            answer: NSLocalizedString("faq_a1", comment: "")
        ),
        QuestionAndAnswer(
            question: NSLocalizedString("faq_q2", comment: ""),
            answer: String(format: NSLocalizedString("faq_a2", comment: ""), InteractionChecker.additionalInteractionsToCheck.joined(separator: ", "))
        ),
        QuestionAndAnswer(
            question: NSLocalizedString("faq_q3", comment: ""),
            answer: NSLocalizedString("faq_a3", comment: "")
        ),
        QuestionAndAnswer(
            question: NSLocalizedString("faq_q4", comment: ""),
            answer: NSLocalizedString("faq_a4", comment: "")
        ),
        QuestionAndAnswer(
            question: NSLocalizedString("faq_q5", comment: ""),
            answer: NSLocalizedString("faq_a5", comment: "")
        ),
        QuestionAndAnswer(
            question: NSLocalizedString("faq_q6", comment: ""),
            answer: NSLocalizedString("faq_a6", comment: "")
        ),
    ]
}

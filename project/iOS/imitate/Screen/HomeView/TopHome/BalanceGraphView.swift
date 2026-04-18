//
//  BalanceGraphView.swift
//  imitate
//
//  Created by garigari0118 on 2026/04/18.
//

import SwiftUI

struct DailyBalance {
    let date: Date
    let cumulativeIncome: Double
    let cumulativeExpenses: Double
}

struct BalanceGraphView: View {

    let year: Int
    let month: Int
    let dailyBalances: [DailyBalance]

    private let graphHeight: CGFloat = 220
    private let yAxisWidth: CGFloat = 64
    private let xAxisHeight: CGFloat = 24
    private let yDivisions: Int = 5

    private var maxValue: Double {
        let maxIncome = dailyBalances.map { $0.cumulativeIncome }.max() ?? 0
        let maxExpenses = dailyBalances.map { $0.cumulativeExpenses }.max() ?? 0
        return max(maxIncome, maxExpenses, 1)
    }

    private var yTickInterval: Double {
        (maxValue / Double(yDivisions)).rounded(.up)
    }

    private var yAxisMax: Double {
        yTickInterval * Double(yDivisions)
    }

    private var mondays: [Date] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ja_JP")
        var components = DateComponents(year: year, month: month, day: 1)
        guard let firstDay = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: firstDay) else { return [] }

        return range.compactMap { day -> Date? in
            components.day = day
            guard let date = calendar.date(from: components) else { return nil }
            return calendar.component(.weekday, from: date) == 2 ? date : nil
        }
    }

    private var daysInMonth: Int {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ja_JP")
        let components = DateComponents(year: year, month: month, day: 1)
        guard let firstDay = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: firstDay) else { return 30 }
        return range.count
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            monthHeader
            graphArea
        }
        .padding(.horizontal)
    }

    private var monthHeader: some View {
        HStack {
            Text("\(String(year))年\(String(month))月")
                .font(.headline)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 8)
    }

    private var graphArea: some View {
        HStack(alignment: .top, spacing: 0) {
            yAxisLabels
            GeometryReader { geo in
                let plotWidth = geo.size.width
                ZStack(alignment: .topLeading) {
                    gridLines(plotWidth: plotWidth)
                    incomeLine(plotWidth: plotWidth)
                    expensesLine(plotWidth: plotWidth)
                    xAxisLabels(plotWidth: plotWidth)
                }
            }
            .frame(height: graphHeight + xAxisHeight)
        }
    }

    private var yAxisLabels: some View {
        VStack(alignment: .trailing, spacing: 0) {
            ForEach((0...yDivisions).reversed(), id: \.self) { i in
                let value = yTickInterval * Double(i)
                Text(formatAmount(value))
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .frame(height: graphHeight / CGFloat(yDivisions))
                    .frame(width: yAxisWidth, alignment: .trailing)
            }
            Spacer().frame(height: xAxisHeight)
        }
    }

    private func gridLines(plotWidth: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach((0...yDivisions).reversed(), id: \.self) { _ in
                Rectangle()
                    .fill(Color.secondary.opacity(0.2))
                    .frame(width: plotWidth, height: 0.5)
                    .frame(height: graphHeight / CGFloat(yDivisions))
            }
        }
    }

    private func incomeLine(plotWidth: CGFloat) -> some View {
        linePath(values: dailyBalances.map { $0.cumulativeIncome }, plotWidth: plotWidth)
            .stroke(Color.blue, lineWidth: 2)
    }

    private func expensesLine(plotWidth: CGFloat) -> some View {
        linePath(values: dailyBalances.map { $0.cumulativeExpenses }, plotWidth: plotWidth)
            .stroke(Color.red, lineWidth: 2)
    }

    private func linePath(values: [Double], plotWidth: CGFloat) -> Path {
        guard !values.isEmpty else { return Path() }
        return Path { path in
            for (index, value) in values.enumerated() {
                let x = xPosition(day: index + 1, plotWidth: plotWidth)
                let y = yPosition(value: value)
                if index == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
        }
    }

    private func xAxisLabels(plotWidth: CGFloat) -> some View {
        ZStack(alignment: .topLeading) {
            ForEach(mondays, id: \.self) { monday in
                let day = Calendar.current.component(.day, from: monday)
                Text("\(day)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .offset(
                        x: xPosition(day: day, plotWidth: plotWidth) - 8,
                        y: graphHeight + 4
                    )
            }
        }
        .frame(width: plotWidth, height: graphHeight + xAxisHeight, alignment: .topLeading)
    }

    private func xPosition(day: Int, plotWidth: CGFloat) -> CGFloat {
        let ratio = CGFloat(day - 1) / CGFloat(max(daysInMonth - 1, 1))
        return ratio * plotWidth
    }

    private func yPosition(value: Double) -> CGFloat {
        let ratio = CGFloat(value / yAxisMax)
        return graphHeight * (1 - ratio)
    }

    private func formatAmount(_ value: Double) -> String {
        if value >= 10_000 {
            return String(format: "%.0f万", value / 10_000)
        }
        return String(format: "%.0f", value)
    }

    static var dummyPreview: BalanceGraphView {
        let calendar = Calendar.current
        let today = Date()
        let dummies: [DailyBalance] = (1...30).map { day in
            let components = DateComponents(year: 2026, month: 4, day: day)
            let date = calendar.date(from: components) ?? today
            return DailyBalance(
                date: date,
                cumulativeIncome: Double(day) * 1_500,
                cumulativeExpenses: Double(day) * 900
            )
        }
        return BalanceGraphView(year: 2026, month: 4, dailyBalances: dummies)
    }
}

#Preview {
    BalanceGraphView.dummyPreview
}

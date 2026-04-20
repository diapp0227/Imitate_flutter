//
//  BalanceGraphView.swift
//  imitate
//
//  Created by garigari0118 on 2026/04/18.
//

import SwiftUI
import Charts

struct DailyBalance {
    let date: Date
    let cumulativeIncome: Double
    let cumulativeExpenses: Double
}

// MARK: - ① Header

struct BalanceGraphHeaderView: View {

    let year: Int
    let month: Int
    var onPreviousMonth: (() -> Void)? = nil
    var onNextMonth: (() -> Void)? = nil

    var body: some View {
        HStack {
            Button(action: { onPreviousMonth?() }) {
                Image(systemName: "chevron.left")
                    .font(.headline)
            }
            Spacer()
            Button(action: {}) {
                Text("\(String(year))年\(String(month))月")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            Spacer()
            Button(action: { onNextMonth?() }) {
                Image(systemName: "chevron.right")
                    .font(.headline)
            }
        }
        .padding(.bottom, 8)
    }
}

// MARK: - ② Chart

struct BalanceGraphChartView: View {

    let year: Int
    let month: Int
    let dailyBalances: [DailyBalance]

    private let graphHeight: CGFloat = 220

    private var labelDays: [Int] {
        [1, 5, 10, 15, 20, 25, daysInMonth]
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
        Chart {
            ForEach(Array(dailyBalances.enumerated()), id: \.offset) { index, balance in
                LineMark(
                    x: .value("日付", index + 1),
                    y: .value("金額", balance.cumulativeIncome),
                    series: .value("種別", "収入")
                )
                .foregroundStyle(.blue)

                LineMark(
                    x: .value("日付", index + 1),
                    y: .value("金額", balance.cumulativeExpenses),
                    series: .value("種別", "支出")
                )
                .foregroundStyle(.red)
            }

            if let last = dailyBalances.last {
                PointMark(
                    x: .value("日付", dailyBalances.count),
                    y: .value("金額", last.cumulativeIncome)
                )
                .foregroundStyle(.clear)
                .annotation(position: .topLeading) {
                    Text(formatAmount(last.cumulativeIncome))
                        .font(.caption2)
                        .foregroundColor(.blue)
                }

                PointMark(
                    x: .value("日付", dailyBalances.count),
                    y: .value("金額", last.cumulativeExpenses)
                )
                .foregroundStyle(.clear)
                .annotation(position: .topLeading) {
                    Text(formatAmount(last.cumulativeExpenses))
                        .font(.caption2)
                        .foregroundColor(.red)
                }
            }
        }
        .chartXScale(domain: 1...daysInMonth)
        .chartXAxis {
            AxisMarks(values: labelDays) { value in
                AxisGridLine()
                AxisValueLabel {
                    if let day = value.as(Int.self) {
                        Text("\(month)/\(day)")
                            .font(.caption2)
                    }
                }
            }
        }
        .chartYAxis(.hidden)
        .chartLegend(.hidden)
        .frame(height: graphHeight)
    }

    private func formatAmount(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: value)) ?? "\(Int(value))"
    }
}

// MARK: - ③ Container

struct BalanceGraphView: View {

    let year: Int
    let month: Int
    let dailyBalances: [DailyBalance]
    var onPreviousMonth: (() -> Void)? = nil
    var onNextMonth: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            BalanceGraphHeaderView(
                year: year,
                month: month,
                onPreviousMonth: onPreviousMonth,
                onNextMonth: onNextMonth
            )
            BalanceGraphChartView(year: year, month: month, dailyBalances: dailyBalances)
                .padding(.horizontal, 4)
        }
        .padding(.horizontal)
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

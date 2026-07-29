//
//  SegmentedTimelineView.swift
//  should-i-really
//
//  Created by Jose Putra Perdana Taneo on 28/07/26.
//

import SwiftUI

struct SegmentedTimelineView: View {
    let timeline: TimelineData?

    var body: some View {
        HStack(spacing: 4) {
            SingleChevronSegment(
                yearTitle: "Year 1",
                yearNumber: 1,
                currentTimeline: timeline
            )
            SingleChevronSegment(
                yearTitle: "Year 2",
                yearNumber: 2,
                currentTimeline: timeline
            )
            SingleChevronSegment(
                yearTitle: "Year 3",
                yearNumber: 3,
                currentTimeline: timeline
            )
        }
    }
}

struct SingleChevronSegment: View {
    let yearTitle: String
    let yearNumber: Int
    let currentTimeline: TimelineData?
    
    let frameImageName: String = "chevron_outline"
    let fillImageName: String = "chevron_fill"
    
    @State private var animatedProgress: CGFloat = 0.0
    @State private var isPulsing: Bool = false
    
    private var targetProgress: CGFloat {
        guard let t = currentTimeline else {
            return yearNumber == 1 ? 0.2 : 0.0
        }
        
        if t.year > yearNumber {
            return 1.0
        } else if t.year < yearNumber {
            return 0.0
        } else {
            let totalMonthsPassed = CGFloat(((t.semester - 1) * 6) + t.month)
            return min(max(totalMonthsPassed / 12.0, 0.15), 1.0)
        }
    }
    
    private var isActiveYear: Bool {
        guard let t = currentTimeline else { return yearNumber == 1 }
        return t.year == yearNumber
    }
    
    var body: some View {
        VStack(spacing: 6) {
            Text(yearTitle)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.textBrown)
                .scaleEffect(isPulsing ? 1.15 : 1.0)
            
            Color.clear
                .aspectRatio(79/41, contentMode: .fit)
                .overlay {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Image(fillImageName)
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(Color.background)
                                .frame(
                                    width: geo.size.width,
                                    height: geo.size.height
                                )
                            
                            Image(fillImageName)
                                .resizable()
                                .scaledToFit()
                                .frame(
                                    width: geo.size.width,
                                    height: geo.size.height,
                                    alignment: .leading
                                )
                                .mask(
                                    HStack(spacing: 0) {
                                        Rectangle()
                                            .frame(
                                                width: geo.size.width * animatedProgress
                                            )
                                        Spacer(minLength: 0)
                                    }
                                )

                            
                            Image(frameImageName)
                                .resizable()
                                .scaledToFit()
                                .frame(
                                    width: geo.size.width,
                                    height: geo.size.height,
                                    alignment: .leading
                                )
                        }
                    }
                }
                .scaleEffect(isPulsing ? 1.08 : 1.0)
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            animatedProgress = targetProgress
        }
        .onChange(of: currentTimeline) { oldValue , _ in
            if oldValue != nil {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                    animatedProgress = targetProgress
                }
                
                if isActiveYear {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.5)) {
                    }
                    isPulsing = true
                    Task {
                        try? await Task.sleep(for: .seconds(0.3))
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                            isPulsing = false
                        }
                    }
                }
            } else {
                animatedProgress = targetProgress
            }
        }
    }
}

#Preview {
    struct TimelinePreviewWrapper: View {
        @State private var year: Int = 2
        @State private var semester: Int = 1
        @State private var month: Int = 3
            
        var body: some View {
            VStack(spacing: 32) {
                SegmentedTimelineView(
                    timeline: TimelineData(
                        year: year,
                        semester: semester,
                        month: month
                    )
                )
                .padding(24)
                .background()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.08), radius: 10)
    
                VStack(alignment: .leading, spacing: 16) {
                    Text("Live Controls")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                
                    Stepper("Year: \(year)", value: $year, in: 1...3)
                    Stepper(
                        "Semester: \(semester)",
                        value: $semester,
                        in: 1...2
                    )
                    Stepper("Month: \(month)", value: $month, in: 1...6)
                }
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(20)
                .background(Color.gray.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(24)
        }
    }
        
    return TimelinePreviewWrapper()
}

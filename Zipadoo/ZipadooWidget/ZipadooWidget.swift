//
//  ZipadooWidget.swift
//  ZipadooWidget
//
//  Created by 아라 on 2023/09/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> ZipadooEntry {
        ZipadooEntry(date: Date(), promiseID: "", title: "약속 타이틀", destination: "약속 장소", time: "약속 시간")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ZipadooEntry) -> Void) {
        let entry = ZipadooEntry(date: Date(),
                                 promiseID: "",
                                 title: "약속 타이틀",
                                 destination: "서울시 종로구 종로3길 17",
                                 time: "오전 9시")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ZipadooEntry>) -> Void) {
        let promiseData = UserDefaults.shared.data(forKey: "todayPromises")
        
        var entries: [ZipadooEntry] = []
        
        if let promiseData = promiseData {
            
            do {
                let decoder = JSONDecoder()
                var todayPromises = try decoder.decode([WidgetData].self, from: promiseData)
                
                if todayPromises.isEmpty {
                    let empty = ZipadooEntry(date: Date(),
                                             promiseID: "",
                                             title: "Zipadoo",
                                             destination: "오늘의 일정은?",
                                             time: "")
                    entries.append(empty)
                    
                    completion(Timeline(entries :entries,policy:.atEnd))
                    return
                }
                
                todayPromises.sort { $0.time < $1.time }
                
                for (index, data) in todayPromises.enumerated() {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "hh:mm a"
                    
                    let dateOfPromise = Date(timeIntervalSince1970: data.time)
                    
                    var entryStartTime: Date
                    
                    
                    if index == 0 {
                        // 오늘의 첫 약속이라면 바로 보여주고
                        entryStartTime = Calendar.current.startOfDay(for: dateOfPromise)
                    } else {
                        // 이전 약속이 있을 때,
                        let currentPromiseTime = Date(timeIntervalSince1970: data.time)
                        let previousPromiseTime = Date(timeIntervalSince1970: todayPromises[index - 1].time)
                        
                        let timeDifference = currentPromiseTime.timeIntervalSince(previousPromiseTime)
                        
                        if timeDifference < (3 * 60 * 60) {
                            // 시간 차이가 3시간 미만이라면 현재 약속 시작 30분 전부터
                            entryStartTime = previousPromiseTime.addingTimeInterval(-30 * 60)
                        } else {
                            // 시간 차이가 3시간 이상이라면 이전 약속 3시간 후 부터
                            entryStartTime = previousPromiseTime.addingTimeInterval(3 * 60 * 60)
                        }
                    }
                    
                    let entryAtLoadTime = ZipadooEntry(date: entryStartTime,
                                                       promiseID: data.promiseID,
                                                       title: data.title,
                                                       destination: data.place,
                                                       time: dateFormatter.string(from:dateOfPromise))
                    
                    entries.append(entryAtLoadTime)
                    
                    // 마지막 약속이면 약속 3시간 뒤에 해당 entry 보여주기
                    if index == todayPromises.count - 1 {
                        let lastEvent = ZipadooEntry(date: dateOfPromise.addingTimeInterval(10800),
                                                     promiseID: "",
                                                     title: "Zipadoo",
                                                     destination: "오늘 모든 일정이 끝났어요!",
                                                     time: "")
                        
                        entries.append(lastEvent)
                    }
                }
                
                // TODO: 데이터 연결하고 확인필요!! 약속시간 30분 전부터는 5분마다 갱신하는 부분
                if let nextPromise = todayPromises.first,
                   let dateOfNextPromise = Calendar.current.date(byAdding: .second, value: Int(nextPromise.time), to: Date()),
                   dateOfNextPromise.timeIntervalSinceNow <= (30 * 60) {
                    
                    let refreshDate = Calendar.current.date(byAdding: .minute, value: 10, to: Date())!
                    let timeline = Timeline(entries: entries, policy: .after(refreshDate))
                    completion(timeline)
                } else {
                    if let dateOfNextPromise = todayPromises.first.map({ Calendar.current.date(byAdding: .second, value: Int($0.time), to: Date()) }) {
                        let timeline = Timeline(entries: entries, policy:.after(dateOfNextPromise!))
                        completion(timeline)
                    } else {
                        let startOfTomorrow = Calendar.current.date(bySettingHour:0 , minute :0 , second :0 , of :Date().addingTimeInterval(24*60*60))!
                        let timeline = Timeline(entries :entries,policy:.after(startOfTomorrow))
                        completion(timeline)
                    }
                }
            } catch {
                print("Failed to decode saved data:", error)
            }
        }
        return
    }
}

struct ZipadooWidgetEntryView: View {
    var entry: ZipadooEntry
    var body: some View {
        if entry.title == "Zipadoo" {
            emptyView
        } else {
            Link(destination: URL(string: "zipadoo://detailView?promiseID=\(entry.promiseID)")!) {
                promiseInfoView
            }
        }
    }
    
    // 아무 약속도 없을 때 보여지는 뷰
    private var emptyView: some View {
        VStack {
            Text(entry.title)
                .font(.title)
                .bold()
                .padding(.vertical, 3)

            Text(entry.destination)
                .font(.title3)
                .foregroundColor(.secondary)
        }
    }
    
    // 약속 정보 띄워주는 뷰
    private var promiseInfoView: some View {
            VStack(alignment: .leading) {
                HStack {
                    Image(.logo)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 55)
                    
                    Spacer()
                    
                    Text(calculateDate(date: entry.date))
                }
                
                Divider()
                    .padding(.bottom, 5)
                
                Group {
                    Text(entry.title)
                    
                    Text(entry.destination)
                    
                    Text(entry.time)
                        .font(.largeTitle)
                }
                .bold()
            }
            .padding([.vertical, .horizontal], 7)
    }
    
    func calculateDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd"
        return dateFormatter.string(from: date)
    }
}

struct ZipadooWidget: Widget {
    let kind: String = "ZipadooWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                ZipadooWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                ZipadooWidgetEntryView(entry: entry)
                    .padding()
                    .background()
                    .containerBackground(.fill.tertiary, for: .widget)
            }
        }
        .configurationDisplayName("Zipadoo Widget")
        .description("약속 및 친구 도착 정보를 확인할 수 있습니다.")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    ZipadooWidget()
} timeline: {
    ZipadooEntry(date: Date(),
                 promiseID: "",
                 title: "Zipadoo 뒷풀이",
                 destination: "앤티앤즈 센트럴시티터미널역점",
                 time: "06:30 PM")
}

#Preview(as: .systemMedium) {
    ZipadooWidget()
} timeline: {
    ZipadooEntry(date: Date(),
                 promiseID: "",
                 title: "Zipadoo",
                 destination: "오늘 모든 일정이 끝났어요!",
                 time: "")
}

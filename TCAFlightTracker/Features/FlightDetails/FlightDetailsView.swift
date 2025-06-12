import SwiftUI
import Foundation
import CoreLocation
import ComposableArchitecture


// MARK: - SwiftUI View
struct FlightDetailsView: View {
    let store: StoreOf<FlightDetailsFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with airline and flight info
            headerSection
            
            // Route section
            routeSection
            
            // Times section
            timesSection
            
            // Status and additional info
            statusSection
            
//            // Expanded details (if expanded)
//            if store.isExpanded {
                expandedSection
//            }
            
            // Action buttons
            actionButtonsSection
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(store.flight.airline.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(store.flight.designator)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                statusIndicator
                
                if !store.flight.codeShares.isEmpty {
                    Text("Codeshare")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if store.isTracked {
                    HStack(spacing: 4) {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.blue)
                            .font(.caption)
                        Text("Tracked")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemGray6))
    }
    
    private var routeSection: some View {
        HStack(alignment: .center, spacing: 12) {
            // Departure airport
            VStack(alignment: .leading, spacing: 4) {
                Text(store.flight.departureAirport.designator)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(store.flight.departureAirport.city.name)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Flight path indicator
            HStack(spacing: 4) {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 6, height: 6)
                
                Rectangle()
                    .fill(Color.blue)
                    .frame(height: 2)
                
                Image(systemName: "airplane")
                    .foregroundColor(.blue)
                    .font(.system(size: 16, weight: .medium))
                
                Rectangle()
                    .fill(Color.blue)
                    .frame(height: 2)
                
                Circle()
                    .fill(Color.blue)
                    .frame(width: 6, height: 6)
            }
            .frame(maxWidth: 80)
            
            Spacer()
            
            // Arrival airport
            VStack(alignment: .trailing, spacing: 4) {
                Text(store.flight.arrivalAirport.designator)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(store.flight.arrivalAirport.city.name)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }
    
    private var timesSection: some View {
        HStack(spacing: 20) {
            // Departure time
            timeDisplay(
                title: "Departure",
                info: store.flight.departure,
                timezone: store.flight.departureAirport.city.timezone
            )
            
            Spacer()
            
            // Flight duration (if we can calculate it)
            if let duration = flightDuration {
                VStack(spacing: 4) {
                    Text("Duration")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(formatDuration(duration))
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
            }
            
            Spacer()
            
            // Arrival time
            timeDisplay(
                title: "Arrival",
                info: store.flight.arrival,
                timezone: store.flight.arrivalAirport.city.timezone
            )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
    
    private var statusSection: some View {
        VStack(spacing: 8) {
            Divider()
            
            HStack {
                // Aircraft info
                VStack(alignment: .leading, spacing: 2) {
                    Text("Aircraft")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(store.flight.aircraft.type)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    if let registration = store.flight.aircraft.registration {
                        Text(registration)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // Last updated
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Last Updated")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(store.flight.lastUpdated, style: .time)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    private var expandedSection: some View {
        VStack(spacing: 12) {
            Divider()
            
            VStack(spacing: 8) {
                // Codeshare flights
                if !store.flight.codeShares.isEmpty {
                    HStack {
                        Text("Codeshare Flights")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Text(store.flight.codeShares.joined(separator: ", "))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Additional timing details
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Scheduled Departure")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(formatTime(store.flight.departure.scheduled, timezone: store.flight.departureAirport.city.timezone))
                            .font(.subheadline)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Scheduled Arrival")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(formatTime(store.flight.arrival.scheduled, timezone: store.flight.arrivalAirport.city.timezone))
                            .font(.subheadline)
                    }
                }
                
                // Flight ID
                HStack {
                    Text("Flight ID")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(store.flight.id)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .monospacedDigit()
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    private var actionButtonsSection: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: 16) {
                // Track/Untrack button
                Button {
                    store.send(.trackButtonTapped)
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: store.isTracked ? "bell.slash" : "bell")
                        Text(store.isTracked ? "Untrack" : "Track")
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(store.isTracked ? .red : .blue)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
    
    private func timeDisplay(title: String, info: Flight.Info, timezone: TimeZone) -> some View {
        VStack(alignment: .center, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            VStack(spacing: 2) {
                // Main time
                Text(formatTime(info.mostActual, timezone: timezone))
                    .font(.title3)
                    .fontWeight(.semibold)
                
                // Delay indicator
                if let delay = info.delay, delay > .seconds(60) {
                    HStack(spacing: 2) {
                        Image(systemName: info.isDelayed ? "clock.badge.exclamationmark" : "clock.badge.checkmark")
                            .foregroundColor(info.isDelayed ? .red : .green)
                            .font(.caption)
                        
                        Text(formatDelay(delay))
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(info.isDelayed ? .red : .green)
                    }
                }
            }
        }
    }
    
    private var statusIndicator: some View {
        Group {
            switch store.flight.departure.state {
            case .scheduled:
                statusBadge("Scheduled", color: .blue)
            case .onTime:
                statusBadge("On Time", color: .green)
            case .delayed(let duration):
                statusBadge("Delayed \(formatDuration(duration))", color: .red)
            case .early(let duration):
                statusBadge("Early \(formatDuration(duration))", color: .green)
            case .canceled:
                statusBadge("Canceled", color: .red)
            case .diverted(let airport):
                statusBadge("Diverted to \(airport.designator)", color: .orange)
            }
        }
    }
    
    private func statusBadge(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.1))
            .foregroundColor(color)
            .cornerRadius(8)
    }
    
    private var flightDuration: TimeInterval? {
        let departureTime = store.flight.departure.mostActual
        let arrivalTime = store.flight.arrival.mostActual
        
        // Basic calculation - in real app you'd want to account for timezone differences
        return arrivalTime.timeIntervalSince(departureTime)
    }
    
    private func formatTime(_ date: Date, timezone: TimeZone) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.timeZone = timezone
        return formatter.string(from: date)
    }
    
    private func formatDuration(_ duration: Duration) -> String {
        let totalMinutes = Int(duration / .seconds(60))
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    private func formatDuration(_ timeInterval: TimeInterval) -> String {
        let totalMinutes = Int(abs(timeInterval / 60))
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    private func formatDelay(_ delay: Duration) -> String {
        let minutes = Int(abs(delay / .seconds(60)))
        let sign = delay < .zero ? "-" : "+"
        return "\(sign)\(minutes)m"
    }
}

#Preview {
    FlightDetailsView(
        store: Store(
            initialState: .init(
                flight: MockData.Flights.create(),
                isTracked: false
            )
        ) {
            FlightDetailsFeature()
        }
    )
}

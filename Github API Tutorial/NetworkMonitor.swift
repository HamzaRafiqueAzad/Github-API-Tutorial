//
//  NetworkMonitor.swift
//  Github API Tutorial
//
//  Created by Hamza Rafique Azad on 9/8/22.
//

import UIKit
import Network

protocol NetworkMonitorDelegate {
    func updateConnection()
}

final class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    
    var delegate: NetworkMonitorDelegate?
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    public private(set) var isConnected: Bool = false
    
    public private(set) var connectionType: ConnectionType?
    
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
    }
    
    public init() {
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring() {
        monitor.start(queue: queue)
        
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status != .unsatisfied
            self?.connectionChange()
            
            self?.getConnectionType(path)
        }
    }
    
    func connectionChange() {
        delegate?.updateConnection()
    }
    
    public func stopMonitoring() {
        monitor.cancel()
    }
    
    private func getConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
        } else {
            connectionType = nil
        }
    }
}

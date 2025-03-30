import Foundation
import CoreLocation
import os

final class LocationManager: NSObject, ObservableObject {
    static let shared = LocationManager()
    private let locationManager = CLLocationManager()
    @Published var currentLocation: CLLocation?

    override private init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocationPermissions() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    func getCurrentLocation(completion: @escaping (Result<CLLocation, Error>) -> Void) {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
            if let location = locationManager.location {
                completion(.success(location))
            } else {
                completion(.failure(NSError(domain: "LocationError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener la ubicación"])))
            }
        } else {
            completion(.failure(NSError(domain: "LocationError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Los servicios de ubicación están deshabilitados"])))
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        os_log("Error al obtener ubicación: \(error.localizedDescription)")
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            os_log("Permiso de ubicación concedido")
            startUpdatingLocation()
        case .denied, .restricted:
            os_log("Permiso de ubicación denegado")
        case .notDetermined:
            os_log("Permiso de ubicación no determinado")
        @unknown default:
            break
        }
    }
}

//
//  BaseService.swift
//  TravelSchedule
//
//  Created by Alekhina Viktoriya on 30/06/2026.
//

import OpenAPIRuntime
import OpenAPIURLSession

class BaseService {
    let client: Client

    init(client: Client) {
        self.client = client
    }
}

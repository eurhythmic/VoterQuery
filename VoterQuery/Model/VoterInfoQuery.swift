//
//  VoterInfoQuery.swift
//  VoterQuery
//
//  Created by RnD on 9/1/20.
//  Copyright © 2020 RnD. All rights reserved.
//

import Foundation

// MARK: - VoterInfoQuery
struct VoterInfoQuery: Codable {
    let election: Election
    let normalizedInput: NormalizedInput
    let pollingLocations: [PollingLocation]?
    let contests: [Contest]
    let state: [State]
    let kind: String
}

// MARK: - Contest
struct Contest: Codable {
    let type: ContestType
    let office: String?
    let level: [Level]?
    let roles: [String]?
    let district: District
    let sources: [Source]
    let candidates: [Candidate]?
    let referendumTitle, referendumSubtitle: String?
    let referendumURL: String?

    enum CodingKeys: String, CodingKey {
        case type, office, level, roles, district, sources, candidates, referendumTitle, referendumSubtitle
        case referendumURL = "referendumUrl"
    }
}

// MARK: - Candidate
struct Candidate: Codable {
    let name, party: String
    let candidateURL: String?
    let email: String?
    let channels: [Channel]?
    let phone: String?

    enum CodingKeys: String, CodingKey {
        case name, party
        case candidateURL = "candidateUrl"
        case email, channels, phone
    }
}

// MARK: - Channel
struct Channel: Codable {
    let type: ChannelType
    let id: String
}

enum ChannelType: String, Codable {
    case facebook = "Facebook"
    case twitter = "Twitter"
    case youTube = "YouTube"
}

// MARK: - District
struct District: Codable {
    let name, scope: String
    let id: String?
}

enum Level: String, Codable {
    case administrativeArea1 = "administrativeArea1"
    case administrativeArea2 = "administrativeArea2"
    case country = "country"
}

// MARK: - Source
struct Source: Codable {
    let name: Name
    let official: Bool
}

enum Name: String, Codable {
    case ballotInformationProject = "Ballot Information Project"
    case democracyWorks = "DemocracyWorks"
    case empty = ""
    case votingInformationProject = "Voting Information Project"
}

enum ContestType: String, Codable {
    case federalPrimary = "Federal Primary"
    case general = "General"
    case referendum = "Referendum"
}

// MARK: - Election
struct Election: Codable {
    let id, name, electionDay, ocdDivisionID: String

    enum CodingKeys: String, CodingKey {
        case id, name, electionDay
        case ocdDivisionID = "ocdDivisionId"
    }
}

// MARK: - NormalizedInput
struct NormalizedInput: Codable {
    let line1, city, state, zip: String
    let locationName: String?
}

// MARK: - PollingLocation
struct PollingLocation: Codable {
    let address: NormalizedInput
    let notes, pollingHours: String
    let sources: [Source]
}

// MARK: - State
struct State: Codable {
    let name: String
    let electionAdministrationBody: StateElectionAdministrationBody
    let localJurisdiction: LocalJurisdiction?
    let sources: [Source]

    enum CodingKeys: String, CodingKey {
        case name, electionAdministrationBody
        case localJurisdiction = "local_jurisdiction"
        case sources
    }
}

// MARK: - StateElectionAdministrationBody
struct StateElectionAdministrationBody: Codable {
    let name: String
    let electionInfoURL: String
    let votingLocationFinderURL, ballotInfoURL: String
    let correspondenceAddress: NormalizedInput

    enum CodingKeys: String, CodingKey {
        case name
        case electionInfoURL = "electionInfoUrl"
        case votingLocationFinderURL = "votingLocationFinderUrl"
        case ballotInfoURL = "ballotInfoUrl"
        case correspondenceAddress
    }
}

// MARK: - LocalJurisdiction
struct LocalJurisdiction: Codable {
    let name: String
    let electionAdministrationBody: LocalJurisdictionElectionAdministrationBody
    let sources: [Source]
}

// MARK: - LocalJurisdictionElectionAdministrationBody
struct LocalJurisdictionElectionAdministrationBody: Codable {
    let electionInfoURL: String
    let physicalAddress: NormalizedInput
    let electionOfficials: [ElectionOfficial]

    enum CodingKeys: String, CodingKey {
        case electionInfoURL = "electionInfoUrl"
        case physicalAddress, electionOfficials
    }
}

// MARK: - ElectionOfficial
struct ElectionOfficial: Codable {
    let officePhoneNumber, emailAddress: String
}

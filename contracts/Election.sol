// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

// todo:
// 4- election result
// 5- election time threshold


contract Election {
    string public role;
    uint256 candidaciesInitialTimeStamp;
    uint256 candidaciesFinalTimeStamp;
    uint256 electionInitialTimeStamp;
    uint256 electionFinalTimeStamp;

    Candidate[] internal candidates;
    mapping (uint16 => CandidateVotes) internal candidatesVotes;

    constructor(string memory _role, uint256 _candidaciesInitialTimeStamp, uint256 _candidaciesFinalTimeStamp, uint256 _electionInitialTimeStamp, uint256 _electionFinalTimeStamp) {
        require(bytes(_role).length > 0, "Role is not defined.");
        role = _role;
        candidaciesInitialTimeStamp = _candidaciesInitialTimeStamp;
        candidaciesFinalTimeStamp = _candidaciesFinalTimeStamp;
        electionInitialTimeStamp = _electionInitialTimeStamp;
        electionFinalTimeStamp = _electionFinalTimeStamp;
    }

    struct PreCandidate {
        address id;
        string name;
        string party;
    }

    struct Candidate {
        address id;
        string name;
        string party;
        uint16 voteNumber; 
    }

    struct CandidateVotes {
    uint256 votes;
    uint16 voteNumber;
    }

    struct VoteFeedBack {
        bool result;
        string error;
    }

    function getRole() public view returns (string memory) {
        return role;
    }

// precandidates
// [0x154AD4c90D9979A912452D3055032b772339e463, "lucas", "pl"]
// [0x6d2e03b7effeae98bd302a9f836d0d6ab0002766, "bob", "pp"]
// [0x2759bC7b8f9F2b47eEeFFB2f5751E0CFF3fF1aD8, "lucy", "pm"]

// Candidate
// [0x154AD4c90D9979A912452D3055032b772339e463, "lucas", "pl", 1]
    function setCandidate(PreCandidate calldata preCandidate) public {
        require(candidateRegisterIsValid(preCandidate), "Candidate input is invalid,");
        Candidate memory candidate;
        uint16 newVoteNumber = uint16(candidates.length + 1);
        candidate = Candidate( preCandidate.id, preCandidate.name, preCandidate.party, newVoteNumber);
        candidates.push(candidate);
        candidatesVotes[newVoteNumber] = CandidateVotes(0, newVoteNumber);
    }

    function candidateRegisterIsValid(PreCandidate calldata preCandidate) internal view returns(bool)  {
        for (uint i = 0; i < candidates.length; i++) 
        {
            if (preCandidate.id == candidates[i].id) {
                return false;
            }
        }
            return true;
    }

    function vote(uint16 voteNumber) public returns(VoteFeedBack memory){
        (, bool found) = getCandidateByNumber(voteNumber);
        if (!found) {
            return VoteFeedBack(false, "Candidate not found!");
        }
        candidatesVotes[voteNumber].votes += 1;
        return VoteFeedBack(true, "");
    }

    function getCandidateByNumber(uint16 voteNumber) public view returns (Candidate memory, bool) {
        for (uint i = 0; i < candidates.length; i++) 
        {
            if (candidates[i].voteNumber == voteNumber) {
                return (candidates[i], true);
            }
        }
        return (Candidate(address(0), "","", 0), false);
    }

    function getCandidateVotes(uint16 voteNumber) public view returns (uint256) {
        CandidateVotes memory candVotes = candidatesVotes[voteNumber];
        require(candVotes.voteNumber != 0, "Candidate not found!");
        return candVotes.votes;
    }


    function getElectionResult () public view returns (mapping (uint16 => CandidateVotes) calldata candidateVotes) {
        return candidatesVotes;
    }
}


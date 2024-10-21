// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

// todo:
// 0- test contract interaction
// 0.5- create roles data structure
// 0.6- contract constructor
// 1- compute vote
// 2- add candidates into the election
// 3- votes count 
// 4- election result
// 5- convert Candidate[] to mapping(uint16 => Candidate) ?

contract Election {
    string public role;
    Candidate[] public candidates;
    uint votesCount;
    mapping (uint16 => CandidateVotes) internal candidatesVotes;

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

    function setRole(string memory _role) public  {
        require(bytes(role).length == 0, "Role is already defined.");
        require(bytes(_role).length > 0, "Role is not defined.");
        role = _role;
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
    function setCandidate(PreCandidate memory preCandidate) public {
        require(candidateRegisterIsValid(preCandidate), "Candidate input is invalid,");
        require(bytes(role).length > 0, "Role is not defined.");
        Candidate memory candidate;
        uint16 newVoteNumber = uint16(candidates.length + 1);
        candidate = Candidate( preCandidate.id, preCandidate.name, preCandidate.party, newVoteNumber);
        candidates.push(candidate);
        candidatesVotes[newVoteNumber] = CandidateVotes(0, newVoteNumber);
    }

    function candidateRegisterIsValid(PreCandidate memory preCandidate) internal view returns(bool)  {
        for (uint i = 0; i < candidates.length; i++) 
        {
            if (preCandidate.id == candidates[i].id) {
                return false;
            }
        }
            return true;
    }



    function vote(uint16 voteNumber) public view returns(VoteFeedBack memory){
        (, bool found) = getCandidateByNumber(voteNumber);
        if (!found) {
            return VoteFeedBack(false, "Candidate not found!");
        }
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

    // function computeVote(Candidate memory) internal returns (bool result) {
    //     candidatesVotes
    // }
}

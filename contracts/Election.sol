// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.0;

// todo:
// 1- create roles data structure
// 2- add candidates into the election
// 3- votes count into vote and election contract
// 4- election result

contract Election {
    string public role;
    Candidate[] public candidates;
    uint votesCount;

    struct Candidate {
        address id;
        string name;
        uint16 voteNumber; 
        string party;
    }

    struct CandidatesVotes {
        string role;
        Candidate[] candidates;
    }

    struct VoteFeedBack {
        bool result;
        string error;
    }



    function setRole(string memory _role) public  {
        role = _role;
    }

    function getRole() public view returns (string memory) {
        return role;
    }
// [0x154AD4c90D9979A912452D3055032b772339e463, "lucas", 1, "pl"]
    function setCandidate(Candidate memory candidate) public {
        require(candidateRegisterIsValid(candidate), "Candidate input is invalid");
        candidates.push(candidate);

    }

    function candidateRegisterIsValid(Candidate memory candidate) internal view returns(bool)  {
        for (uint i = 0; i < candidates.length; i++) 
        {
            if (candidate.id == candidates[i].id) {
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
        return (Candidate(address(0), "",0,""), false);
    }
}

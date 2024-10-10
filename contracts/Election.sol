// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.0;

// todo:
// 1- create roles data structure
// 2- add candidates into the election
// 3- votes count into vote and election contract
// 4- election result

contract Election {
    string public role;
    Candidate[] candidates;
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



    function setRole(string memory _role) public  {
        role = _role;
    }

    function getRole() public view returns (string memory) {
        return role;
    }

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
}

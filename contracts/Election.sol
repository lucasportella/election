// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.0;

contract Election {
    string public role;

    function set(string memory _role) public  {
        role = _role;
    }

    function get() public view returns (string memory) {
        return role;
    }
}

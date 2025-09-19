// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BalanceVulnerable {
    mapping(address => uint256) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    // Vulnerable: external call happens before state update
    function withdraw() external {
        uint256 bal = balances[msg.sender];
        require(bal > 0, "No balance");
        // send Ether (unsafe pattern)
        (bool ok, ) = msg.sender.call{value: bal}("");
        require(ok, "Transfer failed");
        // state update after external call -> reentrancy possible
        balances[msg.sender] = 0;
    }
}

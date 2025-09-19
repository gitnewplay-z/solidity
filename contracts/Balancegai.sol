// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 根据你安装的 OZ 版本调整路径：
// v4.x: import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
// v5.x: import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Balance is ReentrancyGuard {
    mapping(address => uint256) private _balances;

    event Deposited(address indexed who, uint256 amount);
    event Withdrawn(address indexed who, uint256 amount);

    // deposit: simple
    function deposit() external payable {
        require(msg.value > 0, "Must send ETH");
        _balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    // withdraw: nonReentrant and checks-effects-interactions
    function withdraw(uint256 amount) external nonReentrant {
        uint256 bal = _balances[msg.sender];
        require(amount > 0 && amount <= bal, "Invalid amount");

        // Effects: update state BEFORE external call
        _balances[msg.sender] = bal - amount;

        // Interactions: external call last, use call and check result
        (bool ok, ) = msg.sender.call{value: amount}("");
        require(ok, "ETH transfer failed");

        emit Withdrawn(msg.sender, amount);
    }

    // helper: view balance
    function balanceOf(address who) external view returns (uint256) {
        return _balances[who];
    }

    // OPTIONAL: emergency withdraw pattern (owner) / pause - not implemented here
}

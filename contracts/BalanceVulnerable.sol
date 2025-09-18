// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BalanceVulnerable {
    address public owner;

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed to, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    // 存款函数
    function deposit() public payable {
        require(msg.value > 0, "Deposit must be > 0");
        emit Deposited(msg.sender, msg.value);
    }

    // 脆弱的 withdraw（存在重入漏洞）
    function withdraw(address payable to, uint256 amount) public onlyOwner {
        require(address(this).balance >= amount, "Insufficient contract balance");
        // ⚠️ 使用 call 发送 ETH → 重入可能
        (bool sent, ) = to.call{value: amount}("");
        require(sent, "Failed to send Ether");
        emit Withdrawn(to, amount);
    }

    // 查询合约余额
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

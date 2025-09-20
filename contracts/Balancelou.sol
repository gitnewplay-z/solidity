// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Balance {
    mapping(address => uint256) public balances;

    // 存钱
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    // 提现
    function withdraw(uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        // ⚠️ 问题点：先发送ETH，再更新余额
        (bool sent, ) = msg.sender.call{value: _amount}("");
        require(sent, "Failed to send Ether");

        balances[msg.sender] -= _amount;
    }

    // 获取合约余额
    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Balance {
    // 用 mapping 记录每个地址的余额
    mapping(address => uint256) public balances;

    // 存款函数，payable 让函数能接收 ETH
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    // 取款函数
    function withdraw(uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    // 查询自己余额
    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
}

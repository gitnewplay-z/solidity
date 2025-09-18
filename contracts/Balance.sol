// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Balance {
    // 合约拥有者
    address public owner;

    // 事件
    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed to, uint256 amount);

    // 构造函数：部署合约时设置 owner
    constructor() {
        owner = msg.sender;
    }

    // 修饰符：只有 owner 才能操作
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    // 存款函数（任何人都能存）
    function deposit() public payable {
        require(msg.value > 0, "Deposit must be greater than 0");
        emit Deposited(msg.sender, msg.value);
    }

    // 取款函数（只有 owner 能提取）
    function withdraw(address payable to, uint256 amount) public onlyOwner {
        require(address(this).balance >= amount, "Insufficient contract balance");
        to.transfer(amount);
        emit Withdrawn(to, amount);
    }

    // 查询合约余额（所有存款总额）
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

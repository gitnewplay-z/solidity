// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Balance {
    address public owner;
    mapping(address => uint256) public balances;

    // 事件定义
    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    // 构造函数，设置合约拥有者
    constructor() {
        owner = msg.sender;
    }

    // 权限修饰符：只有拥有者才能取款
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can withdraw");
        _;
    }

    // 存款函数，payable 使得该函数能接收 ETH
    function deposit() public payable {
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);  // 触发事件
    }

    // 取款函数，只有拥有者才能取款
    function withdraw(uint256 amount) public onlyOwner {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdrawn(msg.sender, amount);  // 触发事件
    }

    // 查询余额
    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
}

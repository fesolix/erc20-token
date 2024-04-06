// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";

import {DeployEasierToken} from "../script/DeployTokens.s.sol";
import {EasierToken} from "../src/EasierToken.sol";

contract EasierTokenTest is Test {
    EasierToken public easierToken;
    DeployEasierToken public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployEasierToken();
        easierToken = deployer.run();

        vm.prank(msg.sender);
        easierToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public view {
        assertEq(easierToken.balanceOf(bob), STARTING_BALANCE);
    }

    function testAllowances() public {
        uint256 initialAllowance = 1000;

        vm.prank(bob);
        easierToken.approve(alice, initialAllowance);

        uint256 transferAmount = 500;

        vm.prank(alice);
        easierToken.transferFrom(bob, alice, transferAmount);

        assertEq(easierToken.balanceOf(alice), transferAmount);
        assertEq(easierToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }
}

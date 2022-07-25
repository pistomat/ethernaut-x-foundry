// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Reentrance/Reentrance.sol";
import "../Reentrance/ReentranceAttack.sol";
import "../Reentrance/ReentranceFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract ReentranceTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;

    function setUp() public {
        // Setup instance of the Ethernaut contracts
        ethernaut = new Ethernaut();
    }

    function testReentranceAttack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        ReentranceFactory reentranceFactory = new ReentranceFactory();
        ethernaut.registerLevel(reentranceFactory);
        vm.startPrank(tx.origin);
        address levelAddress = ethernaut.createLevelInstance{value: 1 ether}(reentranceFactory);

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        ReentranceAttack reentranceAttack = new ReentranceAttack(payable(levelAddress));
        reentranceAttack.causeOverflow{value: 2 ether}();
        reentranceAttack.deplete();
        
        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
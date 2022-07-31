// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Recovery/RecoveryAttack.sol";
import "../Recovery/RecoveryFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract RecoveryTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        vm.deal(eoaAddress, 5 ether);
    }

    function testRecoveryAttack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        RecoveryFactory recoveryFactory = new RecoveryFactory();
        ethernaut.registerLevel(recoveryFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance{value : 0.001 ether}(recoveryFactory);

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        RecoveryAttack recoveryAttack = new RecoveryAttack();
        uint8 nonce = uint8(uint256(vm.getNonce(address(ethernaut))));
        emit log_named_uint("Nonce: ", nonce);

        recoveryAttack.attack(levelAddress, nonce);

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}

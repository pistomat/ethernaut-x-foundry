// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../GatekeeperOne/GatekeeperOneAttack.sol";
import "../GatekeeperOne/GatekeeperOneFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract GatekeeperOneTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;

    function setUp() public {
        // Setup instance of the Ethernaut contracts
        ethernaut = new Ethernaut();
    }

    function testGatekeeperOneAttack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        GatekeeperOneFactory gatekeeperOneFactory = new GatekeeperOneFactory();
        ethernaut.registerLevel(gatekeeperOneFactory);
        vm.startPrank(tx.origin);
        address levelAddress = ethernaut.createLevelInstance(gatekeeperOneFactory);
        // GatekeeperOne gatekeeperOne = GatekeeperOne(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        GatekeeperOneAttack gatekeeperOneAttack = new GatekeeperOneAttack();

        gatekeeperOneAttack.attack(levelAddress);

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
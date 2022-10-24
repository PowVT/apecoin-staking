// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "../ApeCoinStaking.sol";
import "../SimpleERC20.sol";
import "../SimpleERC721.sol";

import "@arcadexyz/contracts/vault/VaultFactory.sol";
import "@arcadexyz/contracts/OriginationController.sol";
import "@arcadexyz/contracts/RepaymentController.sol";

import "forge-std/Test.sol";
import "ds-test/test.sol";

import { console } from "forge-std/console.sol";

contract ContractTest is Test {

    address constant alice = address(0x1111);
    address constant bob = address(0x1337);

    SimpleERC20 public apeCoin;
    SimpleERC721 public bayc;
    SimpleERC721 public mayc;
    SimpleERC721 public bakc;
    ApeCoinStaking public apeStake;

    function setUp() public {
        /// Yuga set up
        apeCoin = new SimpleERC20("ApeCoin", "APE");
        bayc = new SimpleERC721("Bored Ape Yacht Club", "BAYC", "https://ipfs.io/ipfs/");
        mayc = new SimpleERC721("Mutant Ape Yacht Club", "MAYC", "https://ipfs.io/ipfs/");
        bakc = new SimpleERC721("Bored Ape Kennel Club", "BAKC", "https://ipfs.io/ipfs/");
        apeStake = new ApeCoinStaking(address(apeCoin), address(bayc), address(mayc), address(bakc));
        // setup apeCoin staking pool (this test contract is the owner)
        // start: Oct18
        // end: Nov18
        apeStake.addTimeRange(0, 10*10*18, block.timestamp, block.timestamp + 30 * 86400, 30_000_000*10**18);
        // setup bayc staking pool
        // start: Oct18
        // end: Nov18
        apeStake.addTimeRange(1, 10*10*18, block.timestamp, block.timestamp + 30 * 86400, 47_105_000*10**18);
        // setup mayc staking pool
        // start: Oct18
        // end: Nov18
        apeStake.addTimeRange(2, 10*10*18, block.timestamp, block.timestamp + 30 * 86400, 19_060_000*10**18);
        // setup bakc staking pool
        // start: Oct18
        // end: Nov18
        apeStake.addTimeRange(3, 10*10*18, block.timestamp, block.timestamp + 30 * 86400, 3_835_000*10**18);

        /// Arcade Lending

    }

    function testClainInLoan() public {
        vm.startPrank(alice);

        apeCoin.mint(address(alice), 1_000_000*10**18);
        assertEq(apeCoin.balanceOf(address(alice)), 1_000_000*10**18);

        vm.stopPrank();
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "../ApeCoinStaking.sol";
import "../SimpleERC20.sol";
import "../SimpleERC721.sol";

import "forge-std/Test.sol";
import "ds-test/test.sol";

import {console} from "forge-std/console.sol";

contract ContractTest is Test {

    address constant alice = address(0x1111);
    address constant bob = address(0x1337);

    SimpleERC20 public apeCoin;
    SimpleERC721 public bayc;
    SimpleERC721 public mayc;
    SimpleERC721 public bakc;
    ApeCoinStaking public apeStake;

    function setUp() public {
        apeCoin = new SimpleERC20("ApeCoin", "APE");
        bayc = new SimpleERC721("Bored Ape Yacht Club", "BAYC", "https://ipfs.io/ipfs/");
        mayc = new SimpleERC721("Mutant Ape Yacht Club", "MAYC", "https://ipfs.io/ipfs/");
        bakc = new SimpleERC721("Bored Ape Kennel Club", "BAKC", "https://ipfs.io/ipfs/");
        apeStake = new ApeCoinStaking(address(apeCoin), address(bayc), address(mayc), address(bakc));
        // setup apeCoin staking pool (this test contract is the owner)
        apeStake.addTimeRange(0, 10*10*18, 1666206000, 1668888000, 30_000_000*10**18);
    }

    function testExample() public {
        vm.startPrank(alice);

        apeCoin.mint(address(alice), 1_000_000*10**18);
        assertEq(apeCoin.balanceOf(address(alice)), 1_000_000*10**18);
        apeCoin.approve(address(apeStake), 1_000*10**18);
        assertEq(apeCoin.allowance(address(alice), address(apeStake)), 1_000*10**18);
        // stake ape coin
        apeStake.depositSelfApeCoin(1_000*10**18);

        vm.stopPrank();
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "../ApeCoinStaking.sol";
import "../SimpleERC20.sol";
import "../SimpleERC721.sol";

import "forge-std/Test.sol";
import "ds-test/test.sol";

import { console } from "forge-std/console.sol";

contract ContractTest is Test {

    address constant alice = address(0x1111); // user
    address constant bob = address(0x1337); // contract owner

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
        vm.startPrank(bob);
        apeCoin.mint(address(bob), 1_000_000);
        apeCoin.transfer(address(apeStake), 1_000_000);
        vm.stopPrank();
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

    function testClaimApe() public {
        vm.startPrank(alice);

        apeCoin.mint(address(alice), 1_000_000*10**18);
        assertEq(apeCoin.balanceOf(address(alice)), 1_000_000*10**18);
        apeCoin.approve(address(apeStake), 1_000*10**18);
        assertEq(apeCoin.allowance(address(alice), address(apeStake)), 1_000*10**18);

        // stake ape coin
        apeStake.depositSelfApeCoin(1_000*10**18);
        // fast forward time 1 week
        skip(7 * 86400);
        // claim
        apeStake.claimSelfApeCoin();
        // fast forward time 1 week
        skip(7 * 86400);
        // withdraw apeCoin
        apeStake.withdrawApeCoin(1_000*10**18, address(alice));

        console.log(apeCoin.balanceOf(address(alice)));

        vm.stopPrank();
    }

    function testClaimBayc() public {
        vm.startPrank(alice);

        apeCoin.mint(address(alice), 1_000_000*10**18);
        assertEq(apeCoin.balanceOf(address(alice)), 1_000_000*10**18);
        apeCoin.approve(address(apeStake), 1_000*10**18);
        assertEq(apeCoin.allowance(address(alice), address(apeStake)), 1_000*10**18);

        bayc.mint(1);
        assertEq(bayc.balanceOf(address(alice)), 1);
        bayc.approve(address(apeStake), 0);
        assertEq(bayc.getApproved(0), address(apeStake));
        // stake bayc
        ApeCoinStaking.SingleNft[] memory nft = new ApeCoinStaking.SingleNft[](1);
        nft[0].tokenId = 0;
        nft[0].amount = 1_000*10**18;
        apeStake.depositBAYC(nft);

        vm.stopPrank();
    }

    function testClaimMayc() public {
        vm.startPrank(alice);

        apeCoin.mint(address(alice), 1_000_000*10**18);
        assertEq(apeCoin.balanceOf(address(alice)), 1_000_000*10**18);
        apeCoin.approve(address(apeStake), 1_000*10**18);
        assertEq(apeCoin.allowance(address(alice), address(apeStake)), 1_000*10**18);

        mayc.mint(1);
        assertEq(mayc.balanceOf(address(alice)), 1);
        mayc.approve(address(apeStake), 0);
        assertEq(mayc.getApproved(0), address(apeStake));
        // stake bayc
        ApeCoinStaking.SingleNft[] memory nft = new ApeCoinStaking.SingleNft[](1);
        nft[0].tokenId = 0;
        nft[0].amount = 1_000*10**18;
        apeStake.depositMAYC(nft);

        vm.stopPrank();
    }

    function testClaimBakc() public {
        vm.startPrank(alice);

        apeCoin.mint(address(alice), 1_000_000*10**18);
        assertEq(apeCoin.balanceOf(address(alice)), 1_000_000*10**18);
        apeCoin.approve(address(apeStake), 1_000*10**18);
        assertEq(apeCoin.allowance(address(alice), address(apeStake)), 1_000*10**18);

        bayc.mint(1);
        assertEq(bayc.balanceOf(address(alice)), 1);
        bayc.approve(address(apeStake), 0);
        assertEq(bayc.getApproved(0), address(apeStake));
        assertEq(bayc.ownerOf(0), address(alice));
        bakc.mint(1);
        assertEq(bakc.balanceOf(address(alice)), 1);
        bakc.approve(address(apeStake), 0);
        assertEq(bakc.getApproved(0), address(apeStake));
        assertEq(bakc.ownerOf(0), address(alice));
        // stake bakc
        ApeCoinStaking.PairNftWithAmount[] memory nft_bored = new ApeCoinStaking.PairNftWithAmount[](1);
        nft_bored[0].mainTokenId = 0;
        nft_bored[0].bakcTokenId = 0;
        nft_bored[0].amount = 1_000*10**18;
        ApeCoinStaking.PairNftWithAmount[] memory nft_mutant;
        apeStake.depositBAKC(nft_bored, nft_mutant);

        vm.stopPrank();
    }

    function testStartLoanDepositApeCoin() public {
        vm.startPrank(alice);

        bayc.mint(1);
        assertEq(bayc.balanceOf(address(alice)), 1);
        bayc.approve(address(apeStake), 0);
        assertEq(bayc.getApproved(0), address(apeStake));
        assertEq(bayc.ownerOf(0), address(alice));

        vm.stopPrank();
    }

    function testDoubleDeposit() public {
        vm.startPrank(alice);
        // mint and approve apeCoin
        apeCoin.mint(address(alice), 1_000_000*10**18);
        assertEq(apeCoin.balanceOf(address(alice)), 1_000_000*10**18);
        apeCoin.approve(address(apeStake), 1_000*10**18);
        assertEq(apeCoin.allowance(address(alice), address(apeStake)), 1_000*10**18);
        // deposit to only bayc pool
        bayc.mint(2);
        assertEq(bayc.balanceOf(address(alice)), 2);
        bayc.approve(address(apeStake), 1);
        assertEq(bayc.getApproved(1), address(apeStake));

        ApeCoinStaking.SingleNft[] memory nft = new ApeCoinStaking.SingleNft[](1);
        nft[0].tokenId = 0;
        nft[0].amount = 1_000*10**18;
        apeStake.depositBAYC(nft);

        // deposit to only bayc pair pool
        apeCoin.approve(address(apeStake), 1_000*10**18);
        assertEq(apeCoin.allowance(address(alice), address(apeStake)), 1_000*10**18);
        bakc.mint(1);
        assertEq(bakc.balanceOf(address(alice)), 1);
        bakc.approve(address(apeStake), 0);
        assertEq(bakc.getApproved(0), address(apeStake));
        assertEq(bakc.ownerOf(0), address(alice));
        // stake bakc
        ApeCoinStaking.PairNftWithAmount[] memory nft_bored = new ApeCoinStaking.PairNftWithAmount[](1);
        nft_bored[0].mainTokenId = 1;
        nft_bored[0].bakcTokenId = 0;
        nft_bored[0].amount = 1_000*10**18;
        ApeCoinStaking.PairNftWithAmount[] memory nft_mutant;
        apeStake.depositBAKC(nft_bored, nft_mutant);

        vm.stopPrank();
    }
}

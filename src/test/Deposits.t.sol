// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "../ApeCoinStaking.sol";
import "../SimpleERC20.sol";
import "../SimpleERC721.sol";

import "@arcadexyz/OriginationController.sol";
import "@arcadexyz/RepaymentController.sol";
import "@arcadexyz/LoanCore.sol";

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
        /// Yuga set up
        apeCoin = new SimpleERC20("ApeCoin", "APE");
        bayc = new SimpleERC721("Bored Ape Yacht Club", "BAYC", "https://ipfs.io/ipfs/");
        mayc = new SimpleERC721("Mutant Ape Yacht Club", "MAYC", "https://ipfs.io/ipfs/");
        bakc = new SimpleERC721("Bored Ape Kennel Club", "BAKC", "https://ipfs.io/ipfs/");
        apeStake = new ApeCoinStaking(address(apeCoin), address(bayc), address(mayc), address(bakc));
        // setup apeCoin staking pool (this test contract is the owner)
        // start: Oct18
        // end: Nov18
        apeStake.addTimeRange(0, 10*10*18, 1666206000, 1668888000, 30_000_000*10**18);
        // setup bayc staking pool
        // start: Oct18
        // end: Nov18
        apeStake.addTimeRange(1, 10*10*18, 1666206000, 1668888000, 47_105_000*10**18);
        // setup mayc staking pool
        // start: Oct18
        // end: Nov18
        apeStake.addTimeRange(2, 10*10*18, 1666206000, 1668888000, 19_060_000*10**18);
        // setup bakc staking pool
        // start: Oct18
        // end: Nov18
        apeStake.addTimeRange(3, 10*10*18, 1666206000, 1668888000, 3_835_000*10**18);

        /// Arcade Lending

    }

    function testDepositApe() public {
        vm.startPrank(alice);

        apeCoin.mint(address(alice), 1_000_000*10**18);
        assertEq(apeCoin.balanceOf(address(alice)), 1_000_000*10**18);
        apeCoin.approve(address(apeStake), 1_000*10**18);
        assertEq(apeCoin.allowance(address(alice), address(apeStake)), 1_000*10**18);

        // stake ape coin
        apeStake.depositSelfApeCoin(1_000*10**18);

        vm.stopPrank();
    }

    function testDepositBayc() public {
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

    function testDepositMayc() public {
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

    function testDepositBakc() public {
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
        bayc.mint(1);
        assertEq(bayc.balanceOf(address(alice)), 1);
        bayc.approve(address(apeStake), 0);
        assertEq(bayc.getApproved(0), address(apeStake));

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
        nft_bored[0].mainTokenId = 0;
        nft_bored[0].bakcTokenId = 0;
        nft_bored[0].amount = 1_000*10**18;
        ApeCoinStaking.PairNftWithAmount[] memory nft_mutant;
        apeStake.depositBAKC(nft_bored, nft_mutant);

        vm.stopPrank();
    }
}

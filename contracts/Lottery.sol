// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

//Enter the lottery
//select  a random verify person

// Import this file to use console.log
import "hardhat/console.sol";
error Lottery__NotenoughETH();

contract Lottery {
    uint256 private immutable i_entryfee;
    address payable[] private players;

    constructor(uint256 entryamount) {
        i_entryfee = entryamount;
    }

    function entryRaffle() public payable {
        if (msg.value < i_entryfee) {
            revert Lottery__NotenoughETH();
        }
        players.push(payable(msg.sender));
    }

    function getEntryfee() public view returns (uint256) {
        return i_entryfee;
    }

    function getplayers(uint256 index) public view returns (address) {
        return players[index];
    }
}

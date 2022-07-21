// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/KeeperCompatibleInterface.sol";
import "hardhat/console.sol";

error Raffle__SendMoreToEnterRaffle();
error Raffle_FundNotTransfer();
error Raffle_NotOpen();
error Raffle_CheckupNotNeed(
    uint256 balance,
    uint256 arraylength,
    uint256 rafflestate
);

contract Raffle is VRFConsumerBaseV2, KeeperCompatibleInterface {
    enum RaffleState {
        OPEN,
        CALCULATING
    }

    event RaffleEnter(address indexed player);
    event RequestedRandomWinner(uint256 indexed requestid);
    event WinnerPicked(address indexed winner);

    uint256 private i_entranceFee;
    address payable[] private s_players;
    address private recent_winner;
    uint256 private immutable i_interval;
    uint256 private last_time_stamp;

    RaffleState private s_rafflestate;

    VRFCoordinatorV2Interface private immutable i_vrfcoordinator;
    bytes32 private immutable gaslane;
    uint64 private immutable i_subid;
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private immutable i_callbackGasLimit;
    uint32 private constant NUM_WORDS = 1;

    constructor(
        address vrfCoordinatorV2,
        uint256 entranceFee,
        bytes32 gasLane,
        uint64 subid,
        uint32 callbackGasLimit,
        uint256 interval
    ) VRFConsumerBaseV2(vrfCoordinatorV2) {
        i_entranceFee = entranceFee;
        i_vrfcoordinator = VRFCoordinatorV2Interface(vrfCoordinatorV2);
        gaslane = gasLane;
        i_subid = subid;
        i_callbackGasLimit = callbackGasLimit;
        s_rafflestate = RaffleState(0);
        i_interval = interval;
        last_time_stamp = block.timestamp;
    }

    function enterRaffle() public payable {
        // require(msg.value >= i_entranceFee, "Not enough value sent");
        // require(s_raffleState == RaffleState.OPEN, "Raffle is not open");
        if (msg.value < i_entranceFee) {
            revert Raffle__SendMoreToEnterRaffle();
        }
        if (s_rafflestate != RaffleState(0)) {
            revert Raffle_NotOpen();
        }

        s_players.push(payable(msg.sender));

        // Emit an event when we update a dynamic array or mapping
        // Named events with the function name reversed
        emit RaffleEnter(msg.sender);
    }

    /**
1. check if the raffle is open
2. check the time interval
3. check the length of player is player is atleast one
4. check the subscription is fund with gas

 */

    function checkUpkeep(
        bytes memory /*checkdata*/
    )
        public
        view
        override
        returns (
            bool upkeepneed,
            bytes memory /*perform data*/
        )
    {
        bool isopen = (RaffleState(0) == s_rafflestate);
        bool istimecame = ((block.timestamp - last_time_stamp) > i_interval);
        bool hasplayer = (s_players.length > 0);
        bool hasbalance = (address(this).balance > 0);
        bool upkeepneed = (isopen && istimecame && hasplayer && hasbalance);
    }

    function performUpkeep(
        bytes calldata /**performdata */
    ) external override {
        (bool upkeepneed, ) = checkUpkeep("");

        if (!upkeepneed) {
            revert Raffle_CheckupNotNeed(
                address(this).balance,
                s_players.length,
                uint256(s_rafflestate)
            );
        }

        s_rafflestate = RaffleState(1);
        uint256 requestid = i_vrfcoordinator.requestRandomWords(
            gaslane,
            i_subid,
            REQUEST_CONFIRMATIONS,
            i_callbackGasLimit,
            NUM_WORDS
        );

        emit RequestedRandomWinner(requestid);
    }

    function fulfillRandomWords(
        uint256,
        /*requestId*/
        uint256[] memory randomWords
    ) internal override {
        uint256 Winnerindex = randomWords[0] % s_players.length;
        address payable recentwinner = s_players[Winnerindex];
        (bool success, ) = recentwinner.call{value: address(this).balance}("");
        recent_winner = recentwinner;
        s_players = new address payable[](0);
        last_time_stamp = block.timestamp;
        s_rafflestate = RaffleState(0);
        if (!success) {
            revert Raffle_FundNotTransfer();
        }

        emit WinnerPicked(recentwinner);
    }

    /** Getter Functions */

    function getPlayer(uint256 index) public view returns (address) {
        return s_players[index];
    }

    function getEntranceFee() public view returns (uint256) {
        return i_entranceFee;
    }

    function getNumberOfPlayers() public view returns (uint256) {
        return s_players.length;
    }

    function getRecentWinner() public view returns (address) {
        return recent_winner;
    }

    function getNumofWords() public pure returns (uint32) {
        return NUM_WORDS;
    }
}

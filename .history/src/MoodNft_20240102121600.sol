// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MoodNft is ERC721 {

    uint256 private s_tokenCounter;
    string private 
    constructor(
        string memory sadSvg,
        string memory happySvg
    ) ERC721("Mood", "MT") {

    }
}

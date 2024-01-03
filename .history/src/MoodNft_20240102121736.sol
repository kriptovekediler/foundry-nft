// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MoodNft is ERC721 {
    uint256 private s_tokenCounter;
    string private s_sadSvg;
    string private s_happySvg;

    constructor(
        string memory sadSvg,
        string memory happySvg
    ) ERC721("Mood", "MT") {
        s_tokenCounter = 0;
        s_happySvg = happySvg;
        s_sadSvg = sadSvg;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter)
        s_tokenCounter++;
    }
}

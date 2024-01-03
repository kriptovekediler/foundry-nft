// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "@thirdweb-dev/contracts/base/ERC721DelayedReveal.sol";

contract AtlasPioneers is ERC721DelayedReveal {
    constructor(
        address _defaultAdmin,
        string memory _name,
        string memory _symbol,
        address _royaltyRecipient,
        uint128 _royaltyBps
    )
        ERC721DelayedReveal(
            _defaultAdmin,
            _name,
            _symbol,
            _royaltyRecipient,
            _royaltyBps
        )
    {}

    function verifyClaim(
        address _claimer,
        uint256 _quantity
    ) public view virtual override {
        // Your custom claim restriction logic
    }
}

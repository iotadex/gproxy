// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title Group contract, help groupfi to supply some data servies
contract GroupERC1155 is ERC1155, Ownable {
    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    constructor(string memory _uri) ERC1155(_uri) Ownable(msg.sender) {}

    function mint(
        address _to,
        uint256 _tokenId,
        uint256 value
    ) external onlyOwner {
        super._mint(_to, _tokenId, value, "");
    }
}

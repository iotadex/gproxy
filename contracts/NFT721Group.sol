// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title Group contract, help groupfi to supply some data servies
contract GroupNFT is ERC721, Ownable {
    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    constructor(
        string memory name_,
        string memory symbol_
    ) ERC721(name_, symbol_) Ownable(msg.sender) {}

    function mint(address _to, uint256 _tokenId) external onlyOwner {
        super._safeMint(_to, _tokenId);
    }

    function multiMint(
        address _to,
        uint256 _tokenIdBegin,
        uint256 _tokenIdEnd
    ) external onlyOwner {
        for (uint256 id = _tokenIdBegin; id <= _tokenIdEnd; id++) {
            super._safeMint(_to, id);
        }
    }

    function burn(uint256 tokenId) external {
        if (msg.sender != super._ownerOf(tokenId))
            revert ERC721InvalidOwner(msg.sender);
        super._burn(tokenId);
    }

    function _baseURI() internal pure override returns (string memory) {
        return
            "ipfs://bafybeidfvzjbovlskk6gw3vtubg4h4adn3k6bms7xwd4ixzl4wh2rfav24/";
    }
}

// SPDX-License-Identifier: Apache-2.0
pragma solidity >0.8.0;

import "@lukso/lsp8-contracts/contracts/LSP8IdentifiableDigitalAsset.sol";

contract MyLSP8Token is LSP8IdentifiableDigitalAsset {
    constructor(
        string memory name, // Name of the token
        string memory symbol, // Symbol of the token
        uint256 lsp4TokenType_, // 1 if NFT, 2 if an advanced collection of multiple NFTs
        uint256 lsp8TokenIdFormat_ // 0 for compatibility with ERC721, check LSP8 specs for other values
    )
        LSP8IdentifiableDigitalAsset(
            name,
            symbol,
            msg.sender,
            lsp4TokenType_,
            lsp8TokenIdFormat_
        )
    {}

    function mint(address to, bytes32 tokenId) external onlyOwner {
        // _mint(to, tokenId, force, data)
        // force: should be set to true to allow EOA to receive tokens
        // data: only relevant if the `to` is a smart contract supporting LSP1.
        _mint(to, tokenId, true, "");
    }
}

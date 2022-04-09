// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract DecentraNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("DcentraNFT", "DNFT") {}

    function mintNFT(address recipient, string memory tokenURI)
        public
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId); // or _safeMint ??
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }
}

//     function tokensOfOwner(address _owner)
//         external
//         view
//         returns (uint256[] memory)
//     {
//         uint256 tokenCount = balanceOf(_owner);
//         uint256[] memory tokensId = new uint256[](tokenCount);

//         for (uint256 i = 0; i < tokenCount; i++) {
//             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
//         }
//         return tokensId;
//     }

//     function withdraw() public payable onlyOwner {
//         uint256 balance = address(this).balance;
//         require(balance > 0, "No ether left to withdraw");

//         (bool success, ) = (msg.sender).call{value: balance}("");
//         require(success, "Transfer failed.");
//     }
// }

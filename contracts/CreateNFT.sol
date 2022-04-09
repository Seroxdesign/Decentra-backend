// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract DecentraNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint256 public constant MAX_SUPPLY = 100;
    uint256 public constant PRICE = 0.01 ether;
    uint256 public constant MAX_PER_MINT = 5;
    uint256 public constant RESERVED_NFTS = 10;
    string public baseTokenURI;

    constructor(string memory baseURI) ERC721("DcentraNFT", "DNFT") {
        setBaseURI(baseURI);
    }

    function reserveNFTs() public onlyOwner {
        uint256 totalMinted = _tokenIds.current();
        require(totalMinted + RESERVED_NFTS < MAX_SUPPLY, "Not enough NFTs");
        for (uint256 i = 0; i < RESERVED_NFTS; i++) {
            _mintSingleNFT();
        }
    }

    // The owner can change the baseTokenURI even after the contract has been deployed
    function setBaseURI(string memory _baseTokenURI) public onlyOwner {
        baseTokenURI = _baseTokenURI;
    }

    function mintNFTs(uint256 _count) public payable {
        // (address recipient, string memory tokenURI)

        uint256 totalMinted = _tokenIds.current();

        require(totalMinted + _count <= MAX_SUPPLY, "Not enough NFTs!");
        require(
            _count > 0 && _count <= MAX_PER_MINT,
            "Cannot mint specified number of NFTs."
        );
        require(
            msg.value >= PRICE * _count,
            "Not enough ether to purchase NFTs."
        );

        for (uint256 i = 0; i < _count; i++) {
            _mintSingleNFT();
        }
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }

    function _mintSingleNFT() private {
        uint256 newTokenID = _tokenIds.current();
        _safeMint(msg.sender, newTokenID);
        _tokenIds.increment();
    }

    function tokensOfOwner(address _owner)
        external
        view
        returns (uint256[] memory)
    {
        uint256 tokenCount = balanceOf(_owner);
        uint256[] memory tokensId = new uint256[](tokenCount);
        for (uint256 i = 0; i < tokenCount; i++) {
            tokensId[i] = tokenOfOwnerByIndex(_owner, i);
        }

        return tokensId;
    }

    function withdraw() public payable onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No ether left to withdraw");
        (bool success, ) = (msg.sender).call{value: balance}("");
        require(success, "Transfer failed.");
    }
}

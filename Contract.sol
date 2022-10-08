// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract ARABPUNKS is ERC721, Ownable {
    using Counters for Counters.Counter;

    string private URI;
    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("Name", "Symbol") {}


    mapping(uint => string) _tokenURIs;
    function _baseURI() internal view override returns (string memory) {
        return URI;
    }

    function tokenURI(uint256 _tokenId) public view override returns(string memory) {
        require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
        return bytes(_tokenURIs[_tokenId]).length > 0 ?
            string(abi.encodePacked(_tokenURIs[_tokenId])) : "";
    }

    function _setTokenURI(uint _tokenId, string memory _tokenURI) internal {
        _tokenURIs[_tokenId] = _tokenURI;
    }

   function safeMint(string memory _tokenURI, uint _tokenId) public {
        _tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, _tokenId);
        _setTokenURI(_tokenId, _tokenURI);
    }

     function airdropMint(address[] memory _addresses, string[] memory _tokenURI, uint[] memory _tokenIds) external onlyOwner {
        require(_addresses.length == _tokenURI.length);
        require(_addresses.length == _tokenIds.length);
        uint arrayLength = _addresses.length;
        for(uint i = 0; i < arrayLength; i++){
            _safeMint(_addresses[i], _tokenIds[i]);
            _setTokenURI(_tokenIds[i], _tokenURI[i]);
        }
    }

}

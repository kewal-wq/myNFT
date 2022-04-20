// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract myNFT is ERC721, Ownable{
uint256 public mintPrice;
uint256 public totalSupply;
uint256 public max_supply;
string internal baseTokenUri;
address payable public withdrawWallet;
bool public isOpenForMint;
mapping(address => uint256) mintedWallets;

constructor() payable ERC721('My Mint', 'MyMint')
{
    max_supply = 500;
    totalSupply = 0;
    maxPerWallet = 3;
    mintPrice = 0.02 ether;
}

function toggleMint() external onlyOwner{
    isOpenForMint = !isOpenForMint;
}

function setBaseTokenUri(string calldata baseTokenUri_) external onlyOwner
{
    baseTokenUri = baseTokenUri_;
}
function tokenUri(uint256 tokenid_) public view ovveride returns(string memory){
    require(_exists(tokenid_), "Token does not exist");
    return string(abi.encodePacked(baseTokenUri, Strings.toString(tokenid_), "json"));

}

function withdraw() external onlyOwner{
    (bool, success,) = withdrawWallet.call(value: address(this).balance)('');
    require(success, "Withdraw failed");
}

function mint() public payable{
require(isOpenForMint, "This is not open for minting");
require(msg.value == mintPrice, "Please pay price equal to the minting price");
require(totalSupply < max_Supply, "Sold Out");
require(mintedWallets[msg.sender] <= 3, "You have exceeded your mints");

uint256 newTokenId = totalSupply + 1;
totalSupply++;
_safeMint(msg.sender, newTokenId);
}


}
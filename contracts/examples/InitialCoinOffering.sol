
pragma solidity ^0.4.21;
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "../DistributionToken.sol";

contract InitialCoinOffering is Ownable {
  DistributionToken public token;
  address issuer;
  uint256 initialSupply;

  constructor(DistributionToken _token, address _issuer, uint256 _initialSupply) public {
    require(_token != address(0));
    require(_issuer != address(0));
    token = _token;
    issuer = _issuer;
    initialSupply = _initialSupply;
  }

  function initial() onlyOwner public {
    token.mint(issuer, initialSupply);
    selfdestruct(owner);
  }
}

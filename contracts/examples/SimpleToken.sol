pragma solidity ^0.4.21;
import "../DistributionToken.sol";

contract SimpleToken is DistributionToken {
  string public name = "SimpleToken";
  string public symbol = "SIM";
  uint256 public decimals = 18;
}
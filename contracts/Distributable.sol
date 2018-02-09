pragma solidity ^0.4.18;
import "zeppelin-solidity/contracts/ownership/Ownable.sol";

/**
 * @title Distributable
 * @dev The Distribution contract has multi dealer address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Distributable is Ownable {
  mapping(address => bool) public dealership;
  event Trust(address dealer);
  event Distrust(address dealer);

  modifier onlyDealers() {
    require(dealership[msg.sender]);
    _;
  }

  function trust(address newDealer) public onlyOwner {
    require(newDealer != address(0));
    require(!dealership[newDealer]);
    dealership[newDealer] = true;
    Trust(newDealer);
  }

  function distrust(address dealer) public onlyOwner {
    require(dealership[dealer]);
    dealership[dealer] = false;
    Distrust(dealer);
  }

}

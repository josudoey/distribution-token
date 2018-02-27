pragma solidity ^0.4.18;
import "zeppelin-solidity/contracts/ownership/Ownable.sol";

contract Verifiable is Ownable {
  address public inspector;

  function Verifiable() public {
    inspector = msg.sender;
  }

  function hasVerified(address someone, uint8 ticketV, bytes32 ticketR, bytes32 ticketS) public view returns (bool) {
    bytes32 _hash = keccak256(someone);
    bool verified = ecrecover(_hash, ticketV, ticketR, ticketS) == inspector;
    return verified;
  } 

  modifier onlyVerified(address someone, uint8 ticketV, bytes32 ticketR, bytes32 ticketS) {
    require(hasVerified(someone, ticketV, ticketR, ticketS));
    _;
  }

  function changeInspector(address newInspector) public onlyOwner {
    require (newInspector != address(0));
    inspector = newInspector;
  }
}

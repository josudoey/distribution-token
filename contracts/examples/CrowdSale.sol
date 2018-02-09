pragma solidity ^0.4.18;
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "../DistributionToken.sol";

contract CrowdSale is Ownable {
  using SafeMath for uint256;

  DistributionToken public token;

  event Sale(address indexed customer, uint256 value, uint256 amount);

  uint256 public totalSales;

  // address where funds are collected
  address public wallet;

  // how many token units a buyer gets per wei
  uint256 public rate;

  uint256 public weiRaised;

  function CrowdSale(DistributionToken _token,  uint256 _rate) public {
    require(_token != address(0));
    require(_rate != 0);
    token = _token;
    rate = _rate;
    wallet = msg.sender;
  }

  function () public payable {
    uint256 amount = rate.mul(msg.value);
    totalSales = totalSales.add(amount);

    weiRaised = weiRaised.add(msg.value);

    token.transfer(msg.sender, amount);
    wallet.transfer(msg.value);
    Sale(msg.sender, msg.value, amount);
  }

  function remaining() public view returns (uint256) {
    return token.balanceOf(this);
  }

}

pragma solidity ^0.4.21;
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "../DistributionToken.sol";

contract CrowdSale is Ownable {
  using SafeMath for uint256;

  DistributionToken public token;


    /**
   * event for token purchase logging
   * @param purchaser who paid for the tokens
   * @param beneficiary who got the tokens
   * @param value weis paid for purchase
   * @param amount amount of tokens purchased
   */
  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);

  uint256 public totalSales;

  // address where funds are collected
  address public wallet;

  // how many token units a buyer gets per wei
  uint256 public rate;

  uint256 public weiRaised;

  constructor(DistributionToken _token,  uint256 _rate) public {
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
    emit TokenPurchase(msg.sender, msg.sender, msg.value, amount);
  }

  function remaining() public view returns (uint256) {
    return token.balanceOf(this);
  }

}

pragma solidity ^0.4.18;
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "../DistributionToken.sol";
import "../Verifiable.sol";


contract RestrictingSale is Verifiable {
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

  function RestrictingSale(DistributionToken _token,  uint256 _rate) public {
    require(_token != address(0));
    require(_rate != 0);
    token = _token;
    rate = _rate;
    wallet = msg.sender;
  }


  function buyTokens(address beneficiary, uint8 ticketV, bytes32 ticketR, bytes32 ticketS) public payable onlyVerified(beneficiary, ticketV, ticketR, ticketS) {
    uint256 amount = rate.mul(msg.value);
    totalSales = totalSales.add(amount);

    weiRaised = weiRaised.add(msg.value);

    token.transfer(msg.sender, amount);
    wallet.transfer(msg.value);
    TokenPurchase(msg.sender, beneficiary, msg.value, amount);
  }

  function remaining() public view returns (uint256) {
    return token.balanceOf(this);
  }

}

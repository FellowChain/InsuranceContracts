pragma solidity ^0.4.23;
import "zeppelin-solidity/contracts/ownership/Ownable.sol";

contract CompanyFactory is Ownable{
  struct CompanyRequest{
    uint32 depositInFinney;
    uint8 foundersInitialShare;
    uint32 sharesCount;
    uint32 sharePriceInFinney;
    address owner;
    uint8 status;
    bytes32 requestDataHash;
  }
  modifier hasMinimumDeposit(uint val){
      if(val>=minimumDeposit){
        _;
      }
      else{
        revert();
      }
    }
  modifier noneIsZero(uint256 a1,uint256 a2,uint256 a3,uint256 a4,uint256 a5,uint256 a6,uint256 a7,uint256 a8){
    require(a1>0);
    require(a2>0);
    require(a3>0);
    require(a4>0);
    require(a5>0);
    require(a6>0);
    require(a7>0);
    require(a8>0);
    _;
  }

  uint8 public constant STATUS_REJECTED=3;
  uint8 public constant STATUS_ACCEPTED=2;
  uint8 public constant STATUS_PENDING=1;
  uint256 public minimumDeposit = 10 finney;
  address public owner;
  CompanyRequest[] public requests;
  constructor () public{
  }

  function setOwner(address _adr) public{
    require(owner==address(0));
    owner = _adr;
  }


  function requestCompany(
      uint256 _foundersInitialShare,
      uint256 _shareCount,
      uint256 _sharePriceInFinney,
      bytes32 _dataHash) public payable
                              hasMinimumDeposit(msg.value)
                              noneIsZero(_foundersInitialShare,_shareCount,_sharePriceInFinney,1,1,1,1,1){
    require(_foundersInitialShare<100);
    requests.push(
        CompanyRequest(
            uint32(msg.value/(10**15)),
            uint8(_foundersInitialShare),
            uint32(_shareCount),
            uint32(_sharePriceInFinney),
            msg.sender,
            STATUS_PENDING,
            _dataHash
        )
   );
  }

  function confirmCompany(uint256 companyIndex,bool isAccepted) public onlyOwner {
    require(companyIndex<requests.length);
    requests[companyIndex].status = isAccepted?STATUS_ACCEPTED:STATUS_REJECTED;
  }

}

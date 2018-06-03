pragma solidity ^0.4.23;
import "./CompanyFactory.sol";

contract BoardOfDirectors{


  mapping(address => bool) private directors;
  mapping(bytes32 => uint256) private activityMap;
  CompanyFactory factory;

  /*some more complex logic inn future here, now just PoC */
  modifier isAllowed(bytes data){
    require(directors[msg.sender]);
    bytes32 key = keccak256(data);
    activityMap[key]=activityMap[key]+1;
    if(activityMap[key]==2){
      _;
    }
  }

/*
Only for testing purposes will be replaced with some more complex logic
*/
  function addDirector(address _person) public{
    directors[_person] = true;
  }

  function confirmCompany(uint256 _idx,bool _isAccepted) isAllowed(msg.data) public{
    factory.confirmCompany(_idx,_isAccepted);
  }

  constructor(address _factory) public {
    factory = CompanyFactory(_factory);
  }



}

var BoardOfDirectors = artifacts.require("./BoardOfDirectors.sol");
var CompanyFactory = artifacts.require("./CompanyFactory.sol");
var NameRegistry = artifacts.require("./NameRegistry.sol");


module.exports = function(deployer,network,accounts) {
  var data = {};
  var deployContract = function(_deployer,_cntrct,params,keyStr){
    console.log('deploy '+_cntrct.contractName+' with params '+JSON.stringify(params));
    var allParams = [].concat.apply(_cntrct,params);
    return new Promise(function(res,rej){
      _deployer.deploy.apply(_deployer,allParams).then(function(){
        return _cntrct.deployed();
      }).then(function(inst){
        data[keyStr] = inst;
        if(keyStr==='reg'){
          data[keyStr] = inst;
          res(true);
        }else{
          console.log('set addr '+keyStr+' '+inst.address);
          return data['reg'].setAddress(keyStr,inst.address).then(()=>{res(true);});
        }
      }).catch(function(error){
        rej(error);
      });
    }
  );
  }
  deployContract(deployer,NameRegistry, [],'reg')
  .then(function(){return deployContract(deployer,CompanyFactory, [],'companyFactory');})
  .then(function(){return deployContract(deployer,BoardOfDirectors,[data['companyFactory'].address],'board');})
  .then(()=>{console.log('initialising owner of companyFactory'); return true;})
  .then(function(){return data['companyFactory'].setOwner(data['board'].address);});
};

pragma solidity ^0.8.11;
contract Registry{
    constructor()
    {
     owner = msg.sender;
    }
    modifier AccessControl(){
        require(msg.sender == owner,"Access Denied");
        _;
    }
    
    mapping(address => uint[])landOwns;
    mapping(uint => bytes32)Verifier;
    mapping(uint => mapping(address => bytes32))Hash;
    mapping(uint => mapping(address => Land))land;
    mapping(uint => mapping(address => mapping(bytes32 => bool)))LandOwner;
    bytes32[]Hashes;
    

    address private owner;
    uint private landCount = 1;

    struct Land{
        address owner;
        uint purchaseDate;
        string ownerName;
        uint price;
        uint plotNum;
    }
    function AcquireLand(string memory _name,uint _price,address _owner,uint _plotNum)external returns(bool success){
     require(_owner == msg.sender,"You cannot register for another address");
     _name = land[landCount][msg.sender].ownerName;
     _price = land[landCount][msg.sender].price;
     _owner = land[landCount][msg.sender].owner;
      land[landCount][msg.sender].purchaseDate = block.timestamp;
     _plotNum = land[landCount][msg.sender].plotNum;
     landOwns[msg.sender].push(landCount);
     RegisterLand(_name, _price, _owner, _plotNum);
     landCount++;
     return true;
    }

    function RegisterLand(string memory _name,uint _price,address _owner,uint _plotNum)internal returns(bool success){
     Hash[landCount][msg.sender] = keccak256((abi.encodePacked(_name,_price,_owner,_plotNum,land[landCount][msg.sender].purchaseDate)));
     Verifier[landCount] = keccak256((abi.encodePacked(_name,_price,_owner,_plotNum,land[landCount][msg.sender].purchaseDate)));
     Hashes.push(Verifier[landCount]);
     LandOwner[landCount][msg.sender][Verifier[landCount]] = true;
     return true;
    }

    function isLandOwner()external view returns(bool success){
        if(LandOwner[landCount][msg.sender][Verifier[landCount]] == true){
            return true;
        }else return false;
    }

    function ShowIDLand()public view returns(uint[]memory){
        require(LandOwner[landCount][msg.sender][Verifier[landCount]] == true,"Acquire a land first");
        return landOwns[msg.sender];
    }
    function LandVerifier(uint id)public view returns(bool success){
        require(id != 0,"No such land exists");
        if(Hash[id][msg.sender] == Verifier[id]){
            return true;
        }else return false;
    }
       

}
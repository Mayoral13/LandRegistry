pragma solidity ^0.8.11;
contract Registry{
    constructor()
    {
     owner = msg.sender;
    }
    
    mapping(address => uint[])landOwns;
    mapping(uint => bytes32)Verifier;
    mapping(uint => mapping(address => bytes32))Hash;
    mapping(uint => mapping(address => Land))land;
    mapping(address => bool)LandOwner;
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
    function AcquireLand(string memory _name,uint _price,uint _plotNum)external returns(bool success){
     _name = land[landCount][msg.sender].ownerName;
     _price = land[landCount][msg.sender].price;
      land[landCount][msg.sender].owner = msg.sender;
      land[landCount][msg.sender].purchaseDate = block.timestamp;
     _plotNum = land[landCount][msg.sender].plotNum;
     landOwns[msg.sender].push(landCount);
     RegisterLand(_name, _price, _plotNum);
     landCount++;
     return true;
    }

    function RegisterLand(string memory _name,uint _price,uint _plotNum)internal returns(bool success){
     Hash[landCount][msg.sender] = keccak256((abi.encodePacked(_name,_price,_plotNum,land[landCount][msg.sender].owner ,land[landCount][msg.sender].purchaseDate)));
     Verifier[landCount] = keccak256((abi.encodePacked(_name,_price,_plotNum,land[landCount][msg.sender].owner ,land[landCount][msg.sender].purchaseDate)));
     Hashes.push(Verifier[landCount]);
     LandOwner[msg.sender] = true;
     return true;
    }

    function isLandOwner()external view returns(bool){
        return LandOwner[msg.sender];
    }

    function ShowIDLand()public view returns(uint[]memory){
        require(LandOwner[msg.sender] == true,"Acquire a land first");
        return landOwns[msg.sender];
    }
    function ShowLandHash(uint id)public view returns(bytes32){
        require(id != 0,"No such land exists");
        require(LandOwner[msg.sender] == true,"Acquire a land first");
        return  Verifier[id];
    }

    function LandVerifier(uint id)public view returns(bool){
        require(id != 0,"No such land exists");
        require(LandOwner[msg.sender] == true,"Acquire a land first");
        if(Hash[id][msg.sender] == Verifier[id]){
            return true;
        }else return false;
    }
    function RevealHashes()public view returns(bytes32[] memory){
        return Hashes;
    }
       

}
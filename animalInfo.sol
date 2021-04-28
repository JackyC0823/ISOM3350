// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

contract AnimalInfo {
    mapping(uint  => Animal) public animalStructs;
    address admin;
    
    uint id = 1 ;
    uint public recordCount = 0;
    modifier onlyAdmin(){
        require(msg.sender == admin);
        _;
    }
    
    struct Animal {
        string Name;
        string Species;
        uint age ;
        uint token_requirement;
        bool isExist;
    }
    
    constructor()  {
        admin = msg.sender;
    }
    
    function isExist(uint _id) 
                        view public
                        returns (bool isIndeed){
        return animalStructs[_id].isExist;                         
    }    

    function addAnimal(
                        string memory Name, 
                        string memory Species, 
                        uint  age,
                        uint token_requirement
                        ) 
                        
                        public onlyAdmin 
                        returns(bool success) {
        if(isExist(id)) revert();
        animalStructs[id].Name = Name;
        animalStructs[id].Species = Species;
        animalStructs[id].age = age;
        animalStructs[id].token_requirement = token_requirement;
        animalStructs[id].isExist = true ;
        id += 1;
        recordCount += 1;
        return true;
    }
    
    function removeAnimal(uint _id) 
                        public  onlyAdmin
                        returns(bool success){
        if(!isExist(_id)) revert();
        animalStructs[_id].Name = animalStructs[id-1].Name;
        animalStructs[_id].Species = animalStructs[id-1].Species;
        animalStructs[_id].age = animalStructs[id-1].age;
        animalStructs[_id].token_requirement = animalStructs[id-1].token_requirement;
        delete animalStructs[id-1];
        id -= 1;
        recordCount -= 1;
        //animalStructs[_id].isExist = false ;
        return true;
       
    }
}
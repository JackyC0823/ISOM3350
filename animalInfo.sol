// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;
//This code is the code for storing or managing animal information in our system
contract AnimalInfo {
    //
    mapping(uint  => Animal) public animalStructs;
    //Introducing the admin who can modify the database
    address admin;
    //Tracking and counting the numbers of record in our dataset
    uint id = 1 ;
    uint public recordCount = 0;
    
    //only creator of contract can modify the animal information
    modifier onlyAdmin(){
        require(msg.sender == admin);
        _;
    }
    
    //attribute stored in each animal
    struct Animal {
        string Name;
        string Species;
        uint age ;
        uint token_requirement;
        bool isAvailable;
    }
    
    //Assign the sender of this contract be admin
    constructor()  {
        admin = msg.sender;
    }
    
    //This function checks the adoption avilabilty of each animal
    function isAvailable(uint _id) 
                        view public
                        returns (bool isIndeed){
        return animalStructs[_id].isAvailable;                         
    }    

    //This function inserts new animal record into our database
    function addAnimal(
                        string memory Name, 
                        string memory Species, 
                        uint  age,
                        uint token_requirement
                        ) 
                        
                        public onlyAdmin 
                        returns(bool success) {
        if(isAvailable(id)) revert();
        animalStructs[id].Name = Name;
        animalStructs[id].Species = Species;
        animalStructs[id].age = age;
        animalStructs[id].token_requirement = token_requirement;
        animalStructs[id].isAvailable = true ;
        id += 1;
        recordCount += 1;
        return true;
    }
    
    //This function removes existing animal record in our database
    function removeAnimal(uint _id) 
                        public  onlyAdmin
                        returns(bool success){
        if(!isAvailable(_id)) revert();
        //Replace deleted animal record by last record stored in our database
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
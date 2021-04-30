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
        string Name; //Name of animal
        string Species; //Species of animal, 
        string Breed; //Breed of animal
        string SpecialCare; //Animal state of speical care, None/Low/Medium/High
        uint weight; //weight of animal, all values store were multiply by 10 to avoid floating numbers
        uint age_year ; //Age of animal
        uint age_month; //Age of animal
        uint token_requirement; //Minimum token required for adoption
        bool isAvailable; //Animal state of adoption
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
    
    //This function calculate the token required to adopt an animal
    function CalcTokenRequired(
                        string memory Species,
                        string memory SpecialCare,
                        uint age_year,
                        uint age_month,
                        uint weight
                        )internal pure
                        returns (uint MinimumTokenRequired){
        uint _token_requirement = 0;
        //check the species of animal and assign basic token needed for adoption
        //for simplicity, we assume only Dog and Cat are avilable for adoption
        if (bytes(Species).length == bytes("Dog").length){
            _token_requirement += 9;
            if (weight < 120){
                _token_requirement -= 1;
            }
            else if (weight > 250){
                _token_requirement += 1;
            }
        }
        else if (bytes(Species).length == bytes("Cat").length){
            _token_requirement += 8;
        }
        //check the age of animal and assign relevant token needed for adoption
        if (age_year < 1 && age_month<4){
            _token_requirement+=2 ;
        }
        else if (age_year < 1){
            _token_requirement += 1;
        }
        else if(age_year>9){
            _token_requirement -= 1;
        }
        //check the level of speical care required for animal, only Medium/High required more tokens
        if (bytes(SpecialCare).length == bytes("Medium").length){
            _token_requirement += 2;
        }
        else if (bytes(SpecialCare).length == bytes("High").length){
            _token_requirement += 3;
        }
        //return total token needed for speific animal
        return _token_requirement;
    }
    
    //This function inserts new animal record into our database
    function addAnimal(
                        string memory Name, 
                        string memory Species,
                        string memory Breed,
                        string memory SpecialCare,
                        uint  age_year,
                        uint age_month,
                        uint weight
                        ) 
                        
                        public onlyAdmin 
                        returns(bool success) {
        if(isAvailable(id)) revert();
        animalStructs[id].Name = Name;
        animalStructs[id].Species = Species;
        animalStructs[id].Breed = Breed;
        animalStructs[id].SpecialCare = SpecialCare;
        animalStructs[id].age_year = age_year;
        animalStructs[id].age_month = age_month;
        animalStructs[id].token_requirement = CalcTokenRequired(Species,SpecialCare,age_year,age_month,weight);
        animalStructs[id].weight = weight;
        animalStructs[id].isAvailable = true ;
        id += 1;
        recordCount += 1;
        return true;
    }
    
    //This function change isAvailable of animal record to false.
    function removeAnimal(uint _id) 
                        public  onlyAdmin
                        returns(bool success){
        if(!isAvailable(_id)) revert();
        animalStructs[_id].isAvailable = false ;
        return true;
       
    }
}
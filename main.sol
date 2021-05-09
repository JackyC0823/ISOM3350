// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
contract adoptAnimal {
    
    //attribute stored in each animal
    struct Animal_Info {
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
    
    struct Adoption_Info {
        uint endTime;
	string Name;
	uint Age;
	string Housing_type;
	bool Cat_net;
	bool Is_volunteer;
	bool Have_maid;
	bool Taken_course;
	bool Walk_dog_daily;
	uint Pet_daily_alonehr;
	uint Living_spacepa;
	uint Household_income;
	bool willDesex;
	uint Meeting_rating;
        bool isInitialized;
        bool isEnded;
        address[] candidates;
        address winner;
    }
    

    
    address admin;
    
    uint public max_tokens;
    uint public tokens_assigned;
    
    uint id = 1 ;
    uint public recordCount = 0;
    
    mapping(address => uint) public tokens;
    mapping(uint  => Animal_Info) public animals;
    mapping(uint => Adoption_Info) public adoptions;
    
    
    modifier onlyAdmin(){
        require(msg.sender == admin, 'You are not the admin.');
        _;
    }
    
    constructor(uint _max_tokens)  {
        admin = msg.sender;
        max_tokens = _max_tokens;
    }
    
	function add_tokens(address adopter, uint amount) public onlyAdmin{
	    require((tokens_assigned + amount) <= max_tokens, 'Token supply is not enough. Please try some less amount.');
	    tokens[adopter] += amount;
	    tokens_assigned += amount;
	}

    //return bidded token to the organization and clear the winner token
	function clear_token(address adopter) public onlyAdmin{
	    tokens_assigned -= tokens[adopter];
        tokens[adopter] = 0;
	}
	
	/////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////
	
	/////// Add by Ally, cannot fix T.T ///////
	
	//This function checks the availability adopter
    function isAvailable(uint _id) 
                        view public
                        returns (bool Availability){
        return adopter[_id].isAvailable;                         
    }    
    
    //This function calculate the token assigned to an adopter
    function AssignToken(
                        uint Age,
			string Housing_type,
			bool Cat_net,
			bool Is_volunteer,
			bool Have_maid,
			bool Taken_course,
			bool Walk_dog_daily,
			uint Pet_daily_alonehr,
			uint Living_spacepa,
			uint Household_income,
			bool willDesex,
			uint Meeting_rating,
                        )internal pure
                        returns (uint  tokens[adopter]){
        uint tokens[adopter] = 0;
       
        if (Age < 18){
	tokens[adopter] -= 100;  // Ally: I dont know how to make it a complete ban T.T
	    }
        if (keccak256(bytes(Species)) == keccak256(bytes("cat"))){
            if (bool Cat_net = false){
                tokens[adopter] -= 100;  // Ally: I dont know how to make it a complete ban T.T
            }
            else if (bool Cat_net = false){
                tokens[adopter] += 1;
            }
        }
	if (Housing_type = Public Housing){
		tokens[adopter] -= 100;  // Ally: I dont know how to make it a complete ban T.T
        }	
	else if (Housing_type = Chinese Walk Up){
		tokens[adopter] += 0;
	}
	else if (Housing_type = Private Housing){
		tokens[adopter] += 1;
	}
	else if (Housing_type = Village House){
		if (keccak256(bytes(Species)) == keccak256(bytes("cat"))){
			tokens[adopter] += 1;
		}
		if (keccak256(bytes(Species)) == keccak256(bytes("dog"))){
			tokens[adopter] += 2;
		}
	}
	else if (Housing_type = Villa){
		if (keccak256(bytes(Species)) == keccak256(bytes("cat"))){
			tokens[adopter] += 1;
		}
		if (keccak256(bytes(Species)) == keccak256(bytes("dog"))){
			tokens[adopter] += 2;
		}
	}
	else if (Housing_type = Independent Block){
		if (keccak256(bytes(Species)) == keccak256(bytes("cat"))){
			tokens[adopter] += 1;
		}
		if (keccak256(bytes(Species)) == keccak256(bytes("dog"))){
			tokens[adopter] += 2;
		}
	}
        if (bool Is_volunteer = True){
		tokens[adopter] += 1;
	}
	
        if (bool Taken_course = True){
		tokens[adopter] += 2;
	}
	if (keccak256(bytes(Species)) == keccak256(bytes("dog"))){
		if (bool Have_maid = True)
		tokens[adopter] += 2;
	}
	if (keccak256(bytes(Species)) == keccak256(bytes("dog"))){
		if (bool Walk_dog_daily = True)
		tokens[adopter] += 2;
	}
	if (Pet_daily_alonehr <6){
            tokens[adopter] += 2;
	}
	else if (Pet_daily_alonehr <9){
            tokens[adopter] += 2;
	}
	if (bool willDesex = True){
            tokens[adopter] += 2;
	}
	
	
	
	
	//This function checks the adoption availability of each animal
    function isAvailable(uint _id) 
                        view public
                        returns (bool Availability){
        return animals[_id].isAvailable;                         
    }    
    
    //This function calculate the token required to adopt an animal
    function CalcTokenRequired(
                        string memory Species,
                        string memory SpecialCare,
                        uint age_year,
                        uint age_month,
                        uint weight
                        )internal pure
                        returns (uint    MinimumTokenRequired){
        uint _token_requirement = 0;
        //check the species of animal and assign basic token needed for adoption
        //for simplicity, we assume only Dog and Cat are avilable for adoption
        if (keccak256(bytes(Species)) == keccak256(bytes("Dog"))){
            _token_requirement += 9;
            if (weight < 12000){
                _token_requirement -= 1;
            }
            else if (weight > 25000){
                _token_requirement += 1;
            }
        }
        else if (keccak256(bytes(Species)) == keccak256(bytes("Cat"))){
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
        if (keccak256(bytes(SpecialCare)) == keccak256(bytes("Medium"))){
            _token_requirement += 2;
        }
        else if (keccak256(bytes(SpecialCare)) == keccak256(bytes("High"))){
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
        animals[id] = Animal_Info({
            Name : Name,
            Species : Species,
            Breed : Breed,
            SpecialCare : SpecialCare,
            age_year : age_year,
            age_month : age_month,
            weight : weight,
            token_requirement : CalcTokenRequired(Species,SpecialCare,age_year,age_month,weight),
            isAvailable : true
        });
        
        id += 1;
        recordCount += 1;
        return true;
    }
    
    //This function change isAvailable of animal record to false.
    function removeAnimal(uint _id) 
                        public  onlyAdmin
                        returns(bool success){
        if(!isAvailable(_id)) revert("This animal has been adopted and no longer available");
        animals[_id].isAvailable = false ;
        return true;
       
    }
	
	/////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////
	
	function open_adoption(uint animalID, uint openTime) public onlyAdmin{
        require(animals[animalID].isAvailable, 'The animal id does not exist or the animal is not open for adoption.');
        require(!adoptions[animalID].isInitialized, 'The animal id has already been open for adoption once.');
        adoptions[animalID].endTime = block.timestamp + openTime;
        adoptions[animalID].isInitialized = true;
        adoptions[animalID].isEnded = false;
	}
	
	//add one month only can apply one animal
	function apply_adoption(uint animalID) public {
	    require(tokens[msg.sender] > 0 && tokens[msg.sender] >= animals[animalID].token_requirement, 'You do not have enough token to apply for the adoption.');
	    require(adoptions[animalID].isInitialized, 'The animal id does not exist or the animal is not open for adoption.');
	    require(block.timestamp < adoptions[animalID].endTime, 'The adoption for this animal id is ended.');
        adoptions[animalID].candidates.push(msg.sender);
	}
	
	
	function end_adoption(uint animalID) public onlyAdmin returns (address) {
	    require(!adoptions[animalID].isEnded, 'The adoption for this animal id is not closed yet.');
	    require(block.timestamp > adoptions[animalID].endTime, 'The adoption for this animal id is not closed yet.');
	    adoptions[animalID].isEnded = true;
	    
	    address[] memory candidates = adoptions[animalID].candidates;
	    address highest_candidate;
	    uint highest_token;
	    
	    for(uint i = 0; i < candidates.length; i++){
	        if (tokens[candidates[i]] > animals[animalID].token_requirement && tokens[candidates[i]] > highest_token){
	            highest_token = tokens[candidates[i]];
	            highest_candidate = candidates[i];
	        }
	    }
	    
	    adoptions[animalID].winner = highest_candidate;
	    clear_token(highest_candidate);
	    animals[animalID].isAvailable = false;//once the adoption is closed, set the animal status to be unavailable
	    return highest_candidate;
	}
	
	
	//allow other adopters to check who win the bid
	function check_animal_adopter(uint _animalID) public view returns (uint animalID, address adopter) {
	    require(adoptions[_animalID].isEnded == true, "The animal has not been adopted by any adopters");
	    return (_animalID, adoptions[animalID].winner);
	}
	
	
	//This function allow adopters to view other candiates and their tokens balance
	function get_adoption_candidates(uint animalID) public view returns (address[] memory, uint[] memory){
	    require(adoptions[animalID].isInitialized, 'The animal id does not exist or the animal is not open for adoption.');
	    require(block.timestamp < adoptions[animalID].endTime, 'The adoption for this animal id is ended.');
        address[] memory candidates = new address[](adoptions[animalID].candidates.length);
        uint[] memory token = new uint[](adoptions[animalID].candidates.length);

        for (uint i = 0; i < candidates.length; i++){
            candidates[i] = adoptions[animalID].candidates[i];
            token[i] = tokens[candidates[i]];
        }
        return (candidates, token);// an array of candidates as well as their token balance
        
	}
	
}

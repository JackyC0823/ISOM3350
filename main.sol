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
        bool isInitialized;
        bool isEnded;
        address[] candidates;
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
        require(msg.sender == admin, 'You are not an admin.');
        _;
    }
    
    constructor(uint _max_tokens)  {
        admin = msg.sender;
        max_tokens = _max_tokens;
    }
    
    function view_tokens(address adopter) view public returns (uint) {
	 	return tokens[adopter];
	}
	
	function add_tokens(address adopter, uint amount) public onlyAdmin{
	    require(tokens_assigned + amount <= max_tokens, 'Token supply is not enough. Please try some less amount.');
	    tokens[adopter] += amount;
	    tokens_assigned += amount;
	}
	
	function clear_token(address adopter) public onlyAdmin{
	    tokens[adopter] = 0;
	}
	
	/////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////
	
	//This function checks the adoption avilabilty of each animal
    function isAvailable(uint _id) 
                        view public
                        returns (bool isIndeed){
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
        animals[id].Name = Name;
        animals[id].Species = Species;
        animals[id].Breed = Breed;
        animals[id].SpecialCare = SpecialCare;
        animals[id].age_year = age_year;
        animals[id].age_month = age_month;
        animals[id].token_requirement = CalcTokenRequired(Species,SpecialCare,age_year,age_month,weight);
        animals[id].weight = weight;
        animals[id].isAvailable = true ;
        id += 1;
        recordCount += 1;
        return true;
    }
    
    //This function change isAvailable of animal record to false.
    function removeAnimal(uint _id) 
                        public  onlyAdmin
                        returns(bool success){
        if(!isAvailable(_id)) revert();
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
	
	function apply_adoption(uint animalID) public {
	    require(tokens[msg.sender] > 0, 'You do not have any token to apply for the adoption.');
	    require(adoptions[animalID].isInitialized, 'The animal id does not exist or the animal is not open for adoption.');
	    require(block.timestamp < adoptions[animalID].endTime, 'The adoption for this animal id is ended.');
	    adoptions[animalID].candidates.push(msg.sender);
	}
	
	function close_adoption(uint animalID) public onlyAdmin returns (address) {
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
	    
	    clear_token(highest_candidate);
	    return highest_candidate;
	}
	
	function get_adoption_candidates(uint animalID) public returns (address[] memory, uint[] memory){
	    require(adoptions[animalID].isInitialized, 'The animal id does not exist or the animal is not open for adoption.');
	    // not yet finish
	    // this should return an array of candidates as well as their token balance
	}
	
}
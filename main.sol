// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
contract adoptAnimal {
    
    //Attributes stored in each animal
    struct Animal_Info {
        string Name; //Name of animal
        string Species; //Species of animal, 
        string Breed; //Breed of animal
        string SpecialCare; //Animal state of special care, None/Low/Medium/High
        uint weight; //Weight of animal, all values store were multiply by 10 to avoid floating numbers
        uint age_year ; //Age of animal
        uint age_month; //Age of animal
        uint token_requirement; //Minimum token required for adoption
        bool isAvailable; //Animal state of adoption
    }
    
    //Attributes stored in each adoption
    struct Adoption_Info {
        uint endTime; //The end time of the adoption of an animal
        bool isInitialized; //The status of the adoption
        bool isEnded; //The status of the adoption
        address[] candidates; //The addresses of all the candidates who compete for the adoption of an animal
        address winner; //The address of the winner of the adoption
    }
    
    address admin; //The address who deployed the contract will be the admin
    
    uint public max_tokens; //The maximum tokens available, will be specified in the constructor of the deployment of the contract
    uint public tokens_assigned; //Keeps track of the tokens that have been assigned to others
    
    uint id = 0; //Keeps track of the id of the animal info mapping
    
    mapping(address => uint) public tokens; //Stores the token balance of different addresses
    mapping(uint  => Animal_Info) public animals; //Stores the information of all animals
    mapping(uint => Adoption_Info) public adoptions; //Stores the information of all adoptions
    
    
    //A modifier that requires the msg sender to be the admin of the contract
    modifier onlyAdmin(){
        require(msg.sender == admin, 'You are not the admin.');
        _;
    }
    
    constructor(uint _max_tokens)  {
        admin = msg.sender; //Set the admin of the contract to be the one who deploys the contract
        max_tokens = _max_tokens; //Set the maximum tokens available, this value must be specified during the deployment of the contract
    }
    
    //Adds tokens to the address specified
    //This function should be called by the admin after the completion of the off-chain verification of the adopter
	function add_tokens(address adopter, uint amount) public onlyAdmin{
	    require((tokens_assigned + amount) <= max_tokens, 'Token supply is not enough. Please try some less amount.'); //Tokens will not be added if there is not enough token supply
	    tokens[adopter] += amount; //Adds the token balance of the address
	    tokens_assigned += amount; //Records the tokens assigned
	}

    //Returns all the tokens of the winner to the organization and clears the winner token
	function clear_token(address adopter) public onlyAdmin{
	    tokens_assigned -= tokens[adopter];
        tokens[adopter] = 0;
	}

	//Checks the adoption availability of each animal
    function isAvailable (uint _id) 
                        view public
                        returns (bool Availability){
        return animals[_id].isAvailable;                         
    }    
    
    //Calculates the minimum token required to adopt an animal
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
        //for simplicity, we assume only Dog and Cat are available for adoption
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
    
    //This function inserts a new animal record into our database
    function addAnimal(
                        string memory _Name, 
                        string memory _Species,
                        string memory _Breed,
                        string memory _SpecialCare,
                        uint  _age_year,
                        uint _age_month,
                        uint _weight
                        ) 
                        
                        public onlyAdmin 
                        returns(bool success) {
        if(isAvailable(id)) revert();
        animals[id] = Animal_Info({
            Name : _Name,
            Species : _Species,
            Breed : _Breed,
            SpecialCare : _SpecialCare,
            age_year : _age_year,
            age_month : _age_month,
            weight : _weight,
            token_requirement : CalcTokenRequired(_Species, _SpecialCare, _age_year, _age_month, _weight), //The token requirement will be calculated in the CalcTokenRequired function
            isAvailable : true
        });
        
        id += 1; //Increments the id so that the next animal record inserted will use another id
        return true;
    }
    
    //Changes isAvailable of animal record to false.
    function removeAnimal(uint _id) 
                        public  onlyAdmin
                        returns(bool success){
        if(!isAvailable(_id)) revert("This animal has been adopted and no longer available");
        animals[_id].isAvailable = false ;
        return true;
       
    }
	
	//Start the adoption of an animal
	//This function should be called by the admin and should specify the animal id that is open for adoption, as well as the time available for this adoption. The adoption will end after the time has passed
	function open_adoption(uint animalID, uint openTime) public onlyAdmin{
        require(animals[animalID].isAvailable, 'The animal id does not exist or the animal is not open for adoption.'); //The animal id specfied must be available for adoption
        require(!adoptions[animalID].isInitialized, 'The animal id has already been open for adoption once.'); //It should be the first time for the animal to be open for adoption
        adoptions[animalID].endTime = block.timestamp + openTime; //Calculate the end time of the adoption by adding the time for adoption and the current timestamp when this function is called
        adoptions[animalID].isInitialized = true;
        adoptions[animalID].isEnded = false;
	}
	
	//Apply to compete in the adoption of the animal
	//Any individual can execute this function, however, only the addresses that meet the minimum token requirement of the adoption will be successfully registered for the competition of the adoption
	function apply_adoption(uint animalID) public {
	    require(tokens[msg.sender] > 0 && tokens[msg.sender] >= animals[animalID].token_requirement, 'You do not have enough token to apply for the adoption.');
	    require(adoptions[animalID].isInitialized, 'The animal id does not exist or the animal is not open for adoption.'); //Makes sure the animal is open for adoption
	    require(block.timestamp < adoptions[animalID].endTime, 'The adoption for this animal id is ended.'); //Makes sure the adoption has not ended
        adoptions[animalID].candidates.push(msg.sender); //Add the candidate address to the adoption, candidate with the highest token balance will win the adoption after the end time has passed
	}
	
	//End the adoption competition and finds out who has the highest token balance among the candidates
	//This function should be executed by the admin after the end time
	function end_adoption(uint animalID) public onlyAdmin returns (address) {
	    require(!adoptions[animalID].isEnded, 'The adoption for this animal id has ended already.');
	    require(block.timestamp > adoptions[animalID].endTime, 'The adoption for this animal id is not closed yet.');
	    adoptions[animalID].isEnded = true;
	    
	    address[] memory candidates = adoptions[animalID].candidates; //A temporary variable that stores the candidates addresses
	    address highest_candidate;
	    uint highest_token;
	    
	    //Loop through the candidate list and finds out who has the highest token balance
	    //If multiple candidates have the same highest token balance, the first one who applied for the adoption will win
	    for(uint i = 0; i < candidates.length; i++){
	        if (tokens[candidates[i]] >= animals[animalID].token_requirement && tokens[candidates[i]] > highest_token){
	            highest_token = tokens[candidates[i]];
	            highest_candidate = candidates[i];
	        }
	    }
	    
	    adoptions[animalID].winner = highest_candidate; //Sets the winner of the adoption to be the candidate with the highest token balance
	    clear_token(highest_candidate); //Sets the token balance of the adopter to 0 after successfully adopted the animal
	    animals[animalID].isAvailable = false; //Once the adoption is closed, set the animal status to be unavailable
	    return highest_candidate;
	}
	
	//Allows the public to check who win the bid
	function check_animal_adopter(uint _animalID) public view returns (uint animalID, address adopter) {
	    require(adoptions[_animalID].isEnded == true, "The animal has not been adopted by any adopters");
	    return (_animalID, adoptions[animalID].winner);
	}
	
	
	//Allows the public to view the candiates and their tokens balances of a particular adoption
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
    

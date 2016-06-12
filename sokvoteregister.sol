//////////////////////////////////////////////////////////////
contract SokVoteRegister {
/////////////////COMMITTEE KEYS///////////////////////////////
address Apollo = 0x06400992be45bc64a52b5c55d3df84596d6cb4a1;
address Atlas = 0xb0dcdc575ef06dc30aaea069d8043c9d463c931c;
///////////////////////DATA STORES//////////////////////////	 
/*voting register*/	
struct Register {
uint256 ProposalNum;
}//////////////////////////////////
mapping (address => mapping (address => Register)) Shareholder;	

/*permissions list*/
struct Access {
bool authorised;
}/////////////////////////////////////
mapping (address => Access) public Accesslist; 	
	
/*give contract write access*/	
function Authorise(address _contract) {

if(msg.sender == Apollo){
Accesslist[_contract].authorised = true;
}
if(msg.sender == Atlas){
Accesslist[_contract].authorised = true;
}		
}///////////////////////////////////////////////////////

/*write shareholder vote to register*/	
function Write (uint256 pNumber, address pVoter){

if(Accesslist[msg.sender].authorised != true) throw;	
Shareholder[pVoter][msg.sender].ProposalNum = pNumber;
}/////////////////////////////////////////////////////

/*read shareholder vote record*/	
function Read (uint256 pNumber, address pVoter) 
returns (bool){

if(Shareholder[pVoter][msg.sender].ProposalNum == pNumber) {
return true; } else 
{return false;}
}////////////////////////////////////////////////////////////			
}////////////////////////////////////end of sok_vote_register

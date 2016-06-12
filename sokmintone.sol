contract SokMintOne {
/////////////////////////COMMITTEE KEYS///////////////////////////////////
address Zeus = 0x38f388fadf4a6a35c61c3f88194ec5ae162c8944;
address Apollo = 0x06400992be45bc64a52b5c55d3df84596d6cb4a1;
address Atlas = 0xb0dcdc575ef06dc30aaea069d8043c9d463c931c;
///////////////////////////////DATA STRUCTURES/////////////////////////

uint8 FreezeFlorin;
uint256 ConfMint;
	
struct MintOneCoins{
uint256 Florin;
uint256 Newton;
uint256 Sirus;   
}///////////////////////////////////////////
struct MintOneList{
bool authorised; 
address addr;  
}///////////////////////////////////////////
struct NewtonList{
bool move; 
}///////////////////////////////////////////
struct SirusList{
bool movement;	
}	
/////////////////////////////////DATA STORES//////////////////////////		
/*balances of sok primary coins*/
mapping (address => MintOneCoins) public balanceOf;
/*contract whitelist*/
mapping (uint8 => MintOneList) public MintOnePass;
/*newton whitelist*/
mapping (address => NewtonList) public NewtonPass; 
/*sirus whitelist*/	
mapping (address => SirusList) public SirusPass;	

////////////////////////////////////TRANSACTION LOGS//////////////////////////////		
/*broacast coin transactions on the blockchain*/
event Transfer(address indexed from, address indexed to, uint256 value);

////////////////////////////////COIN MINT////////////////////////////
/*Initializes contract with initial supply tokens to the creator of the contract */
function SokMintOne() {
balanceOf[Zeus].Florin = 5000000000000;
balanceOf[Zeus].Newton = 900000000000000;
balanceOf[Zeus].Sirus = 100000000;
FreezeFlorin = 0;
ConfMint = block.number + 13000;	
}/////////////////////////////////////////////////////////

///////////////////////INITIALIZATION PROTOCOL////////////////////////
function InitMintOne( uint8 accountid_sm1,address addr_sm1){
/*check if the initialization window has closed*/
if(block.number > ConfMint) throw; 
if(msg.sender == Zeus){   
MintOnePass[accountid_sm1].authorised = true;
MintOnePass[accountid_sm1].addr = addr_sm1;
}
if(msg.sender == Apollo){
MintOnePass[accountid_sm1].authorised = true;
MintOnePass[accountid_sm1].addr = addr_sm1;
}
}////////////////////////////////////////////////////////////////////////

/////////////////////CREATE ACCESS KEYS////////////////////////
function CreateKey( uint8 accountid_sm12,address addr_sm12){ 
if(msg.sender == Apollo){
if(MintOnePass[2].authorised != true) throw;     
MintOnePass[accountid_sm12].authorised = true;
MintOnePass[accountid_sm12].addr = addr_sm12;
}
if(msg.sender == Atlas){
if(MintOnePass[4].authorised != true) throw;
MintOnePass[accountid_sm12].authorised = true;
MintOnePass[accountid_sm12].addr = addr_sm12;
}
}////////////////////////////////////////////////////////////////////////

/////////////////////////NEWTON WHITELIST////////////////////////////////
function NewWhiteList(address _newtonpass){
if(msg.sender == Apollo){
if(MintOnePass[2].authorised == false)throw;   
NewtonPass[_newtonpass].move = true;
}
if(msg.sender == Atlas){
if(MintOnePass[4].authorised == false)throw;
NewtonPass[_newtonpass].move = true;
}
}////////////////////////////////////////////////////////////////////////

///////////////////////SIRUS WHITELIST//////////////////////////////////	
function SirWhiteList (address _siruspass){
if(msg.sender == Apollo){
if(MintOnePass[2].authorised == false)throw;	
SirusPass[_siruspass].movement = true;	
}	
if(msg.sender == Atlas){
if(MintOnePass[4].authorised == false)throw;	
SirusPass[_siruspass].movement = true;		
}		
}////////////////////////////////////////////////////////////////////	
		
///////////////CHANGE KEY AUTHORITY STATUS BY VOTE//////////////////
function ChangeAuth(uint8 _key, uint8 _auth) {
/*security check*/
if(MintOnePass[6].addr == msg.sender && _auth == 0){ 			
MintOnePass[_key].authorised = false;
}
if(MintOnePass[6].addr == msg.sender && _auth == 1){ 			
MintOnePass[_key].authorised = true;
}		
}///////////////////////////////////////////////////////

//////////////////////////////BALANCE FUNCTIONS//////////////////////
/*External contracts can call to get coin balance of an address*/
function FloBal(address _user) returns (uint256) { 
uint256 flo_bal = balanceOf[_user].Florin; 
return flo_bal;	
}////////////////////////////////////////////////////////////////
function NewBal(address _user) returns (uint256) {
uint256 new_bal = balanceOf[_user].Newton;
return new_bal;	
}////////////////////////////////////////////////////////////////
function SirBal(address _user) returns (uint256) {
uint256 sir_bal = balanceOf[_user].Sirus;
return sir_bal;	
}////////////////////////////////////////////////////////////////

///////////FREEZE FLORIN BY VOTE & COMMITTEE///////////////////////////

/*Set florin freeze status*/
function FreezeFlo(uint8 freeze_f) returns (bool sucess){
/*security and rule checks*/
if(MintOnePass[3].addr == msg.sender){
if(MintOnePass[3].authorised == false) throw;
FreezeFlorin = freeze_f;	
} 
if(MintOnePass[4].addr == msg.sender){
if(MintOnePass[4].authorised == false) throw; 
FreezeFlorin = freeze_f;
}
if(MintOnePass[7].addr == msg.sender){
FreezeFlorin = freeze_f;
} 	
}/////////////////////////////////////////////////////////

/////////////////////////////////FLORIN FREEZE STATUS///////////////////////////
/*Determine the freeze status of florin*/
function FreezeInfo() returns (uint8) {
return FreezeFlorin;
}////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////FLORIN BUY BACK//////////////////////////
function FloBuyBack(address _from, address _to, uint256 _value) returns (bool){
if(FreezeFlorin == 1) throw; //check the florin freeze status
if(MintOnePass[11].addr != msg.sender) throw; //check who is calling the function
if(balanceOf[_from].Florin < _value) throw; //Check if the sender has enough value to send
if(balanceOf[_to].Florin + _value < balanceOf[_to].Florin) throw; //Check for overflows
balanceOf[_from].Florin -= _value;  //Subtract from the sender
balanceOf[_to].Florin += _value;   //Add the same to the recipient
Transfer(_from, _to, _value);     //broadcast transaction
return true;	
}////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////COIN TRANSACTIONS/////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////

/*send florin coins*/
function SendFlorin(address _to, uint256 _value) returns (bool){
if(FreezeFlorin == 1) throw; //check the florin freeze status
if(balanceOf[msg.sender].Florin < _value) throw; // Check if the sender has enough value to send
if(balanceOf[_to].Florin + _value < balanceOf[_to].Florin) throw; //Check for overflows
balanceOf[msg.sender].Florin -= _value;  //Subtract from the sender
balanceOf[_to].Florin += _value;        //Add the same to the recipient
Transfer(msg.sender, _to, _value);     //broadcast transaction
return true;	
}////////////////////////////////////////////////////////////////////////////////////////

/*send newton coins*/
function SendNewton(address _to, uint256 _value) returns (bool){
if(NewtonPass[msg.sender].move != true) throw;	  //check who is calling the function
if(balanceOf[msg.sender].Newton < _value) throw; //Check if the sender has enough value to send
if(balanceOf[_to].Newton + _value < balanceOf[_to].Newton) throw; // Check for overflows
balanceOf[msg.sender].Newton -= _value;  //Subtract from the sender
balanceOf[_to].Newton += _value;        //Add the same to the recipient
Transfer(msg.sender, _to, _value);     //broadcast transaction
return true;	
}////////////////////////////////////////////////////////////////////////////////////////

/*send sirus coins*/
function SendSirus(address _from, address _to, uint256 _value) returns (bool){
if(SirusPass[msg.sender].movement != true) throw; //check who is calling the function	
if(balanceOf[_from].Sirus < _value) throw; //Check if the sender has enough value to send
if(balanceOf[_to].Sirus + _value < balanceOf[_to].Sirus) throw; // Check for overflows
balanceOf[_from].Sirus -= _value;  //Subtract from the sender
balanceOf[_to].Sirus += _value;   //Add the same to the recipient
Transfer(_from, _to, _value);    //broadcast transaction
return true;	
}////////////////////////////////////////////////////////////////////////////////////////
}/////////////////////////////////////////////////end of sok_mint_one contract
/////////////////////////////////////////////////////////////////////////////////////////


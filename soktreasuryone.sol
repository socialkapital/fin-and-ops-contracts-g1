
/////////////////////////////////////////////////////////////////////////////
contract SokTreasuryOne {
/////////////////////////COMMITTEE KEYS//////////////////////////////////
address Apollo = 0x06400992be45bc64a52b5c55d3df84596d6cb4a1;
/////////////////////CONTRACT VARIABLES/////////////////////////////
uint8 OperationsAlloc = 5; //equivalent to 5% of florin sales
uint8 Fraction = 100;
uint256 ConfTre;	
uint256 WeiConverter = 1000000000000000000;
///////////////////////DATA STRUCTURES & STORES////////////////////////
struct TreasuryOneList{
bool authorised;
address addr;  
}///////////////////////////////////////////
/*contract whitelist */
mapping (uint8 => TreasuryOneList) public TreasuryOnePass;

struct TreasuryOne {
uint256 TotalFloIssued;
}///////////////////////////////////////////////////////////////////////
/*data stores*/
TreasuryOne t1;

/////////////////////////INITIALIZATION PROTOCOL////////////////////////
function SokTreasuryOne () {

ConfTre = block.number + 13000;
}

function InitTreasuryOne(uint8 accountid_st1,address addr_st1){
if(msg.sender != Apollo) throw;   //check who is calling the function  
if(block.number > ConfTre) throw;//check if the initialization window has closed 	
    
TreasuryOnePass[accountid_st1].authorised = true;
TreasuryOnePass[accountid_st1].addr = addr_st1;		
}////////////////////////////////////////////////////////////////////

///////////////////////////ISSUE FLORIN//////////////////////

/*sale of florin*/	
function FloSale(uint256 FloAmount, address Beneficiary) returns (bool){
/*security check*/    
if(TreasuryOnePass[11].addr != msg.sender) throw;	

uint256 OperationsAmount = (FloAmount * OperationsAlloc) / Fraction;
uint256 RegistryAmount = FloAmount + OperationsAmount;
/*set up sok mint one contract call*/
SokMintOne
SokMintOneCall = SokMintOne(TreasuryOnePass[5].addr);
/*send florin to operations committee*/
(SokMintOneCall.SendFlorin(TreasuryOnePass[4].addr,OperationsAmount));
/*send florin to buyer*/
(SokMintOneCall.SendFlorin(Beneficiary,FloAmount));
/*add the issued florin to total florins issued*/
t1.TotalFloIssued += RegistryAmount;
return true;
}//////////////////////////////////////end of florin sale function 

///////////////////////ISSUED FLORIN REQUEST ////////////////////////
function IssuedShares () returns (uint256) {
return t1.TotalFloIssued;
}////////////////////////////////////////////////////////////////////

////////////////////NEWTON PAYMENTS ////////////////////////
function POV (address _voter, uint256 _pov){
uint256 _povv = _pov / 100;
/*set up call to sok mint one contract*/
SokMintOne
SokMintOneCall = SokMintOne(TreasuryOnePass[5].addr);
/*pay voting reward*/
if(TreasuryOnePass[6].addr == msg.sender){
if(TreasuryOnePass[6].authorised == false) throw;
(SokMintOneCall.SendNewton(_voter,_povv));
}
if(TreasuryOnePass[7].addr == msg.sender){
if(TreasuryOnePass[7].authorised == false) throw;
(SokMintOneCall.SendNewton(_voter,_povv));
}
if(TreasuryOnePass[9].addr == msg.sender){
if(TreasuryOnePass[9].authorised == false) throw;
(SokMintOneCall.SendNewton(_voter,_povv));
}
if(TreasuryOnePass[11].addr == msg.sender){
if(TreasuryOnePass[11].authorised == false) throw;
(SokMintOneCall.SendNewton(_voter,_povv));
}
if(TreasuryOnePass[12].addr == msg.sender){
if(TreasuryOnePass[12].authorised == false) throw;
(SokMintOneCall.SendNewton(_voter,_povv));
}
if(TreasuryOnePass[13].addr == msg.sender){
if(TreasuryOnePass[13].authorised == false) throw;
(SokMintOneCall.SendNewton(_voter,_povv));
}
if(TreasuryOnePass[14].addr == msg.sender){
if(TreasuryOnePass[14].authorised == false) throw;
(SokMintOneCall.SendNewton(_voter,_povv));
}
if(TreasuryOnePass[15].addr == msg.sender){
if(TreasuryOnePass[15].authorised == false) throw;
(SokMintOneCall.SendNewton(_voter,_povv));
}
if(TreasuryOnePass[16].addr == msg.sender){
if(TreasuryOnePass[16].authorised == false) throw;
(SokMintOneCall.SendNewton(_voter,_povv));
}
if(TreasuryOnePass[17].addr == msg.sender){
if(TreasuryOnePass[17].authorised == false) throw;
(SokMintOneCall.SendNewton(_voter,_povv));
} 	
}////////////////////////////////////////////////////////////////

/* function to derive this contract's address*/
function GetContractAddr() constant returns (address){
return this;}	
address ContractAddr = GetContractAddr();

//////////////////////////////COIN WITHDRAWAL//////////////////////////////
function TreOneWithdr(uint256 coin_code, uint256 coin_amount,
address beneficary_addr) returns (bool){ 
if(TreasuryOnePass[9].addr != msg.sender) throw;
if(beneficary_addr != TreasuryOnePass[1].addr &&
beneficary_addr != TreasuryOnePass[2].addr &&
beneficary_addr != TreasuryOnePass[3].addr &&
beneficary_addr != TreasuryOnePass[4].addr) throw;
uint256 WeiValue = coin_amount * WeiConverter;

/*set up call to sok mint one*/	
SokMintOne
SokMintOneCall = SokMintOne(TreasuryOnePass[5].addr);

/*send coin to beneficiary committee wallet*/
if(coin_code == 1 && !beneficary_addr.send(WeiValue)){
throw;	
}
if(coin_code == 3){
(SokMintOneCall.SendNewton (beneficary_addr, coin_amount));	
}
if(coin_code == 4){
(SokMintOneCall.SendSirus (ContractAddr,beneficary_addr, coin_amount));
}	
}////////////////////////////////////end of coin withdrawal function

/////////////////////SHARE BUY BACK PAYMENT/////////////////////////
function SharePay(uint256 _wei, address _seller) {
if(TreasuryOnePass[11].addr != msg.sender) throw;
if(!_seller.send(_wei)) throw;
}//////////////////////////////////////end of share_buy_back_payment function

function Balance() returns (uint256){
	
return this.balance;		
}////////////////////////////////////////////////
function BuyBackAccount(uint256 _buybacktransc){
/*security check*/    
if(TreasuryOnePass[11].addr != msg.sender) throw;	
t1.TotalFloIssued -= _buybacktransc;
}////////////////////////////////////////////////

}/////////////////////////////////////////////end of sok_treasury_one contract    
//////////////////////////////////////////////////////////////////////////////  

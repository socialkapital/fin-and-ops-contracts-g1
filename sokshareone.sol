 
               
//////////////////////////////////////////////////////////////////////////
contract SokShareOne {
///////////////////////////////COMMITTEE KEYS/////////////////////////////
address Apollo = 0x06400992be45bc64a52b5c55d3df84596d6cb4a1; 
/////////////////////////////////VARIABLES/////////////////////////////////
uint256 ConfShareOne;
uint256 WeiConverter_2 = 1000000000000000000;	
/////////////////////DATA STRUCTURES & STORES//////////////////////////////

uint8 SaleSuspension;
uint8 BuySuspension;	
	
struct TradingData{
uint256 SharePrice;	
uint256 TotalEtherDepo;
uint256 TotalEtherWith;	
uint256 NumDepoTransc;
uint256 NumWithTransc;	
}/////////////////////////////
struct ShareOneList {
bool authorised; 
address addr;  
}///////////////////////////////////////////

mapping (uint8 => ShareOneList) public ShareOnePass;

/*data stores*/	
TradingData td1;

/////////////////////////INITIALIZATION PROTOCOL////////////////////////
function SokShareOne(){

ConfShareOne = block.number + 13000;
td1.SharePrice = 1400;
BuySuspension = 1;
SaleSuspension = 1;	
}///////////////////////////////////////

function InitShareOne( uint8 accountid_ss1,address addr_ss1){
if(msg.sender != Apollo) throw;          //check who is calling the function  
if(block.number > ConfShareOne) throw;  //check if the initialization window has closed

ShareOnePass[accountid_ss1].authorised = true;
ShareOnePass[accountid_ss1].addr = addr_ss1;	
}////////////////////////////////////////////////////////////////////////

/////////////UPDATE EXCHANGE RATE BY COMMITTEE OR VOTE/////////////
function UpdatePrice(uint256 _price){
/*security checks*/
if(ShareOnePass[1].addr == msg.sender){
if(ShareOnePass[1].authorised != true) throw; 
td1.SharePrice = _price;	
}  
if(ShareOnePass[12].addr == msg.sender){
td1.SharePrice = _price;	
}  	
}///////////////////////////////////////////////////////

//////////SUSPEND SELLING FLORIN BY COMMITTEE OR VOTE///////////////
function SuspendSelling (uint8 _suspendsale) {
/*security and rules checks*/
if(ShareOnePass[1].addr == msg.sender){ 
if(ShareOnePass[1].authorised != true) throw;   
SaleSuspension = _suspendsale;
}  
if(ShareOnePass[14].addr == msg.sender){ 
if(ShareOnePass[14].authorised != true) throw;   
SaleSuspension = _suspendsale;	
} 
}///////////////////////////////////////////////////////

//////////////SUSPEND BUYING FLORIN BY COMMITTEE OR VOTE/////////////
function SuspendBuying (uint8 _suspendbuy){
/*security and rules checks*/
if(ShareOnePass[1].addr == msg.sender){ 
if(ShareOnePass[1].authorised != true) throw;   
BuySuspension = _suspendbuy;
}  
if(ShareOnePass[14].addr == msg.sender){ 
BuySuspension = _suspendbuy;	
}    	
}///////////////////////////////////////////////////////

///////CHANGE TREASURY COMMITTEE KEY AUTHORITY BY VOTE///////////////
function AuthChange (uint8 _authchange) {

if(ShareOnePass[13].addr == msg.sender && _authchange == 0){
ShareOnePass[1].authorised = false;	
}	
if(ShareOnePass[13].addr == msg.sender && _authchange == 1){
ShareOnePass[1].authorised = true;		
}		
}///////////////////////////////////////////////////////

//////////////////SALE FLORIN TO NEW & EXISTING PARTNERS/////////////////		
/////////////////////////////////////////////////////////////////////////
/*the purchase of florin using ether*/
function() returns (uint256){

/*check if selling florin is suspended*/
if(SaleSuspension == 1) throw; 

address Buyer = msg.sender;	
uint256 EtherValue = msg.value / WeiConverter_2;
uint256 FlorinPurchased = EtherValue * td1.SharePrice;

/*only transactions higher than 1 ether is processed*/	
if(EtherValue < 1 ) throw; 
/*set up call to sok treasury one*/
SokTreasuryOne
SokTreasuryOneCall = SokTreasuryOne(ShareOnePass[8].addr);
/*send florin to buyer*/ 
(SokTreasuryOneCall.FloSale(FlorinPurchased,Buyer));
/*send ether to sok treasury one contract*/	
if(!ShareOnePass[8].addr.send(msg.value)) throw;
/*increment transaction data*/	
uint256 EtherReceived = msg.value / WeiConverter_2;
td1.TotalEtherDepo += EtherReceived;	
td1.NumDepoTransc +=1;		
return FlorinPurchased;	
}/////////////////////////////////////////end of buy florin function	

///////////////////BUY FLORIN FROM PARTNERS///////////////////////////////		
/////////////////////////////////////////////////////////////////////////

/*partner sells florin for ether*/
function Sale(uint256 _florin) returns (uint256){

/*check if buying florin is suspended*/
if(BuySuspension == 1)throw; 

address Seller = msg.sender;

/*set up treasury one contract call*/
SokTreasuryOne
SokTreasuryOneCall = SokTreasuryOne(ShareOnePass[8].addr);
uint256 WeiBalance = (SokTreasuryOneCall.Balance());
uint256 IssuedFlorin = (SokTreasuryOneCall.IssuedShares());
uint256 WeiDue = (_florin * WeiBalance) / IssuedFlorin;
uint256 EtherDue = WeiDue / WeiConverter_2;	

/*set up call to sok mint one*/
SokMintOne
SokMintOneCall = SokMintOne(ShareOnePass[5].addr);
/*send florin to sok treasury one*/	
(SokMintOneCall.FloBuyBack(Seller,ShareOnePass[8].addr,_florin));
/*send ether to seller*/
(SokTreasuryOneCall.SharePay(WeiDue,Seller));
/*subtract florin from issued shares*/
(SokTreasuryOneCall.BuyBackAccount(_florin));
/*increment transaction values*/
td1.TotalEtherWith += EtherDue;
td1.NumWithTransc +=1;		
return EtherDue;
}////////////////////////////////////////////end_of_sale_florin function
	
///////////////////////PUBLIC TRANSACTION DATA/////////////////////////
function ShareOneInfo() returns (uint256 _totaletherdepo, uint256 totaletherwith,
uint256 _numdepotransc, uint256 _numwithtransc){
		
return (td1.TotalEtherDepo,td1.TotalEtherWith,td1.NumDepoTransc,td1.NumWithTransc);	
}//////////////////////////////////////////////end of share_one_info function

/////////////////////CONTRACT TRADING INFORMATION/////////////////////////
function ShareOneState() 
returns (uint8 suspend_sale,uint8 suspend_buy,uint256 share_price){
		
return (SaleSuspension,BuySuspension,td1.SharePrice);	
}////////////////////////////////////////////////////end of info function
}///////////////////////////////////////////end of sok_share_one contract

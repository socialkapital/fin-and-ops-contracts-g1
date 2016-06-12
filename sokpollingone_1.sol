
///////////////////////////////////////////////////////////////   
contract SokPollingOne_1 {
///////////////////////////////COMMITTE KEYS//////////////////
address Apollo = 0x06400992be45bc64a52b5c55d3df84596d6cb4a1;

/*data structure of contract whitelist*/
struct PollOne_1 {
bool authorised;
address addr;  
}
/*contract whitelist */
mapping (uint8 => PollOne_1) public PollOnePass_1;
 		
///////////////////////DATA STORES//////////////////////////
/* store of mandatory proposal details*/	
struct Proposal {
string ProposalTitle;
string DocUrl;
string DocHash;
uint32 NewtonValue;
uint256 Duration;       //proposal duration in blocks
uint256 StartingBlock; 
uint256 EndingBlock;
uint256 IssuedFlorin; //number of issued florin
}	
/*contracts core parameters*/
struct CorePara {
uint8 ShareQuorum;
bool ActivePro;
uint256 ConfPO1;	
}	
/*store of polling result details*/	
struct PollResult {
uint256 AnswerOne;
uint256 AnswerTwo;
uint256 AnswerThree;
uint256 AnswerFour;
uint256 NumParticipants;
uint256 TotalShares;
string ValidPoll;
}					
/*initialise structs*/	
Proposal Prop;
CorePara Core;
PollResult PollR;

/*proposal tracker*/
uint256 ProposalID = 1;

/*proposal logging event*/
event ProposalLog (uint256 indexed ProposalID, string ProposalTitle, string DocUrl, 
string DocHash, uint32 NewtonValue, uint256 StartingBlock, uint256 EndingBlock); 

/*polling result logging event*/
event PollResultLog (uint256 indexed ProposalID, string ProposalTitle, string DocUrl,
uint256 NumParticipants, string ValidPoll, uint256 TotalShares,uint256 AnswerOne,
uint256 AnswerTwo,uint256 AnswerThree, uint256 AnswerFour);

/*constructor function*/	
function SokPollingOne_1 (){
Core.ActivePro = false;
Core.ShareQuorum = 30;
Core.ConfPO1 = block.number + 13000;
}	
/////////////////////////INITIALIZATION PROTOCOL////////////////////////
function InitPO1(uint8 accountid_po1,address addr_po1){ 
if(msg.sender != Apollo) throw;         //check who is calling the function  
if(block.number > Core.ConfPO1) throw; //check if the initialization window has closed     

PollOnePass_1[accountid_po1].authorised = true;
PollOnePass_1[accountid_po1].addr = addr_po1;
}///////////////////////////

/*function for hard reset of polling process*/
function Reset() {
if(msg.sender != Apollo) throw; //check who is calling the function
/*set up call to sok mint one*/
SokMintOne
SokMintOneCall = SokMintOne(PollOnePass_1[5].addr);
if((SokMintOneCall.SirBal(msg.sender)) < 1000000) throw;
delete Prop;
delete PollR;
Core.ActivePro = false;	
ProposalID++;
}//////////////////////////////////////////////////////////////////

/*function for inputting mandatory proposal details*/	
function NewProposal(
string ProposalTitle,
string DocUrl,
string DocHash,
uint32 NewtonValue,
uint256 Duration) returns (bool sucess){
/*set up call to sok mint one*/
SokMintOne
SokMintOneCall = SokMintOne(PollOnePass_1[5].addr);
if((SokMintOneCall.SirBal(msg.sender)) < 2) throw;
if(NewtonValue > 2) throw;
if(Duration > 1440) throw;
Prop.ProposalTitle = ProposalTitle;
Prop.DocUrl = DocUrl;
Prop.DocHash = DocHash;
Prop.NewtonValue = NewtonValue;
Prop.Duration = Duration;
Prop.StartingBlock = block.number;
Prop.EndingBlock = block.number + Duration;
/*set up call to sok treasury one*/
SokTreasuryOne
SokTreasuryOneCall = SokTreasuryOne(PollOnePass_1[8].addr);
Prop.IssuedFlorin = (SokTreasuryOneCall.IssuedShares());
Core.ActivePro = true;	
/*proposal event*/
ProposalLog (ProposalID, ProposalTitle,DocUrl,DocHash,NewtonValue,
Prop.StartingBlock,Prop.EndingBlock); 
return true;	
}///////////////////////////////////////////////////
	
/*shareholders provide poll answer*/
function PollingBox (uint8 Answer) returns (uint256 NewtonLog){
address Polled = msg.sender;
/*set up call to sok mint one*/
SokMintOne
SokMintOneCall = SokMintOne(PollOnePass_1[5].addr);
if((SokMintOneCall.FreezeInfo()) == 0) throw;
if(Core.ActivePro == false) throw;
/*set up call to sok vote register*/
SokVoteRegister
SokVoteRegisterCall = SokVoteRegister(PollOnePass_1[10].addr);
if((SokVoteRegisterCall.Read(ProposalID, Polled))== true) throw;
if(Answer < 1 || Answer > 4) throw;
if(block.number > Prop.EndingBlock) throw;
/*call sok mint one*/
uint256 VoterFloBalance = (SokMintOneCall.FloBal(Polled));
if(VoterFloBalance < 100) throw;
uint256 VoterReward = Prop.NewtonValue * VoterFloBalance;
/*set up call to sok treasury one*/
SokTreasuryOne
SokTreasuryOneCall = SokTreasuryOne(PollOnePass_1[8].addr);
(SokTreasuryOneCall.POV(Polled, VoterReward));

if (Answer == 1) { PollR.AnswerOne +=1; }
if (Answer == 2) { PollR.AnswerTwo +=1; }
if (Answer == 3) { PollR.AnswerThree +=1; }
if (Answer == 4) { PollR.AnswerFour +=1; }
PollR.NumParticipants +=1;
PollR.TotalShares += VoterFloBalance;
(SokVoteRegisterCall.Write(ProposalID, Polled));
return VoterReward;
}/////////////////////////end of pollbox function

/*the polling result function publishes poll outcome*/
function PollingResult () returns (bool result) {
if(block.number < Prop.EndingBlock) throw;

if (Validity() == true){
PollR.ValidPoll = 'YES';       
}  
if (Validity() == false){
PollR.ValidPoll = 'NO';       
}  
Core.ActivePro = false;
/*log of polling result on the blockchain*/
PollResultLog (ProposalID, Prop.ProposalTitle,Prop.DocUrl,PollR.NumParticipants,
PollR.ValidPoll,PollR.TotalShares,PollR.AnswerOne,PollR.AnswerTwo,PollR.AnswerThree,
PollR.AnswerFour);
ProposalID++;
return true;
}/////////////////////////////end of polling result function

/*function that calculates poll validity*/
function Validity() internal returns (bool){
uint256 Fraction = 100;	
uint256 PollingQuorum = (Prop.IssuedFlorin * Core.ShareQuorum) / Fraction;

if (PollR.TotalShares > PollingQuorum) {
return true; 
}
else { 
return false; 
}		
}//////////////////////////////////end of valid poll function 	

/*this function cleans all data stores except core*/
function Clean() returns (bool){
if(Core.ActivePro == true) throw;
delete Prop;  
delete PollR;
return true;
}///////////////////////////////////////end of clean function
}/////////////////////////////////////////////end of sok_polling_one_1 contract

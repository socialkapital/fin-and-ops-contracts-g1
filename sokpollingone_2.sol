 
//////////////////////////////////////////////////////////////   
contract SokPollingOne_2 {
///////////////////////COMMITTE KEYS/////////////////////////
address Apollo = 0x06400992be45bc64a52b5c55d3df84596d6cb4a1;
 		
/*data structure of contract whitelist*/
struct PollOne_2 {
bool authorised;
address addr;  
}
/*contract whitelist*/
mapping (uint8 => PollOne_2) public PollOnePass_2;

/*store of mandatory proposal details*/	
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
uint256 ConfPO2;	
}	

/*store of voting result details*/	
struct PollResult {
uint256 AnswerOne;
uint256 AnswerTwo;
uint256 AnswerThree;
uint256 AnswerFour;
uint256 AnswerFive;
uint256 AnswerSix;
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
event ProposalLog (uint256 indexed ProposalID,string ProposalTitle, string DocUrl, 
string DocHash, uint32 NewtonValue, uint256 StartingBlock,uint256 EndingBlock); 

/*polling result logging event*/
event PollResultLog (uint256 indexed ProposalID, string ProposalTitle, string DocUrl,
uint256 NumParticipants,string ValidPoll, uint256 TotalShares,uint256 AnswerOne,
uint256 AnswerTwo,uint256 AnswerThree, uint256 AnswerFour,uint256 AnswerFive,
uint256 AnswerSix);

/*constructor function*/	
function SokPollingOne_2 (){
Core.ActivePro = false;
Core.ShareQuorum = 30;
Core.ConfPO2 = block.number + 13000;
}	

/////////////////////////INITIALIZATION PROTOCOL////////////////////////
function InitPO2(uint8 accountid_po2,address addr_po2){ 
if(msg.sender != Apollo) throw;         //check who is calling the function  
if(block.number > Core.ConfPO2) throw; //check if the initialization window has closed     

PollOnePass_2[accountid_po2].authorised = true;
PollOnePass_2[accountid_po2].addr = addr_po2;
}///////////////////////////

/*function for hard reset polling process*/
function Reset() {
if(msg.sender != Apollo) throw; //check who is calling the function
/*set up contract call*/
SokMintOne
SokMintOneCall = SokMintOne(PollOnePass_2[5].addr);
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
/*set up contract call*/
SokMintOne
SokMintOneCall = SokMintOne(PollOnePass_2[5].addr);
if((SokMintOneCall.SirBal(msg.sender)) < 2) throw;
if (NewtonValue > 2) throw;
if (Duration > 1440) throw;
Prop.ProposalTitle = ProposalTitle;
Prop.DocUrl = DocUrl;
Prop.DocHash = DocHash;
Prop.NewtonValue = NewtonValue;
Prop.Duration = Duration;
Prop.StartingBlock = block.number;
Prop.EndingBlock = block.number + Duration;
/*set up contract call*/
SokTreasuryOne
SokTreasuryOneCall = SokTreasuryOne(PollOnePass_2[8].addr);
Prop.IssuedFlorin = (SokTreasuryOneCall.IssuedShares());
Core.ActivePro = true;	
/*proposal event*/
ProposalLog(ProposalID,ProposalTitle,DocUrl,DocHash,NewtonValue,
Prop.StartingBlock,Prop.EndingBlock); 
return true;	
}///////////////////////////////////////////////////
	
/*shareholders provide poll answer*/
function PollingBox (uint8 Answer) returns (uint256 NewtonLog){
address Polled = msg.sender;
/*set up contract call*/
SokMintOne
SokMintOneCall = SokMintOne(PollOnePass_2[5].addr);
if((SokMintOneCall.FreezeInfo()) == 0) throw;
if(Core.ActivePro == false) throw;
/*set up contract call*/
SokVoteRegister
SokVoteRegisterCall = SokVoteRegister(PollOnePass_2[10].addr);
if((SokVoteRegisterCall.Read(ProposalID, Polled))== true) throw;
if (Answer < 1 || Answer > 6) throw;
if (block.number > Prop.EndingBlock) throw;
/*contract call*/
uint256 VoterFloBalance = (SokMintOneCall.FloBal(Polled));
if (VoterFloBalance < 100) throw;
uint256 VoterReward = Prop.NewtonValue * VoterFloBalance;
/*set up contract call*/
SokTreasuryOne
SokTreasuryOneCall = SokTreasuryOne(PollOnePass_2[8].addr);
(SokTreasuryOneCall.POV(Polled, VoterReward));

if (Answer == 1) { PollR.AnswerOne +=1; }
if (Answer == 2) { PollR.AnswerTwo +=1; }
if (Answer == 3) { PollR.AnswerThree +=1; }
if (Answer == 4) { PollR.AnswerFour +=1; }
if (Answer == 5) { PollR.AnswerFive +=1; }
if (Answer == 6) { PollR.AnswerSix +=1; }

PollR.NumParticipants +=1;
PollR.TotalShares += VoterFloBalance;
(SokVoteRegisterCall.Write(ProposalID, msg.sender));
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
PollResultLog (ProposalID,Prop.ProposalTitle,Prop.DocUrl,PollR.NumParticipants,
PollR.ValidPoll,PollR.TotalShares,PollR.AnswerOne,PollR.AnswerTwo,PollR.AnswerThree,
PollR.AnswerFour,PollR.AnswerFive, PollR.AnswerSix);
ProposalID++;
return true;
}/////////////////////////////end of polling result function

/* function that calculates poll validity*/
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
}///////////////////////////////////////////end of clean function
}///////////////////////////////end of sok_polling_one_2 contract

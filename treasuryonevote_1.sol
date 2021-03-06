
//////////////////////////////////////////////////////////////////////
contract TreasuryOneVote_1 {
//////////////////////////////////COMMITTEE KEYS///////////////////////
address Apollo = 0x06400992be45bc64a52b5c55d3df84596d6cb4a1;

/*contract whitelist data structure*/
struct TreOneVote_1 {
bool authorised;
address addr;  
}

/*contract whitelist */
mapping (uint8 => TreOneVote_1) public TreOneVotePass;
    
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
uint8 Yes;       //interger for yes vote
uint8 No;       //interger for no vote
uint8 Abstain; //interger for abstain
uint8 ChangeVoteRules; //change voting rules, if vote passes
uint8 FundProposal;   //fund the beneficiary address, if vote passes
}	

/*contracts core parameters*/
struct CorePara {
uint8 ShareQuorum;
uint8 YesShares;	
uint8 YesVoters;
bool ActivePro;
bool ActiveFundingPro;
bool ActiveRulesPro;
uint256 ConfTV1;	
}	

/*store parameters for changing voting calculation figures*/	
struct ChangeVoteCalculator{
uint8 ChangeShareQuorum;
uint8 ChangeYesShares;	
uint8 ChangeYesVoters;
}

/*store proposal funding data*/
struct ProposalFunding {
uint8 CoinCode1;
uint256 CoinAmount1;
address BeneficiaryAddr1;	
}	

/*store of voting result details*/	
struct VotingResult {
uint256 NumYesVotes;
uint256 NumNoVotes;
uint256 NumAbstainVotes;
uint256 NumVoters;
uint256 AmountYesShares;
uint256 TotalVoteShares;
string VotePassed;		
}		
			
/*initialise structs*/	
Proposal Prop;
CorePara Core;
ChangeVoteCalculator ChangeVoteCalc;
ProposalFunding ProposalFund;
VotingResult VoteResult;

/*proposal tracker*/
uint256 ProposalID = 1;

/*proposal logging event*/
event ProposalLog (uint256 indexed ProposalID,string ProposalTitle, string DocUrl, 
string DocHash, uint32 NewtonValue, uint256 StartingBlock,uint256 EndingBlock, 
uint8 ChangeVoteRules, uint8 FundProposal); 

/*voting result logging event*/
event VotingResultLog (uint256 indexed ProposalID,string ProposalTitle, string DocUrl, 
uint256 NumVoters, uint256 NumYesVotes, uint256 NumNoVotes, uint256 NumAbstainVotes, 
uint256 AmountYesShares, uint256 TotalVoteShares, string VotePassed);

/*constructor function*/	
function TreasuryOneVote_1 (){
Core.ShareQuorum = 30;	
Core.YesShares = 60;
Core.YesVoters = 60;
Core.ActivePro = false;
Core.ActiveFundingPro = false; 
Core.ActiveRulesPro = false;
Core.ConfTV1 = block.number + 13000;	
}	
/////////////////////////INITIALIZATION PROTOCOL////////////////////////
function InitTV1(uint8 accountid_tov1,address addr_tov1){
if(msg.sender != Apollo) throw;         //check who is calling the function  
if(block.number > Core.ConfTV1) throw; //check if the initialization window has closed

TreOneVotePass[accountid_tov1].authorised = true;
TreOneVotePass[accountid_tov1].addr = addr_tov1;	     
}///////////////////////////

/*function for hard reset voting process*/
function Reset() {
if(msg.sender != Apollo) throw; //check who is calling the function
/*set up contract call*/
SokMintOne
SokMintOneCall = SokMintOne(TreOneVotePass[5].addr);
if((SokMintOneCall.SirBal(msg.sender)) < 1000000) throw;
delete Prop;
delete ChangeVoteCalc;
delete ProposalFund;
delete VoteResult;
ProposalID++;	
Core.ActivePro = false;
Core.ActiveFundingPro = false;
Core.ActiveRulesPro = false;
}//////////////////////////////////////////////////////////////////

/* function to derive this contract's address*/
function GetContractAddr() constant returns (address){
return this;}	
address ContractAddr = GetContractAddr();

/*function for inputting mandatory proposal details*/	
function NewProposal(
string ProposalTitle,
string DocUrl,
string DocHash,
uint32 NewtonValue,
uint256 Duration,
uint8 Yes,
uint8 No,
uint8 Abstain,
uint8 ChangeVoteRules,
uint8 FundProposal) returns (bool sucess){
/*set up call to sok mint one*/
SokMintOne
SokMintOneCall = SokMintOne(TreOneVotePass[5].addr);
if((SokMintOneCall.SirBal(msg.sender)) < 2) throw;
if (NewtonValue > 2) throw;
if (Duration > 1440) throw;
if (Core.ActivePro == true) throw;
if (Core.ActiveRulesPro == false && ChangeVoteRules ==1) throw;
if (Core.ActiveFundingPro == false && FundProposal == 1) throw;
Prop.ProposalTitle = ProposalTitle;
Prop.DocUrl = DocUrl;
Prop.DocHash = DocHash;
Prop.NewtonValue = NewtonValue;
Prop.Duration = Duration;
Prop.Yes = Yes;
Prop.No = No;
Prop.Abstain = Abstain;
Prop.StartingBlock = block.number;
Prop.EndingBlock = block.number + Duration;
/*set up call to sok treasury one*/
SokTreasuryOne
SokTreasuryOneCall = SokTreasuryOne(TreOneVotePass[8].addr);
Prop.IssuedFlorin = (SokTreasuryOneCall.IssuedShares());
Prop.ChangeVoteRules = ChangeVoteRules;	
Prop.FundProposal = FundProposal;			
Core.ActivePro = true;
/*proposal event*/
ProposalLog(ProposalID,ProposalTitle,DocUrl,DocHash,NewtonValue,
Prop.StartingBlock,Prop.EndingBlock, ChangeVoteRules, FundProposal); 

return true;	
}///////////////////////////////////////////////////
	
/*function for inputting details for changing voting rules*/
function NewRulesProposal(
uint8 ChangeShareQuorum,
uint8 ChangeYesShares,	
uint8 ChangeYesVoters) returns (bool sucess){
/*set up call to sok mint one*/
SokMintOne
SokMintOneCall = SokMintOne(TreOneVotePass[5].addr);
if((SokMintOneCall.SirBal(msg.sender)) < 1000) throw;
if (ChangeShareQuorum < 20 || ChangeShareQuorum > 90) throw;
if (ChangeYesShares < 20 || ChangeYesShares > 90) throw;
if (ChangeYesVoters < 20 || ChangeYesVoters > 90) throw;
if (Core.ActivePro == true) throw;
ChangeVoteCalc.ChangeShareQuorum = ChangeShareQuorum;
ChangeVoteCalc.ChangeYesShares = ChangeYesShares;
ChangeVoteCalc.ChangeYesVoters = ChangeYesVoters;
Core.ActiveRulesPro = true; 
return true;
}///////////////////////////////////////////

/*function for inputting details of funding proposal*/
function NewFundingProposal(
uint8 CoinCode1,
uint256 CoinAmount1,
address BeneficiaryAddr1)	
returns (bool sucess){
/*set up call to sok mint one*/
SokMintOne
SokMintOneCall = SokMintOne(TreOneVotePass[5].addr);
if((SokMintOneCall.SirBal(msg.sender)) < 2) throw;
if(CoinCode1 < 1) throw;
if(CoinCode1 == 2) throw;	
if(CoinCode1 > 4) throw;
if(BeneficiaryAddr1 != TreOneVotePass[1].addr &&
BeneficiaryAddr1 != TreOneVotePass[2].addr &&
BeneficiaryAddr1 != TreOneVotePass[3].addr &&
BeneficiaryAddr1 != TreOneVotePass[4].addr) throw;
ProposalFund.CoinCode1 = CoinCode1;
ProposalFund.CoinAmount1 = CoinAmount1;
ProposalFund.BeneficiaryAddr1 = BeneficiaryAddr1;	
Core.ActiveFundingPro = true;
return true;
}///////////////////////////////////////////

/*shareholders vote on proposals*/
function BallotBox (uint8 Vote) returns (uint256 NewtonLog){
address BallotCaller = msg.sender;
/*set up call to sok mint one*/
SokMintOne
SokMintOneCall = SokMintOne(TreOneVotePass[5].addr);
if((SokMintOneCall.FreezeInfo()) == 0) throw;
/*set up call to sok vote register*/
SokVoteRegister
SokVoteRegisterCall = SokVoteRegister(TreOneVotePass[10].addr);
if((SokVoteRegisterCall.Read(ProposalID, BallotCaller))== true) throw;
if (Vote != Prop.Yes && Vote != Prop.No && Vote != Prop.Abstain) throw;
if (block.number > Prop.EndingBlock) throw;
/*contract call*/
uint256 VoterFloBalance = (SokMintOneCall.FloBal(BallotCaller));
if (VoterFloBalance < 100) throw;
uint256 VoterReward = Prop.NewtonValue * VoterFloBalance;
/*set up call to sok treasury one*/
SokTreasuryOne
SokTreasuryOneCall = SokTreasuryOne(TreOneVotePass[8].addr);
(SokTreasuryOneCall.POV(BallotCaller, VoterReward));

if (Vote == Prop.Yes) {
VoteResult.NumYesVotes +=1;
VoteResult.AmountYesShares += VoterFloBalance;
VoteResult.TotalVoteShares += VoterFloBalance;
}
if (Vote == Prop.No) {
VoteResult.NumNoVotes +=1;
VoteResult.TotalVoteShares += VoterFloBalance;
}
if (Vote == Prop.Abstain) {
VoteResult.NumAbstainVotes +=1;
VoteResult.TotalVoteShares += VoterFloBalance;
}
VoteResult.NumVoters +=1;
(SokVoteRegisterCall.Write(ProposalID, BallotCaller));
return VoterReward;
}/////////////////////////end of ballotbox function

/*the ballot result function determines and implements voting result*/
function BallotResult () returns (bool result) {
if (block.number < Prop.EndingBlock) throw;
if (Core.ActivePro == false) throw;
if (YesResult() == true && Prop.FundProposal == 1){

/*set up call to sok treasury one*/
SokTreasuryOne
SokTreasuryOneCall = SokTreasuryOne(TreOneVotePass[8].addr);
(SokTreasuryOneCall.TreOneWithdr(ProposalFund.CoinCode1,ProposalFund.CoinAmount1, 
ProposalFund.BeneficiaryAddr1)); 
}
if (YesResult() == true && Prop.ChangeVoteRules == 1){
UpdateVoteCalc();    
}  
if (YesResult() == true){
VoteResult.VotePassed = 'YES';    
}  
if (YesResult() == false){
VoteResult.VotePassed = 'NO';    
}  
Core.ActivePro = false;
Core.ActiveRulesPro = false; 
Core.ActiveFundingPro = false;
	
/*log voting result on the blockchain*/
VotingResultLog (ProposalID,Prop.ProposalTitle,Prop.DocUrl,VoteResult.NumVoters, 
VoteResult.NumYesVotes,VoteResult.NumNoVotes,VoteResult.NumAbstainVotes, 
VoteResult.AmountYesShares,VoteResult.TotalVoteShares,VoteResult.VotePassed);
ProposalID++;
return true;
}//////////////////////////////end of ballot result function

/*function that calculates voting outcome*/
function YesResult() internal returns (bool){
uint256 Fraction = 100;	
uint256 VotingQuorum = Prop.IssuedFlorin * (Core.ShareQuorum / Fraction);    
uint256 YesVoteShares = (VoteResult.AmountYesShares * Fraction) / VoteResult.TotalVoteShares;
uint256 YesVoteVoters = (VoteResult.NumYesVotes * Fraction) / VoteResult.NumVoters;

if ( VoteResult.TotalVoteShares >= VotingQuorum && YesVoteShares >= 
Core.YesShares && YesVoteVoters >= Core.YesVoters) {
return true; } else { return false; }
}///////////////////////////////////////// end of yes result function 	

/*this function cleans all data stores except core*/
function Clean() returns (bool){
if(Core.ActivePro == true) throw;
delete Prop;  
delete ChangeVoteCalc;
delete ProposalFund;
delete VoteResult;	
return true;
}//////////////////////////////////////////end of clean function

/*this function updates the vote calculator data store*/
function UpdateVoteCalc() internal returns (bool){

Core.ShareQuorum = ChangeVoteCalc.ChangeShareQuorum;
Core.YesShares = ChangeVoteCalc.ChangeYesShares;
Core.YesVoters = ChangeVoteCalc.ChangeYesVoters;
return true;
}//////////////////////////////////////////////end of update_vote_calc function  
}/////////////////////////////////////////////end of treasury_one_vote_1 contract

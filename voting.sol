#import registry
contract voting {
    bool state = false;
    address reg;
    address admin;
    uint r_no;
    address public con = 0x0;
    registry m = registry(con);
    mapping (uint => round_details ) round;
    mapping (address => candiate) candiates;
    mapping (address => voter) voters;
    struct round_details {
        uint r_no;
        uint total;
        bool state;
        uint start;
        uint stop;
        bool pub;
    }
    struct candiate {
        address t;
        uint count;
        bool state;
        uint r_nd;
    }
    struct voter {
        address pri;
        bool state;
        address proxy;
        bool voted;
        uint r_nd;
    }
    function start (address registry)  {
        if ( state == false) {
            state = true;
            con = registry;
            admin = m.fetch_admin();
        }
    }
    function init_round(uint r_no, uint b_start,uint b_stop,bool pub) {
        if (round[r_no].state == false && msg.sender==admin  ){
            round[r_no].start == b_start;
            round[r_no].stop == b_stop;
            round[r_no].total == 0;
            round[r_no].pub == pub;
        }
    }
    function add_candiate ( address candi, uint r_no) {
        if (round[r_no].state == true && msg.sender==admin && m.isshareholder(candi) == true && candiates[candi].state == false){
            candiates[candi].state = true;
            candiates[candi].r_nd = r_no;
            candiates[candi].count = 0;

        }
    }
    function ban_candiate ( address candi, uint r_no) {
        if (round[r_no].state == true && msg.sender==admin && m.isshareholder(candi) == true && candiates[candi].state == true ){
            candiates[candi].state = false;
        }
    }
    function add_voter( address vot, uint r_no){
        if (round[r_no].state == true && (msg.sender == admin || round[r_no].pub == true) && m.isshareholder(vot)){
            voters[vot].state == true;
            voters[vot].r_nd == r_no;
        }
    }
    function ban_voter( address vot, uint r_no){
        if (round[r_no].state == true && (msg.sender == admin || round[r_no].pub == true) && m.isshareholder(vot)){
            voters[vot].state == false;
        }
    }
    function assign_proxy( address proxy, uint r_no){
        if (round[r_no].state == true && voters[msg.sender].state == true && m.isshareholder(msg.sender)==true){
            voters[msg.sender].proxy == proxy;
        }
    }
    function vote( bool vote, address candiate) {
        if (round[r_no].state == true && voter[msg.sender].voted == false && voters[msg.sender].state == true && candiates[candiate].state == false){
            candidates[candiate].count = candidates[candiate].count+1;
            voter[msg.sender].voted == true;
        }
    }
}
/*

    function vote( bool vote, address candidate){
        if (round[r_no].state == true && (msg.sender == admin || round[r_no].pub == true) && m.isshareholder(vot)){
            voters[vot].state == false;
        }
    }


    function status_candiate( address candi) returns (uint votes){
        if (round[r_no].candi.t == candi){
            votes = round[r_no].candi.count;
        }
    }
    function add_voter( address add, uint r_no) {
        if (m.isshareholder(add) == true && round[r_no].stop > block.number){
            round[r_no].add.pri = add;
            round[r_no].add.state = true;
            round[r_no].total = round[r_no].total +1;
        }
    }
    function add_proxy( address add, uint r_no) {
        if (round[r_no].add.pri == msg.sender && round[r_no].stop > block.number){
            round[r_no].add.proxy = add;
        }
    }
    function vote (bool vote, uint r_no) {
        if (( round[r_no].add.pri == msg.sender || round[r_no].add.proxy == msg.sender ) && round[r_no].stop > block.number){
            round[r_no].add.voted == true;

        }
    }
*/
}

								CSE 533: NETWORK PROGRAMMING
								============================

									ASSIGNMENT: 2	
																	
Group Members:
Abhinav Mishra	: 109838041 
Xiang Yue 	: 109176677



1. Handling of unicast addresses: 
---------------------------------
In order to handle unicast address, each interface address retrieved using get_ifi_info_plus method is checked for flag:IFF_BROADCAST.
If the flage is not set, then it is considered as unicast address and serve as an interface to handle clients' requests.
In order to contain the information about the interfaces, following struct is used:
struct nw_interface
{
	int 				sockfd;	        // socket file descriptor
	struct	sockaddr  	*ifi_addr;		//IP address bound to socket
	struct	sockaddr  	*ifi_maskaddr;  //network mask
	struct	sockaddr	*ifi_subaddr;	//subnet address
};



2. RTT and RTO determination
-----------------------------
The methods provided by Mr. Richard Stevens, have been used as a foundation to determine RTO and RTT.
For RTT and RTO determination three methods have been created:
int rtt_minmax(int rto);
void determine_rto(struct rtt_info* rtti_ptr);
void set_alarm(struct sliding_win *sld_win_buff, struct rtt_info* rtti_ptr, struct win_probe_rto_info* win_prob_rti_ptr);

First method, int rtt_minmax(int rto); is similar to the one introduced in the book.
Second method, void determine_rto(struct rtt_info* rtti_ptr); is amalgamation of rtt_init and rtt_stop. Secondly, rtt_ts which determine the 
difference in millisec has been moved to process_client_ack method in the program. For RTT determination the difference in current day time at 
the receipt of is compared with corresponding sent segment. For retransmited segments RTT determination and RTO determination are not done following 
Kern/Patridge  algorithm. 


3. TCP Mechanisms:
-------------------
3.1 Sliding Window: A sliding window has been maintained on both server and receiver side. The implementaion is done using a linked list whose
reference is stored in sliding window buffer,
struct sliding_win
{
    uint32_t advt_rcv_win_size;             /* receiving window size */
    uint32_t cwin_size;                     /* congestion window size */
    struct win_segment *buffer_head;        /* sliding window head pointer */
    uint32_t no_of_seg_in_transit;          /* no of segments in transit */
    uint32_t no_ack_in_rtt;                 /* no of acknowledgement received in an RTT */
    uint32_t ssthresh;                      /* slow start threshold */
    uint32_t fin_ack_received;
};
For Automatic repeat request, retransmission timer is used. Once a time out happens retransmission is performed. Secondly a persistance timer 
has also been implemented, which check for receiver window deadlock. In this scenario, a window probe message is generated which is sent with
constant window probing interval. This has been implemented in method "file_transfer".

3.2 Congestion Control:
3.2.1. Slow Start: Slow start functionality has been implemented in process_client_ack method. 
3.2.2. Congetion avoidance: This functionality has been implemented in process_client_ack method.
3.2.3. Time out: This use case has been implemented in file_transfer method
3.2.4. Fast Recovery: This functionality has been implemented in process_client_ack method.

4. TCP connection termination:
For this a fin flag has been used in trasmitted data, header
struct tcp_header{
    uint32_t    seq_num;
    uint32_t    ack_num;
    uint16_t     ack;
    uint16_t     syn;
    uint16_t     fin;
    uint32_t    rcv_wnd_size;
};
First server sends a FIN along with the last data payload. Client responds this by sending an combine ack and fin with both flags set.
Server again responds with an acknowledgemet with an ack set and seqeunce no :0. This information, presence of seqeunce no 0 is used by
client to termination the processing. If the last ack from server is lost, then a time out has been implemented on client side which wiil
terminate the connection after 3 sec.

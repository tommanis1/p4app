/* -*- P4_16 -*- */
const bit<16> TYPE_MYTUNNEL = 0x1212;
const bit<16> TYPE_IPV4 = 0x800;
#include <core.p4>
#include <v1model.p4>

typedef bit<9>  egressSpec_t;
typedef bit<48> macAddr_t;
typedef bit<32> ip4Addr_t;

header ethernet_t {
    macAddr_t dstAddr;
    macAddr_t srcAddr;
    bit<16>   etherType;
}

header myTunnel_t {
    bit<16> proto_id;
    bit<16> dst_id;
}

header ipv4_t {
    bit<4>    version;
    bit<4>    ihl;
    bit<8>    diffserv;
    bit<16>   totalLen;
    bit<16>   identification;
    bit<3>    flags;
    bit<13>   fragOffset;
    bit<8>    ttl;
    bit<8>    protocol;
    bit<16>   hdrChecksum;
    ip4Addr_t srcAddr;
    ip4Addr_t dstAddr;
}

struct headers {
    ethernet_t   ethernet;
    myTunnel_t   myTunnel;
    ipv4_t       ipv4;
}
struct metadata {
    /* empty */
}


parser MyParser(packet_in packet,
                out headers hdr,
                inout metadata meta,
                inout standard_metadata_t standard_metadata) {
    
        bit <2> case = 0x0;  

    state start {
        packet.extract(hdr.ethernet);
        // transtition
        
        if (hdr.ethernet.etherType == TYPE_IPV4) {
            case = 0x1;
        } else {
        if (hdr.ethernet.etherType == TYPE_MYTUNNEL) {
            case = 0x2;
        } else {
            case = 0x3;
        }}

        transition select (case ) {
            1 : parse_hdr_ipv4;
            //2 : 
            3 : accept ;
            default : reject ;
        }

    }

    state parse_hdr_ipv4 {
        packet.extract(hdr.ipv4);
        transition accept;
        
    }

}

control MyDeparser(packet_out packet, in headers hdr) {
    apply {
        packet.emit(hdr);
    }
}
control MyEgress(inout headers hdr,
                 inout metadata meta,
                 inout standard_metadata_t standard_metadata) {
    apply {  }
}

control MyIngress(inout headers hdr,
                  inout metadata meta,
                  inout standard_metadata_t standard_metadata) {
                    apply {}
                  }
control MyVerifyChecksum(inout headers hdr, inout metadata meta) {
    apply {  }
}

control MyComputeChecksum(inout headers  hdr, inout metadata meta) {
     apply {

    }
}

V1Switch(
MyParser(),
MyVerifyChecksum(),
MyIngress(),
MyEgress(),
MyComputeChecksum(),
MyDeparser()
) main;
/* -*- P4_16 -*- */
#include <core.p4>
#include <v1model.p4>
const bit<8> A = 0x0;
const bit<8> B = 0x1;

header test {
    bit<8> value;
    }
struct headers {
        test t;
}
/* 
parser MyParser(packet_in packet,
                out headers hdr,
                inout metadata meta,
                inout standard_metadata_t standard_metadata) {
    bool a = true;
    bool b = false;
    state start {
        transition select () {
            a : state_a; 
            b : state_b;
        }
    }

    state state_a {
        hdr.ethernet = A;
        transition accept;
    }

    state state_b {
        hdr.ethernet = B;
        transition accept;
    }
}
 */
struct metadata {
    /* empty */
}

parser MyParser(packet_in packet,
                out headers hdr,
                inout metadata meta,
                inout standard_metadata_t standard_metadata) {
    bool a = true;
    bool b = false;
    state start {
        transition case_start_select_a;
    }

    state case_start_select_a {
        // meta.tmp = a;
        transition select (a) {
            true : state_a;
            default: case_start_select_b;
        }
    }


    state case_start_select_b {
//        tmp = b;
        transition select (b) {
            true : state_b;
            default: reject;
        }
    }

    state state_a {
        hdr.t.value = A;
        transition accept;
    }

    state state_b {
        hdr.t.value = B;
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
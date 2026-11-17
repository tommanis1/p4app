/* -*- P4_16 -*- */
#include <core.p4>
#include <v1model.p4>
const bit<8> A = 0x0;
const bit<8> B = 0x1;

const bit<16> zero = 0x0

header test {
    bit<8> value;
    }
struct headers {
        test t;
}

struct metadata {
    /* empty */
}



parser MyParser(packet_in packet,
                out headers hdr,
                inout metadata meta,
                inout standard_metadata_t standard_metadata) {
    bit<3> n = 0x5;
    bit<1> test = 0x1;

    bool terminated_in_dig = false;
    
    state start {
        if (n == 0) {
            test = 0;
        }
        if (n > 0) {
            test = 1;
        }
        transition select (test) {
            0 : c;
            1 : state_2;
        }

        
   }

   state c {
        packet.extract(hdr.t);
        transition accept;
   }

   state state_2 {
        bit<1> c = 0x1;
        if (terminated_in_dig) {c = 1;} else {c = 0;}
        if (c == 0) {

        }
        transition select (c) {
            0 : state_5;
            1 : state_3;
        }

   }

   state state_5 {
        // TBD
        // packet.lookahead
        // packet.extract
        terminated_in_dig = true

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
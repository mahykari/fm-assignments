#define TOKEN 1

// We use an array, namely turn, to show which process has the token.
// If turn[i] == 1, then process i has the token. Only process i can
// change the value of turn[i].

int turn[5] = {0};

// Each process will do one of these actions in each iteration:
// 1. Wait for a token; if the process gets one, it will change its
//    turn to 1.
// 2. Send a token to the next (or previous) process in the ring;
//    the process should atomically change its turn to 0, and also
//    send a token to a neighbor process in the ring.

proctype node(chan in_l, in_r, out_l, out_r) {
    do
    :: turn[_pid] == 1 -> atomic { turn[_pid] = 0; out_l!TOKEN }
    :: turn[_pid] == 1 -> atomic { turn[_pid] = 0; out_r!TOKEN }
    :: in_l?TOKEN -> turn[_pid] = 1
    :: in_r?TOKEN -> turn[_pid] = 1
    od
}

// Arrays next and prev contain channels.
// Process i will read from prev[(i + 1) % 4], next[(i - 1) % 4],
// and write to next[i] and prev[i].

// To initiate the ring, we send a token to process 1 
// via channel next[0].

init {
    chan next[4] = [1] of {int};
    chan prev[4] = [1] of {int};

    run node(next[3], prev[1], prev[0], next[0]);
    run node(next[0], prev[2], prev[1], next[1]);
    run node(next[1], prev[3], prev[2], next[2]);
    run node(next[2], prev[0], prev[3], next[3]);
    next[0]!TOKEN;
}

// Property p1 holds, as there is only one token in the ring.

ltl p1 {
    [] ((turn[1] + turn[2] + turn[3] + turn[4]) <= 1)
}

// Property p2 holds, as the token is always sent to a neighbor;
// so there is at least one process that has the token infinitely often.

ltl p2 {
    []<> turn[1] || []<> turn[2] || []<> turn[3] || []<> turn[4]
}

// This property fails, consider the case where processes 0, 1
// only send the token to each other; therefore, only 2 processes
// will get the token.

ltl p3 {
    []<> turn[1] && []<> turn[2] && []<> turn[3] && []<> turn[4]
}
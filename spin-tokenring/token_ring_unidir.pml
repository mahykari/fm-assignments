#define TOKEN 1

int turn[5] = {0};

proctype node(chan _in, out) {
    do
    :: turn[_pid] == 1 -> atomic { turn[_pid] = 0; out!TOKEN }
    :: _in?TOKEN -> turn[_pid] = 1
    od
}

// As our processes only send the token to the next process,
// we only need the array "next".

init {
    chan next[4] = [1] of {int};

    run node(next[3], next[0]);
    run node(next[0], next[1]);
    run node(next[1], next[2]);
    run node(next[2], next[3]);
    next[0]!TOKEN;
}

ltl p1 {
    [] ((turn[1] + turn[2] + turn[3] + turn[4]) <= 1)
}

ltl p2 {
    []<> turn[1] || []<> turn[2] || []<> turn[3] || []<> turn[4]
}

// Property p3 holds this time, as the token is always moving
// through the ring.

ltl p3 {
    []<> turn[1] && []<> turn[2] && []<> turn[3] && []<> turn[4]
}
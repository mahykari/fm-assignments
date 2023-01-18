module hollywood

sig Building {}

abstract sig Person {
    lives_in: one Building
}

sig Man extends Person {
    wife: lone Woman
}

sig Woman extends Person {
    husband: lone Man
}

sig Cinema in Building {
    screens: some Screen
}

sig Time {}

sig Screen {
    plays: set (Time -> Movie)
}{
    all t: Time |
        lone plays[t]
}

sig Actor in Man {}
sig Actress in Woman {}
sig Director in Person {}

sig Movie {
    cast: set (Actor + Actress),
    director: one Director,
    sequel: set Movie
}

pred not_married[p: Person] {
    p in Man =>
        p.wife = none
    else
        p.husband = none
}

pred no_resident[b: Building] {
    lives_in.b = none
}

pred non_roommate_couple[m: Man, w: Woman] {
    (m.wife = w) && (m.lives_in != w.lives_in)
}

fact "Partner of the partner of a married person is him/herself" {
    wife = ~husband
}

fact "Every screen belongs to exactly one cinema." {
    all s: Screen |
        one c: Cinema |
            screens.s = c
}

fact "In any cinema, a movie would not play on two screens at the same time." {
    all c: Cinema | all s1, s2: Screen |
        (s1 != s2 && (s1 + s2) in c.screens) => 
            no t: Time |
                s1.plays[t] = s2.plays[t]
}

fact "There is no movie without any actor or actress." {
    all m: Movie |
        m.cast != none
}

fact "No one can live in a cinema" {
    all c: Cinema |
        no_resident[c]
}

fact "haram fact" {
    all m: Man, w: Woman |
        m.wife = w => (
            (no w1: Woman | w != w1 && w1.lives_in = m.lives_in) &&
            (no m1: Man | m != m1 && m1.lives_in = w.lives_in)
        )
}

fact "The sequel relation between movies can not have a cycle" {
    all m: Movie |
        m not in m.^sequel
}

fact "One movie can not be the sequel of two movies." {
    all m: Movie |
        lone m.sequel
}

fun person_movies[p: Person]: set Movie {
    cast.p
}

fun non_acting_directors[]: set Person {
    Director - (Actor + Actress)
}

fun screen_times[c: Cinema, m: Movie]: set Screen -> Time {
    plays.m - screens[Cinema - c] -> Time
}

assert no_couple_in_a_movie {
    no m: Man, w: Woman |
        m.wife = w &&
        some mo: Movie |
            (m + w) in mo.cast
}

assert couple_men_live_together {
    no m1, m2: Man, w1, w2: Woman |
        m1 != m2 && w1 != w2 &&
        m1.wife = w1 && m2.wife = w2 &&
        m1.lives_in = m2.lives_in
}

assert max_2_buildings_with_min_3_people {
    no b1, b2, b3: Building |
        b1 != b2 && b1 != b3 && b2 != b3 &&
        #(lives_in.b1) >= 3 &&
        #(lives_in.b2) >= 3 &&
        #(lives_in.b3) >= 3
}

run not_married

run no_resident

run non_roommate_couple for 4

run person_movies

run non_acting_directors

run screen_times

check no_couple_in_a_movie

check couple_men_live_together

check max_2_buildings_with_min_3_people for 10

#shoresy.tcl for eggdrop by Ayukawa
#
# Replies with a random insult from Letterkenny
#
# 08-06-2022 v0.1 - Initial version
# 08-10-2022 v0.2 - Adds 3% chance of chirping on text, exempting ignoreNicks

namespace eval ::shoresy {
    set ignoreNicks [list X $botnick ChanServ SplitServ]

    set response {
    "Fight me, see what happens!  Three things:  I hit you, you hit the pavement, and I jerk off on your driver's side door handle!"
    "You're made of spare parts, aren't you, bud?"
    "I wish you weren't so fuckin' awkward, bud."
    "Your life's so fucking pathetic, I ran a charity 15k to raise awareness for it!"
    "Suck my Mr. Cocky, ya fucking loser."
    "Your mom molested me two Halloweens ago, shut the fuck up or I'm taking it to twitter."
    "I wouldn't say shit if my mouth was full of it."
    "Your life is so pathetic, I get a charity tax break just by hanging around you!"
    "Your mom just liked my Instagram post from two years ago in Puerto Vallarta. Tell her I'll put my swim trunks on for her any time she likes."
    "I see the muscle shirt came today. Muscles coming tomorrow? Did ya get a tracking number? Oh, I hope he got a tracking number. That package is going to be smaller than the one you're sportin' now."
    "Our dad says guys with big trucks have little dinks. And that makes sense, 'cuz you want a real big truck and got a real little dink."
    "Fuck, lemony snicket, what a series of unfortunate events you fuckin been through, you ugly fuck."
    "Go scoop my shirt off your mom's floor! She gives my nipples butterfly kisses."
    "Give yer balls a tug, titfucker!"
    "I made your mom so wet, Trudeau had to deploy a 24-hour national guard unit to stack sandbags around my bed."
    "Your mom tried to stick her finger in my bum, but I said I only let %altnick%'s do that!"
    "Your mom ugly cried because she left the lens cap on the camcorder last night!"
    "Tell your mom to top up the cell phone she bought me so I can FaceTime her late night."
    "Fight me, see what happens!  Three things:  I hit you, you hit the pavement, ambulance hits 60!"
    "I made your mom cum so hard that they made a Canadian heritage minute out of it and Don McKellar played my dick."
    "Your mom shot cum straight across the room and killed my Siamese fighting fish, threw off the pH levels in my aquarium!"
    "I made an oopsie, can you tell your mom to pick up %altnick%'s mom on the way over to my place? I double booked them by mistake, you fuckin' loser."
    "Tell your mom I drained the bank account she set up for me. Top it up so I can get some fucking KFC."
    "Your breath's so bad it gave me an existential crisis — it made me question my whole life."
    "I didn't say any of that shit, you dumb broads, but I did say your breath could stop a Mack truck, %usernick%. I'll tell that to anyone who will listen!"
    "Tell your mom to leave me alone, she's been laying on my waterbed since Labor Day!"
    "Shoulda heard your mom last night, she sounded like my great aunt when I pop in for a surprise visit, like, 'Oooh!'"
    }
}
proc ::shoresy::mappersistent {nick chan str} {
	return [string map [list %usernick% $nick %altnick% [::shoresy::getrandomnick $chan]] $str]
}
proc ::shoresy::getrandomnick {chan} {
	global botnick
	set members [chanlist $chan]

	foreach nick $shoresy::ignoreNicks {
    set idx [lsearch $members $nick]
		set members [lreplace $members $idx $idx]
  }
	set retval [lindex $members [expr {int(rand()*[llength $members])}]]
	return $retval
}

proc ::shoresy::respond {nick chan text} {
   set output [::shoresy::mappersistent $nick $chan [lindex $::shoresy::response [rand [llength $::shoresy::response]]]]  
   return "Fuck you, $nick! $output"
}

proc ::shoresy::chan {nick uhost handle chan args} {
  global response botnick
  
  foreach en $::shoresy::ignoreNicks {
    if {[string equal -nocase $en $nick]} {
      return 1
    }
  }
  putserv "PRIVMSG $chan :[::shoresy::respond $nick $chan $args]"
}

proc ::shoresy::random {nick uhost handle chan args} {
  if {rand()<0.03} { ::shoresy::chan $nick $uhost $handle $chan $args }
}

bind pubm - "% Fuck*you*Shoresy*" ::shoresy::chan
bind pubm - "*" ::shoresy::random

putlog "Loaded shoresy.tcl Script by Ayukawa"
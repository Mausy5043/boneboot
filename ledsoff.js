var b=require('bonescript');

b.pinMode('USR0', 'out');
b.pinMode('USR1', 'out');
b.pinMode('USR2', 'out');
b.pinMode('USR3', 'out');

b.digitalWrite('USR0', 0);
b.digitalWrite('USR1', 0);
b.digitalWrite('USR2', 0);
b.digitalWrite('USR3', 0);

process.stdout.write("USR LEDS switched off\n");

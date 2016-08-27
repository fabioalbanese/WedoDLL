# WedoDLL
An ActiveX DLL made in VB6.0 to control Lego Wedo motors and sensors

ENGLISH
Wedo DLL - By Fabio Albanese 2016

A simple ActiveX/DLL that allows you to control Lego Wedo motors and sensors in Windows applications.

It has been tested using Visual Basic 6.0 and VB.NET 2013

Usage:
Once you have instanced myWedo as new WedoDLL.WedoControls
to control motors (A and B) you need only to use the SetMotorA and SetMotorB methods:
myWedo.SetMotorA 100 (where 100 is the speed)
myWedo.SetMotorB 100 (where 100 is the speed)
Speed range is -100 to 100 where 0 is motor stop.

to read sensors value simply get the value from GetTilt and GetDistance functions (they return an integer value) 
myTilt=myWedo.GetTilt
myDistance=myWedo.GetDistance

The software is given "as it is" for fun, without any responsibility from author.

FOr comments and suggestion, please use the contact module in my website: http://www.fabioalbanese.it

Have fun!

Fabio

----
ITALIANO
Wedo DLL - Di Fabio Albanese 2016

Una semplice DLL ActiveX che permette di controllare i motori e i sensori di Lego Wedo in applicazioni Windows .

E' stato testata utilizzando Visual Basic 6.0 e VB.NET 2013

Uso:
Una volta che avete istanziato myWedo come nuova istanza di WedoDLL.WedoControls
per controllare motori (A e B ) è sufficiente utilizzare i metodi SetMotorA e SetMotorB :
myWedo.SetMotorA 100 (dove 100 è la velocità )
myWedo.SetMotorB 100 (dove 100 è la velocità )
La gamma di velocità è da -100 a 100 , dove 0 è l'arresto del motore .

per leggere il valore dei sensori è sufficiente recuperare il valore dalle funzioni GetTilt e GetDistance (restituiscono un valore intero)
myTilt = myWedo.GetTilt
myDistance = myWedo.GetDistance

Il software è fornito "così com'è" per giocarci, senza alcuna responsabilità dell' autore.

Per commenti e suggerimenti, utilizzare il modulo di contatto nel mio sito : http://www.fabioalbanese.it

Buon divertimento !

Fabio




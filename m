From: =?ISO-8859-1?Q?V=EDctor_Fern=E1ndez_Mart=EDnez?= 
	<vfernandez-JE8hqn47KVKB+jHODAdFcQ@public.gmane.org>
Subject: Getting notifications of the tasks file
Date: Tue, 31 Jul 2012 11:42:06 +0200
Message-ID: <5486539.IgfTNnpt1m@valencia>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8-sig"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

=EF=BB=BFI'm trying to use the eventfd notification API to get notified=
 when the tasks=20
file changes. This way I would like to know when child processes are sp=
awned=20
and when they exit. However, I always get EINVAL when writing to=20
cgroup.event_control. Even cgroup_event_listener.c returns that error:

# cat /sys/fs/cgroup/memory/grp0/tasks=20
3590
23902
# ./cgroup_event_listener /sys/fs/cgroup/memory/grp0/tasks 0
Cannot write to cgroup.event_control: Invalid argument

I have also tried to monitor cgroup.procs.

Is it possible to monitor the tasks file at all or is this a bug? If 0 =
is a=20
wrong argument, which argument should I use instead?


Thanks.


Barracuda Networks AG
Vorsitzender des Aufsichtsrates/ Chairman of the supervisory board: Dea=
n Drako
Vorstand/ Executive Board: Dr. Wieland Alge, Mag. Guenter Klausner
Sitz der Gesellschaft/ Registered office: 6020 Innsbruck, Austria
Handelsgericht Innsbruck Firmenbuch/ Registration Number: 184392s
UID-Nr/ VAT Number: ATU47509003

Diese Nachricht und allfaellige angehaengte Dokumente sind vertraulich =
und nur fuer den/die Adressaten bestimmt. Sollten Sie nicht der beabsic=
htigte Adressat sein, ist jede Offenlegung, Weiterleitung oder sonstige=
 Verwendung dieser Information nicht gestattet. In diesem Fall bitten w=
ir, den Absender zu verstaendigen und die Information zu vernichten. Fu=
er Uebermittlungsfehler oder sonstige Irrtuemer bei Uebermittlung beste=
ht keine Haftung.

This message and any attached files are confidential and intended solel=
y for the addressee(s). Any publication, transmission or other use of t=
he information by a person or entity other than the intended addressee =
is prohibited. If you receive this in error please contact the sender a=
nd delete the material. The sender does not accept liability for any er=
rors or omissions as a result of the transmission.


'Like' us on Facebook for exclusive content and other resources on all =
Barracuda Networks solutions.=0D
Visit http://barracudanetworks.com/facebook=0D
=0D

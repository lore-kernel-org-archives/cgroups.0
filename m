From: Aristeu Rozanski <aris-moeOTchvdi7YtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 0/4] device_cgroup: replace internally whitelist with exception list
Date: Tue, 24 Jul 2012 18:03:33 -0400
Message-ID: <20120724220333.966415895@muttley.lan.cathedral>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="utf-8"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

The original model of device_cgroup is having a whitelist where all the
allowed devices are listed. The problem with this approach is that is
impossible to have the case of allowing everything but few devices.

The reason for that lies in the way the whitelist is handled internally=
:
since there's only a whitelist, the "all devices" entry would have to b=
e
removed and replaced by the entire list of possible devices but the one=
s
that are being denied.  Since dev_t is 32 bits long, representing the a=
llowed
devices as a bitfield is not memory efficient.

This patch replaces the "whitelist" by a "exceptions" list and the defa=
ult
policy is kept as "deny_all" variable in dev_cgroup structure.

The current interface determines that whenever "a" is written to device=
s.allow
or devices.deny, the entry masking all devices will be added or removed=
,
respectively. This behavior is kept and it's what will determine the de=
fault
policy:

	# cat devices.list=20
	a *:* rwm
	# echo a >devices.deny
	# cat devices.list=20
	# echo a >devices.allow
	# cat devices.list=20
	a *:* rwm

The interface is also preserved. For example, if one wants to block onl=
y access
to /dev/null:
	# ls -l /dev/null
	crw-rw-rw- 1 root root 1, 3 Jul 24 16:17 /dev/null
	# echo a >devices.allow
	# echo "c 1:3 rwm" >devices.deny
	# cat /dev/null
	cat: /dev/null: Operation not permitted
	# echo >/dev/null
	bash: /dev/null: Operation not permitted
	mknod /tmp/null c 1 3
	mknod: =E2=80=98/tmp/null=E2=80=99: Operation not permitted
	# echo "c 1:3 r" >devices.allow
	# cat /dev/null
	# echo >/dev/null
	bash: /dev/null: Operation not permitted
	mknod /tmp/null c 1 3
	mknod: =E2=80=98/tmp/null=E2=80=99: Operation not permitted
	# echo "c 1:3 rw" >devices.allow
	# echo >/dev/null
	# cat /dev/null
	# mknod /tmp/null c 1 3
	mknod: =E2=80=98/tmp/null=E2=80=99: Operation not permitted
	# echo "c 1:3 rwm" >devices.allow
	# echo >/dev/null
	# cat /dev/null
	# mknod /tmp/null c 1 3
	#

 device_cgroup.c |  371 ++++++++++++++++++++++++++++++++---------------=
---------
 1 file changed, 212 insertions(+), 159 deletions(-)

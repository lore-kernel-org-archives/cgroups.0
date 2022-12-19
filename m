From: Nikolay Borisov <nikolay.borisov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH 0/2] Defer checking wildcard exceptions to parent
Date: Mon, 19 Dec 2022 13:40:50 +0200
Message-ID: <20221219114052.1582992-1-nikolay.borisov@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Nikolay Borisov <nikolay.borisov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

This patchset enables adding a wildcard exception to a child cgroup irrespective
whether the parent allows it or not. At first sight this might seem like
fundamentally breaking the devcgroup hierarchy invariant that child cgroups can't
be more permissive than their parent, however that's not the case. Instead,
when such a wildcard rule is evaluated upon permission check it's actually
checked in the parent cgroup. For example, assume we have the A/B as 2 parent/child
cgroups. A allows a set of devices, but not wildcard rules, and B wants to
access some of those devices of A but initializes A to have a set of well known
character devices and finally writes "b *:* rmw". Currently this would fail, with
this patch the write will succeed and B would have access to only those devices
that are allowed in A.

The situation I described is how systemd functions, in particular when setting up
a devcg for a service it would first disable all devices, then add a bunch of
well-known characters devices and finally evaluate the respective cgroup-related
directives in the service file, in particular that's how systemd is being run.

Without this series systemd-udevd service ends up in a cgroup whose devices.list
contains:

	c 1:3 rwm
	c 1:5 rwm
	c 1:7 rwm
	c 1:8 rwm
	c 1:9 rwm
	c 5:0 rwm
	c 5:2 rwm
	c 136:* rw

But its .service file also instructs it to add 'b *:* rwm' and 'c *:* rwm'. The
parent cg in turn contains:

	c 128:* rwm
	c 136:* rwm
	c 2:* rwm
	c 3:* rwm
	c 1:3 rwm
	c 1:5 rwm
	c 1:7 rwm
	c 5:0 rwm
	c 5:1 rwm
	c 5:2 rwm
	c 4:* rwm
	c 1:8 rwm
	c 1:9 rwm
	c 1:11 rwm
	c 10:200 rwm
	c 10:235 rwm
	c 10:229 rwm
	b 182:701984 rm
	b 182:701985 rm
	b 182:700656 rmM
	b 182:700657 rmM

In this case we'd want wildcard exceptions in the child to match any of the
exceptions in the parent.


Nikolay Borisov (2):
  devcg: Move match_exception_partial before match_exception PSBM-144033
  devcg: Allow wildcard exceptions in DENY child cgroups PSBM-144033

 security/device_cgroup.c | 106 +++++++++++++++++++++++++--------------
 1 file changed, 67 insertions(+), 39 deletions(-)

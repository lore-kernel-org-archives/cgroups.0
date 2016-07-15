From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [PATCH 0/3] cgroupns: Locking and semantic fixes
Date: Fri, 15 Jul 2016 06:34:37 -0500
Message-ID: <87y45316eq.fsf@x220.int.ebiederm.org>
References: <87h9br4h80.fsf@x220.int.ebiederm.org>
	<20160715111847.GC3078@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160715111847.GC3078-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org> (Tejun Heo's message of
	"Fri, 15 Jul 2016 07:18:47 -0400")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



While going through the cgroup namespace I found a couple of significant
bugs.  The first bug I fix could cause a kernel deadlock. The second
fixes a rare race that if it happens we get insane semantics.  The third
removes an allowance that could not possibly be used.

The patches have been respun against for-v4.7-fixes

Eric W. Biederman (3):
      cgroupns: Fix the locking in copy_cgroup_ns
      cgroupns: Close race between cgroup_post_fork and copy_cgroup_ns
      cgroupns: Only allow creation of hierarchies in the initial cgroup namespace

 kernel/cgroup.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

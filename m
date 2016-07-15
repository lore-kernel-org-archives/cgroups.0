From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [PATCH 0/3] cgroupns: Locking and semantic fixes
Date: Fri, 15 Jul 2016 00:14:08 -0500
Message-ID: <87bn1z4h5r.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


(Resending and including the cgroups mailing list this time oops)

While going through the cgroup namespace I found a couple of significant
bugs.  The first bug I fix could cause a kernel deadlock. The second
fixes a rare race that if it happens we get insane semantics.  The third
removes an allowance that could not possibly be used.

The patches are against v4.7-rc2 where I have been doing my testing
and does not include the recent spin_lock_bh(&css_set_lock) to
spin_lock_irq(&css_set_lock) change.  But that should be trivial to
resolve.

If you need me to respin things against your for-4.7-fixes branch I will
be happy to oblige.  Likewise if another strategy for fixing the cgroup
namespace locking issues is necessary just let me know.

Eric W. Biederman (3):
      cgroupns: Fix the locking in copy_cgroup_ns
      cgroupns: Close race between cgroup_post_fork and copy_cgroup_ns
      cgroupns: Only allow creation of hierarchies in the initial cgroup namespace

 kernel/cgroup.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

Thank you,
Eric Biederman

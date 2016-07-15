From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [PATCH 3/3] cgroupns: Only allow creation of hierarchies in the initial cgroup namespace
Date: Fri, 15 Jul 2016 06:36:44 -0500
Message-ID: <87h9br16b7.fsf@x220.int.ebiederm.org>
References: <87h9br4h80.fsf@x220.int.ebiederm.org>
	<87r3av32g1.fsf@x220.int.ebiederm.org>
	<20160715111659.GB3078@mtj.duckdns.org>
	<8760s72lu5.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8760s72lu5.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org> (Eric W. Biederman's
	message of "Fri, 15 Jul 2016 06:16:02 -0500")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


Unprivileged users can't use hierarchies if they create them as they do not
have privilieges to the root directory.

Which means the only thing a hiearchy created by an unprivileged user
is good for is expanding the number of cgroup links in every css_set,
which is a DOS attack.

We could allow hierarchies to be created in namespaces in the initial
user namespace.  Unfortunately there is only a single namespace for
the names of heirarchies, so that is likely to create more confusion
than not.

So do the simple thing and restrict hiearchy creation to the initial
cgroup namespace.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Fixes: a79a908fd2b0 ("cgroup: introduce cgroup namespaces")
Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 kernel/cgroup.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e75efa819911..e0be49fc382f 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2215,12 +2215,8 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		goto out_unlock;
 	}
 
-	/*
-	 * We know this subsystem has not yet been bound.  Users in a non-init
-	 * user namespace may only mount hierarchies with no bound subsystems,
-	 * i.e. 'none,name=user1'
-	 */
-	if (!opts.none && !capable(CAP_SYS_ADMIN)) {
+	/* Hierarchies may only be created in the initial cgroup namespace. */
+	if (ns != &init_cgroup_ns) {
 		ret = -EPERM;
 		goto out_unlock;
 	}
-- 
2.8.3

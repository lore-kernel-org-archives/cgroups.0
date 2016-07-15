From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [PATCH 1/3] cgroupns: Fix the locking in copy_cgroup_ns
Date: Fri, 15 Jul 2016 00:15:46 -0500
Message-ID: <8737nb4h31.fsf@x220.int.ebiederm.org>
References: <87h9br4h80.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87h9br4h80.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org> (Eric W. Biederman's
	message of "Fri, 15 Jul 2016 00:12:47 -0500")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


If "clone(CLONE_NEWCGROUP...)" is called it results in a nice lockdep
valid splat.

In __cgroup_proc_write the lock ordering is:
     cgroup_mutex -- through cgroup_kn_lock_live
     cgroup_threadgroup_rwsem

In copy_process the guts of clone the lock ordering is:
     cgroup_threadgroup_rwsem -- through threadgroup_change_begin
     cgroup_mutex -- through copy_namespaces -- copy_cgroup_ns

lockdep reports some a different call chains for the first ordering of
cgroup_mutex and cgroup_threadgroup_rwsem but it is harder to trace.
This is most definitely deadlock potential under the right
circumstances.

Fix this by by skipping the cgroup_mutex and making the locking in
copy_cgroup_ns mirror the locking in cgroup_post_fork which also runs
during fork under the cgroup_threadgroup_rwsem.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Fixes: a79a908fd2b0 ("cgroup: introduce cgroup namespaces")
Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 kernel/cgroup.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 86cb5c6e8932..66d2441f6db2 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -6305,14 +6305,11 @@ struct cgroup_namespace *copy_cgroup_ns(unsigned long flags,
 	if (!ns_capable(user_ns, CAP_SYS_ADMIN))
 		return ERR_PTR(-EPERM);
 
-	mutex_lock(&cgroup_mutex);
+	/* It is not safe to take cgroup_mutex here */
 	spin_lock_bh(&css_set_lock);
-
 	cset = task_css_set(current);
 	get_css_set(cset);
-
 	spin_unlock_bh(&css_set_lock);
-	mutex_unlock(&cgroup_mutex);
 
 	new_ns = alloc_cgroup_ns();
 	if (IS_ERR(new_ns)) {
-- 
2.8.3

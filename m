From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/2] cgroup, cpuset: replace cpuset_post_attach_flush() with
 cgroup_subsys->post_attach callback
Date: Thu, 21 Apr 2016 19:06:48 -0400
Message-ID: <20160421230648.GI4775@htj.duckdns.org>
References: <20160413094216.GC5774@pathway.suse.cz>
 <20160413183309.GG3676@htj.duckdns.org>
 <20160413192313.GA30260@dhcp22.suse.cz>
 <20160414175055.GA6794@cmpxchg.org>
 <20160415191719.GK12583@htj.duckdns.org>
 <20160417120747.GC21757@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=94p6Q6z76R2V2et6xPeZuwX1veWEyPWivtlnEjCcqeQ=;
        b=xqxSNjSI6nZHar2HBUFJvbBf4tShRyROD2aGAp3bdjatFwZsHJNEsa23W8vNhzvVMj
         Lb1ZmD4KYpsYxXOCwdbzbmVEhOpT6gEQ5Z7e0C+2D6qsPWQI2U+suSXg4F0jWX6v8MND
         n1gySWOO7PNJxcgEYMZSBfTBJwr0zRdibnaFldZfwJHrcayxCyXxyt0FiWRrskGiZIjF
         5GE9AFbOMApIdW9/8vSVuYVC8el6uQ+69Xt3DuRUOzvnhC6b0MuzHCYIHXH6MPkvauxg
         7M6EB3GksArMU4tmWHUI8UQTGW+Q3k7mTRghg2irXUF00mq0+duqxNZpDTneUrX5cYHB
         qIaA==
Content-Disposition: inline
In-Reply-To: <20160417120747.GC21757-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Since e93ad19d0564 ("cpuset: make mm migration asynchronous"), cpuset
kicks off asynchronous NUMA node migration if necessary during task
migration and flushes it from cpuset_post_attach_flush() which is
called at the end of __cgroup_procs_write().  This is to avoid
performing migration with cgroup_threadgroup_rwsem write-locked which
can lead to deadlock through dependency on kworker creation.

memcg has a similar issue with charge moving, so let's convert it to
an official callback rather than the current one-off cpuset specific
function.  This patch adds cgroup_subsys->post_attach callback and
makes cpuset register cpuset_post_attach_flush() as its ->post_attach.

The conversion is mostly one-to-one except that the new callback is
called under cgroup_mutex.  This is to guarantee that no other
migration operations are started before ->post_attach callbacks are
finished.  cgroup_mutex is one of the outermost mutex in the system
and has never been and shouldn't be a problem.  We can add specialized
synchronization around __cgroup_procs_write() but I don't think
there's any noticeable benefit.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 4.4+ prerequisite for the next patch
---
 include/linux/cgroup-defs.h |    1 +
 include/linux/cpuset.h      |    6 ------
 kernel/cgroup.c             |    7 +++++--
 kernel/cpuset.c             |    4 ++--
 4 files changed, 8 insertions(+), 10 deletions(-)

--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -444,6 +444,7 @@ struct cgroup_subsys {
 	int (*can_attach)(struct cgroup_taskset *tset);
 	void (*cancel_attach)(struct cgroup_taskset *tset);
 	void (*attach)(struct cgroup_taskset *tset);
+	void (*post_attach)(void);
 	int (*can_fork)(struct task_struct *task);
 	void (*cancel_fork)(struct task_struct *task);
 	void (*fork)(struct task_struct *task);
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -137,8 +137,6 @@ static inline void set_mems_allowed(node
 	task_unlock(current);
 }
 
-extern void cpuset_post_attach_flush(void);
-
 #else /* !CONFIG_CPUSETS */
 
 static inline bool cpusets_enabled(void) { return false; }
@@ -245,10 +243,6 @@ static inline bool read_mems_allowed_ret
 	return false;
 }
 
-static inline void cpuset_post_attach_flush(void)
-{
-}
-
 #endif /* !CONFIG_CPUSETS */
 
 #endif /* _LINUX_CPUSET_H */
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2825,9 +2825,10 @@ static ssize_t __cgroup_procs_write(stru
 				    size_t nbytes, loff_t off, bool threadgroup)
 {
 	struct task_struct *tsk;
+	struct cgroup_subsys *ss;
 	struct cgroup *cgrp;
 	pid_t pid;
-	int ret;
+	int ssid, ret;
 
 	if (kstrtoint(strstrip(buf), 0, &pid) || pid < 0)
 		return -EINVAL;
@@ -2875,8 +2876,10 @@ out_unlock_rcu:
 	rcu_read_unlock();
 out_unlock_threadgroup:
 	percpu_up_write(&cgroup_threadgroup_rwsem);
+	for_each_subsys(ss, ssid)
+		if (ss->post_attach)
+			ss->post_attach();
 	cgroup_kn_unlock(of->kn);
-	cpuset_post_attach_flush();
 	return ret ?: nbytes;
 }
 
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -58,7 +58,6 @@
 #include <asm/uaccess.h>
 #include <linux/atomic.h>
 #include <linux/mutex.h>
-#include <linux/workqueue.h>
 #include <linux/cgroup.h>
 #include <linux/wait.h>
 
@@ -1016,7 +1015,7 @@ static void cpuset_migrate_mm(struct mm_
 	}
 }
 
-void cpuset_post_attach_flush(void)
+static void cpuset_post_attach(void)
 {
 	flush_workqueue(cpuset_migrate_mm_wq);
 }
@@ -2087,6 +2086,7 @@ struct cgroup_subsys cpuset_cgrp_subsys
 	.can_attach	= cpuset_can_attach,
 	.cancel_attach	= cpuset_cancel_attach,
 	.attach		= cpuset_attach,
+	.post_attach	= cpuset_post_attach,
 	.bind		= cpuset_bind,
 	.legacy_cftypes	= files,
 	.early_init	= true,

From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 7/8] memcg: Enable logging of memory control mitigation action
Date: Mon, 17 Aug 2020 10:08:30 -0400
Message-ID: <20200817140831.30260-8-longman@redhat.com>
References: <20200817140831.30260-1-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597673413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=YtkHP8yUHAR+QqSRHcyYDisXPjLvOXyhm/pXyropj8M=;
        b=MROEtBTIdIf27CWSx8g5+kjA6m1hfBz+Cd9LZzKzOlyoMWtx+OTaKDhRcX6vCc50jIk0n8
        qzOGmy2fk6DCkW7Q72oVGcJ5BP59KLknaJFpSX8gaD5nfpaKUasf7bHn/APwVd1OdzHvxf
        SvWVbdDIZ9QkJUgTeqLvBOFgAehM2YU=
In-Reply-To: <20200817140831.30260-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Some of the migitation actions of PR_SET_MEMCONTROL give no visible
signal that some actions are being done inside the kernel. To make it
more visble, a new PR_MEMFLAG_LOG flag is added to enable the logging
of the migitation action done in the kernel ring buffer.

The logging is done once when the mitigation action starts through the
setting of an internal PR_MEMFLAG_LOGGED flag. This flag will be cleared
when it is detected that the memory limit no longer exceeds memory.high.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/uapi/linux/prctl.h |  1 +
 mm/memcontrol.c            | 34 +++++++++++++++++++++++++++++++++-
 2 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 7ba40e10737d..faa7a51fc52a 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -266,6 +266,7 @@ struct prctl_mm_map {
 /* Flags for PR_SET_MEMCONTROL */
 # define PR_MEMFLAG_SIGCONT		(1UL <<  0) /* Continuous signal delivery */
 # define PR_MEMFLAG_DIRECT		(1UL <<  1) /* Direct memory limit */
+# define PR_MEMFLAG_LOG			(1UL <<  2) /* Log action done */
 # define PR_MEMFLAG_RSS_ANON		(1UL <<  8) /* Check anonymous pages */
 # define PR_MEMFLAG_RSS_FILE		(1UL <<  9) /* Check file pages */
 # define PR_MEMFLAG_RSS_SHMEM		(1UL << 10) /* Check shmem pages */
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bddf3e659469..5bda2dd755fc 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2640,6 +2640,7 @@ get_rss_counter(struct mm_struct *mm, int mm_bit, u16 flags, int rss_bit)
  * Return true if an action has been taken or further check is not needed,
  * false otherwise.
  */
+#define PR_MEMFLAG_LOGGED	(1UL << 7)	/* A log message printed */
 static bool __mem_cgroup_over_high_action(struct mem_cgroup *memcg, u8 action,
 					  u16 flags)
 {
@@ -2714,6 +2715,32 @@ static bool __mem_cgroup_over_high_action(struct mem_cgroup *memcg, u8 action,
 		break;
 	}
 
+	if ((flags & (PR_MEMFLAG_LOG|PR_MEMFLAG_LOGGED)) == PR_MEMFLAG_LOG) {
+		char name[80];
+		static const char * const acts[] = {
+			[PR_MEMACT_ENOMEM]   = "Action: return ENOMEM on some syscalls",
+			[PR_MEMACT_SLOWDOWN] = "Action: slow down process",
+			[PR_MEMACT_SIGNAL]   = "Action: send signal",
+			[PR_MEMACT_KILL]     = "Action: kill the process",
+		};
+
+		name[0] = '\0';
+		if (memcg)
+			cgroup_name(memcg->css.cgroup, name, sizeof(name));
+		else
+			strcpy(name, "N/A");
+
+		/*
+		 * Use printk_deferred() to minimize delay in the memory
+		 * allocation path.
+		 */
+		printk_deferred(KERN_INFO
+			"Cgroup: %s, Comm: %s, Pid: %d, Mem: %ld pages, %s\n",
+			name, current->comm, current->pid, mem, acts[action]);
+		WRITE_ONCE(current->memcg_over_high_flags,
+			   flags | PR_MEMFLAG_LOGGED);
+	}
+
 out:
 	mmput(mm);
 	/*
@@ -2740,8 +2767,13 @@ static inline bool mem_cgroup_over_high_action(struct mem_cgroup *memcg,
 
 	if (flags & PR_MEMFLAG_DIRECT)
 		memcg = NULL;	/* Direct per-task memory limit checking */
-	else if (!mem_high)
+	else if (!mem_high) {
+		/* Clear the PR_MEMFLAG_LOGGED flag, if set */
+		if (flags & PR_MEMFLAG_LOGGED)
+			WRITE_ONCE(current->memcg_over_high_flags,
+				   flags & ~PR_MEMFLAG_LOGGED);
 		return false;
+	}
 
 	return __mem_cgroup_over_high_action(memcg, action, flags);
 }
-- 
2.18.1


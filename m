From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v12 01/10] cgroup/cpuset: Enable update_tasks_cpumask() on top_cpuset
Date: Thu,  1 Sep 2022 16:57:36 -0400
Message-ID: <20220901205745.323326-2-longman@redhat.com>
References: <20220901205745.323326-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662065900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gMnIc1DxJTwqCxueqMFDO4d5MiXT6iHBs4E8HuDXzH8=;
        b=HnVQKfCAkWspSezOQ/H8cJPCVZGLkKx0DHevo7Nj/aWPiUxKU84WhLMNcz4CSBbL+UUByw
        s+UqU8Kq1wpkKuOkPXeMR7rRBI+mouNw5qdp4WwD9mBUja/HNAgnpwyUbT9b1bT1p6XEem
        jcArAAJ6F02AcffaLjXjmm88Ufv5zJo=
In-Reply-To: <20220901205745.323326-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Previously, update_tasks_cpumask() is not supposed to be called with
top cpuset. With cpuset partition that takes CPUs away from the top
cpuset, adjusting the cpus_mask of the tasks in the top cpuset is
necessary. Percpu kthreads, however, are ignored.

Fixes: ee8dde0cd2ce ("cpuset: Add new v2 cpuset.sched.partition flag")
Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 1f3a55297f39..50bf837571ac 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -33,6 +33,7 @@
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/kmod.h>
+#include <linux/kthread.h>
 #include <linux/list.h>
 #include <linux/mempolicy.h>
 #include <linux/mm.h>
@@ -1127,10 +1128,18 @@ static void update_tasks_cpumask(struct cpuset *cs)
 {
 	struct css_task_iter it;
 	struct task_struct *task;
+	bool top_cs = cs == &top_cpuset;
 
 	css_task_iter_start(&cs->css, 0, &it);
-	while ((task = css_task_iter_next(&it)))
+	while ((task = css_task_iter_next(&it))) {
+		/*
+		 * Percpu kthreads in top_cpuset are ignored
+		 */
+		if (top_cs && (task->flags & PF_KTHREAD) &&
+		    kthread_is_per_cpu(task))
+			continue;
 		set_cpus_allowed_ptr(task, cs->effective_cpus);
+	}
 	css_task_iter_end(&it);
 }
 
@@ -2092,12 +2101,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 		update_flag(CS_CPU_EXCLUSIVE, cs, 0);
 	}
 
-	/*
-	 * Update cpumask of parent's tasks except when it is the top
-	 * cpuset as some system daemons cannot be mapped to other CPUs.
-	 */
-	if (parent != &top_cpuset)
-		update_tasks_cpumask(parent);
+	update_tasks_cpumask(parent);
 
 	if (parent->child_ecpus_count)
 		update_sibling_cpumasks(parent, cs, &tmpmask);
-- 
2.31.1


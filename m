From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v11 1/8] cgroup/cpuset: Add top_cpuset check in update_tasks_cpumask()
Date: Tue, 10 May 2022 11:34:06 -0400
Message-ID: <20220510153413.400020-2-longman@redhat.com>
References: <20220510153413.400020-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652196880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LdXD9yJFaOeo2pHNThXvtRNDE3czSMc0peQhxLvTF7o=;
        b=S08Dvaq4QDPshlC4fq7y90+C9zjaZMUD85VWMi2bIQ6izCcnCrIVmPZzJPTx/yUojUR7mP
        fEyBBPYLpm228i9cxC98ojS26bEV49p2uw6tiY/2jICfrsrmW1EcmdqESTX+0clu2MS1eC
        xBMDt8TU7+pFrzCghjaV3MakCJzNW24=
In-Reply-To: <20220510153413.400020-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Right now, update_tasks_cpumask() is not supposed to be called with top
cpuset.  With cpuset partition that takes CPUs away from the top cpuset,
we may want to consider adjusting the cpu_allows mask of the tasks in
the top cpuset as well. However, we need more investigation to figure
out a way to do that without breaking non-cgroup aware applications in
the top cpuset. So move the top_cpuset check into update_tasks_cpumask()
and add a comment about possible future work.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 9390bfd9f1cd..d90f33b068a3 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1128,6 +1128,14 @@ static void update_tasks_cpumask(struct cpuset *cs)
 	struct css_task_iter it;
 	struct task_struct *task;
 
+	/*
+	 * TODO: With cpuset partition that takes CPUs away from the top
+	 * cpuset, we may want to properly adjust the cpus_allowed mask of
+	 * tasks in the top cpuset as well.
+	 */
+	if (cs == &top_cpuset)
+		return;
+
 	css_task_iter_start(&cs->css, 0, &it);
 	while ((task = css_task_iter_next(&it)))
 		set_cpus_allowed_ptr(task, cs->effective_cpus);
@@ -2092,12 +2100,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
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
2.27.0


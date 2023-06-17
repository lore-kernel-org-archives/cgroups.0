From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup/cpuset: remove unneeded nodes_or() in cpuset_change_task_nodemask()
Date: Sat, 17 Jun 2023 16:30:43 +0800
Message-ID: <20230617083043.2065556-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

The tsk->mems_allowed is changed before calling mpol_rebind_task() and
being reassigned right after it. But tsk->mems_allowed is not needed
inside mpol_rebind_task(). So remove unneeded tsk->mems_allowed modify
via nodes_or() here.

Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 58e6f18f01c1..33a429c1179f 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1941,7 +1941,6 @@ static void cpuset_change_task_nodemask(struct task_struct *tsk,
 	local_irq_disable();
 	write_seqcount_begin(&tsk->mems_allowed_seq);
 
-	nodes_or(tsk->mems_allowed, tsk->mems_allowed, *newmems);
 	mpol_rebind_task(tsk, newmems);
 	tsk->mems_allowed = *newmems;
 
-- 
2.27.0


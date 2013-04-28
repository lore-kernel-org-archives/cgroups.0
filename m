From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cpuset: fix compile warning when CONFIG_SMP=n
Date: Sun, 28 Apr 2013 09:46:57 +0800
Message-ID: <517C7F91.2030705@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zhong <zhong-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Reported by Fengguang's kbuild test robot:

kernel/cpuset.c:787: warning: 'generate_sched_domains' defined but not used

Introduced by commit e0e80a02e5701c8790bd348ab59edb154fbda60b
("cpuset: use rebuild_sched_domains() in cpuset_hotplug_workfn()),
which removed generate_sched_domains() from cpuset_hotplug_workfn().

Reported-by: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cpuset.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index ef05901..2422c5b 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -789,13 +789,6 @@ out:
 static void rebuild_sched_domains_locked(void)
 {
 }
-
-static int generate_sched_domains(cpumask_var_t **domains,
-			struct sched_domain_attr **attributes)
-{
-	*domains = NULL;
-	return 1;
-}
 #endif /* CONFIG_SMP */
 
 void rebuild_sched_domains(void)
-- 
1.8.0.2

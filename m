From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 01/10] cpuset: remove redundant check in cpuset_cpus_allowed_fallback()
Date: Fri, 19 Apr 2013 20:25:33 +0800
Message-ID: <517137BD.4060203@huawei.com>
References: <517137A7.4020605@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <517137A7.4020605-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

task_cs() will never return NULL.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cpuset.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 866d78e..4a62dcc 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2259,8 +2259,7 @@ void cpuset_cpus_allowed_fallback(struct task_struct *tsk)
 
 	rcu_read_lock();
 	cs = task_cs(tsk);
-	if (cs)
-		do_set_cpus_allowed(tsk, cs->cpus_allowed);
+	do_set_cpus_allowed(tsk, cs->cpus_allowed);
 	rcu_read_unlock();
 
 	/*
-- 
1.8.0.2

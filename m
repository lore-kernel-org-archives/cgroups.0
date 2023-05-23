From: Xiu Jianfeng <xiujianfeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH -next] cgroup: Remove out-of-date comment in cgroup_migrate()
Date: Tue, 23 May 2023 19:14:56 +0800
Message-ID: <20230523111456.146053-1-xiujianfeng@huaweicloud.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xiujianfeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org

From: Xiu Jianfeng <xiujianfeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Commit 674b745e22b3 ("cgroup: remove rcu_read_lock()/rcu_read_unlock()
in critical section of spin_lock_irq()") has removed the rcu_read_lock,
which makes the comment out-of-date, so remove it.

Signed-off-by: Xiu Jianfeng <xiujianfeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index d8ba2c67910d..415d51c713ad 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2871,11 +2871,6 @@ int cgroup_migrate(struct task_struct *leader, bool threadgroup,
 {
 	struct task_struct *task;
 
-	/*
-	 * Prevent freeing of tasks while we take a snapshot. Tasks that are
-	 * already PF_EXITING could be freed from underneath us unless we
-	 * take an rcu_read_lock.
-	 */
 	spin_lock_irq(&css_set_lock);
 	task = leader;
 	do {
-- 
2.17.1


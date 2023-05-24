From: Xiu Jianfeng <xiujianfeng@huaweicloud.com>
Subject: [PATCH -next v2] cgroup: Update out-of-date comment in cgroup_migrate()
Date: Wed, 24 May 2023 14:54:31 +0800
Message-ID: <20230524065431.145434-1-xiujianfeng@huaweicloud.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Commit 674b745e22b3 ("cgroup: remove rcu_read_lock()/rcu_read_unlock()
in critical section of spin_lock_irq()") has removed the rcu_read_lock,
which makes the comment out-of-date, so update it.

Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
---
v2: don't remove the comment, just update it.
---
 kernel/cgroup/cgroup.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index d8ba2c67910d..f10cef511ffa 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2872,9 +2872,11 @@ int cgroup_migrate(struct task_struct *leader, bool threadgroup,
 	struct task_struct *task;
 
 	/*
-	 * Prevent freeing of tasks while we take a snapshot. Tasks that are
-	 * already PF_EXITING could be freed from underneath us unless we
-	 * take an rcu_read_lock.
+	 * We should take an rcu_read_lock to prevent freeing of tasks while
+	 * taking a snapshot, because tasks that are already PF_EXITING could
+	 * be freed when traversing all threads of leader. However rcu_read_lock
+	 * which disable preempt is implied by the spin_lock_irq, so no explicit
+	 * rcu call here.
 	 */
 	spin_lock_irq(&css_set_lock);
 	task = leader;
-- 
2.17.1


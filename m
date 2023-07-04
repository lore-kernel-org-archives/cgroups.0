From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup/cpuset: avoid unneeded cpuset_mutex re-lock
Date: Tue, 4 Jul 2023 20:03:52 +0800
Message-ID: <20230704120352.1226787-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

cpuset_mutex unlock and lock pair is only needed when transferring tasks
out of empty cpuset. Avoid unneeded cpuset_mutex re-lock when !is_empty
to save cpu cycles.

Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 601c40da8e03..e136269c152c 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3521,17 +3521,16 @@ hotplug_update_tasks_legacy(struct cpuset *cs,
 	is_empty = cpumask_empty(cs->cpus_allowed) ||
 		   nodes_empty(cs->mems_allowed);
 
-	mutex_unlock(&cpuset_mutex);
-
 	/*
 	 * Move tasks to the nearest ancestor with execution resources,
 	 * This is full cgroup operation which will also call back into
 	 * cpuset. Should be done outside any lock.
 	 */
-	if (is_empty)
+	if (is_empty) {
+		mutex_unlock(&cpuset_mutex);
 		remove_tasks_in_empty_cpuset(cs);
-
-	mutex_lock(&cpuset_mutex);
+		mutex_lock(&cpuset_mutex);
+	}
 }
 
 static void
-- 
2.33.0


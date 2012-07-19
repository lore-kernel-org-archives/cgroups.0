From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH] cgroup: Don't drop the cgroup_mutex in cgroup_rmdir
Date: Thu, 19 Jul 2012 19:39:32 +0530
Message-ID: <1342706972-10912-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <87ipdjc15j.fsf@skywalker.in.ibm.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87ipdjc15j.fsf-6yE53ggjAfyqSkle7U1LjlaTQe2KTcn/@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, liwanp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

We dropped cgroup mutex, because of a deadlock between memcg and cpuset.
cpuset took hotplug lock followed by cgroup_mutex, where as memcg pre_destroy
did lru_add_drain_all() which took hotplug lock while already holding
cgroup_mutex. The deadlock is explained in 3fa59dfbc3b223f02c26593be69ce6fc9a940405
But dropping cgroup_mutex in cgroup_rmdir also means tasks could get
added to cgroup while we are in pre_destroy. This makes error handling in
pre_destroy complex. So move the unlock/lock to memcg pre_destroy callback.
Core cgroup will now call pre_destroy with cgroup_mutex held.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 kernel/cgroup.c |    3 +--
 mm/memcontrol.c |   11 ++++++++++-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 7981850..01c67f4 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4151,7 +4151,6 @@ again:
 		mutex_unlock(&cgroup_mutex);
 		return -EBUSY;
 	}
-	mutex_unlock(&cgroup_mutex);
 
 	/*
 	 * In general, subsystem has no css->refcnt after pre_destroy(). But
@@ -4171,10 +4170,10 @@ again:
 	ret = cgroup_call_pre_destroy(cgrp);
 	if (ret) {
 		clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
+		mutex_unlock(&cgroup_mutex);
 		return ret;
 	}
 
-	mutex_lock(&cgroup_mutex);
 	parent = cgrp->parent;
 	if (atomic_read(&cgrp->count) || !list_empty(&cgrp->children)) {
 		clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e8ddc00..9bd56ee 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4993,9 +4993,18 @@ free_out:
 
 static int mem_cgroup_pre_destroy(struct cgroup *cont)
 {
+	int ret;
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
 
-	return mem_cgroup_force_empty(memcg, false);
+	cgroup_unlock();
+	/*
+	 * we call lru_add_drain_all, which end up taking
+	 * mutex_lock(&cpu_hotplug.lock), But cpuset have
+	 * the reverse order. So drop the cgroup lock
+	 */
+	ret = mem_cgroup_force_empty(memcg, false);
+	cgroup_lock();
+	return ret;
 }
 
 static void mem_cgroup_destroy(struct cgroup *cont)
-- 
1.7.10

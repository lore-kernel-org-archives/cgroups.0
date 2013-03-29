From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH v2 5/5] cgroup: Kill subsys.active flag
Date: Fri, 29 Mar 2013 14:44:42 +0800
Message-ID: <5155385A.4040207@huawei.com>
References: <51553813.10004@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <51553813.10004@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ingo Molnar <mingo@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

The only user was cpuacct.

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/cgroup.h | 1 -
 kernel/cgroup.c        | 3 ---
 2 files changed, 4 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 900af59..95c02c0 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -458,7 +458,6 @@ struct cgroup_subsys {
 	void (*bind)(struct cgroup *root);
 
 	int subsys_id;
-	int active;
 	int disabled;
 	int early_init;
 	/*
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a32f943..5c46281 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4468,7 +4468,6 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss)
 	 * need to invoke fork callbacks here. */
 	BUG_ON(!list_empty(&init_task.tasks));
 
-	ss->active = 1;
 	BUG_ON(online_css(ss, dummytop));
 
 	mutex_unlock(&cgroup_mutex);
@@ -4573,7 +4572,6 @@ int __init_or_module cgroup_load_subsys(struct cgroup_subsys *ss)
 	}
 	write_unlock(&css_set_lock);
 
-	ss->active = 1;
 	ret = online_css(ss, dummytop);
 	if (ret)
 		goto err_unload;
@@ -4614,7 +4612,6 @@ void cgroup_unload_subsys(struct cgroup_subsys *ss)
 	mutex_lock(&cgroup_mutex);
 
 	offline_css(ss, dummytop);
-	ss->active = 0;
 
 	if (ss->use_id)
 		idr_destroy(&ss->idr);
-- 
1.8.0.2

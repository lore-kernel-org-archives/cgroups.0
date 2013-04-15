From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH] cgroup: remove cgrp->top_cgroup
Date: Mon, 15 Apr 2013 14:25:05 +0800
Message-ID: <516B9D41.8080508@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

It's not used, and it can be retrieved via cgrp->root->top_cgroup.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/cgroup.h | 1 -
 kernel/cgroup.c        | 2 --
 2 files changed, 3 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 9c300ad..64047ae 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -204,7 +204,6 @@ struct cgroup {
 	struct cgroup_subsys_state *subsys[CGROUP_SUBSYS_COUNT];
 
 	struct cgroupfs_root *root;
-	struct cgroup *top_cgroup;
 
 	/*
 	 * List of cg_cgroup_links pointing at css_sets with
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 6780459..c16719e 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1418,7 +1418,6 @@ static void init_cgroup_root(struct cgroupfs_root *root)
 	root->number_of_cgroups = 1;
 	cgrp->root = root;
 	cgrp->name = &root_cgroup_name;
-	cgrp->top_cgroup = cgrp;
 	init_cgroup_housekeeping(cgrp);
 	list_add_tail(&cgrp->allcg_node, &root->allcg_list);
 }
@@ -4145,7 +4144,6 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 
 	cgrp->parent = parent;
 	cgrp->root = parent->root;
-	cgrp->top_cgroup = parent->top_cgroup;
 
 	if (notify_on_release(parent))
 		set_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
-- 
1.8.0.2

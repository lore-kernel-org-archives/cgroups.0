From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH] cgroup: fix bogus kernel warnings when cgroup_create() failed
Date: Mon, 21 Jan 2013 18:18:33 +0800
Message-ID: <50FD15F9.1090701@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

If cgroup_create() failed and cgroup_destroy_locked() is called to
do cleanup, we'll see a bunch of warnings:

cgroup_addrm_files: failed to remove 2MB.limit_in_bytes, err=-2
cgroup_addrm_files: failed to remove 2MB.usage_in_bytes, err=-2
cgroup_addrm_files: failed to remove 2MB.max_usage_in_bytes, err=-2
cgroup_addrm_files: failed to remove 2MB.failcnt, err=-2
cgroup_addrm_files: failed to remove prioidx, err=-2
cgroup_addrm_files: failed to remove ifpriomap, err=-2
...

We failed to remove those files, because cgroup_create() has failed
before creating those cgroup files.

To fix this, we simply don't warn if cgroup_rm_file() can't find the
cft entry.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 77ab520..1db2438 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -928,13 +928,17 @@ static void remove_dir(struct dentry *d)
 	dput(parent);
 }
 
-static int cgroup_rm_file(struct cgroup *cgrp, const struct cftype *cft)
+static void cgroup_rm_file(struct cgroup *cgrp, const struct cftype *cft)
 {
 	struct cfent *cfe;
 
 	lockdep_assert_held(&cgrp->dentry->d_inode->i_mutex);
 	lockdep_assert_held(&cgroup_mutex);
 
+	/*
+	 * If we're doing cleanup due to failure of cgroup_create(),
+	 * the corresponding @cfe may not exist.
+	 */
 	list_for_each_entry(cfe, &cgrp->files, node) {
 		struct dentry *d = cfe->dentry;
 
@@ -947,9 +951,8 @@ static int cgroup_rm_file(struct cgroup *cgrp, const struct cftype *cft)
 		list_del_init(&cfe->node);
 		dput(d);
 
-		return 0;
+		break;
 	}
-	return -ENOENT;
 }
 
 /**
@@ -2765,14 +2768,14 @@ static int cgroup_addrm_files(struct cgroup *cgrp, struct cgroup_subsys *subsys,
 		if ((cft->flags & CFTYPE_ONLY_ON_ROOT) && cgrp->parent)
 			continue;
 
-		if (is_add)
+		if (is_add) {
 			err = cgroup_add_file(cgrp, subsys, cft);
-		else
-			err = cgroup_rm_file(cgrp, cft);
-		if (err) {
-			pr_warning("cgroup_addrm_files: failed to %s %s, err=%d\n",
-				   is_add ? "add" : "remove", cft->name, err);
+			if (err)
+				pr_warn("cgroup_addrm_files: failed to add %s, err=%d\n",
+					cft->name, err);
 			ret = err;
+		} else {
+			cgroup_rm_file(cgrp, cft);
 		}
 	}
 	return ret;
-- 
1.8.0.2

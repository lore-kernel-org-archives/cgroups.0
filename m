From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH 2/8] cgroup: remove unused variables in cgroup_destroy_locked()
Date: Tue, 12 Mar 2013 14:50:17 +0800
Message-ID: <513ED029.4090104@huawei.com>
References: <513ED010.5060906@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <513ED010.5060906@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>


Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 02b02ca..71bc33d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4347,10 +4347,8 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 {
 	struct dentry *d = cgrp->dentry;
 	struct cgroup *parent = cgrp->parent;
-	DEFINE_WAIT(wait);
 	struct cgroup_event *event, *tmp;
 	struct cgroup_subsys *ss;
-	LIST_HEAD(tmp_list);
 
 	lockdep_assert_held(&d->d_inode->i_mutex);
 	lockdep_assert_held(&cgroup_mutex);
-- 
1.8.0.2

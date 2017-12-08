From: Ma Shimiao <mashimiao.fnst@cn.fujitsu.com>
Subject: [PATCH v2] cgroup: avoid cgroup root name longer than max
Date: Fri, 8 Dec 2017 18:04:31 +0800
Message-ID: <20171208100431.13021-1-mashimiao.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Ma Shimiao <mashimiao.fnst@cn.fujitsu.com>

v1->v2:
  - only copy maxlength-1 to name, otherwise have problem to print it

cgroup root name has max length limit, we should avoid copying
longer name than that to the name.

Signed-off-by: Ma Shimiao <mashimiao.fnst@cn.fujitsu.com>
---
 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 0b1ffe147f24..f5b0478c89b7 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1866,7 +1866,7 @@ void init_cgroup_root(struct cgroup_root *root, struct cgroup_sb_opts *opts)
 	if (opts->release_agent)
 		strcpy(root->release_agent_path, opts->release_agent);
 	if (opts->name)
-		strcpy(root->name, opts->name);
+		strncpy(root->name, opts->name, MAX_CGROUP_ROOT_NAMELEN - 1);
 	if (opts->cpuset_clone_children)
 		set_bit(CGRP_CPUSET_CLONE_CHILDREN, &root->cgrp.flags);
 }
-- 
2.13.6




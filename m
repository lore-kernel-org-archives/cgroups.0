From: Ma Shimiao <mashimiao.fnst@cn.fujitsu.com>
Subject: [PATCH] cgroup: avoid cpoied names in cgroup longer than max
Date: Tue, 12 Dec 2017 09:43:49 +0800
Message-ID: <20171212014349.5036-1-mashimiao.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Ma Shimiao <mashimiao.fnst@cn.fujitsu.com>

cgroup root name and file name have max length limit, we should
avoid copying longer name than that to the name.

Signed-off-by: Ma Shimiao <mashimiao.fnst@cn.fujitsu.com>
---
 kernel/cgroup/cgroup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 0b1ffe147f24..18d71fbd3923 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1397,7 +1397,7 @@ static char *cgroup_file_name(struct cgroup *cgrp, const struct cftype *cft,
 			 cgroup_on_dfl(cgrp) ? ss->name : ss->legacy_name,
 			 cft->name);
 	else
-		strncpy(buf, cft->name, CGROUP_FILE_NAME_MAX);
+		strscpy(buf, cft->name, CGROUP_FILE_NAME_MAX);
 	return buf;
 }
 
@@ -1864,9 +1864,9 @@ void init_cgroup_root(struct cgroup_root *root, struct cgroup_sb_opts *opts)
 
 	root->flags = opts->flags;
 	if (opts->release_agent)
-		strcpy(root->release_agent_path, opts->release_agent);
+		strscpy(root->release_agent_path, opts->release_agent, PATH_MAX);
 	if (opts->name)
-		strcpy(root->name, opts->name);
+		strscpy(root->name, opts->name, MAX_CGROUP_ROOT_NAMELEN);
 	if (opts->cpuset_clone_children)
 		set_bit(CGRP_CPUSET_CLONE_CHILDREN, &root->cgrp.flags);
 }
-- 
2.13.6




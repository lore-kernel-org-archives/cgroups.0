From: Miaohe Lin <linmiaohe@huawei.com>
Subject: [PATCH] cgroup: short-circuit current_cgns_cgroup_from_root() on the default hierarchy
Date: Sun, 29 Sep 2019 16:06:58 +0800
Message-ID: <20190929080658.11430-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linmiaohe@huawei.com, mingfangsen@huawei.com

Like commit 13d82fb77abb ("cgroup: short-circuit cset_cgroup_from_root() on
the default hierarchy"), short-circuit current_cgns_cgroup_from_root() on
the default hierarchy.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 kernel/cgroup/cgroup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 8be1da1ebd9a..b90c8b200aa2 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1374,6 +1374,8 @@ current_cgns_cgroup_from_root(struct cgroup_root *root)
 	cset = current->nsproxy->cgroup_ns->root_cset;
 	if (cset == &init_css_set) {
 		res = &root->cgrp;
+	} else if (root == &cgrp_dfl_root) {
+		res = cset->dfl_cgrp;
 	} else {
 		struct cgrp_cset_link *link;
 
-- 
2.21.GIT


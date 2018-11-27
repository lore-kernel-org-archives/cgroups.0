From: Peng Wang <rocking@whu.edu.cn>
Subject: [PATCH] cgroup: remove unused member "cgrp_ancestor_id_storage" in struct cgroup_root
Date: Tue, 27 Nov 2018 14:53:57 +0800
Message-ID: <20181127065357.28130-1-rocking@whu.edu.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Peng Wang <rocking@whu.edu.cn>

"cgrp_ancestor_id_storage" is not used, so let's clean it up.

Signed-off-by: Peng Wang <rocking@whu.edu.cn>
---
 include/linux/cgroup-defs.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 5e1694fe035b..639a96576ef3 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -467,9 +467,6 @@ struct cgroup_root {
 	/* The root cgroup.  Root is destroyed on its release. */
 	struct cgroup cgrp;
 
-	/* for cgrp->ancestor_ids[0] */
-	int cgrp_ancestor_id_storage;
-
 	/* Number of cgroups in the hierarchy, used only for /proc/cgroups */
 	atomic_t nr_cgrps;
 
-- 
2.19.1


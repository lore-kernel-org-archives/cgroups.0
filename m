From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH 3/3] cgroup: deal with dummp_top in cgroup_name() and cgroup_path()
Date: Fri, 14 Feb 2014 16:56:04 +0800
Message-ID: <52FDDA24.6080204@huawei.com>
References: <52FDD9C4.1070001@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <52FDD9C4.1070001@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

My kernel fails to boot, because blkcg calls cgroup_path() while
cgroupfs is not mounted.

Fix both cgroup_name() and cgroup_path().

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/cgroup.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index ef0b3af..8c283a9 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -487,13 +487,21 @@ struct cgroup_subsys_state *seq_css(struct seq_file *seq);
 
 static inline int cgroup_name(struct cgroup *cgrp, char *buf, size_t buflen)
 {
-	return kernfs_name(cgrp->kn, buf, buflen);
+	/* dummy_top doesn't have a kn associated */
+	if (cgrp->kn)
+		return kernfs_name(cgrp->kn, buf, buflen);
+	else
+		return strlcpy(buf, "/", buflen);
 }
 
 static inline char * __must_check cgroup_path(struct cgroup *cgrp, char *buf,
 					      size_t buflen)
 {
-	return kernfs_path(cgrp->kn, buf, buflen);
+	/* dummy_top doesn't have a kn associated */
+	if (cgrp->kn)
+		return kernfs_path(cgrp->kn, buf, buflen);
+	strlcpy(buf, "/", buflen);
+	return (buflen <= 2) ? NULL : buf;
 }
 
 static inline void pr_cont_cgroup_name(struct cgroup *cgrp)
-- 
1.8.0.2

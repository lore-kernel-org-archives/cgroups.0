From: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH -next] cgroup/cpuset: fix typos in comments
Date: Thu, 8 Apr 2021 16:03:46 +0800
Message-ID: <20210408080346.166046-1-lujialin4@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Wang Weiyang <wangweiyang2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Change hierachy to hierarchy and unrechable to unreachable,
no functionality changed.

Signed-off-by: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 5258b68153e0..a945504c0ae7 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -585,7 +585,7 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
 
 	par = parent_cs(cur);
 
-	/* On legacy hiearchy, we must be a subset of our parent cpuset. */
+	/* On legacy hierarchy, we must be a subset of our parent cpuset. */
 	ret = -EACCES;
 	if (!is_in_v2_mode() && !is_cpuset_subset(trial, par))
 		goto out;
@@ -1726,7 +1726,7 @@ static void update_tasks_nodemask(struct cpuset *cs)
  * When configured nodemask is changed, the effective nodemasks of this cpuset
  * and all its descendants need to be updated.
  *
- * On legacy hiearchy, effective_mems will be the same with mems_allowed.
+ * On legacy hierarchy, effective_mems will be the same with mems_allowed.
  *
  * Called with cpuset_mutex held
  */
@@ -2500,7 +2500,7 @@ static s64 cpuset_read_s64(struct cgroup_subsys_state *css, struct cftype *cft)
 		BUG();
 	}
 
-	/* Unrechable but makes gcc happy */
+	/* Unreachable but makes gcc happy */
 	return 0;
 }
 
-- 
2.17.1


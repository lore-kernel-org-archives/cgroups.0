From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/6] cgroup: replace cgroup_add_cftypes() with cgroup_add_legacy_cftypes()
Date: Mon, 14 Jul 2014 11:44:05 -0400
Message-ID: <1405352648-4279-4-git-send-email-tj@kernel.org>
References: <1405352648-4279-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/hBBkORbOFF0Wt4u/kmWyizH+fIdNzkUkNXeYGENalk=;
        b=vABEW1mpF3JlMTIvp5kcnjaRqsaNL5DzxH9C5aqs+3Jd8OkkoM/YRcklltapOPF/yY
         ckm6Xfq4PzshuxAfF4p/TMwTABSJw+wQ4x5utZamq9lGH8Yw15/lkkHf16X2sL5yAVIo
         hWsl0XX8XrH29w0+JNj0roUX8frQWUeBFxfwbmmP1WSY7FooGlG3+lEG6qJTZ1apHvpf
         mmvsKlGB89i3bLVBh6ce9X5LaTXhxRGThW/OL6MhXbjEWzLKuJx0jT3zBN7I86cEZosR
         HlsXeq1Ty8FIqCrhf4Coc7AuRfiu1Y9zhwamKb2TRjE0kdDFkWgV6WQ4ux7ZqXJjDVRs
         SfWw==
In-Reply-To: <1405352648-4279-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

Currently, cftypes added by cgroup_add_cftypes() are used for both the
unified default hierarchy and legacy ones and subsystems can mark each
file with either CFTYPE_ONLY_ON_DFL or CFTYPE_INSANE if it has to
appear only on one of them.  This is quite hairy and error-prone.
Also, we may end up exposing interface files to the default hierarchy
without thinking it through.

cgroup_subsys will grow two separate cftype addition functions and
apply each only on the hierarchies of the matching type.  This will
allow organizing cftypes in a lot clearer way and encourage subsystems
to scrutinize the interface which is being exposed in the new default
hierarchy.

In preparation, this patch adds cgroup_add_legacy_cftypes() which
currently is a simple wrapper around cgroup_add_cftypes() and replaces
all cgroup_add_cftypes() usages with it.

While at it, this patch drops a completely spurious return from
__hugetlb_cgroup_file_init().

This patch doesn't introduce any functional differences.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 block/blk-cgroup.c        | 3 ++-
 include/linux/cgroup.h    | 2 +-
 kernel/cgroup.c           | 7 ++++++-
 mm/hugetlb_cgroup.c       | 5 ++---
 mm/memcontrol.c           | 3 ++-
 net/ipv4/tcp_memcontrol.c | 2 +-
 6 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 5cfbc72..2541cf0 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1124,7 +1124,8 @@ int __init blkcg_policy_register(struct blkcg_policy *pol)
 
 	/* everything is in place, add intf files for the new policy */
 	if (pol->cftypes)
-		WARN_ON(cgroup_add_cftypes(&blkio_cgrp_subsys, pol->cftypes));
+		WARN_ON(cgroup_add_legacy_cftypes(&blkio_cgrp_subsys,
+						  pol->cftypes));
 	ret = 0;
 out_unlock:
 	mutex_unlock(&blkcg_pol_mutex);
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index a6e9c2e..f5f0fee 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -590,7 +590,7 @@ static inline void pr_cont_cgroup_path(struct cgroup *cgrp)
 
 char *task_cgroup_path(struct task_struct *task, char *buf, size_t buflen);
 
-int cgroup_add_cftypes(struct cgroup_subsys *ss, struct cftype *cfts);
+int cgroup_add_legacy_cftypes(struct cgroup_subsys *ss, struct cftype *cfts);
 int cgroup_rm_cftypes(struct cftype *cfts);
 
 bool cgroup_is_descendant(struct cgroup *cgrp, struct cgroup *ancestor);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 6496a83..c275aa4 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3170,7 +3170,7 @@ int cgroup_rm_cftypes(struct cftype *cfts)
  * function currently returns 0 as long as @cfts registration is successful
  * even if some file creation attempts on existing cgroups fail.
  */
-int cgroup_add_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
+static int cgroup_add_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 {
 	int ret;
 
@@ -3195,6 +3195,11 @@ int cgroup_add_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 	return ret;
 }
 
+int cgroup_add_legacy_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
+{
+	return cgroup_add_cftypes(ss, cfts);
+}
+
 /**
  * cgroup_task_count - count the number of tasks in a cgroup.
  * @cgrp: the cgroup in question
diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index 493f758..9aae6f4 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -358,9 +358,8 @@ static void __init __hugetlb_cgroup_file_init(int idx)
 	cft = &h->cgroup_files[4];
 	memset(cft, 0, sizeof(*cft));
 
-	WARN_ON(cgroup_add_cftypes(&hugetlb_cgrp_subsys, h->cgroup_files));
-
-	return;
+	WARN_ON(cgroup_add_legacy_cftypes(&hugetlb_cgrp_subsys,
+					  h->cgroup_files));
 }
 
 void __init hugetlb_cgroup_file_init(void)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8331f27..b6b3c6f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -7065,7 +7065,8 @@ __setup("swapaccount=", enable_swap_account);
 
 static void __init memsw_file_init(void)
 {
-	WARN_ON(cgroup_add_cftypes(&memory_cgrp_subsys, memsw_cgroup_files));
+	WARN_ON(cgroup_add_legacy_cftypes(&memory_cgrp_subsys,
+					  memsw_cgroup_files));
 }
 
 static void __init enable_swap_cgroup(void)
diff --git a/net/ipv4/tcp_memcontrol.c b/net/ipv4/tcp_memcontrol.c
index f7a2ec3..3af5226 100644
--- a/net/ipv4/tcp_memcontrol.c
+++ b/net/ipv4/tcp_memcontrol.c
@@ -222,7 +222,7 @@ static struct cftype tcp_files[] = {
 
 static int __init tcp_memcontrol_init(void)
 {
-	WARN_ON(cgroup_add_cftypes(&memory_cgrp_subsys, tcp_files));
+	WARN_ON(cgroup_add_legacy_cftypes(&memory_cgrp_subsys, tcp_files));
 	return 0;
 }
 __initcall(tcp_memcontrol_init);
-- 
1.9.3

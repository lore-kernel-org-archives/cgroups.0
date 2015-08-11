From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/8] cgroup: make cgroup_addrm_files() clean up after itself on failures
Date: Tue, 11 Aug 2015 13:58:05 -0400
Message-ID: <1439315889-3492-5-git-send-email-tj@kernel.org>
References: <1439315889-3492-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=D7BAV6c2I7FMfs9jDv6dGYkzC9ypgO+yeI+HMtpmpNw=;
        b=WJryhZcru8Ac9Mc2FbrV6gURjRdcpFeWDq+2LoD3DF+ANAmCWquD/WP34kBHyYydac
         w4uB2lbN2cNZLbwH132s7fNnHCbXuH8ORGf1t0CihUlxhK5kgNhthKiU7tHki3K3lTf4
         Oct6llDlkKruU2UReu0so4BJZ4Q7EB1qCwcP7v0L1C98Q9sYydTAz3IrWOjLL8J5a5xr
         TsbYRkwHlOD1FnCGx4zVRFbBKDoO+UhtDl0gxvQZRnZOPocnyniSigiVv8ki+zi3bbWz
         U9zXhFoC07k+XIoCA9INTRqCLUzIMyJFTUF+JKbGsXMDwy53+k2jV5mOaiheuLy6bve8
         i6+A==
In-Reply-To: <1439315889-3492-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes@cmpxchg.org, lizefan@huawei.com
Cc: mhocko@kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

After a file creation failure, cgroup_addrm_files() it didn't remove
the files which had already been created.  When cgroup_populate_dir()
is the caller, this is fine as the caller performs cleanup; however,
for other callers, this may leave unactivated dangling files behind.
As kernfs directory removals are recursive, this doesn't lead to
permanent memory leak but it can, for example, fail future attempts to
create those files again.

There's no point in keeping around this sort of subtlety and it gets
in the way of planned updates to file handling.  This patch makes
cgroup_addrm_files() clean up after itself on failures.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
 kernel/cgroup.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 92b8cc7..5e5a4e0 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3154,19 +3154,18 @@ static int cgroup_add_file(struct cgroup *cgrp, struct cftype *cft)
  * @is_add: whether to add or remove
  *
  * Depending on @is_add, add or remove files defined by @cfts on @cgrp.
- * For removals, this function never fails.  If addition fails, this
- * function doesn't remove files already added.  The caller is responsible
- * for cleaning up.
+ * For removals, this function never fails.
  */
 static int cgroup_addrm_files(struct cgroup *cgrp, struct cftype cfts[],
 			      bool is_add)
 {
-	struct cftype *cft;
+	struct cftype *cft, *cft_end = NULL;
 	int ret;
 
 	lockdep_assert_held(&cgroup_mutex);
 
-	for (cft = cfts; cft->name[0] != '\0'; cft++) {
+restart:
+	for (cft = cfts; cft != cft_end && cft->name[0] != '\0'; cft++) {
 		/* does cft->flags tell us to skip this file on @cgrp? */
 		if ((cft->flags & __CFTYPE_ONLY_ON_DFL) && !cgroup_on_dfl(cgrp))
 			continue;
@@ -3182,7 +3181,9 @@ static int cgroup_addrm_files(struct cgroup *cgrp, struct cftype cfts[],
 			if (ret) {
 				pr_warn("%s: failed to add %s, err=%d\n",
 					__func__, cft->name, ret);
-				return ret;
+				cft_end = cft;
+				is_add = false;
+				goto restart;
 			}
 		} else {
 			cgroup_rm_file(cgrp, cft);
-- 
2.4.3

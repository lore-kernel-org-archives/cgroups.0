From: Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: fix display of forceidle time at root
Date: Wed, 15 Mar 2023 14:40:29 -0700
Message-ID: <20230315214029.899573-1-joshdon@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678916433;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0vT5pZgC3odOnq/dCWudlRqWXNT/3pXxM4U4p7g/Zps=;
        b=GBOhli6DgB6C2e3UwLY3hOUyIJJCYvBv89mVgUJNI9rwDtzV+xfm8MeOiM6FEn49Og
         dac3udvhEPDGv68VxZ6KhmgYa4bE5Dz2pnI3o8WNC7zwpdH+SXm0yGK2BrWrxEibNsx8
         QKnsQoEIsXs+afDVgCAFeywJEHRVjsD4xI8bX3UKIZ4GhZqHkz0b+XtP5oLct1tiKV/F
         iYR9De56Y/qllKPi2/15D5E/kuCmnylV9fo3Kt/lp51pvJt+dzgVvcEIMWJNH5RgUhn3
         wmDFBrCXDyMivyyL/lELOeFVcxU8TifaiKU3oAM6dlFLK+vrPqZNEe2nDCphqMJtMcz7
         t7tg==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

We need to reset forceidle_sum to 0 when reading from root, since the
bstat we accumulate into is stack allocated.

To make this more robust, just replace the existing cputime reset with a
memset of the overall bstat.

Signed-off-by: Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/rstat.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 831f1f472bb8..0a2b4967e333 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -457,9 +457,7 @@ static void root_cgroup_cputime(struct cgroup_base_stat *bstat)
 	struct task_cputime *cputime = &bstat->cputime;
 	int i;
 
-	cputime->stime = 0;
-	cputime->utime = 0;
-	cputime->sum_exec_runtime = 0;
+	memset(bstat, 0, sizeof(*bstat));
 	for_each_possible_cpu(i) {
 		struct kernel_cpustat kcpustat;
 		u64 *cpustat = kcpustat.cpustat;
-- 
2.40.0.rc1.284.g88254d51c5-goog


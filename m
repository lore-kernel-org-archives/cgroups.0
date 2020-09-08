From: Hao Lee <haolee.swjtu@gmail.com>
Subject: [PATCH] cgroup: Remove unnecessary call to strstrip()
Date: Tue, 8 Sep 2020 13:33:50 +0000
Message-ID: <20200908133350.GA22979@haolee.github.io>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=+6DdVEAHk114MPmsPvfVgelrnLIdaVwBYKUdcVJCimM=;
        b=HPLtU7p7+fZmlpVKGRJgNBrW9pG+Pguf8LaEfIFwclcfVemFqf6hA9KIkFKJbdA5N+
         cnvbL6ax5PILNSwlu6yYTmSXX5MHWydlptjrYmj/nhqNmMKdFK/XDIWD84yQU6bZ2HTr
         eeKLOni7tBf/Id+S5ooNK1z4U4n2Yo+xgTwDf3V9nWDGICmjNZ1NLZFDkBwp/CxKv5Zi
         rSQcp/aQ5m+S0CC2TOjS+6R6cV3WDdHohNaNexMB3SpT84nHcJr9iNKMl3mKOGh4xKw0
         tIR6Fmh3AuWLgCnVNoWVlMLZEbGh06xkPT66Bm9MQUVqOQdYTtql2qSEu593Nvq335Db
         avBQ==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org
Cc: lizefan@huawei.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, haolee.swjtu@gmail.com

The string buf will be stripped in cgroup_procs_write_start() before it
is converted to int, so remove this unnecessary call to strstrip().

Signed-off-by: Hao Lee <haolee.swjtu@gmail.com>
---
 kernel/cgroup/cgroup.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index b6714166106d..90ee7e73eb2e 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4772,14 +4772,12 @@ static ssize_t cgroup_threads_write(struct kernfs_open_file *of,
 {
 	struct cgroup *src_cgrp, *dst_cgrp;
 	struct task_struct *task;
 	ssize_t ret;
 	bool locked;
 
-	buf = strstrip(buf);
-
 	dst_cgrp = cgroup_kn_lock_live(of->kn, false);
 	if (!dst_cgrp)
 		return -ENODEV;
 
 	task = cgroup_procs_write_start(buf, false, &locked);
 	ret = PTR_ERR_OR_ZERO(task);
-- 
2.24.1


From: Peng Wang <rocking@whu.edu.cn>
Subject: [PATCH] cgroup: remove early strstrip in cgroup_threads_write
Date: Wed, 24 Jul 2019 21:05:26 +0800
Message-ID: <20190724130526.20671-1-rocking@whu.edu.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Peng Wang <rocking@whu.edu.cn>

cgroup_procs_write_start() will process leading and
trailing whitespace when necessary.

Signed-off-by: Peng Wang <rocking@whu.edu.cn>
---
 kernel/cgroup/cgroup.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 753afbca549f..49f2b133cf67 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4796,8 +4796,6 @@ static ssize_t cgroup_threads_write(struct kernfs_open_file *of,
 	struct task_struct *task;
 	ssize_t ret;
 
-	buf = strstrip(buf);
-
 	dst_cgrp = cgroup_kn_lock_live(of->kn, false);
 	if (!dst_cgrp)
 		return -ENODEV;
-- 
2.19.1

